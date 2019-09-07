#!/usr/bin/ruby

# Description:
# 
# Ruby script that calls an almost interactive shell via WinRM (TCP/5985) on an Windows machine,
# relaying on a valid Kerberos ticket. (Very useful with Golden Tickets)

# Dependencies:
# gem install winrm

# Author: Sh11td0wn (Github)

#          *** Do NOT use this for illegal or malicious use ***                     
#      By running this, YOU are using this program at YOUR OWN RISK.                 
#  This software is provided "as is", WITHOUT ANY guarantees OR warranty. 

# Modules
require 'winrm'
require 'optparse'

# Options handling
options = {}
OptionParser.new do |parser|

    parser.banner = "
    Description

    Ruby script that calls an almost interactive shell via WinRM (TCP/5985) on an Windows machine,
    relaying on a valid Kerberos ticket. (Very useful with Golden Tickets)

    ### ATTENTION ###

    Make sure you have your kerberos ticket properly configured,
    either setting the KRB5CCNAME variable or copying and renaming it to '/tmp/krb5cc_0'
    
    Example:
 
    export KRB5CCNAME='/foo/bar/ticket.ccache'
    or
    cp -v /foo/bar/ticket.ccache /tmp/krb5cc_0
 
    Also, make sure you can resolve all domain involved names.

    Usage: ./winrm_kerb_shell.rb [options]

    Example:
    ./winrm_kerb_shell.rb -s fooserver.contoso.com -r CONTOSO.COM

    Obs. Options --server, and --realm are REQUIRED!

    Options:
	"

   	parser.on("-h", "--help", "Show this help message") do ||
		puts parser
		puts
		exit
  	end
	# Whenever we see -f or --foo, with an argument, save the argument.
	parser.on("-s", "--server SERVER", "The server FQDN.") do |v|
    	options[:server] = v
	end
	
	parser.on("-r", "--realm DOMAIN", "The realm name. (UPPERCASE)") do |v|
    	options[:realm] = v
	end
end.parse!

# WinRM connection
conn = WinRM::Connection.new( 
  endpoint: "http://#{ options[:server] }:5985/wsman",
  user: '',
  password: '',
  transport: :kerberos,
  realm: "#{ options[:realm] }"
)

# Almost interactive shell (changes directory successfully)
command=""
conn.shell(:powershell) do |shell|
    until command == "exit\n" do
        output = shell.run("-join($id,'PS ',$(whoami),'@',$env:computername,' ',$((gi $pwd).Name),'> ')")
        print(output.output.chomp)
        command = gets        
        output = shell.run(command) do |stdout, stderr|
            STDOUT.print stdout
            STDERR.print stderr
        end
    end    
    puts "Exiting with code #{output.exitcode}"
end
