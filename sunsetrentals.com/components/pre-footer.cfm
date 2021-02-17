<cfquery name="getRandomTestimony" dataSource="#settings.dsn#">
	select user,body from cms_testimonials order by rand() limit 1
</cfquery>

<cfsavecontent variable="sc_testimonial">
	<p class="h3 site-color-2">Testimonial</p>
	<cfoutput><p><i>#getRandomTestimony.body#</i> <span class="site-color-4">~ #getRandomTestimony.user#</span></p></cfoutput>
</cfsavecontent>

<cfquery name="getUpcomingEvent" dataSource="#settings.dsn#">
	select * from cms_eventcal where now() < start_date order by start_date limit 1
</cfquery>

<cfsavecontent variable="sc_upcomingevent">
	<p class="h3 site-color-2">Upcoming Event</p>
	<cfoutput>
		<p class="h5">#getUpcomingEvent.event_title#</p>
		<p><i>#getUpcomingEvent.event_location#</i></p>
		<p>#DateFormat(getUpcomingEvent.start_date,'mm/dd/yyyy')# - #DateFormat(getUpcomingEvent.end_date,'mm/dd/yyyy')#</p>
		<p>#getUpcomingEvent.time_start# - #getUpcomingEvent.time_end#</p>
	</cfoutput>
</cfsavecontent>

<!--- !!!! CHANGE THE TABLE NAMES IN THE QUERY AND UNCOMMENT THIS TO USE IT !!!!
<cfset rootPath = ExpandPath( "." ) />
<cfif FileExists('#rootPath#\blog\index.php')>
	<cfquery name="getLatestBlog" dataSource="cms3_icnd_net_wp">
		SELECT *, name as categoryName, slug as categorySlug
		FROM cms3_posts
		left join cms3_term_relationships
		on cms3_posts.id = cms3_term_relationships.object_id
		left join cms3_term_taxonomy on cms3_term_relationships.term_taxonomy_id = cms3_term_taxonomy.term_taxonomy_id
		left join cms3_terms on cms3_term_taxonomy.term_id = cms3_terms.term_id
		where post_status = 'publish' AND post_type = 'post'
		ORDER BY post_date DESC LIMIT 1
	</cfquery>
	<cfsavecontent variable="sc_recentblogpost">
		<cfoutput query="getLatestBlog">
			<p class="h3 site-color-2">Recent Blog Post</p>
			<p class="h4"><a href="/blog/#slug#/#post_name#" class="site-color-3">#post_title#</a></p>
			<cfset beg_caption = Find("[caption",post_content)>
			<cfif beg_caption GT 0>
  			<cfset end_caption = Find("[/caption",post_content,#beg_caption#)>
  			<cfset clean_content = RemoveChars(post_content,#beg_caption#,#end_caption# - #beg_caption# + 10)>
			<cfelse>
  			<cfset clean_content = "#post_content#">
			</cfif>
			<p>#fullLeft(stripHTMLr(clean_content), 250)#. . . <a href="/blog/#slug#/#post_name#" class="site-color-2">read more</a></p>
		</cfoutput>
	</cfsavecontent>
</cfif>
--->
<cfset sc_recentblogpost = 'Look in components/pre-footer.cfm to make this live'> <!--- remove this if you uncomment the code above --->

<cfif settings.prefooter_left eq 'lc_none' and settings.prefooter_right eq 'rc_none'>
	<!--- DONT SHOW ANYTHING --->
<cfelse>
	<div class="i-pre-footer site-color-1-bg">
		<div class="container">
	  	<div class="row">

        <cfif settings.prefooter_left eq 'lc_none' and settings.prefooter_right neq 'rc_none'>

          <!--- ONLY SHOW RIGHT COLUMN --->
  	    	<div class="col">
  	        <div class="i-pre-footer-right-col text-white">
  	        	<cfif settings.prefooter_right eq 'rc_testimony'>
  	            <cfoutput>#sc_testimonial#</cfoutput>
  	          <cfelseif settings.prefooter_right eq 'rc_event'>
  	            <cfoutput>#sc_upcomingevent#</cfoutput>
              <cfelseif settings.prefooter_right eq 'rc_blog' and isdefined('sc_recentblogpost')>
  	            <cfoutput>#sc_recentblogpost#</cfoutput>
  	          <cfelseif settings.prefooter_right eq 'rc_tweeter'>
  	            <cfinclude template="/components/most-recent-tweet.cfm"> <!--- Had to move it to it's own component file so that the JS wouldn't appear when it wasn't selected --->
  	      	  </cfif>
  	        </div>
  	    	</div>

        <cfelseif settings.prefooter_left neq 'lc_none' and settings.prefooter_right eq 'rc_none'>

          <!--- ONLY SHOW LEFT COLUMN --->
  	    	<div class="col">
  	        <div class="i-pre-footer-left-col text-white">
  	        	<cfif settings.prefooter_left eq 'lc_testimony'>
  	            <cfoutput>#sc_testimonial#</cfoutput>
  	          <cfelseif settings.prefooter_left eq 'lc_event'>
  	            <cfoutput>#sc_upcomingevent#</cfoutput>
              <cfelseif settings.prefooter_left eq 'lc_blog' and isdefined('sc_recentblogpost')>
  	            <cfoutput>#sc_recentblogpost#</cfoutput>
  	          <cfelseif settings.prefooter_left eq 'lc_tweeter'>
  	            <cfinclude template="/components/most-recent-tweet.cfm"> <!--- Had to move it to it's own component file so that the JS wouldn't appear when it wasn't selected --->
  	      	  </cfif>
  	        </div>
  	    	</div>

        <cfelse>

          <!---  SHOW BOTH COLUMNS --->
  	    	<div class="col-sm-12 col-md-12 col-lg-6 text-right">
  	        <div class="i-pre-footer-left-col text-white">
  	        	<cfif settings.prefooter_left eq 'lc_testimony'>
  	            <cfoutput>#sc_testimonial#</cfoutput>
  	          <cfelseif settings.prefooter_left eq 'lc_event'>
  	            <cfoutput>#sc_upcomingevent#</cfoutput>
              <cfelseif settings.prefooter_left eq 'lc_blog' and isdefined('sc_recentblogpost')>
  	            <cfoutput>#sc_recentblogpost#</cfoutput>
  	          <cfelseif settings.prefooter_left eq 'lc_tweeter'>
  	            <cfinclude template="/components/most-recent-tweet.cfm"> <!--- Had to move it to it's own component file so that the JS wouldn't appear when it wasn't selected --->
  	      	  </cfif>
  	        </div>
  	    	</div>
  	    	<div class="col-sm-12 col-md-12 col-lg-6">
  	        <div class="i-pre-footer-right-col text-white">
  	        	<cfif settings.prefooter_right eq 'rc_testimony'>
  	            <cfoutput>#sc_testimonial#</cfoutput>
  	          <cfelseif settings.prefooter_right eq 'rc_event'>
  	            <cfoutput>#sc_upcomingevent#</cfoutput>
              <cfelseif settings.prefooter_right eq 'rc_blog' and isdefined('sc_recentblogpost')>
  	            <cfoutput>#sc_recentblogpost#</cfoutput>
  	          <cfelseif settings.prefooter_right eq 'rc_tweeter'>
  	            <cfinclude template="/components/most-recent-tweet.cfm"> <!--- Had to move it to it's own component file so that the JS wouldn't appear when it wasn't selected --->
  	      	  </cfif>
  	        </div>
  	    	</div>

        </cfif>

	  	</div>
		</div>
	</div>
</cfif>