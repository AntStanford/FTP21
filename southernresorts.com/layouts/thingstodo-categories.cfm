<!--- Get Category based on slug --->
<cfquery name="getCategory" dataSource="#settings.dsn#">
	select * from cms_thingstodo_categories where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<!--- Query all Destinations to loop over later --->

<!--- Query all Categories for sub menu --->
<cfquery name="getAllCategories" dataSource="#settings.dsn#">
	select title,slug,content from cms_thingstodo_categories order by title
</cfquery>
<cfquery name="getAllSubCategories" dataSource="#settings.dsn#">
	select title,slug from cms_thingstodo_subcategories order by title
</cfquery>
<cfinclude template="/components/header.cfm">
	<cfquery name="getDestinations" datasource="#settings.dsn#">
	SELECT ID, Title, bannerImage, nodeid, slug FROM cms_destinations
		order by title
</cfquery>
<style>
.row.pdp-experience p.h1 { text-align: left; }
.experience-listings { margin: 0 35px; }
.i-quick-search {display: none;}
.experience-listings .h4 { font-family: 'Playfair Display', serif !important; font-weight: 400 !important; /* text-shadow: 0px 2px 5px rgb(44, 44, 44); */ margin-top: 0 !important; font-size: 21px !important; line-height: 27px !important; letter-spacing: 1px; }	
.i-content h1 { text-align: left; color: #000 !important; }
.h2.site-color-1 { font-family: 'Playfair Display', serif; text-transform: none; color: #000 !important; font-weight: 100; font-size: 25px; }
.row.experience-group, .row.gcg-map { margin: 10px 37px 58px; }
.i-content .callouts-wrapper h1, .i-content .callouts-wrapper .h1, .mce-content-body .callouts-wrapper  h1, .mce-content-body .callouts-wrapper  .h1 { margin-bottom: 4px; font-size: 30px;}
.i-content .h5.callout-subtext {font-size: 15px;}
.i-content .h4.callout-category { font-size: 34px;}
.row.experience-group input {background: transparent; border: none; font-style: italic; float: right;}
</style>
	<div class="i-content ttd-cat-wrapper">
	  <div class="container">
	  	<div class="row">
	  		<div class="col-sm-12">
		  		<div class="i-quick-nav">
					<!---
	        	<cfloop query="getAllCategories">
	         		<cfoutput><a href="/gulf-coast-guide/things-to-do/#slug#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white">#title#</a></cfoutput>
	         	</cfloop>
	--->
	       	</div><br>
	        <!---   <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
	        <cfoutput>
	   				<cfif len(getCategory.h1)>
	   					<h1 class="site-color-1">#getCategory.h1#</h1>
	   				<cfelse>
	   					<h1 class="site-color-1">#getCategory.title#</h1>
	   				</cfif>
						<p>#getcategory.content#</p>
	        <!---    <p>#getCategory.body#</p> --->
					</cfoutput>
	       <!---   </cfcache> --->
	  		</div>
	  	</div>
	  	<!--- Loop over all Destinations --->
	  	<cfoutput query="getDestinations">	
	  		<!--- While looping over all destinations, query for 5 random things to do --->
	  		<cfquery name="getThingstodo" dataSource="#settings.dsn#">
				select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
				AND (subcatIDS is null OR subcatIDS = '')
				AND destination_id like '%-#getDestinations.nodeID#-%'
				ORDER BY RAND()
				limit 5
			</cfquery> 
			<!--- Loop over the 5 random Things To Do --->
			<cfif getThingstodo.recordcount gt 0>
		  	<div class="row experience-group">
		  		<div class="col-sm-12 experience-group-col">
	          	<!---    <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
			      <div class="h2 site-color-1">Experience #getDestinations.Title# #getCategory.Title#</div>
			        <div class="row">
				        <cfloop query="getThingstodo">
				  		    <div class="col-xs-12 col-sm-2 dest-ttd-listing">
	                  <!--- <img src="https://via.placeholder.com/150"> --->
	                  <cfif len(website)>
			      			    <a href="#website#" target="_blank" rel="noopener">
			      			    	<cfif len(photo)>
			      			    		<img src="/images/thingstodo/#photo#">
			      			    	<cfelse>
			      			    		<img src="http://placehold.it/359x177&text=No%20Image">
			      			    	</cfif>
			      			    </a>
		      			    <cfelse>
		      			    	<cfif len(photo)>
		      			    		<img src="/images/thingstodo/#photo#">
		      			    	<cfelse>
		      			    		<img src="http://placehold.it/359x177&text=No%20Image">
		      			    	</cfif>
		      			    </cfif>
					  		    <div class="title">#title#</div>
					  		    <div class="description">
						  		    <cfif len(description) gt 250>
	                      #left(description,250)#...
	                    <cfelse>
	                      #description# 
	                    </cfif>
	                  </div>
										<!---
						  		    <div class="address">Address</div>
						  		    <a href="" class="phone">(555) 555-5555</a>
										--->
					  		  </div><!--END dest-ttd-listing col -->
									<cfif currentrow mod 5 EQ 0>
										<div class="col-xs-12"><input type="button" value="See More..." class="see-more" onclick="window.location='/thingstodo-more/#cgi.query_string#/#getdestinations.slug#'"></div>
										</div><!--END row-->
										<div class="row cat_#getcategory.id#" style="display:none">
									</cfif>
						  	</cfloop>
					  		<cfloop from="1" to ="#5-getThingstodo.recordcount#" index="i">
					  			<div class="col-xs-12 col-sm-2"></div><!--END Empty col-->
					  		</cfloop>
			<!---         </cfcache> --->
			  		</div><!--END row-->
			  	</div><!--END experience-group-col col-->
			  </div><!--END row experience-group-->
			</cfif>
							
			<cfquery name="getThingstodosub" dataSource="#settings.dsn#">
			select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
			AND (subcatIDS is not null OR subcatIDs <> '')
			AND destination_id like '%-#getDestinations.nodeID#-%'
			ORDER BY RAND()
			</cfquery>	
					
			<cfquery name="getsubIDs" dbtype="query">
				select distinct(subcatIDs) from getThingstodosub
			</cfquery>
			<cfloop list="#valuelist(getSubIDs.subcatIDs)#" index="subid">
				<cfquery dataSource="#settings.dsn#" name="subcat">
					select * from cms_thingstodo_subcategories
					where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#subid#">
				</cfquery>
			<!--- Loop over the 5 random Things To Do Items For SUBCAT'S --->
          <!--- 			<cfif getThingstodo.recordcount gt 0> --->
			  	<div class="row experience-group subcategory">
			  		<div class="col-sm-12">
			        <!---   <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
				        <div class="h2 site-color-1">Experience #getDestinations.Title# #subcat.Title# </div>
				        <div class="row">
							
							<cfquery name="getst" dataSource="#settings.dsn#">
								select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
								AND subcatIDS = #subID#
								AND destination_id like '%-#getDestinations.nodeID#-%'
								ORDER BY RAND()
								limit 5
							</cfquery>
							
                  			        <cfloop query="getSt"> 
				  		    <div class="col-xs-12 col-sm-2">
	                  <!--- <img src="https://via.placeholder.com/150"> --->
                    <!---
	                  <cfif len(website)>
			      			    <a href="#website#" target="_blank" rel="noopener">
			      			    	<cfif len(photo)>
			      			    		<img src="/images/thingstodo/#photo#">
			      			    	<cfelse>
			      			    		<img src="http://placehold.it/359x177&text=No%20Image">
			      			    	</cfif>
			      			    </a>
		      			    <cfelse>
										--->
										<!---
		      			    	<cfif len(photo)>
		      			    		<img src="/images/thingstodo/#photo#">
		      			    	<cfelse>--->
		      			    	
		      			    	<cfif len(website)>
			      			    <a href="#website#" target="_blank" rel="noopener">
			      			    	<cfif len(photo)>
			      			    		<img src="/images/thingstodo/#photo#">
			      			    	<cfelse>
			      			    		<img src="http://placehold.it/359x177&text=No%20Image">
			      			    	</cfif>
			      			    </a>
		      			    <cfelse>
		      			    	<cfif len(photo)>
		      			    		<img src="/images/thingstodo/#photo#">
		      			    	<cfelse>
		      			    		<img src="http://placehold.it/359x177&text=No%20Image">
		      			    	</cfif>
		      			    </cfif>
<!--- 		      			    		<img src="http://placehold.it/359x177&text=No%20Image"> --->
										<!--- </cfif> --->
										<!---  </cfif> --->
					  		    <div class="title">#title#</div>
					  		    <div class="description">
											<!---
																	  		    <cfif len(description) gt 250>
												                      #left(description,250)#...
												                    <cfelse>
											--->
	                    #description#
                     <!--- 	                    </cfif> --->
							
	                  </div>
										<!---
															  		    <div class="address">Address</div>
															  		    <a href="" class="phone">(555) 555-5555</a>
										--->
					  		  </div>
									
																<cfif currentrow mod 5 EQ 0>
																	<div class="col-xs-12" class="see-more-ttd"><input type="button" value="See More..." class="see-more" onclick="window.location='/thingstodo-more/#cgi.query_string#/#getdestinations.slug#'"></div><!--END col see-more-ttd-->
																	<div class="row subcat_#subid#" style="display:none"></div>
																</cfif>
									
													</cfloop>				
									
														  	
													  		<cfloop from="1" to ="#5-getThingstodo.recordcount#" index="i">
													  			<div class="col-xs-12 col-sm-2">
													  			</div>
													  		</cfloop>
									
			          <!---         </cfcache> --->
			  		</div>
			  	</div>  
			  </div>
					
					
							</cfloop>			
					
        <!--- 			</cfif> END SUBCAT --->
		
	    </cfoutput> 
  </div><!--END i-content-->

<!--- <cfelse>
	<div class="i-content">
		<div class="container">
			<div class="row">
				<div class="col-lg-9 col-md-8 col-sm-12">
          <h1>Category Not Found</h1>
          <p>Sorry, that category was not found.</p>
				</div>
				<div class="col-lg-3 col-md-4 col-sm-12">
      		<div class="i-sidebar">
      			<cfinclude template="/components/callouts.cfm">
      		</div>
				</div>
			</div>
		</div>
  </div><!-- END i-content -->
</cfif> --->

<cfinclude template="/components/footer.cfm">