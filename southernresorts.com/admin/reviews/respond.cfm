<cfif isdefined('form.submit')>
   
   <!--- Does a response already exist? If so, update it, otherwise, add a new one --->
   <cfquery name="responseCheck" dataSource="#settings.dsn#">
      select ID from be_responses_to_reviews where reviewID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
   </cfquery>
   
   <cfif responseCheck.recordcount gt 0>
        
        <cfquery dataSource="#settings.dsn#">
            update be_responses_to_reviews set response = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.response#">
            where reviewID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">            
        </cfquery>
        
   <cfelse>
         
         <cfquery dataSource="#settings.dsn#">
            insert into be_responses_to_reviews(reviewID,response) 
            values(
               <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">,
               <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.response#">
            )
         </cfquery>
   
   </cfif>
   
   
   
</cfif>

<cfset page.title ="Respond to Review">
<cfset module = 'review'>
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getinfo" dataSource="#settings.dsn#">
   select review from be_reviews where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>

<!--- check for any responses --->
<cfquery name="getResponse" dataSource="#settings.dsn#">
   select response from be_responses_to_reviews where reviewID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>

<cfoutput>

  <cfif isdefined('form.submit')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      Your response has been recorded. <a href="index.cfm">Back</a> to reviews.
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Response Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form method="post" class="form-horizontal">
            	
            
            				
				<div class="control-group">
					<label class="control-label">Review</label>
					<div class="controls">
						<p>#getinfo.review#</p>
					</div>
				</div>
				
            <div class="control-group">
					<label class="control-label">Response</label>
					<div class="controls">
						
            <textarea name="response" id="txtContent" rows="4" cols="30">#getResponse.response#</textarea>
            
            
					</div>
				</div>
				<div class="form-actions">
					<input type="submit" value="Submit Response" class="btn btn-primary" name="submit">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>
    
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">