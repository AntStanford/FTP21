<cfset page.title ="Pixel Codes">
<cfset page.icon="fa-info-circle">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_pixel_codes
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<div class="alert alert-danger">
<strong>NOTE: ALERT</strong> - if you don't know how to use this page, please contact <a href="mailto:support@icoastalnet.com">support@icoastalnet.com</a>  Entering code incorrectly here could crash your website.
</div>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>
<!--- 
<cfif getinfo.recordcount gt 0> 
  <div class="alert alert-info">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <strong>Drag 'n drop the arrows to update sort order</strong> 
  </div>
</cfif>
 --->
<cfif getinfo.recordcount gt 0>
  <div class="widget-box">
    <div class="widget-content nopadding">
      <table class="table table-bordered table-striped">
        <tr>
          <th>Pixel Code Name</th>     
          <th width="50"></th>
		  <th width="65"></th>
        </tr>

        <cfoutput query="getinfo">
              <tr>
                <td>#PixelCodeType#</td>               
                 <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
                <td width="65"><a href="submit.cfm?id=#id#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this Pixel Code?"><i class="icon-remove icon-white"></i> Delete</a></td>   
              </tr>   
        </cfoutput>
      </table>
    </div>
  </div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">
