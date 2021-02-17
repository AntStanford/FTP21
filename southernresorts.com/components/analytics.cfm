<cfif cgi.SCRIPT_NAME eq '/#settings.booking.dir#/book-now-confirm.cfm' and StructKeyExists(request,'reservationCode') and len(request.reservationCode)>
  <cftry>
    <cfset ga = application.bookingObject.setGoogleAnalytics(settings,form,request.reservationCode)>
    <cfoutput>#ga#</cfoutput>
    <cfcatch>
		<cfif isdefined("ravenClient")>
			<cfset ravenClient.captureException(cfcatch)>
		</cfif>
    </cfcatch>
  </cftry>
<cfelse>
  <cfoutput>
    <!---
    <script type="text/javascript" defer="defer">
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', '#settings.googleAnalytics#', 'auto');
    ga('require', 'displayfeatures');
    ga('send', 'pageview');
    </script>
    --->
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=#settings.googleAnalytics#"></script>
    <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '#settings.googleAnalytics#');
    </script>
    
    <script>(function(w,d,t,r,u){var f,n,i;w[u]=w[u]||[],f=function(){var o={ti:"14007437"};o.q=w[u],w[u]=new UET(o),w[u].push("pageLoad")},n=d.createElement(t),n.src=r,n.async=1,n.onload=n.onreadystatechange=function(){var s=this.readyState;s&&s!=="loaded"&&s!=="complete"||(f(),n.onload=n.onreadystatechange=null)},i=d.getElementsByTagName(t)[0],i.parentNode.insertBefore(n,i)})(window,document,"script","//bat.bing.com/bat.js","uetq");window.uetq = window.uetq||[];window.uetq.push('event','',{'revenue_value':'REPLACE_WITH_REVENUE_VALUE','currency':'REPLACE_WITH_CURRENCY_CODE'});</script>
    <meta name="google-site-verification" content="-TRPVsda0Dk_F-LjDq_I0fGR93Vfl8tf1lU_ednrKTY" />
  </cfoutput>
</cfif>