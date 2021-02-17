<script type="text/javascript">
  var onloadCallback = function() {
  	if($('div#sendtofriendcaptcha').length){
      //Send to Friend form on the PDP
      var sendtofriend = grecaptcha.render('sendtofriendcaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
      });
    }
    if($('div#reviewscaptcha').length){
      //Submit a Review form on the PDP
      var reviews = grecaptcha.render('reviewscaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
      });
    }
    if($('div#qandacaptcha').length){
      //Submit a Question form on the PDP
      var qanda = grecaptcha.render('qandacaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
      });
    }
    if($('div#pdpmoreinfocaptcha').length){
      //Request More Info form on the PDP
      var qanda = grecaptcha.render('pdpmoreinfocaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
      });
    }
    if($('div#sendtofriendcomparecaptcha').length){
      //Footer contact form
      var footerform = grecaptcha.render('sendtofriendcomparecaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>' ,
      });
    }
  };
</script>
