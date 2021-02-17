$(document).ready(function(){

  ///////////////////////////////////
  // All Pages
  ///////////////////////////////////

  //Mobile Navigation Toggle
  $('.navbar-toggle').click(function(){
    $(this).find('.fa').toggleClass('fa-bars').toggleClass('fa-times');
    $('.nav.navbar-nav').slideToggle(200);
  });

  //Datepicker
  if ($('.datepicker').length) {
    $('.datepicker').datepicker();
  }

  ///////////////////////////////////
  // Internal Pages
  ///////////////////////////////////

  //Sidebar Navigation Dropdown Toggle
  if ($('sidebar-list-link').length) {
    $('.sidebar-list-link').click(function(){
      $(this).toggleClass('open');
      $(this).next().slideToggle(200);
      $(this).find('.sidebar-list-link-arrow .fa').toggleClass('fa-chevron-down').toggleClass('fa-chevron-up');
    });
  }

  ///////////////////////////////////
  // Login Page
  ///////////////////////////////////

  //Login Tabs Toggle
  if ($('.login-tabs').length) {
    $('.login-tabs a').click(function(){
      var dataTab = $(this).attr('data-tab');
      if (dataTab === dataTab) {
        $('.login-tabs a').removeClass('active');
        $(this).addClass('active');
        $('.login-form-item').addClass('hidden');
        $('#'+dataTab).removeClass('hidden');
      }
    });
  }

  //Validate Login Form
  if ($('#loginform').length) {
    $('form#loginform').validate();
  }

  //Validate Creat Account Form
  if ($('#createaccountform').length) {
    $('form#createaccountform').validate(
      {
    		rules: {
    			password: 'required',
    			password_again: {
    				equalTo: '#password'
    			}
    		}
    	}
    );
  }

  //Validate Send Question to Form
  if ($('#sendquestiontopmform').length) {
    $('form#sendquestiontopmform').validate();
  }

  //Forgot Password Form
  if ($('#forgotPasswordForm').length) {
    $('#forgotPasswordForm').validate();
    $('#forgotPasswordForm').submit(function(){
      $.ajax({
        type: "POST",
        url: "../guest-focus/submit.cfm",
        data: $("#forgotPasswordForm").serialize(),
        success: function(data) {
          if ( $('#forgotPasswordForm').valid() == true ) {
            $('#forgotPasswordModal').modal('hide');
            $('.forgot-password-alert').removeClass('hidden');
          }
        }
      });
      return false;
    });
  }
  
  //Validate Send to Friend form
  if ($('#sendFavsToFriend').length) {
    $('form#sendFavsToFriend').validate();
  }
  
  //Validate Request to Redeem Points form
  if ($('#requestToRedeemPointsForm').length) {
    $('form#requestToRedeemPointsForm').validate();
  }

});