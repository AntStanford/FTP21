<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>Style Guide</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="/stylesheets/styles.css" rel="stylesheet" type="text/css" media="screen, projection">
</head>
<body>
  <style>
    .style { height: 35px; }
  </style>

  <div class="i-content" style="background:#fff !important;">
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-6 col-md-4">
          <p class="h2">Site Color 1</p>
          <div class="style site-color-1">TEXT Example</div><div class="style site-color-1-hover">TEXT Example</div>
          <div class="style site-color-1-lighten">TEXT Example</div><div class="style site-color-1-lighten-hover">TEXT Example</div>
          <div class="style site-color-1-bg">TEXT Example</div><div class="style site-color-1-bg-hover">TEXT Example</div>
          <div class="style site-color-1-lighten-bg">TEXT Example</div><div class="style site-color-1-lighten-bg-hover">TEXT Example</div>
        </div>
      </div>
    </div><!-- END container -->

    <hr>

    <div class="container color-container">
      <div class="row">
        <div class="col-xs-12 col-sm-6 col-md-6">
          <p class="h2">Enter a Color:</p>
          <label><span class="w3-text-grey"><i>name, hex, rgb, hsl, hwb, cmyk, ncol:</i></span></label>
          <input id="color01" type="text" value="rgb(68, 138, 156)" class="w3-input w3-border" oninput="convertColor()" onchange="validateColor()" onkeydown="submitOnEnter(event)">
          <br>
          <div class="resultStrings">
            <div id="error01"></div>
            <table id="resultTable">
            <tr><td id="helpname01"></td><td id="name01"></td></tr>
            <tr><td id="helprgb01"></td><td id="rgb01"></td></tr>
            <tr><td id="helphex01"></td><td id="hex01"></td></tr>
            <tr><td id="helphsl01"></td><td id="hsl01"></td></tr>
            <tr><td id="helphwb01"></td><td id="hwb01"></td></tr>
            <tr><td id="helpcmyk01"></td><td id="cmyk01"></td></tr>
            <tr><td id="helpncol01"></td><td id="ncol01"></td></tr>
            <!--<tr><td id="helpasterix" colspan="2">*Not a web standard.</td></tr>-->
            </table>
          </div>
        </div>
        <div class="col-xs-12 col-sm-6 col-md-6">
          <div id="behindresult01">
            <div style="height:200px" id="result01">&nbsp;</div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="w3-col">
          <div id="linktocp"></div>
        </div>
      </div>
    </div><!-- END color-container -->
  </div><!-- END i-content -->

  <script src="javascript/w3color.js"></script>
  <script src="javascript/color-convertor.js"></script>

</body>
</html>