<cfparam name="url.id" default="0">
<cfparam name="url.nodeid" default="0">
<cfif url.id gt 0> 
    <cfset PageTable = "cms_destinations"> 

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from #PageTable# where id = 
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#"> 
  </cfquery>  
	  
</cfif> 
<cfif url.id gt 0>
  <cfset page.title = "Destinations - #getinfo.title#">
<cfelse>
  <cfset page.title = "Destinations">
</cfif>
<!--- <cfset page.title = "Pages"> --->
<cfset page.module = 'page'>
<cfquery name="getcallouts" datasource="#application.dsn#">
  SELECT * FROM cms_destinations_callouts where destination_id = #url.nodeid#
</cfquery> 
<cfinclude template="/admin/components/header.cfm"> 

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

      <ul class="nav nav-tabs" style="margin-top:20px">
        <li><a href="##basicTab" data-toggle="tab">Basic Form</a></li>
        <li><a href="##seoTab" data-toggle="tab">SEO Form</a></li>
        <li><a href="##calloutsTab" data-toggle="tab">Callouts</a></li>
      </ul>

      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
        <input type="hidden" name="nodeid" value="#url.nodeid#">
        <div class="tab-content">
          <div class="tab-pane active" id="basicTab">


            <div class="control-group">
              <label class="control-label">Slug</label>
              <div class="controls">
                <input class="sluggable" maxlength="255" name="slug" type="text" <cfif  url.id gt 0>value="#getinfo.slug#"</cfif>>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Slug for Homepage Destinations</label>
              <div class="controls">
                <input class="sluggable" maxlength="255" name="homepageSlug" type="text" <cfif  url.id gt 0>value="#getinfo.homepageSlug#"</cfif>>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Title</label>
              <div class="controls">
                <input class="sluggable" maxlength="255" name="title" type="text" <cfif  url.id gt 0>value="#getinfo.title#"</cfif>>
              </div>
            </div>
		  
		    <div class="control-group">
              <label class="control-label">Hide on Site</label>
              <div class="controls">
                <select name="hideonsite" style="width:100px">
                  <option <cfif parameterexists(id) and getinfo.hideonsite eq 'Yes'>selected="selected"</cfif>>Yes</option>
                  <option <cfif parameterexists(id) and getinfo.hideonsite eq 'No'>selected="selected"</cfif>>No</option>
                </select>
              </div>
            </div>
	
			<div class="control-group">
    					<label class="control-label">Description</label>
    					<div class="controls">
    						<textarea name="description" <!---class="mceNoEditor"---> ><cfif url.id gt 0>#getinfo.description#</cfif></textarea>
    						
    					</div>
    				</div>

             <div class="control-group">
              <label class="control-label">Banner Image</label>
              <div class="controls">
                <div class="uploader" id="uniform-undefined" style="width:290px;">
                  <input type="file" size="19" name="bannerimage" id="fileName" style="opacity:0;">
                  <span class="filename" style="width:182px;">No file selected</span>
                  <span class="action">Choose File</span>
                </div>

                <span class="help-block">
                  <br>Please adhere to the following parameters to maintain optimal page load times:<br><br>
                  Max width = 1800px<br>
                  Image resolution must not exceed 72 pixels per inch<br>
                  Max file size is 300 kb
                </span>

                <cfif  url.id gt 0 and getinfo.bannerimage neq ''>
                  <br><br>Preview:
                  <div id="chosenBanner">
                    <img src="/images/header/#getinfo.bannerimage#" style="width:50%">
                  </div>
                  <div id="hiddenBanner" style="display:none">
                    <img src="/images/layout/hero-int.jpg" style="width:50%">
                  </div>
                  <br><br>
                  <button type="button" class="btn btn-danger delete-banner-btn" data-toggle="modal" data-target="##deleteBannerModal">
                    Delete Banner Image
                  </button> 
                </cfif>

              </div>
            </div>
	
	
			 <div class="control-group">
              <label class="control-label">Vacation Stays Banner</label>
              <div class="controls">
                <div class="uploader" id="uniform-undefined" style="width:290px;">
                  <input type="file" size="19" name="vacationBanner" id="fileName2" style="opacity:0;">
                  <span class="filename" style="width:182px;">No file selected</span>
                  <span class="action">Choose File</span>
                </div>

                <span class="help-block">
                  <br>Please adhere to the following parameters to maintain optimal page load times:<br><br>
                  Max width = 1800px<br>
                  Image resolution must not exceed 72 pixels per inch<br>
                  Max file size is 300 kb
                </span>

                <cfif  url.id gt 0 and getinfo.vacationbanner neq ''>
                  <br><br>Preview:
                  <div id="chosenBanner2">
                    <img src="/images/header/#getinfo.vacationbanner#" style="width:50%">
                  </div>
                  <div id="hiddenBanner2" style="display:none">
                    <img src="/images/layout/hero-int.jpg" style="width:50%">
                  </div>
                  <br><br>
                  <button type="button" class="btn btn-danger delete-banner-btn" data-toggle="modal" data-target="##deleteBannerModal2">
                    Delete Banner Image
                  </button> 
                </cfif>

              </div>
            </div>

				 
          </div><!-- END basicTab -->

          <div class="tab-pane" id="seoTab">

  				<div class="control-group">
  					<label class="control-label">Canonical URL</label>
  					<div class="controls">
  						<input maxlength="255" name="canonicalLink" type="text" <cfif url.id gt 0>value="#getinfo.canonicalLink#"</cfif>>
  					</div>
  				</div>

            <div class="control-group">
    					<label class="control-label">H1 Tag</label>
    					<div class="controls">
    						<input maxlength="255" name="h1" type="text" <cfif url.id gt 0>value="#getinfo.h1#"</cfif>>
    					</div>
    				</div>

            <div class="control-group">
    					<label class="control-label">Meta Title</label>
    					<div class="controls">
    						<input maxlength="255" name="metatitle" size="70" type="text" <cfif url.id gt 0>value="#getinfo.metatitle#"</cfif>>
    						<div class="input-prepend">
                  <button class="btn btn-info" type="button" onClick="countit3(this)">Calculate Characters</button>
                  <input type="text" name="displaycount3" class="input-small" style="width:10%"  id="prependedInputButton">
    						</div>
    					</div>
    				</div>

            <div class="control-group">
    					<label class="control-label">Meta Description</label>
    					<div class="controls">
    						<textarea name="metadescription" class="mceNoEditor"><cfif url.id gt 0>#getinfo.metadescription#</cfif></textarea>
    						<div class="input-prepend">
                  <button class="btn btn-info" type="button" onClick="countit2(this)">Calculate Characters</button>
                  <input type="text" name="displaycount2" class="input-small" style="width:10%"  id="prependedInputButton">
    						</div>
    					</div>
    				</div>

          </div><!-- END seoTab -->

          <div class="tab-pane" id="calloutsTab">
          <cfloop from = "1" to ="4" index="i">
            <div class="control-group">
            <label class="control-label">Title</label>
            <div class="controls">
              <input type="text" name="Callout_title_#i#" <cfif getcallouts.recordcount gte i>value="#getcallouts.title[i]#"</cfif>>
            </div>
          </div>
			  
		  <div class="control-group">
            <label class="control-label">Link</label>
            <div class="controls">
              <input type="text" name="link_#i#" <cfif getcallouts.recordcount gte i>value="#getcallouts.link[i]#"</cfif>>
            </div>
          </div>
         
          <div class="control-group">
            <label class="control-label">Description</label>
            <div class="controls">
              <textarea name="Callout_description_#i#" style="height:100px"><cfif getcallouts.recordcount gte i>#getcallouts.description[i]#</cfif></textarea>
            </div>
          </div>
  				<div class="control-group">
            <label class="control-label">Image</label>
            <div class="controls">
              <div class="uploader" id="uniform-undefined">
                <input type="file" size="19" name="Callout_photo_#i#" style="opacity:0;">             
                <span class="filename">No file selected</span>
                <span class="action">Choose File</span>
              </div>        
              <div class="help-block">(Image must be resized to 262 by 200 before uploaded; max file size is 200kb)</div>
              <cfif getcallouts.recordcount gte i>
                <br /><img src="/images/callouts/#getcallouts.photo[i]#">
              </cfif>            
            </div>
          </div>
      </cfloop>
          </div><!-- END calloutsTab -->

          <div class="form-actions">
            <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
            <input type="hidden" name="id" value="#url.id#">
          </div>
        </div>

      </form>

    </div><!-- END widget-content -->
  </div><!-- END widget-box -->

</cfoutput>

<div class="modal fade" id="deleteBannerModal" tabindex="-1" role="dialog" aria-labelledby="deleteBannerModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="deleteBannerModalLabel">Wait!</h4>
      </div>
      <div class="modal-body">
        <h3>Are you sure you want to delete this image?</h3>

        <cfif  url.id gt 0 and getinfo.bannerimage neq ''>
          <img src="/images/header/<cfoutput>#getinfo.bannerimage#</cfoutput>" style="width:100%">
        </cfif>

        <br><br>

        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
        <button id="deleteBannerPhoto" type="button" class="btn btn-danger">Delete</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteBannerModal2" tabindex="-1" role="dialog" aria-labelledby="deleteBannerModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="deleteBannerModalLabel">Wait!</h4>
      </div>
      <div class="modal-body">
        <h3>Are you sure you want to delete this image?</h3>

        <cfif  url.id gt 0 and getinfo.vacationbanner neq ''>
          <img src="/images/header/<cfoutput>#getinfo.vacationbanner#</cfoutput>" style="width:100%">
        </cfif>

        <br><br>

        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
        <button id="deleteBannerPhoto2" type="button" class="btn btn-danger">Delete</button>
      </div>
    </div>
  </div>
</div>


<script>
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

<cfif  url.id gt 0>

    // BANNER IMAGE CONTROLS
    $(document).on('click','#deleteBannerPhoto',function(){
  		$.ajax({
				url: "bannerDelete.cfm",
  			type: "GET",
  			data: {id: <cfoutput>#url.id#</cfoutput>},
				success: function (results){
          $('#deleteBannerModal').modal('hide');
          $('.delete-banner-btn').hide();
          $('#chosenBanner').hide();
          $('#hiddenBanner').show();
				},
				error: function (xhr, textStatus, errorThrown){
				// show error
				// alert(textStatus);
				}
  		});
  	});
	  
	$(document).on('click','#deleteBannerPhoto2',function(){
  		$.ajax({
				url: "bannerDelete2.cfm",
  			type: "GET",
  			data: {id: <cfoutput>#url.id#</cfoutput>},
				success: function (results){
          $('#deleteBannerModal2').modal('hide');
          $('.delete-banner-btn').hide();
          $('#chosenBanner2').hide();
          $('#hiddenBanner2').show();
				},
				error: function (xhr, textStatus, errorThrown){
				// show error
				// alert(textStatus);
				}
  		});
  	});
</cfif>
  });
</script>

<cfinclude template="/admin/components/footer.cfm">