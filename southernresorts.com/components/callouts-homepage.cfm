<link href="/stylesheets/animate.css" rel="stylesheet" type="text/css">
<cfquery name="getCallouts" dataSource="#settings.dsn#">
  select id,title,description,photo,link, linkbuttontext
  from cms_callouts
  order by sort
</cfquery>
<div class="owl-carousel home-callouts">
	<cfset myvar = 0>
	<cfoutput query="getCallouts">
		<cfset myvar = myvar + 1>
		<cfif findnocase('http',link)>
		  <cfset newLink = link />
		<cfelse>
		  <cfif cgi.server_name eq settings.devURL>
		    <cfset newLink = "http://#settings.devURL#/#link#" />
		  <cfelse>
		    <cfset newLink = "http://#settings.website#/#link#" />
		  </cfif>
		</cfif>
		<div class="book-direct-wrapper hp-callout-wrapper item hp-callout-#myvar#">
			<div class="book-direct-box">
				<h4><!--- Book Direct &amp; Save --->#title#</h4>
        <!--- <h3>Relax &amp; Enjoy your stay at the <span>Gulf Coast</span></h3> --->
				<div class="hp-callout-desc">#description#</div>
				<div class="hp-callout-link">
					<cfif len(link) gt 10><a class="southern-btn" href="#link#"><span>#linkbuttontext#</span><!--- View Our Specials ---><i class="fa fa-arrow-right"></i></a><cfelse><a style="display: none;" class="southern-btn" href="#link#"><span>#linkbuttontext#</span><!--- View Our Specials ---><i class="fa fa-arrow-right"></i></a></cfif>
				</div>
				<div class="home-callouts-nav owl-nav">
					<button type="button" role="presentation" class="owl-prev customPrevBtn"><btn class="bottom-link bottom-link-left" alt=""><i class="fa fa-arrow-left"></i> <span>#title#</span></btn></button>
					<button type="button" role="presentation" class="owl-next customNextBtn"><btn class="bottom-link bottom-link-right" href="" alt=""> <span>#title#</span> <i class="fa fa-arrow-right"></i></btn></button>
				</div><!--END owl-nav-->
		  </div>
		</div>
	</cfoutput>
</div>