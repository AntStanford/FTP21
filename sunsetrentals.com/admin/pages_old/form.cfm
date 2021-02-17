<cfif isdefined('url.id')>
  <cfif isdefined('versionid')>
    <cfset PageTable = "cms_pages_versioning">
  <cfelse>
    <cfset PageTable = "cms_pages">
  </cfif>

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from <cfif isdefined('versionid')>cms_pages_versioning<cfelse>cms_pages</cfif> where id =
    <cfif isdefined('versionid')>
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.versionid#">
    <cfelse>
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
    </cfif>
  </cfquery>

  <cfquery name="GetPreviousVersions" dataSource="#application.dsn#">
    select * from cms_pages_versioning where MainPageID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
    order by createdat desc
  </cfquery>
</cfif>

<cfif parameterexists(id)>
  <cfset page.title = "Pages - #getinfo.name#">
<cfelse>
  <cfset page.title = "Pages">
</cfif>
<!--- <cfset page.title = "Pages"> --->
<cfset page.module = 'page'>
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getTopLevelPages" dataSource="#dsn#">
  select id,name from cms_pages where parentID = 0 and showInAdmin = 'Yes' order by name
</cfquery>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this #page.module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Success!</strong> Add another #page.module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>#page.title#</h5>
    </div>
    <div class="widget-content nopadding">

      <cfif parameterexists(id) and len(getinfo.slug)>
         <a href="/#getinfo.slug#" target="_blank" class="btn btn-info pull-right" style="margin-right:15px">View Page</a>
      </cfif>

      <ul class="nav nav-tabs" style="margin-top:20px">
        <li><a href="##basicTab" data-toggle="tab">Basic Form</a></li>
        <li><a href="##seoTab" data-toggle="tab">SEO Form</a></li>
        <li><a href="##customTab" data-toggle="tab">Custom Results Form</a></li>
      </ul>

      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
        <div class="tab-content">
          <div class="tab-pane active" id="basicTab">
				
				<div class="control-group">
            <label class="control-label">Parent</label>
            <div class="controls">
              <select name="parentID" style="width:200px">
               <option value="0" <cfif parameterexists(id) and getinfo.parentID eq 0>selected="selected"</cfif>>None</option>
               <cfloop query="getTopLevelPages">
                  <option value="#id#" <cfif isdefined('url.id') and getinfo.parentID eq #id#>selected="selected"</cfif>>#name#</option>
               </cfloop>
              </select>
            </div>
          </div>
          
            <div class="control-group">
              <label class="control-label">Show in Navigation</label>
              <div class="controls">
                <select name="showinnavigation" style="width:100px">
                  <option <cfif parameterexists(id) and getinfo.showinnavigation eq 'Yes'>selected="selected"</cfif>>Yes</option>
                  <option <cfif parameterexists(id) and getinfo.showinnavigation eq 'No'>selected="selected"</cfif>>No</option>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Show in Footer Quick Links</label>
              <div class="controls">
                <select name="showInFooter" style="width:100px">
                  <option <cfif parameterexists(id) and getinfo.showInFooter eq 'No'>selected="selected"</cfif>>No</option>
                  <option <cfif parameterexists(id) and getinfo.showInFooter eq 'Yes'>selected="selected"</cfif>>Yes</option>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Trigger Only?</label>
              <div class="controls">
                <select name="triggerOnly" style="width:200px">
                  <option <cfif parameterexists(id) and getinfo.triggerOnly eq 'No'>selected="selected"</cfif>>No</option>
                  <option <cfif parameterexists(id) and getinfo.triggerOnly eq 'Yes'>selected="selected"</cfif>>Yes</option>
                </select>
              </div>
            </div>
          
            <div class="control-group">
              <label class="control-label">Custom Booking Search Page?</label>
              <div class="controls">
                <input id="isCustomSearchPage" name="isCustomSearchPage" type="checkbox" value="yes" <cfif parameterexists(id) and getinfo.isCustomSearchPage eq 'Yes'>checked <cfelse> </cfif>>
                <small>Example - Pet Friendly Rentals</small>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Name</label>
              <div class="controls">
                <input class="sluggable" maxlength="255" name="name" type="text" <cfif parameterexists(id)>value="#getinfo.name#"</cfif>>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Slug</label>
              <div class="controls">
  
                <cfif parameterexists(id)>

                  <cfif getinfo.parentID neq 0 and getinfo.ignoreParentSlug eq 'No'> <!--- this page has a parent --->

                     <!--- Get the slug for the parent page --->
                     <cfquery name="getParentSlug" dataSource="#dsn#">
                        select slug from cms_pages where id = <cfqueryparam  CFSQLType="CF_SQL_INTEGER" value="#getinfo.parentID#">
                     </cfquery>

                     <!--- remove the parent slug --->
                     <cfset newString = replace(getinfo.slug,'#getParentSlug.slug#/','','all')>

                     <div class="input-prepend">
                        <span class="add-on">#getParentSlug.slug# /</span>
                        <input class="span2" id="prependedInput" type="text" value="#newString#" name="slug">
                     </div>

                  <cfelse>
                     <input onkeypress="return isSluggableKey(event);" class="slug" maxlength="255" name="slug" type="text" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
                  </cfif>

                <cfelse>
                  <input onkeypress="return isSluggableKey(event);" class="slug" maxlength="255" name="slug" type="text" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
                </cfif>
                <br /><br /><div class="alert alert-danger" style="width:50%">(The slug value may only contain lowercase letters, numbers and hyphens - all other characters are prohibited)</div>
              </div>
            </div>

            <cfif parameterexists(id)>
              <div class="control-group">
                <label class="control-label" for="ignoreParentSlug">Ignore Parent Slug</label>
                <div class="controls">
                  <label class="radio inline" for="radios-0">
                    <input type="radio" name="ignoreParentSlug" id="radios-0" value="No" <cfif getinfo.ignoreParentSlug eq 'No'>checked="checked"</cfif>>
                    No
                  </label>
                  <label class="radio inline" for="radios-1">
                    <input type="radio" name="ignoreParentSlug" id="radios-1" value="Yes" <cfif getinfo.ignoreParentSlug eq 'Yes'>checked="checked"</cfif>>
                    Yes
                  </label>
                </div>
              </div>
            <cfelse>
              <div class="control-group">
                <label class="control-label" for="ignoreParentSlug">Ignore Parent Slug</label>
                <div class="controls">
                  <label class="radio inline" for="radios-0">
                    <input type="radio" name="ignoreParentSlug" id="radios-0" value="No" checked="checked">
                    No
                  </label>
                  <label class="radio inline" for="radios-1">
                    <input type="radio" name="ignoreParentSlug" id="radios-1" value="Yes">
                    Yes
                  </label>
                </div>
              </div>
            </cfif>

            <div class="control-group">
              <label class="control-label">External Link</label>
              <div class="controls">
                <input maxlength="255" name="externalLink" type="text" <cfif parameterexists(id)>value="#getinfo.externalLink#"</cfif>>
              </div>
            </div>

            <cfif parameterexists(id) and getinfo.slug eq 'index'>
  			  		<!--- Don't let a user change the layout for the homepage --->
  			  		<input type="hidden" name="layout" value="home.cfm">  			  		
            <cfelse>
  			  		  				  	  
  				  	  <cfset layoutList = 'Default.cfm,Full.cfm,Left-sidebar.cfm'>
	              
                <div id="selectStandardLayout" class="control-group select-layout">
  		            <label class="control-label">Layout</label>
  		            <div class="controls">
  		              <select name="layout" id="layoutSelect" style="width:200px">
                      <cfloop list="#layoutList#" index="i">
                      <option value="#i#" <cfif parameterexists(id) and getinfo.layout eq i>selected</cfif>>#i#</option>
                      </cfloop>
  		              </select>
  		            </div>
  		          </div>
                <div id="selectBookingLayout" class="control-group select-layout">
  		            <label class="control-label">Layout</label>
  		            <div class="controls">
  		              <select name="layout" id="layoutSelect" style="width:200px">
                      <option id="bookingVal" value="full-booking.cfm">Full Booking</option>
  		              </select>
  		            </div>
  		          </div>
	
    			  </cfif>

            <div class="control-group">
              <label class="control-label">Body</label>
              <div class="controls">
                <textarea id="txtContent" name="body" rows="4" cols="30">
                  <cfif parameterexists(id)>#getinfo.body#</cfif>
                </textarea>
                <br /><div class="alert alert-danger" style="width:50%">(DO NOT copy/paste your content into the text editor)</div>
              </div>
            </div>

            <cfif isdefined('url.id') and GetPreviousVersions.recordcount gt 0>
        			<div class="control-group">
                <label class="control-label">Versioning</label>
                <div class="controls">
                  <a href="form.cfm?id=#url.id#" class="btn btn-info">Current</a>
                  <cfloop query="GetPreviousVersions">
                  <a style="margin-bottom:5px" class="btn btn-info" href="form.cfm?id=#MainPageID#&versionid=#id#">#dateformat(createdat,'dd/mm/yyyy')# #timeformat(createdat,'hh:mm tt')#</a>
                  </cfloop>
                </div>
              </div>
            </cfif>
          </div><!-- END basicTab -->

          <div class="tab-pane" id="seoTab">
  				
  				<cfinclude template="_seo-form.cfm">
  
          </div><!-- END seoTab -->

          <div class="tab-pane" id="customTab">
            
				<div class="control-group">
	            <label class="control-label">Popular search?</label>
	            <div class="controls">
	              <select name="popularSearch" style="width:200px">
	               <option <cfif parameterexists(id) and getinfo.popularSearch eq 'No'>selected="selected"</cfif>>No</option>
	               <option <cfif parameterexists(id) and getinfo.popularSearch eq 'Yes'>selected="selected"</cfif>>Yes</option>
	              </select>
	            </div>
	          </div>

						<div class="control-group">
							<label class="control-label">Popular Search Photo</label>
							<div class="controls">
								<div class="uploader" id="uniform-undefined">
									<input type="file" size="19" name="popularSearchPhoto" style="opacity:0;">
									<span class="filename">No file selected</span>
									<span class="action">Choose File</span>
								</div>
								<cfif parameterexists(id) and len(getinfo.popularSearchPhoto)>
									<a href="/images/popular/#getinfo.popularSearchPhoto#" target="_blank" class="btn btn-mini btn-info"><i class="icon-eye-open icon-white"></i> View Image</a>
								</cfif>
							</div>
						</div>

            <div class="custom-search-fields">
            <cfinclude template="_search-form.cfm">
            </div>

          </div><!-- END customTab -->

          <div class="form-actions">
            <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
            <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
          </div>
        </div>
      </form>

    </div><!-- END widget-content -->
  </div><!-- END widget-box -->

</cfoutput>


<script type="text/javascript">
  
  /* 45 = hyphen */	
	function isSluggableKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode != 45 && charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 97 || charCode > 122)){
      return false;
    } else {
      return true;
    }
  };
  	
  $(document).ready(function(){
    checkCustomPage();
    
    $( "input[name=isCustomSearchPage]" ).click(function() {
      checkCustomPage();
    });

    function checkCustomPage() {

      var customChecked = $('input[name=isCustomSearchPage]:checked');
      console.log(customChecked);
      if (customChecked.length == 1) {      

        console.log('checked');

        $('#selectStandardLayout').addClass('hidden');
        $('#selectBookingLayout').removeClass('hidden');
        $("#selectStandardLayout #layoutSelect").attr("disabled", true);
        $("#selectBookingLayout #layoutSelect").attr("disabled", false);
        $('#layoutSelect').select2();
  
      } else {

        console.log('not checked');

        $('#selectStandardLayout').removeClass('hidden');
        $('#selectBookingLayout').addClass('hidden');
        $("#selectStandardLayout #layoutSelect").attr("disabled", false);
        $("#selectBookingLayout #layoutSelect").attr("disabled", true);
        $('#layoutSelect').select2();
      }
    }        
  });
</script>

<cfinclude template="/admin/components/footer.cfm">