  <div class="booking-footer-wrap
    <cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/layouts/special.cfm')>
      results-footer-wrap
    <cfelseif cgi.script_name eq '/#settings.booking.dir#/property.cfm'>
      property-footer-wrap
    <cfelseif cgi.script_name eq '/#settings.booking.dir#/compare-favs.cfm'>
      compare-footer-wrap
    <cfelseif cgi.script_name eq '/#settings.booking.dir#/book-now.cfm'>
      booknow-footer-wrap
    <cfelseif cgi.script_name eq '/#settings.booking.dir#/book-now-confirm.cfm'>
      booknow-confirm-footer-wrap
    </cfif> site-color-3-bg">
    <cfoutput>
      <ul class="booking-footer-quick-links">
        <!--- <li><a href="javascript:;"><i class="fa fa-comments"></i><span>Click to Chat (Optional)</span></a></li> --->
        <li><a href="tel:#settings.tollFree#"><i class="fa fa-phone"></i><span>#settings.tollFree#</span></a></li>
        <li><a href="/contact"><i class="fa fa-envelope"></i><span>Get In Touch</span></a></li>
      </ul>
      <span class="booking-footer-copyright">
        <span>Copyright &copy; #dateformat(now(),'YYYY')# <a href="">#settings.company#</a>.</span> All Rights Reserved.
      </span>
    </cfoutput>
  </div><!-- END booking-footer-wrap -->
</div><!-- END wrapper -->

<!--- Output all scripts here --->
<cf_htmlfoot output="true" />

<cfinclude template="footer-javascripts.cfm">
<!--- Shared.js is a Shared Sitewide JS file --->
<script src="/javascripts/shared.js" defer></script>
<!--- global.js made last on Purpose --->
<script src="/<cfoutput>#settings.booking.dir#</cfoutput>/javascripts/global.min.js?v=1.2" defer></script>

<cfif (cgi.script_name neq '/#settings.booking.dir#/book-now.cfm')>
  <script type='text/javascript' data-cfasync='false'>window.purechatApi = { l: [], t: [], on: function () { this.l.push(arguments); } }; (function () { var done = false; var script = document.createElement('script'); script.async = true; script.type = 'text/javascript'; script.src = 'https://app.purechat.com/VisitorWidget/WidgetScript'; document.getElementsByTagName('HEAD').item(0).appendChild(script); script.onreadystatechange = script.onload = function (e) { if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) { var w = new PCWidget({c: '39a326f0-b492-4ca1-bedc-abbeb53a1325', f: true }); done = true; } }; })();</script>
</cfif>

<script type="text/javascript">
  (function(){
      var c = function() {
        var track = new Track('<cfoutput>#settings.dsn#</cfoutput>', 'phone');
        track.track();
      };

      var t = document.createElement('script');t.type = 'text/javascript'; t.src = '//cdn.trackhs.com/tracking/tracking.js';
      t.onload = t.onreadystatechange = function() { var state = s.readyState; if(!c.done && (!state || /loaded|complete/.test(state))){c.done = true; c()} };
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t,s);
  }());
</script>

<!-- Accessibility Script --->
<script>(function(document, tag) { var script = document.createElement(tag); var element = document.getElementsByTagName('body')[0]; script.src = 'https://acsbap.com/api/app/assets/js/acsb.js'; script.async = true; script.defer = true; (typeof element === 'undefined' ? document.getElementsByTagName('html')[0] : element).appendChild(script); script.onload = function() { acsbJS.init({ statementLink : '', feedbackLink : '', footerHtml : '', hideMobile : false, hideTrigger : false, handleJquery : true, language : 'en', position : 'left', leadColor : '#146ff8', triggerColor : '#146ff8', triggerRadius : '50%', triggerPositionX : 'left', triggerPositionY : 'bottom', triggerIcon : 'default', triggerSize : 'medium', triggerOffsetX : 20, triggerOffsetY : 20, usefulLinks : { }, mobile : { triggerSize : 'small', triggerPositionX : 'left', triggerPositionY : 'center', triggerOffsetX : 0, triggerOffsetY : 0, triggerRadius : '0' } }); };}(document, 'script'));</script>


</body>
</html>