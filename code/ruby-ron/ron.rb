#!/usr/bin/env ruby

require 'net/ping'
require 'socket'
require 'resolv'
require 'rubygems'
require 'priority_queue'
require 'time'

#Parameters (Options for command line entry should be added)
nodefile = "nodes.txt"
port = 5001
timeout = 1
probeinterval = 1
infinity = 10 #Relative infinity for priority queue routng
t = Time.now #For use in the routing table output
puts t

#Figure out who I am
localhost= Socket.gethostname.split('.').first
localip = Resolv.getaddress(localhost)

#Initializes the RON from the local nodes file storing each node as an array element
#Planned Revision: move to a seperate module
nodecount = %x{wc -l '#{nodefile}'}.to_i
nodelist = Array.new(nodecount-1)
File.open(nodefile) do |infile|
  i = 0  
  while i < nodecount-1 do
    line = infile.gets.chop
    if (line != localip)
      nodelist[i] = line
      i += 1
    end
  end
end

#Routing Table Initialization
noderoute = Hash.new()
nodelist.each do |destination|
  noderoute[destination] = PriorityQueue.new
  #Create local entries for the queue
  nodelist.each do |nexthop|
    if (destination != nexthop)
      noderoute[destination][nexthop] = infinity
    end
  end
  noderoute[destination][localip] = infinity
end

#Create a server thread to listen for connections
#Future Revision: move to seperate module and call from the main program

Thread.new {
  server = TCPServer.new(localip, port)   
  loop {                          
    begin
      Thread.new(server.accept) do |client|
        #Forward each current route to the client, min_key is the next hop
        noderoute.each do |destination, queue|
          #noderoute[destination][localip]
          client.puts "#{noderoute[destination][localip]},#{destination},#{localip}"
        end
        client.close
      end
    rescue Exception => msg  
      puts "RON Server Thread has failed: #{msg}"
    end
  }
}

#Probe each node as specified by the parameter probeinterval and update the hash metrics
begin
  loop {
    nodelist.each do |target|
      u = Net::Ping::TCP.new(target, port, timeout)
      if(u.ping?)
        noderoute[target][localip] = u.duration
        begin
          s = TCPSocket.new(target, port, localip)
          y = nodecount-1
          y.times do
            update = s.gets.chop.split(',')
            latency = update[0].to_f
            dst = update[1]
            nxt = update[2]
            if (dst != localip && nxt != localip) #ignores routes to/through itself
              noderoute[dst][nxt] = noderoute[target][localip] + latency
              #puts "Update from #{target} is:\t#{update}"
            end
          end
          s.close
        rescue Errno::ECONNREFUSED
          puts "Connection to #{target} refused.\n"
          noderoute[target][localip] = infinity
        rescue Errno::EHOSTUNREACH
          puts "No route to #{target}.\n"
          noderoute[target][localip] = infinity
        end
      else
        #If you can't probe a target make all routes through it invalid
        nodelist.each do |dst|
          if (dst != target)
            noderoute[dst][target] = infinity
          end
        end
        noderoute[target][localip] = infinity
      end
      #puts "#{target}\t#{noderoute[target].inspect}"
    end
    noderoute.each do |destination|
      $stdout.puts "#{Time.now - t}\t#{destination[0]}\t#{destination[1].min_key}\t#{destination[1].min_priority}"
      $stdout.flush
    end
    #puts noderoute
    sleep(probeinterval)
  }
rescue Interrupt => e
  puts "Interrupted by the user: (Ctrl-C)\n"
rescue Exception => msg  
  #display system generated error message for any other error type
  puts "Update Module Failure: #{msg}\n"
end


