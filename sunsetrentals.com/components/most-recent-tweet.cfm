<!--- Had to move it to it's own component file so that the JS wouldn't appear when it wasn't selected --->
<p class="h3 site-color-2">Most Recent Tweet</p>
<div class="twitter-feed-wrap">
  <div class="twitterLoadingWrap"><div class="twitterLoading"></div></div>
  <div class="twitterFeed">
    <a class="twitter-timeline" data-height="250" href="<cfoutput>#settings.twitterURL#</cfoutput>"></a>
    <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
  </div>
  <cf_htmlfoot>
  <script type="text/javascript" defer="defer">
  $(document).ready(function(){
    setTimeout(function(){
      <cfoutput>$('.twitterFeed iframe').contents().find('head').append('<link rel="stylesheet" href="//#cgi.server_name#/stylesheets/styles.css?v=#DateFormat(now(),'mmddhhssl')#" type="text/css" />');</cfoutput>
      $('.twitterFeed iframe').css({'height':'120px','min-height':'120px'});
      $('.twitterFeed iframe').contents().find('body').addClass('twitterBody');
      $('.twitterFeed iframe').contents().find('a').addClass('site-color-2');
      $('.twitterFeed iframe').contents().find('.timeline-TweetList .timeline-TweetList-tweet').not(':first').remove();
      if ($('.twitter-feed-wrap').parent().parent().hasClass('text-right')) {
        $('.twitterFeed iframe').contents().find('.timeline-Tweet-text').css({'text-align':'right'});
      }
    }, 2000);
    setTimeout(function(){
      $('.twitterLoadingWrap').hide();
      $('.twitterFeed').show();
    }, 2500);
  });
  </script>
  </cf_htmlfoot>
</div>