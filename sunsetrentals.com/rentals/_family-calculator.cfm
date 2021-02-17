<cfif isdefined('total') and isdefined('numNights')>
<div class="modal-header site-color-1-bg text-white">
  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  <h4 class="modal-title" id="splitModalLabel"><i class="fa fa-calculator" aria-hidden="true"></i> Split Cost Calculator</h4>
</div>
<div class="modal-body">

	<ul class="nav nav-tabs" role="tablist">
		<li class="active"><a href="#home" role="tab" data-toggle="tab">By # People</a></li>
		<li><a href="#profile" role="tab" data-toggle="tab">By # Families</a></li>
	</ul>
	<div class="tab-content">
		<div class="tab-pane active" id="home">
      <div class="row">
        <div class="col-xs-12 col-sm-3">
          <i class="fa fa-user split-cost-icon" aria-hidden="true"></i>
        </div>
        <div class="col-xs-12 col-sm-9">
    			<form role="form" class="people-form" id="peopleForm">
            <fieldset class="row">
              <div class="form-group col-xs-12">
    					  <label for="howmanypeople">How Many People</label>
    				  	<input id="howmanypeople" name="howmanypeople" type="text" pattern="[0-9]*" class="form-control" maxlength="2">
                <em>How many people will be going?</em>
    					</div>
              <div class="form-group col-xs-12">
    					  <label for="costperperson">Cost per Person is</label>
    					  <input id="costperperson" name="costperperson" type="text" disabled class="form-control">
    					</div>
              <div class="form-group col-xs-12">
    					  <label for="costperpersonpernight">Cost per Person per Night</label>
    					  <input id="costperpersonpernight" name="costperpersonpernight" type="text" disabled class="form-control">
    					</div>
    				</fieldset>
    			</form>
        </div>
      </div>
		</div><!-- END tab-pane active -->
		<div class="tab-pane" id="profile">
      <div class="row">
        <div class="col-xs-12 col-sm-3">
          <i class="fa fa-users split-cost-icon" aria-hidden="true"></i>
        </div>
        <div class="col-xs-12 col-sm-9">
      		<div class="row">
            <div class="form-group col-xs-12">
              <label for="howmanyfamilies">How many families are going?</label>
            	<input id="howmanyfamilies" name="howmanyfamilies" type="text" pattern="[0-9]*" class="form-control" maxlength="2">
      				<em>How many rooms?</em>
      	    </div>
      		</div>

    			<form role="form" class="family-form" id="familyForm">
    				<fieldset class="row">
    				  <div class="fcost form-group col-xs-12">
    			      <label for="familybedrooms_1">How many bedrooms will family <span>1</span> use?</label>
    			      <input name="familybedrooms_1" type="text" class="form-control">
    				  </div>
              <div class="form-group col-xs-12">
    			      <label for="familycost_1">Cost for family <span>1</span> is</label>
    			      <input name="familycost_1" type="text" disabled class="form-control">
    				  </div>
    				</fieldset>
    			</form>
        </div>
      </div>
		</div><!-- END tab-pane -->
	</div><!-- END tab-content -->

</div><!-- END modal-body -->
<div class="modal-footer">
  <button type="button" class="btn site-color-2-bg site-color-3-bg-hover text-white" data-dismiss="modal">Close</button>
</div>


<!--- THIS STAYS ON PAGE - IT ERRORS IF REMOVED --->
<script type="text/javascript" defer="defer">
	var total_cost = $('#splitCalcTotalVal').val();
	var number_of_nights = <cfoutput>#numNights#</cfoutput>;

	$(document).ready(function(){
		$("#howmanypeople").keyup(function(){
			var howmanypeople = $("#howmanypeople").val();
			if ($.isNumeric( howmanypeople )) {

				var costperperson=Math.ceil($('#splitCalcTotalVal').val() / howmanypeople);
				$("#costperperson").val("$"+costperperson);

				var costperpersonpernight = Math.ceil(costperperson / $('#splitCalcNumNightVal').val());
				$("#costperpersonpernight").val("$"+costperpersonpernight);
			}
		});

		$("#howmanyfamilies").keyup(function(){
			var numberoffamilies = $(this).val();
			if ($.isNumeric(numberoffamilies)==false) {
				numberoffamilies=1;
			}

			if (numberoffamilies < 1) {
				numberoffamilies = 1;
			}

			var cloned_row = $("#familyForm fieldset.row:first").clone();
			var current_rows = $("#familyForm fieldset.row").length;

			rows_to_add = numberoffamilies-current_rows;

			console.log('current_rows: ', current_rows);
			console.log('rows_to_add: ', rows_to_add);
			console.log('total_cost: ', total_cost);

			if (rows_to_add > 0) {
				for (i=current_rows;i<=current_rows+rows_to_add-1;i++){

					row1 = $("#familyForm fieldset.row:first").clone().addClass('clone');
					$(row1).find("label[for^='familybedrooms_']").attr("for","familybedrooms_"+(i+1));
					$(row1).find("label[for^='familybedrooms_']").find("span").html(i+1);
					$(row1).find("input").val("");

					$(row1).find("label[for^='familycost_']").attr("for","familycost_"+(i+1));
					$(row1).find("label[for^='familycost_']").find("span").html(i+1);

					$("#familyForm").append(row1);
				}
			} else if (rows_to_add < 0){
				$('#familyForm > div.row').slice(rows_to_add).remove();
				console.log('rows_to_add: ', rows_to_add);
			}
			calculateTotals();
		});

		$("#familyForm").on('keyup','input[name^="familybedrooms"]',function(){
			calculateTotals();
		});
	});

	function calculateTotals(){
		$("#familyForm input[name^='familybedrooms']").each(function(){
			var total_rooms = 0;

			$("#familyForm input[name^='familybedrooms']").each(function(){
				if ($(this).val()!=='' && $.isNumeric($(this).val())) {
					total_rooms = total_rooms + parseInt($(this).val());
				}
			});

			var fbval = $(this).val();
			var costperroom = calcluateCostPerRoom(total_cost,total_rooms);

			console.log('fbval: ', fbval);
			console.log('total_cost', total_cost);

			if (fbval!==''){
				costfamily = Math.ceil(costperroom * parseInt(fbval));
				console.log('costfamily: ', costfamily);
				$(this).closest("div.fcost").next().find("input").val('$'+costfamily);
			}
		});
	}

	function calcluateCostPerRoom(total_cost,total_rooms){
		return total_cost / total_rooms;
	}
</script>

</cfif>
