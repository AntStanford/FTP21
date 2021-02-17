<cfquery name="GetHPAnnouncements" dataSource="#settings.dsn#">
  select * from cms_homepage_announcements
  where active = 'Yes'
  AND now() BETWEEN start_date AND end_date
  order by createdAt desc
</cfquery>
 
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
      <p class="title"><b><cfif link is not ""><a href="#link#">#title#</a><cfelse>#title#</cfif></b></p>
      <p class="description">#description#</p>
    </div>
  </div>
</cfoutput>

<style>
/* Keep here under above content */
.announcement { text-align: center; }
.announcement p { font-size: 18px; margin-bottom: 0; }
.announcement .emergencyMessage { color: #a94442; background-color: #f2dede; padding: 15px 30px; }
.announcement .specialMessage { color: #8a6d3b; background-color: #fcf8e3; padding: 15px 30px; }
.announcement .regularMessage { color: #31708f; background-color: #d9edf7; padding: 15px 30px; }
.announcement div p { text-align: center !important; }
@media (max-width: 1024px) {
  .i-header-navigation + .announcement { margin-top: 50px; }
}
/*@media(max-width: 992px){
  .announcement { display: none; }
}*/
</style>