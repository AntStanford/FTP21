<!DOCTYPE html>
<html>
	<head>
  	<cfoutput>
		<title>#settings.company#</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css">
		<link href="/#settings.booking.dir#/stylesheets/styles.css" rel="stylesheet">
    </cfoutput>
		<style>
  		.compare .logo {margin: 10px 0;}
      .compare .property-info { margin: 10px 0; font-size: 16px; line-height: 1.25; font-weight: 700; }
      .compare .h2 {margin: 0 0 10px;}
      .compare .compare-list [class^="col-"] {display: inline-block; vertical-align: top; float: none; margin: 0 -4px 25px 0;}
      .compare .compare-list .compare-pic {width: 100%; padding-bottom: 70%; position: relative; overflow: hidden; margin-bottom: 5px;}
      .compare .compare-list .compare-pic img {width: 100%; position: absolute; top: 0; right: 0; left: 0;}
      .compare .compare-list .compare-details p {margin-bottom: 0; font-size: 16px; line-height: 1.5;}
		</style>
	</head>
	<body>
		<div class="wrapper">
      <div class="compare container">
        <div class="row">
          <div class="col-xs-6">
            <img src="/images/layout/logo.jpg" class="logo" alt="Southern Resorts">
          </div>
          <div class="col-xs-6">
            <cfoutput>
            <p class="property-info text-right"><span>#settings.company#</span><br>
            #settings.address#<br>
            <cfif len(settings.city)>#settings.city#, #settings.state# #settings.zip#<br></cfif>
            #settings.phone#</p>
            </cfoutput>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12">

          	<div class="panel panel-default">
          	  <div class="panel-body">
        	  		<div class="h2">Your Favorites - <span><cfoutput>#ListLen(cookie.favorites)#</cfoutput> Properties Total</span></div>

                <cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)>
                  <div class="row compare-list">
                    <cfloop list="#cookie.favorites#" index="i">

        							<cfset getProperty = application.bookingObject.getProperty(i)>
        							<!--- <cfset minMaxPrice = application.bookingObject.getPropertyPriceRange(i)> --->

                      <cfoutput>
                      <div class="col-xs-4">
	                      <div class="compare-details">
	                        <div class="compare-pic"><img src="https://img.trackhs.com/337x219/#getProperty.defaultPhoto#"></div>
	                        <p><strong>#getProperty.name#</strong></p>
	                        <p>#getProperty.city#, #getProperty.state#</p>
      	    							<cfif len(getProperty.minRate)><p>$#getProperty.minRate# - $#getProperty.maxRate#</p></cfif>
      	    							<p>Bedrooms: #getProperty.bedrooms#</p>
      	    							<p>Bathrooms: #getProperty.bathrooms#</p>
	                      </div>
	                    </div>
	                    </cfoutput>

                    </cfloop>
                  </div><!-- END  -->
                </cfif>

            	</div><!-- END panel-body -->
          	</div><!-- END panel -->

          </div>
        </div>
      </div><!-- END compare -->

		</div><!-- END wrapper -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
		<script type="text/javascript" defer="defer">
    $(document).ready(function(){
			setTimeout(printWindow, 2000);
			function printWindow(){
        window.print();
      }
		});
		</script>
	</body>
</html>