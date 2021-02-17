<cfset page.title ="Dashboard">

<cfquery name="totalContacts" dataSource="#dsn#">
  select `id` from cms_contacts
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfoutput>
  	
    <div class="alert alert-info">
      Welcome to your website's control panel. Use the navigation on the left to access each module.  Use the top right buttons to update your profile
      or manage your site's contact information.
      <a href="##" data-dismiss="alert" class="close">x</a>
    </div>
						 		
  	<div class="row-fluid">
  		<div class="span12">  			
  			<div class="widget-box">
  			   
  			  
						 
  				<div class="widget-title"><span class="icon"><i class="icon-signal"></i></span><h5>Site Statistics</h5><div class="buttons"><a href="javascript:;" onclick="window.location.reload();" class="btn btn-mini" id="fetchSeries"><i class="icon-refresh"></i> Update stats</a></div></div>
  				<div class="widget-content">
  					<div class="row-fluid">
  					<div class="span4">
  						<ul class="site-stats">
  							<li><i class="icon-comment"></i> <strong>#totalContacts.recordcount#</strong> <small>Total Contacts</small></li>
  						</ul>
  					</div>
  					<div class="span8">  						
  						<cfinclude template="/admin/components/generate-contacts-graph.cfm"> 						  						
  					</div>	
  					</div>							
  				</div>
  			</div>					
  		</div>
  	</div>
  	</cfoutput> 

  
<cfinclude template="components/footer.cfm">
