<cfquery name="GetHPAnnouncements" dataSource="#settings.dsn#">
  select * from cms_homepage_announcements
  where active = 'Yes'
  AND now() BETWEEN start_date AND end_date
  order by createdAt desc
</cfquery>
<style>
/* Keep here under above content */
.announcement { text-align: center; position: relative; top:145px; left:0; right:0; z-index: 2; }
.announcement p { font-size: 15px; margin-bottom: 0; }
.announcement p.title { font-size:16px; }
.announcement .emergencyMessage { color: #a94442; background-color: #f2dede; padding: 15px 30px; }
.announcement .specialMessage { color: #8a6d3b; background-color: #fcf8e3; padding: 15px 30px; }
.announcement .regularMessage { color: #31708f; background-color: #d9edf7; padding: 15px 30px; }
.announcement div p { text-align: center !important; }
.announcement-close { position: absolute; top: 0; right: 0; font-size: 24px; padding: 14px; line-height: 1; }
@media (max-width: 1024px) {
  .announcement { position:relative; top:0; z-index:1; margin-top:50px;}
  .announcement + .i-wrapper { margin-top:0; padding-top:0; }
  .announcement .emergencyMessage { padding: 10px 30px; }
}
/* SRP */
.srp-page-announcements { display: none; }
.results-body:not(.resort-body) #homepage-announcement { display: none; }
.results-body:not(.resort-body) .srp-page-announcements { display: block; }
.results-body:not(.resort-body) .srp-page-announcements #homepage-announcement { display: block; top: 0; margin: -17px 0 20px; }
@media (max-width: 1400px) {
  .results-body:not(.resort-body) .srp-page-announcements #homepage-announcement { margin: 0 0 20px; }
}
/* SRP - Resort Pages */
@media (min-width: 1024px) {
  .results-body.resort-body #homepage-announcement { top: 109px; }
  .results-body.resort-body .i-header { top: 0; }
  .results-body.resort-body .results-wrap.resorts-wrap { padding-top: 0; }
  .results-body.resort-body #homepage-announcement + .wrapper { padding-top: 109px; }
}
.results-body.resort-body #homepage-announcement { margin-bottom: -50px; }
/* PDP */
@media (min-width: 1024px) {
  .pdp-body .wrapper { padding-top: 123px; }
  .pdp-body .announcement { top: 123px; }
}
.pdp-body #homepage-announcement { margin-bottom: -50px; }
/* Blog Pages */
@media (max-width: 1024px) {
  .wp-blog #homepage-announcement + #boxed-wrapper .i-wrapper { margin-top: 0; }
}
</style>
<cfoutput query="GetHPAnnouncements">
  <cfif GetHPAnnouncements.type eq 'Regular'>
    <cfset theClass = 'regularMessage'>
  <cfelseif GetHPAnnouncements.type eq 'Emergency'>
    <cfset theClass = 'emergencyMessage'>
  <cfelseif GetHPAnnouncements.type eq 'Special'>
    <cfset theClass = 'specialMessage'>
  </cfif>
  <div id="homepage-announcement" class="announcement">
    <div class="#theClass#">
      <a href="javascript:;" class="announcement-close">x</a>
      <p class="title"><b><cfif link is not ""><a href="#link#">#title#</a><cfelse>#title#</cfif></b></p>
      <p class="description">#description#</p>
    </div>
  </div>
</cfoutput>
<cf_htmlfoot>
<script type="text/javascript">
$(document).ready(function(){
  $('.announcement-close').on('click',function(){
    $(this).closest('#homepage-announcement').addClass('hidden');
  });
});
</script>
</cf_htmlfoot>