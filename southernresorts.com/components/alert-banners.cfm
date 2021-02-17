<cfquery name="getAlerts" dataSource="#settings.dsn#">
  select * from cms_alerts order by createdat
</cfquery>
<!---
<div class="header-reservations" style="display: none;">
  <div class="container">
    <cfoutput query="getAlerts">
      <div class="header-reservations-text">
        <h3><b>#getAlerts.heading#</b> #getAlerts.subheading#<!--- <a href="#getAlerts.linkto#" class="btn">#getAlerts.buttonText#</a> ---></h3>
      </div>
    </cfoutput>
  </div>
</div>
--->
<cfoutput query="getAlerts">
<div class="banner-title"><div class="carousel-intro"><!--- Welcome to the Gulf Coast --->#getAlerts.heading#</div><h1><!--- Sweet Southern Moments --->#getAlerts.subheading#</h1><!--- <a class="southern-btn" href="">Learn About Us<i class="fa fa-arrow-right"></i></a> ---></div></cfoutput>