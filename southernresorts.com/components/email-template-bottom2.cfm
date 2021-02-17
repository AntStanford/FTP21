                              </td>
                            </tr>
                            <!-- spacing -->
                            <tr>
                              <td width="100%" height="15" style="font-size:1px;line-height:1px;mso-line-height-rule:exactly;">&nbsp;</td>
                            </tr>
                            <!-- End of spacing -->
                            <!-- Spacing -->
                            <tr>
                              <td width="100%" height="15" style="font-size:1px;line-height:1px;mso-line-height-rule:exactly;">&nbsp;</td>
                            </tr>
                            <!-- Spacing -->
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <!-- Spacing -->
                    <tr>
                      <td height="20" style="font-size:1px;line-height:1px;mso-line-height-rule:exactly;">&nbsp;</td>
                    </tr>
                    <!-- Spacing -->
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
  </tbody>
</table>
<!-- End of Full Text -->
<!-- Start of seperator -->
<table width="100%" bgcolor="#fff" cellpadding="0" cellspacing="0" border="0" id="backgroundTable" st-sortable="seperator">
  <tbody>
    <tr>
      <td>
        <table width="600" align="center" cellspacing="0" cellpadding="0" border="0" class="devicewidth">
          <tbody>
            <tr>
              <td align="center" height="25" style="font-size:1px;line-height:1px;">&nbsp;</td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
  </tbody>
</table>
<!-- End of seperator -->
<!-- Start of footer -->
<table width="100%" class="footer" bgcolor="#fff" cellpadding="0" cellspacing="0" border="0" id="backgroundTable" st-sortable="postfooter" >
  <tbody>
    <tr>
      <td>
        <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
          <tbody>
            <!-- Spacing -->
            <tr>
              <td width="100%" height="5"></td>
            </tr>
            <!-- Spacing -->
            <cfif LEN(settings.company)>
                <td height="30" align="center" valign="middle" style="font-family:Raleway,Helvetica,arial,sans-serif;font-size:16px;font-weight:bold;color:hsl(202, 8%, 20%) !important" st-content="menu">
                  <cfoutput>
                    <p style="color:hsl(202, 8%, 20%) !important;">#settings.company#</p>
                  </cfoutput>
                </td>
              </tr>
            </cfif>
            <cfif LEN(settings.address)>
              <tr width="600">
                <td align="center" valign="middle" style="font-family:Raleway,Helvetica,arial,sans-serif;font-size:13px;color:hsl(202, 8%, 20%)" st-content="menu">
                  <cfoutput>
                    <p style="padding:0 0 5px 0;color:hsl(202, 8%, 20%) !important;line-height:20px;">#settings.address# <br /> #settings.city#,#settings.state# #settings.zip#</p>
                  </cfoutput>
                </td>
              </tr>
            </cfif>
            <cfif LEN(settings.phone)>
              <tr width="600">
                <td align="center" valign="middle" style="font-family:Raleway,Helvetica,arial,sans-serif;font-size:13px;hsl(202, 8%, 20%)" st-content="menu">
                  <cfoutput>
                    <p style="padding:0;"><a href="tel:#settings.phone#" style="color:hsl(202, 8%, 20%) !important;"><b>#settings.phone#</b></a></p>
                  </cfoutput>
                </td>
              </tr>
            </cfif>
            <!-- Spacing -->
            <tr>
              <td width="100%" height="10"></td>
            </tr>
            <!-- Spacing -->
          </tbody>
        </table>
      </td>
    </tr>
  </tbody>
</table>
<table width="100%" bgcolor="#fff" cellpadding="0" cellspacing="0" border="0" id="backgroundTable" st-sortable="footer">
  <tbody>
    <tr>
      <td>
        <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
          <tbody>
            <tr>
              <td width="100%">
                <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="devicewidth">
                  <tbody>
                    <!-- Spacing -->
                    <tr>
                      <td>
                        <cfoutput>
                          <!-- Social icons -->
                          <table  width="150" align="center" border="0" cellpadding="0" cellspacing="0" class="devicewidth social-wrapper">
                            <tbody>
                              <tr>
                                <cfif LEN(settings.facebookURL)>
                                  <td width="36" height="36" align="center">
                                    <div class="imgpop">
                                     <a href="#settings.facebookURL#" target="_blank" class="" ><img src="http://www.southernresorts.com/images/email/social-facebook.png?v=1" alt="facebook" border="0" width="36" height="36" style="display:block;border:none;outline:none;text-decoration:none;"></a>
                                    </div>
                                  </td>
                                </cfif>
                                <cfif LEN(settings.instagramURL)>
                                  <td width="36" height="36" align="center">
                                    <div class="imgpop">
                                      <a href="#settings.instagramURL#" target="_blank" class="" ><img src="http://www.southernresorts.com/images/email/social-insta.png?v=1" alt="instagram" border="0" width="36" height="36" style="display:block;border:none;outline:none;text-decoration:none;"></a>
                                    </div>
                                  </td>
                                </cfif>
                                <cfif LEN(settings.twitterURL)>
                                  <td width="36" height="36" align="center">
                                    <div class="imgpop">
                                      <a href="#settings.twitterURL#" target="_blank" class="" ><img src="http://www.southernresorts.com/images/email/social-twitter.png?v=1" alt="twitter" border="0" width="36" height="36" style="display:block;border:none;outline:none;text-decoration:none;"></a>
                                    </div>
                                  </td>
                                </cfif>
                                <cfif LEN(settings.pinterestURL)>
                                  <td width="36" height="36" align="center">
                                    <div class="imgpop">
                                      <a href="#settings.pinterestURL#" target="_blank" class="" ><img src="http://www.southernresorts.com/images/email/social-pinterest.png?v=1" alt="pinterest" border="0" width="36" height="36" style="display:block;border:none;outline:none;text-decoration:none;"></a>
                                    </div>
                                  </td>
                                </cfif>
                                <cfif LEN(settings.youtubeURL)>
                                  <td width="36" height="36" align="center">
                                    <div class="imgpop">
                                      <a href="#settings.youtubeURL#" target="_blank" class="" ><img src="http://www.southernresorts.com/images/email/social-youtube.png?v=1" alt="youtube" border="0" width="36" height="36" style="display:block;border:none;outline:none;text-decoration:none;"></a>
                                    </div>
                                  </td>
                                </cfif>

                              </tr>
                            </tbody>
                          </table>
                        </cfoutput>
                        <!-- end of Social icons -->
                      </td>
                    </tr>
                    <!-- Spacing -->
                    <tr>
                      <td height="10" style="font-size:1px;line-height:1px;mso-line-height-rule:exactly;">&nbsp;</td>
                    </tr>
                    <!-- Spacing -->
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
      </td>
    </tr>
  </tbody>
</table>
</body>
</html>