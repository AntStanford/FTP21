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
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>',
        'size':'compact'
      });
    }
    if($('div#contactcaptcha').length){
      //Contact form on the Contact Us page
      var contactform = grecaptcha.render('contactcaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
      });
    }
    if($('div#footercaptcha').length){
      //Footer contact form
      var footerform = grecaptcha.render('footercaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>' ,
      });
    }
    if($('div#sendtofriendcomparecaptcha').length){
      //Footer contact form
      var footerform = grecaptcha.render('sendtofriendcomparecaptcha', {
        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>' ,
      });
    }
  //ADA Compliance for Google Recaptcha
  if ( $('textarea[id^=g-recaptcha-response]').length ) {
    $('textarea[id^=g-recaptcha-response]').each(function(){
      var id = $(this).attr('id');
      $(this).before('<label for="'+id+'" class="hidden">'+id+'</label>');
    });
  }
};
</script>


