<div class="container blog-wrapper">
    	<div class="row">
    		<div class="col-lg-12">
				<h3 class="header-subtext">Come &amp; Discover</h3>
				<p class="h1 h1-header site-color-3">The Gulf Coast Blog</p>
    		</div>

	    	<cfset rootPath = ExpandPath( "." ) />
	    	<cfif FileExists('#rootPath#\blog\index.php') and isDefined('settings.wp_dsn') and settings.wp_dsn neq ''>

			  <!--- This query returns a single row for a post, regardless of ho many categories it is in. --->
			  <cfquery name="getLatestBlog" dataSource="#settings.wp_dsn#">
				  SELECT posts.*, NAME AS categoryName, slug AS categorySlug, MIN(dfgh_terms.term_id), tn.guid AS thumbnail_url, dfgh_terms.name AS category, dfgh_terms.slug AS categorySlug
					FROM dfgh_posts posts
					LEFT JOIN dfgh_term_relationships ON posts.id = dfgh_term_relationships.object_id
					LEFT JOIN dfgh_term_taxonomy ON dfgh_term_relationships.term_taxonomy_id = dfgh_term_taxonomy.term_taxonomy_id
					LEFT JOIN dfgh_terms ON dfgh_term_taxonomy.term_id = dfgh_terms.term_id
					LEFT JOIN dfgh_posts AS tn ON tn.id = (SELECT meta_value FROM dfgh_postmeta WHERE post_id = posts.id AND meta_key = '_thumbnail_id' LIMIT 1)
					WHERE posts.post_status = 'publish' AND posts.post_type = 'post' AND dfgh_terms.name <> 'Gulf Coast Blog' and
                    dfgh_term_taxonomy.taxonomy = 'category'
					GROUP BY posts.ID
					ORDER BY posts.post_date DESC LIMIT 3
			  </cfquery>

			  <cfsavecontent variable="sc_recentblogpost">
			    <cfoutput query="getLatestBlog">

			      <cfset beg_caption = Find("[caption",post_content)>
			      <cfif beg_caption GT 0>
			        <cfset end_caption = Find("[/caption",post_content,#beg_caption#)>
			        <cfset clean_content = RemoveChars(post_content,#beg_caption#,#end_caption# - #beg_caption# + 10)>
			      <cfelse>
			        <cfset clean_content = "#post_content#">
			      </cfif>

					  <cfset ep = Find('id=""]',clean_content)>
<!--- 			Replace(Replace(theText, ']', '', 'all'), '[', '', 'all')> --->
<!--- 			<cfset clean_content = RemoveChars(clean_content,1,ep+5)> --->
<!--- 		  <cfset clean_content = REReplaceNoCase(clean_content,'[(.|\n)*?]',"","ALL")> --->
					  <cfset clean_content = REReplaceNoCase(clean_content,'\[.*?\]',"","ALL")>
			      <div class="col-xs-12 col-sm-3 blog-post-wrapper">
				      <a href="/blog/#post_name#"><cfif LEN(thumbnail_url)><img class="lazy" data-src="#thumbnail_url#" src="/images/layout/1x1.png" alt=""><cfelse><img src="https://via.placeholder.com/150" alt=""></cfif></a>
							<a href="/blog/category/#categorySlug#"><p class="blog-header-subtext">#category#</p></a>
							<a href="/blog/#post_name#" class="link-post-title"><p class="h4 h1-header site-color-3">#fullLeft(stripHTMLr(post_title), 40)#. . .</p></a>
<!--- <article class="test"> --->
              <p class="blog-content">#fullLeft(stripHTMLr(clean_content), 125)#. . .<a href="/blog/#post_name#" class="site-color-1">read more</a></p>
<!--- </article> --->
		    		</div>
			    </cfoutput>
			  </cfsavecontent>
			</cfif>
			<cfif isDefined('sc_recentblogpost')><cfoutput>#sc_recentblogpost#</cfoutput></cfif>
			<!---
						<cfoutput>#rootPath#</cfoutput><br>
						<cfoutput>#settings.wp_dsn# jjjjj</cfoutput><br>
			--->
			<!--- 			E:\inetpub\wwwroot\domains\southernresorts.com\htdocs\blog\index.php --->

    		<div class="col-xs-12">
				<a class="southern-btn" href="/blog">All Blog Posts<i class="fa fa-arrow-right"></i></a>
    		</div>
       	</div>
	</div>
	<cf_htmlfoot>
		<script>
			$('.blog-content:contains("PGJyPgo8Y2VudGVyPg==PC9jZW50ZXI+CjxCUj4=PGJyPgo8Y2VudGVyPjwvY2VudGVyPg==")').each(function(){
			    $(this).html($(this).html().split("PGJyPgo8Y2VudGVyPg==PC9jZW50ZXI+CjxCUj4=PGJyPgo8Y2VudGVyPjwvY2VudGVyPg==").join(""));
			});
		</script>
	</cf_htmlfoot>