<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_contacts where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Contacts">
<cfset module = 'contact'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Insert successful!</strong> Add another #module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
           
         
      <form action="submit.cfm" method="post" class="form-horizontal">
         
         <cfif parameterexists(id) and isdefined('getinfo.camefrom') and len(getinfo.camefrom)>
            <div class="control-group">
               <label class="control-label">Came From</label>
               <div class="controls">
                  #getinfo.camefrom#
               </div>
            </div>
         </cfif>
         
         <cfif parameterexists(id) and isdefined('getinfo.property') and len(getinfo.property)>
            <div class="control-group">
               <label class="control-label">Property</label>
               <div class="controls">
                  #getinfo.property#
               </div>
            </div>
         </cfif>
         
         <cfif parameterexists(id) and isdefined('getinfo.unitcode') and len(getinfo.unitcode)>
            <div class="control-group">
               <label class="control-label">Property ID</label>
               <div class="controls">
                  #getinfo.unitcode#
               </div>
            </div>
         </cfif>
         
         <cfif parameterexists(id) and isdefined('getinfo.arrivalDate') and len(getinfo.arrivalDate)>
            <div class="control-group">
               <label class="control-label">Arrival Date</label>
               <div class="controls">
                  #DateFormat(getinfo.arrivalDate,'mm/dd/yyyy')#
               </div>
            </div>
         </cfif>
         
         <cfif parameterexists(id) and isdefined('getinfo.departureDate') and len(getinfo.departureDate)>
            <div class="control-group">
               <label class="control-label">Departure Date</label>
               <div class="controls">
                  #DateFormat(getinfo.departureDate,'mm/dd/yyyy')#
               </div>
            </div>
         </cfif>
        
        <div class="control-group">
					<label class="control-label">First Name</label>
					<div class="controls">
						<input maxlength="255" name="firstname" type="text" <cfif parameterexists(id)>value="#getinfo.firstname#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Last Name</label>
					<div class="controls">
						<input maxlength="255" name="lastname" type="text" <cfif parameterexists(id)>value="#getinfo.lastname#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						<input maxlength="255" name="email" type="text" <cfif parameterexists(id) and len(getinfo.email)>value="#decrypt(getinfo.email, application.contactInfoEncryptKey, 'AES')#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Phone</label>
					<div class="controls">
						<input maxlength="255" name="phone" type="text" <cfif parameterexists(id) and len(getinfo.phone)>value="#decrypt(getinfo.phone, application.contactInfoEncryptKey, 'AES')#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Comments</label>
					<div class="controls">
						<textarea name="comments"><cfif parameterexists(id)>#getinfo.comments#</cfif></textarea>
					</div>
				</div>
				<div class="form-actions">
				  <input type="submit" value="Submit" class="btn btn-primary">
				  <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
  		</form> 

    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">