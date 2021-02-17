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
<!---  <cfoutput>
    <script type="text/javascript" defer="defer">
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', '#settings.googleAnalytics#', 'auto');
    ga('require', 'displayfeatures');
    ga('send', 'pageview');
    </script>
  </cfoutput>

    <cfoutput>
    <script async src="https://www.googletagmanager.com/gtag/js?id=#settings.googleAnalytics#"></script>

    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '#settings.googleAnalytics#');
    </script>
    </cfoutput>--->

</cfif>

<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-PX5S4Q6');</script>
<!-- End Google Tag Manager -->