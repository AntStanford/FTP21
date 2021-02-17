<cfset page.title ="Resorts">  
<cfif isdefined('url.id')>
   <cfquery name="getProperty" dataSource="#application.dsn#">
  select * from track_nodes where typeid = 5 and id = #url.id#
</cfquery>
  
<cfquery name="getcms_resorts" dataSource="#application.dsn#">
 select FullDescription,videoLink,notfoundurl,metatitle,metadescription from cms_resorts where propertyid = #url.id#
</cfquery>
</cfif>

<cfinclude template="/admin/components/header.cfm"> 
 

<cfoutput> 
	<form action="submit.cfm" class="form-horizontal" method="post">
		   <div class="tab-content">

        <div class="tab-pane active" id="basicTab">
			 <div class="control-group">
	            <label class="control-label">Full Description</label>
	            <div class="controls">
	              #getProperty.longdescription#
	            </div>
	          </div>

		 
	  	<div class="control-group">
	            <label class="control-label">Full Description Override</label>
	            <div class="controls">
	  				<textarea name="FullDescription">#getcms_resorts.FullDescription#</textarea>
	            </div>
</div>
			<div class="control-group">
	            <label class="control-label">Video Link</label>
	            <div class="controls">
	  				<input type="text" name="videoLink" value="#getcms_resorts.videoLink#">
	            </div>
</div>
			<div class="control-group">
			<label class="control-label">Not Found Redirect</label>
			<div class="controls">
			   <input maxlength="255" name="notfoundurl" type="text" value="#trim(getcms_resorts.notfoundurl)#" /> 
			</div>
		 </div>
</div> 


<div class="control-group">
	<label class="control-label">SEO Title Tag</label>
		<div class="controls">
			<input maxlength="255" name="metatitle" type="text" value="#trim(getcms_resorts.metatitle)#" /> 
		</div>
	</div>
</div> 

<div class="control-group">
	<label class="control-label">SEO Meta Description Tag</label>
		<div class="controls">
			<input maxlength="255" name="metadescription" type="text" value="#trim(getcms_resorts.metadescription)#" /> 
		</div>
	</div>
</div> 


	  	<input type="submit" value="Submit">
	  	<input type="hidden" name="propertyid" value="#url.id#">
  </form>
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">
