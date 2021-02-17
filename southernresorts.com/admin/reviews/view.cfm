<cfset page.title ="View Property Review">
<cfset module = 'review'>
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from be_reviews where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>

<cfif settings.booking.pms eq 'Homeaway'>
   
   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select strpropid,strname from pp_propertyinfo where strpropid = <cfqueryparam CFSQLType="cf_sql_varchar" value="#getinfo.unitcode#">
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>
   
   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select propertyid,name from bf_properties where propertyid = <cfqueryparam CFSQLType="cf_sql_varchar" value="#getinfo.unitcode#">
   </cfquery>

<cfelseif settings.booking.pms eq 'Escapia'>
   
   <cfquery name="getProperties" dataSource="#settings.booking.dsn#">
      select unitcode,unitshortname from escapia_properties where unitcode = <cfqueryparam CFSQLType="cf_sql_varchar" value="#getinfo.unitcode#">
   </cfquery>

</cfif>

<cfoutput>

  <p><a href="index.cfm" class="btn btn-success"><i class="icon-chevron-left icon-white"></i> Back</a></p>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form action="submit.cfm" method="post" class="form-horizontal">
            
            <div class="control-group">
					<label class="control-label">Property</label>
					<div class="controls">
						<cfif settings.booking.pms eq 'Homeaway'>
                     #getProperties.strname#   
                  <cfelseif settings.booking.pms eq 'Barefoot'>
                     #getProperties.name#
                  <cfelseif settings.booking.pms eq 'Escapia'>
                     #getProperties.unitshortname#
                  </cfif>
					</div>
				</div>
								
            <div class="control-group">
					<label class="control-label">First Name</label>
					<div class="controls">
						#getinfo.firstname#
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Last Name</label>
					<div class="controls">
						#getinfo.lastname#
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Home Town</label>
					<div class="controls">
						#getinfo.hometown#
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						#getinfo.email#
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Check-In Date</label>
					<div class="controls">
						#DateFormat(getinfo.checkInDate,'mm/dd/yyyy')#
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Check-Out Date</label>
					<div class="controls">
						 #DateFormat(getinfo.checkOutDate,'mm/dd/yyyy')#
					</div>
				</div>
				
            <div class="control-group">
              <label class="control-label" for="rating">Rating</label>
              <div class="controls">
                #getinfo.rating#
              </div>
            </div>
				
				<div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						#getinfo.title#
					</div>
				</div>
				
            <div class="control-group">
					<label class="control-label">Review</label>
					<div class="controls">            
               #getinfo.review#            
					</div>
				</div>
				
      </form>
    
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">