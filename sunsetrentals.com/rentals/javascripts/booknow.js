$(document).ready(function(){
	$('form#bookNowForm').validate({
		submitHandler: function(form){
			if( $('input[name=travel_insurance]').is(':checked') ){
				//alert("it's checked");
			}else{
				alert("You must choose an insurance option to submit the reservation.");
				return false;
			}

			<!---//DISABLE THE CONFIRM BUTTON ON-CLICK SO THEY CANT SUBMIT TWICE--->
			$(window).on('beforeunload', function () {
				$("input[type=submit].booking-btn").prop("disabled", "disabled");
			});

			//iPhone specific: Does *not* support beforeunload
			var isOnIOS = navigator.userAgent.match(/iPad/i)|| navigator.userAgent.match(/iPhone/i);

			if(isOnIOS) {
				$("input[type=submit].booking-btn").prop("disabled", "disabled");
			}

			form.submit();

			$("input[type=submit].booking-btn").prop("disabled", "disabled");
		}
	});

	var propertyid = $('#propertyid').val();
	var strcheckin = $('#strCheckin').val();
	var strcheckout = $('#strCheckout').val();

	// ON PAGE LOAD, ATTEMPT TO GRAB THE SUMMAR OF FEES
	$.ajax({
		url: '/rentals/ajax/get-booknow-rates.cfm?propertyid='+propertyid+'&strcheckin='+strcheckin+'&strcheckout='+strcheckout,
		success: function( data ) {

			if(data.indexOf('Error') == 0){
				$('div#summaryContainer').hide();
				$('div#bookingform').html('<b>' + data + '</b>').show();
			}else{
				$("#apiresponse").html(data);
			}
		}
	});

	$('#numPets').change(function(){
		$('#apiresponse').fadeOut("1000");
		
		var pets = $(this).val();
		var carpass = $('#numCarPass').val();
		var addons = $('#allAddOns').val();
		var travelInsuranceSelected = '';
		var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
		var propertyid = $('#propertyid').val();
		var strcheckin = $('#strCheckin').val();
		var strcheckout = $('#strCheckout').val();

		travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

		if(!travelInsuranceSelected && !travelInsuranceNotSelected){
			travelInsuranceSelected = '';
		}


		$.ajax({
			url: '/rentals/ajax/get-booknow-rates.cfm?propertyid='+propertyid+'&strcheckin='+strcheckin+'&strcheckout='+strcheckout+'&pets='+pets+'&carpass='+carpass+'&addons='+addons+'&travelInsuranceSelected='+travelInsuranceSelected,
			success: function( data ) {
				$("#apiresponse").html(data);
				
				if(travelInsuranceSelected) {
					$("#addinsurance").trigger("click");
				}
			}
		});

		$('#apiresponse').fadeIn("1000");
	});

	$('#numCarPass').change(function(){
		$('#apiresponse').fadeOut("1000");
		var carpass = $(this).val();
		var pets = $('#numPets').val();
		var addons = $('#allAddOns').val();
		var travelInsuranceSelected = '';
		var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
		var propertyid = $('#propertyid').val();
		var strcheckin = $('#strCheckin').val();
		var strcheckout = $('#strCheckout').val();
		
		travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

		if(!travelInsuranceSelected && !travelInsuranceNotSelected){
			travelInsuranceSelected = '';
		}


		$.ajax({
			url: '/rentals/ajax/get-booknow-rates.cfm?propertyid='+propertyid+'&strcheckin='+strcheckin+'&strcheckout='+strcheckout+'&pets='+pets+'&carpass='+carpass+'&addons='+addons+'&travelInsuranceSelected='+travelInsuranceSelected,
			success: function( data ) {
				$("#apiresponse").html(data);
				
				if(travelInsuranceSelected) {
					$("#addinsurance").trigger("click");
				}
			}
		});

		$('#apiresponse').fadeIn("1000");
	});

	$('body').on('click','#enhancementsApply',function(){
		$('#apiresponse').fadeOut("1000");
		var propertyid = $('#propertyid').val();
		var strcheckin = $('#strCheckin').val();
		var strcheckout = $('#strCheckout').val();
		var pets = $('#numPets').val();
		var addons = $('#allAddOns').val();
		var carpass = $('#numCarPass').val();
		var travelInsuranceSelected = '';
		var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
		travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

		if(!travelInsuranceSelected && !travelInsuranceNotSelected){
			travelInsuranceSelected = '';
		}

		$.ajax({
			url: '/rentals/ajax/get-booknow-rates.cfm?propertyid='+propertyid+'&strcheckin='+strcheckin+'&strcheckout='+strcheckout+'&pets='+pets+'&carpass='+carpass+'&addons='+addons+'&travelInsuranceSelected='+travelInsuranceSelected,
			success: function( data ) {
				$("#apiresponse").html(data);
				if(travelInsuranceSelected) {
					$("#addinsurance").trigger("click");
				}
			}
		});

		$('#apiresponse').fadeIn("1000");
	});

	$('body').on('click','#tchoice_half',function(){
		$('#apiresponse').fadeOut("1000");

		var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
		var useraction = $(this).val(); // ADD OR REMOVE
		var promocode = $('#promocodeform').find('input[name=promocode]').val();
		var ti = $('.travel_insurance:checked').val();
		var propertyid = $('#propertyid').val();
		var strcheckin = $('#strcheckin').val();
		var strcheckout = $('#strcheckout').val();
		
		$.ajax({
			url: '/rentals/ajax/get-booknow-rates.cfm?useraction='+useraction+'&ti='+ti+'&promocode='+promocode+'&paychoice=half',
			data: formdata,
			success: function( data ) {
				$("#apiresponse").html(data);
			}
		});

		$('#apiresponse').fadeIn("1000");
	});

	$('body').on('click','#tchoice_total',function(){
		$('#apiresponse').fadeOut("1000");

		var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
		var useraction = $(this).val(); // ADD OR REMOVE
		var promocode = $('#promocodeform').find('input[name=promocode]').val();
		var ti = $('.travel_insurance:checked').val();
		var propertyid = $('#propertyid').val();
		var strcheckin = $('#strcheckin').val();
		var strcheckout = $('#strcheckout').val();

		$.ajax({
			url: '/rentals/ajax/get-booknow-rates.cfm?useraction='+useraction+'&ti='+ti+'&promocode='+promocode+'&paychoice=full',
			data: formdata,
			success: function( data ) {
				$("#apiresponse").html(data);
			}
		});

		$('#apiresponse').fadeIn("1000");
	});

		// USER IS TRYING TO ADD/REMOVE TRAVEL INSURANCE TO THER RESERVATION
		$("body").on('click','input[name="travel_insurance"]',function(){
			$('#apiresponse').fadeOut("1000");
			var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
			var useraction = $(this).val(); // ADD OR REMOVE
			var allAddOnsTotalValue = $("#allAddOnsTotalValue").val();
			var propertyid = $('#propertyid').val();
			var strcheckin = $('#strCheckin').val();
			var strcheckout = $('#strCheckout').val();
			var pets = $('#numPets').val();
			var addons = $('#allAddOns').val();
			var carpass = $('#numCarPass').val();
			var travelInsuranceSelected = '';
			var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
			travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

			if(!travelInsuranceSelected && !travelInsuranceNotSelected){
				travelInsuranceSelected = '';
			}

			$.ajax({
				url: '/rentals/ajax/get-booknow-rates.cfm?propertyid='+propertyid+'&strcheckin='+strcheckin+'&strcheckout='+strcheckout+'&pets='+pets+'&carpass='+carpass+'&addons='+addons+'&travelInsuranceSelected='+travelInsuranceSelected,
				success: function( data ) {
					$("#apiresponse").html(data);
					
					/**if(travelInsuranceSelected) {
						$("#addinsurance").trigger("click");
					}*/
				}
			});

			$('#apiresponse').fadeIn("1000");

			/**if(useraction == 'remove_insurance'){
				$('table#insuranceTable,#travelInsuranceRow').hide();
				$('#travelInsurance').val('false');
				$("#travelInsuranceAlert").modal();

				//TT 113353 start
				$("#totalAmountDisplay").html("<strong>$" + $('#TotalTotal').val() + "</strong>");
				$("#DueTodayDisplay").html("<strong>$" + parseFloat( $('#Total').val() ) + "</strong>");
				//TT 113353 end
			}else{
				$('table#insuranceTable,#travelInsuranceRow').show();
				$('#travelInsurance').val('true');

				var twi = $('#tripinsuranceamount').val();
				var total = $('#Total').val();
				var twi_total = parseFloat( total ) + parseFloat( twi );

				$('#TotalWithInsurance').val( twi_total );

				//TT 113353 start
				$("#totalAmountDisplay").html("<strong>$" + $('#TotalTotalWithInsurance').val() + "</strong>");
				$("#DueTodayDisplay").html("<strong>$" + parseFloat( twi_total.toFixed(2) ) + "</strong>");
				//TT 113353 end
			}*/
		});

		$('#addTravelInsurance2').click(function(){
			var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );

			$("#addinsurance").prop("checked", true);
			$("#addinsurance").trigger("click");	//TT 113353

			$('table#insuranceTable').show();
			$('#travelInsurance').val('true');
		});


		// PROCESS THE PROMO CODE FROM SUBMISSION
		$('form#promocodeform').submit(function(){
			var promocode = $(this).find('input[name=promocode]').val();
			var travelInsuranceSelected = '';
			var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
			travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

			if(!travelInsuranceSelected && !travelInsuranceNotSelected){
				travelInsuranceSelected = '';
			}

			if(promocode == ''){
				alert('Whoops! Looks like you forgot to enter your promo code.');
			 } else {
				var formdata = $.param( $("#promocodeform input") ) + '&addons=' + $("#allAddOns").val() + '&travelInsuranceSelected=' + travelInsuranceSelected;

				$.ajax({
					url: "/rentals/ajax/submit-promo-code.cfm",
					data: formdata,
					success: function( data ) {

						if(data.indexOf('Error') == 0){
							alert('Sorry, that promo code was invalid.');
						}else{

							$('#apiresponse').fadeOut("1000");
							$("#apiresponse").html(data);
							$('#apiresponse').fadeIn("1000");

							$('input[name=hiddenPromoCode]').val(promocode);


							if($(data).find('#promoCodeTr').length > 0){
								$('.promo-code h3').text('Promo Code Applied');
							}

							if(travelInsuranceSelected) {
								$("#addinsurance").trigger("click");
							}
						}

					}
				});
			}
			return false;
		});

		// Disable Booking Button Until Terms Are Checked
		confirmTheBooking();

		$( "#termsAndConditions" ).click(function() {
			confirmTheBooking();
		});

		function confirmTheBooking() {

			var customChecked = $('#termsAndConditions:checked');

			if (customChecked.length == 1) {
			  $("#confirmBooking").attr("disabled", false);
			} else {
			  $("#confirmBooking").attr("disabled", true);
			}

		}


    // AUTOFILL FOR FORM
    $("#contactFirstName").autofill({
      fieldId : "ccFirstName",
      overrideFieldEverytime : true
    });

    $("#contactLastName").autofill({
      fieldId : "ccLastName",
      overrideFieldEverytime : true
    });
    $("#address1").autofill({
      fieldId : "billingAddress",
      overrideFieldEverytime : true
    });
    $("#contactCity").autofill({
      fieldId : "billingCity",
      overrideFieldEverytime : true
    });
    $("#contactState").autofill({
      fieldId : "billingState",
      overrideFieldEverytime : true
    });
    $("#contactZip").autofill({
      fieldId : "billingZip",
      overrideFieldEverytime : true
    });
    $("#contactCountry").autofill({
      fieldId : "billingCountry",
      overrideFieldEverytime : true
    });
});