<!--- ADOUTE DEBUG --->
<cfset variables.adouteIP = createObject("java","java.net.InetAddress").getByName("adoute.dyndns.org").getHostAddress() />
<cfif cgi.remote_addr eq '216.99.119.254' or cgi.remote_addr eq variables.adouteIP>
    <cfdump var="#application#" label="application">
</cfif>
<!--- ADOUTE DEBUG --->