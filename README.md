# winrm_kerb_shell

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
	
    -h, --help                       Show this help message
    -s, --server SERVER              The server FQDN.
    -r, --realm DOMAIN               The realm name. (UPPERCASE)

          *** Do NOT use this for illegal or malicious use ***                     
      By running this, YOU are using this program at YOUR OWN RISK.                 
    This software is provided "as is", WITHOUT ANY guarantees OR warranty. 
