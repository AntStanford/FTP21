<cfset page.title ="Add Location">

<cfinclude template="/admin/components/header.cfm">

<div class="widget-box">
    <div class="widget-title">
        <span class="icon">
            <i class="icon-th"></i>
        </span>
        <h5>Add Location</h5>
    </div>
    <div class="widget-content nopadding">
        <form action="submit.cfm" method="post" class="form-horizontal">
            <div class="control-group">
                <label class="control-label">Location Title</label>
                <div class="controls">
                    <input maxlength="255" name="title" id="title" type="text" >
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">slug</label>
                <div class="controls">
                    <input maxlength="255" name="areaslug" id="areaslug" type="text" >
                </div>
            </div>
            <div class="form-actions">
                <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
                <cfoutput>
					<cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</cfoutput>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
		$("#title").on('blur', function (){	$("#areaslug").val(convertToSlug($(this).val()));	});
	});
	function convertToSlug(Text){
		return Text.toLowerCase().replace(/[^\w ]+/g,'').replace(/ +/g,'-');
	}
</script>
<cfinclude template="/admin/components/footer.cfm">
