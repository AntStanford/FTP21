<cfset page.title ="Longterm Rentals">
<cfset uppicture = #ExpandPath('/images/longtermrentals')#>


<cfif isdefined('url.id')>
  
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_longterm_rentals where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
  
</cfif>

<cfinclude template="/admin/components/header.cfm">  
  
<cfquery name="getStates" dataSource="#settings.bcdsn#">
	select * from states order by name_long
</cfquery> 
  
  
<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this long term rental or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.deletephoto') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Photo deleted!</strong> Continue editing this long term rental or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Insert successful!</strong> Add another long term rental or <a href="index.cfm">go back.</a>
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
  
      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">        
        
            <div class="control-group">
					<label class="control-label">Status</label>
					<div class="controls">
						<select name="status" style="width:200px">
							<option <cfif parameterexists(id) and getinfo.status eq 'Active'>selected</cfif>>Active</option>
							<option <cfif parameterexists(id) and getinfo.status eq 'In-Active'>selected</cfif>>In-Active</option>
						</select>
						<div class="help-block">
						(Setting this rental to 'in-active' will remove it from the public view)
						</div>
					</div>
				</div>
            
            <div class="control-group">
					<label class="control-label">Name</label>
					<div class="controls">
						<input type="text" name="name" <cfif parameterexists(id)>value="#getinfo.name#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Slug</label>
					<div class="controls">
						<input type="text" name="slug" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
						<div class="help-block">(No spaces or special characters, hyphens are allowed, all lowercase please)</div>
					</div>
				</div>


           	<div class="control-group">
					<label class="control-label">Address</label>
					<div class="controls">
						<input type="text" name="address" <cfif parameterexists(id)>value="#getinfo.address#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls">
						<input type="text" name="city" <cfif parameterexists(id)>value="#getinfo.city#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">State</label>
					<div class="controls">
						<select name="state" style="width:200px">
							<cfloop query="getStates">
								<option <cfif parameterexists(id) and getinfo.state eq getStates.name_long>selected="selected"</cfif>>#name_long#</option>
							</cfloop>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Zip</label>
					<div class="controls">
						<input type="text" name="zip" <cfif parameterexists(id)>value="#getinfo.zip#"</cfif>>
					</div>
				</div>
				
								
				<div class="control-group">
					<label class="control-label">Type</label>
					<div class="controls">
						<select name="type" style="width:200px">
							<option value=" ">- Choose One -</option>
						   <option value="Townhouse" <cfif parameterexists(id) and getinfo.type eq 'Townhouse'>selected="selected"</cfif>>Townhouse</option>
						   <option value="House" <cfif parameterexists(id) and getinfo.type eq 'House'>selected="selected"</cfif>>House</option>
						   <option value="Condo" <cfif parameterexists(id) and getinfo.type eq 'Condo'>selected="selected"</cfif>>Condo</option>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Beds</label>
					<div class="controls">
		            <select class="form-control" name="bedrooms" style="width:100px">							
							<cfloop from="1" to="6" index="i">
							    <cfoutput><option <cfif parameterexists(id) and getinfo.bedrooms eq #i#>selected="selected"</cfif>>#i#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Baths</label>
					<div class="controls">
						<input type="text" name="bathrooms" <cfif parameterexists(id)>value="#getinfo.bathrooms#"<cfelse>value="0.0"</cfif>>
						<div class="help-block">(Decimals are allowed)</div>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Pet Friendly</label>
					<div class="controls">
						<select class="form-control" name="pet_friendly" style="width:100px">							
							<option <cfif parameterexists(id) and getinfo.pet_friendly eq 'No'>selected="selected"</cfif>>No</option>
							<option <cfif parameterexists(id) and getinfo.pet_friendly eq 'Yes'>selected="selected"</cfif>>Yes</option>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Available Now</label>
					<div class="controls">
						<select class="form-control" name="available_now" style="width:100px">							
							<option <cfif parameterexists(id) and getinfo.available_now eq 'No'>selected="selected"</cfif>>No</option>
							<option <cfif parameterexists(id) and getinfo.available_now eq 'Yes'>selected="selected"</cfif>>Yes</option>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Monthly Rate</label>
					<div class="controls">
						<input type="text" name="monthly_rate" <cfif parameterexists(id)>value="#getinfo.monthly_rate#"<cfelse>value="0.0"</cfif>>
						<div class="help-block">(No commas please, decimals are allowed)</div>
					</div>
				</div>	
				
				
				<div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<textarea name="description" id="txtContent"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>
						
                    
					</div>
				</div>
								
				<div class="control-group">
					<label class="control-label">Amenities</label>
					<div class="controls">
						<textarea name="amenities" style="height:100px"><cfif parameterexists(id)>#getinfo.amenities#</cfif></textarea>
						<div class="help-block">(Separate amenities using a semi-colon)</div>
					</div>
				</div>    
				
				
				<div class="control-group">
					<label class="control-label">Meta Title</label>
					<div class="controls">
						<input type="text" name="metaTitle" <cfif parameterexists(id)>value="#getinfo.metaTitle#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Meta Description</label>
					<div class="controls">
						<textarea name="metaDescription" class="mceNoEditor" style="height:100px"><cfif parameterexists(id)>#getinfo.metaDescription#</cfif></textarea>
					</div>
				</div>     
				
               <div class="control-group">
                  <label class="control-label">Main Photo</label>
                  <div class="controls">
                  <div class="uploader" id="uniform-undefined">
                  <input type="file" size="19" name="mainphoto" style="opacity:0;">
                  <span class="filename">No file selected</span>
                  <span class="action">Choose File</span>
                  </div>	
                  <div class="help-block">For optimal load times, images should be resized to 800px max width before uploading</div>			
                  <cfif parameterexists(id) and len(getinfo.mainphoto)>
                  <a href="/images/longtermrentals/#getinfo.mainphoto#" target="_blank" class="btn btn-mini btn-success"><i class="icon-eye-open icon-white"></i> View Image</a>                  
                  </cfif>              
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


<script type="text/javascript">

   	/*
$(document).ready(function(){
   		
   		$(".form-horizontal").validate({
   		rules:{
   			pricingLow:{
   				number:true
   			},
   			pricingHigh:{
   				number:true
   			}
   		},
   		errorClass: "help-inline",
   		errorElement: "span",
   		highlight:function(element, errorClass, validClass) {
   			$(element).parents('.control-group').addClass('error');
   		},
   		unhighlight: function(element, errorClass, validClass) {
   			$(element).parents('.control-group').removeClass('error');
   			$(element).parents('.control-group').addClass('success');
   		}
   	
   	});
		
	});
*/

</script>

