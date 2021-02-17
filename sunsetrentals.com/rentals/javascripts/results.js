// MASTER VARIABLE FOR BOOKING DIRECTORY
var bookingFolder = '/rentals';

// FORM SUBMITTER FUNCTION
function submitForm() {

  function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1);
      if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
  }
  $('#refineForm, #sortForm').find('[name=page]').val(0);
  // THIS DOES THE NEW SEARCH QUERY
  $.ajax({
    type: "POST",
    url: bookingFolder+'/ajax/results.cfm',
    data: $('#refineForm, #sortForm').serialize(),
    beforeSend: function(){
      $('.results-loader-overlay').fadeIn(200);
    },
    success: function(data) {
      var numResults = getCookie('NUMRESULTS');
      $('#bottom-result').attr('data-count', numResults);
      $('.props-return').text(numResults);
      $('#list-all-results').html(data);
      // THIS LOADS THE loading.gif IN TOP RIGHT CORNER
      $('.results-loader-overlay').fadeOut(200);

      // SRP - Featured Properties
      if ($('.owl-carousel.results-featured-carousel').length) {
        $('.owl-carousel.results-featured-carousel').owlCarousel({
          lazyLoad: true, loop: false, center: false, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: true, margin: 15,
          responsive: { 0: { items: 1 }, 737: { items: 2 }, 2000: { items: 3 } }
        });
      }

      var strcheckin = $('#refineForm input[name=strCheckin]').val();
      var strcheckout = $('#refineForm input[name=strCheckout]').val();
      var myrandnum = Math.floor((Math.random() * 100) + 1);

      // SHOW THE URGENCY FEATURE
      if(strcheckin != '' && strcheckout != ''){

        // console.log($('ul.results-sort-by li.priceasc').length);
        // USER SEARCHED BY DATES, APPEND 'price' OPTIONS TO THE SORT BY DROP DOWN, BUT ONLY IF IT DOESN'T ALREADY EXIST
        // if($('ul.results-sort-by li.priceasc').length === 0){
        $('.hidden-sort').show();
        // }

        // THIS FUNCTION GESTS THE % OF PROPERTIES BOOKED FOR THE GIVEN SEARCH CRITERIA
        $.ajax({
          type: "POST",
          url: bookingFolder+'/ajax/get-percentage-booked.cfm',
          data: $('#refineForm, #sortForm').serialize(),
          success: function(data){
            //console.log('data = ' + data);
            var percentBookedAjax = $('.percent-booked-ajax');
            if (data > 0 && numResults > 0){
              // HIDE THE DIV LOADED VIA THE POST
              $('#results-list-alert-popular-post').remove();
              var percentBooked = Math.ceil(data);
              $('#results-list-alert-popular-ajax span.percent-booked-ajax').html(percentBooked);
              $('#results-list-alert-popular-ajax').show();
            } else {
              // HIDE THE DIV LOADED VIA THE POST
              $('#results-list-alert-popular-post').remove();
              // HIDE THE DIV LOADED VIA AJAX
              $('#results-list-alert-popular-ajax').hide();
            }
          }
        }); // END AJAX CALL
      } else {
        // HIDE THE URGENCY FEATURE
        $('#results-list-alert-popular-ajax').hide();
      }
      // UPDATE THE MAP
      $.ajax({
        type: "POST",
        url: bookingFolder+'/ajax/map-all-results.cfm',
        data: $('#refineForm, #sortForm').serialize(),
        dataType: 'json',
        success: function(data) {
          var props = serializeCFJSON(data);
          drawMapAllResults(map, markers, props);
          //console.log('map has been moved - test');
        },
        error: function(xhr, textStatus, error){
          //console.log(xhr.statusText);
          //console.log(textStatus);
          //console.log(error);
        }
      });
      // END UPDATE THE MAP
    }
  }); // END AJAX CALL
};


//   ****     ****    ****  **  **   ***  ***   ******  **   **  ******       *****   ******   ****   ****    **  **
//   **  **  **  **  **     **  **  ** **** **  **      ***  **    **         **  **  **      **  **  **  **  **  **
//   **  **  **  **  **     **  **  **  **  **  *****   ** ** *    **         ** **   *****   ******  **  **   ****
//   **  **  **  **  **     **  **  **  **  **  **      **  ***    **         *** *   **      **  **  **  **    **
//   ****     ****    ****   ****   **      **  ******  **   **    **         **  **  ******  **  **  ****      **
$(document).ready(function(){
/////////////////////////////////////////
///////////   REFINE SEARCH   ///////////
/////////////////////////////////////////

  // REPEATABLE FUNCTION TO HIDE MORE FILTERS BOX
  function hideMoreFilters() {
    if (!$('.refine-filter-box').hasClass('hidden')) {
      $('.refine-filter-box').addClass('hidden');
      $('.refine-filters').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
    }
  }

  // DROP DOWN IN REFINE WRAP
  $('.refine-text').on('click', function(){
    // TOGGLE DROP DOWNS
    if ($(this).next().hasClass('hidden')) {
      hideMoreFilters();
      $('.refine-dropdown').addClass('hidden');
      $(this).addClass('active');
      $('.refine-text').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up'); // FIND ADJACENT CHEVRONS, FLIP TOGGLE WHEN OTHER REFINE ITEM IS SELECTED
      $(this).find('.fa-chevron-down').removeClass('fa-chevron-down').addClass('fa-chevron-up');
      $(this).next().removeClass('hidden');
    } else {
      $(this).removeClass('active');
      $(this).find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
      $(this).next().addClass('hidden');
    }
  });

  // OUTSIDE CLICK TO CLOSE THE DROPDOWNS
  $(document).on('click', function(e) {
    if ($(e.target).is('.refine-text, .refine-text *, .refine-dropdown, .refine-dropdown *, .refine-filter-box, .refine-filter-box *, .ui-datepicker-next, .ui-datepicker-next *, .ui-datepicker-prev, .ui-datepicker-prev *, .amen-arrow')) {
      e.stopPropagation();
    }else {
      $('.refine-dropdown, .refine-filter-box').addClass('hidden');
      $('.refine-text').removeClass('active');
      $('.refine-text').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
    }
  });

  // REFINE APPLY/CANCEL - HIDES CURRENT BOX
  $('.refine-apply, .refine-close').on('click', function(){
    // GENERAL DROPDOWNS
    if ($(this).parent().hasClass('refine-dropdown')) {
      $(this).parent().addClass('hidden');
    }
    // FILTERS
    if ($(this).parent().hasClass('refine-filter-action')) {
      $(this).parent().parent().addClass('hidden');
    }
    if ($(this).parent().parent().hasClass('refine-filter-box')) {
      $(this).parent().parent().prev().find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
    } else {
      $(this).parent().prev().find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
    }
  });

  if ($(window).width() < 1024) {
  	$('.refine-apply').on('click', function(){
      // SWAP THE REFINE TEXT BUTTON
      $('#viewFiltersMobile').html('<i class="fa fa-toggle-off site-color-1" aria-hidden="true"></i> <span class="site-color-1">Refine</span>');
      // CLOSE THE REFINE DROPDOWNS
    	if ($('.refine-text').hasClass('active')) {
      	$('.refine-dropdown').addClass('hidden');
      	$('.refine-text').removeClass('active');
      }
      // CLOSE THE REFINE
      $('.refine-form').addClass('mobile-hidden');
      // SCROLL TO TOP OF RESULTS
      var headerHeight = $('.booking-header-wrap').outerHeight();
      var refineHeight = $('.refine-mobile-controls').outerHeight();
      var headerRefineHeight = headerHeight + refineHeight + 15;
      $('html, body').animate({scrollTop : $('#scrollReturn').position().top - headerRefineHeight},800);
  	});
  }

  // ARRIVAL -> DEPARTURE DATEPICKER
  var calCount = 1;
  if ($(window).width() > 768) {
    // DESKTOP
    var calCount = [1, 2]; // TWO CALENDARS ON PAGE LOAD
  } else {
    // MOBILE
    var calCount = 1; // ONE CALENDAR ON PAGE LOAD
  }
  var dateToday = new Date();
  var startDate = $('#startDateRefine').val();

  $.datepicker.setDefaults({
    dateFormat: 'mm/dd/yy',
    minDate: dateToday
  });

  $('#refineDatepicker').datepicker({
    defaultDate: startDate,
    numberOfMonths: calCount,
    beforeShowDay: function(date) {
      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#startDateRefine').val());
      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#endDateRefine').val());
      var isHighlight = date1 && ((date.getTime() == date1.getTime()) || (date2 && date >= date1 && date <= date2));
      return [true, isHighlight ? 'dp-highlight' : ''];
    },
    onSelect: function(dateText, inst) {
      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#startDateRefine').val());
      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#endDateRefine').val());
      var selectedDate = $.datepicker.parseDate($.datepicker._defaults.dateFormat, dateText);
      if (!date1 || date2) {
        $('#startDateRefine').val(dateText).addClass('date-entered');
        $('#endDateRefine').val('').addClass('date-entered');
        console.log('Start Date Entered');
      } else if (selectedDate < date1) {
        $('#endDateRefine').val($('startDateRefine').val());
        $('#startDateRefine').val(dateText);
        console.log('You are going Backwards!');
      } else {
        $('#endDateRefine').val(dateText);
        console.log('End Date Entered');
      }
    }
  });

  // CLEAR/RESET DATEPICKERS & DATEPICKER WINDOW
  $(document).on('click','.refine-clear',function(){
    // CLEAR/RESET THE DATEPICKER VALUES
    $('#refineDatepicker').datepicker('refresh');
    // SET DATE TO TODAY FOR RESET
    $('#refineDatepicker').datepicker('setDate',new Date());
    $('#startDateRefine').val('').removeClass('date-entered').datepicker('refresh');
    $('#endDateRefine').val('').removeClass('date-entered').datepicker('refresh');
    // REMOVE HIGHLIGHT FROM DATEPICKER
    $('.ui-datepicker-calendar td').removeClass('dp-highlight');
    // HIDE DATEPICKER WRAP
    //$(this).parent('.refine-dropdown').addClass('hidden');
    // TOGGLE CHEVRON
    $(this).parent().siblings().find('.fa-chevron-up').removeClass('fa-chevron-up').addClass('fa-chevron-down');
    // Clear flexed
    $("#flexDates"). prop("checked", false);
    $('#flexed').val('');
    $('.results-tab-bar').addClass('hidden');
    submitForm();
  });

  // REFINE DATES APPLY - SUBMITS FORM
  $(document).on('click','#refineDatesApply',function(){
    submitForm();
  });


  // REFINE SELECT COUNTER
  $('.refine-counter').each(function(){
    var countTop = $(this).parent().find('.refine-count');
    var countDropdown = $(this).parent().find('.refine-drop-count');
    var currentCount = countTop.text();
    var min = $(this).find('.refine-drop-count').data('min');
    var max = $(this).find('.refine-drop-count').data('max');
    var counter = currentCount;
    if (currentCount > min) {
      $(this).find('.fa-minus').removeClass('disabled');
    }
    // COUNTING UP
    $(this).find('.fa-plus').on('click', function(){
      if (counter >= min && counter < max) {
        counter++;
        countTop.text(counter);
        countDropdown.text(counter);
        $(this).prev().prev().removeClass('disabled');
      }
      if (counter === max) {
        $(this).addClass('disabled');
      }
    });
    // COUNTING DOWN
    $(this).find('.fa-minus').on('click', function(){
      if (counter <= max && counter > min) {
        --counter;
        countTop.text(counter);
        countDropdown.text(counter);
        $(this).next().next().removeClass('disabled');
      }
      if (counter === min) {
        $(this).addClass('disabled');
      }
    });
  });

  // REFINE GUESTS COUNTER
  if($('.refine-guests-counter-wrap').length) {
    $('#refineGuestsCountApply').on('click', function(){
      var guestCount = $('.refine-guests .refine-count').text();
      $('.refine-guests input[name=sleeps]').val(guestCount);
      console.log('guestCount: ' + guestCount);
      submitForm();
    });
  }

  // REFINE BEDROOMS COUNTER
  if($('.refine-bedrooms-counter-wrap').length) {
    $('#refineBedsCountApply').on('click', function(){
      var bedCount = $('.refine-beds').text();
      $('input[name=bedrooms]').val(bedCount);
      console.log('bedCount: ' + bedCount);
      submitForm();
    });
  }

  // REFINE BATHROOMS COUNTER
  if($('.refine-bathrooms-counter-wrap').length) {
    $('#refineBathsCountApply').on('click', function(){
      var bathCount = $('.refine-baths').text();
      $('input[name=bathrooms]').val(bathCount);
      console.log('bathCount: ' + bathCount);
      submitForm();
    });
  }

/*
  // MUST HAVES CUSTOM MULTISELECT
  $('.refine-must-haves-list-item').on('click', function(){
    $(this).find('.fa').toggleClass('hidden').toggleClass('checked');
    var numChecked = $('.refine-must-haves-list-item .fa-check.checked').length;
    var refineCount = $(this).parent().parent().prev().find('.refine-count');
    refineCount.text(numChecked);
    refineCount.removeClass('hidden');
    if (refineCount.text() == 0) {
      refineCount.addClass('hidden');
    }
    var amenityText = $(this).find('em').text();
    var amenityInput = $(this).find('input[name=must_haves]');
    if (amenityInput.val()) {
      amenityInput.val('');
    } else {
      amenityInput.val(amenityText);
    }
  });

  // MUST HAVES SUBMIT
  $(document).on('click','#refineMustHavesApply', function(){
    submitForm();
  });
*/

  // MORE FILTERS SELECTED COUNT
  $('#refineMoreFiltersApply').on('click', function(){
    var checkedBoxes = $('.refine-filter-checkbox[type=checkbox]:checked').length;
    $('#filtersCount').text('(' + checkedBoxes + ')');
  });

  $('.refine-filter-checkbox').on('click', function(){
    var checkedBoxes = $('.refine-filter-checkbox[type=checkbox]:checked').length;
    var checked = $(this).prop('checked');
  });

  // MORE FILTERS - SEE ALL *
  $('.refine-filter-see-all').on('click', function(){
    $(this).prev().toggleClass('hidden');
    $(this).find('.fa').toggleClass('fa-chevron-down').toggleClass('fa-chevron-up');
  });

  // MORE FILTERS - APPLY BUTTON SUBMIT FORM
  $(document).on('click','#refineMoreFiltersApply', function(){
    submitForm();
  });


  // THIS IS FOR THE LARGE MAP
  //////////////////////////////////////////////////////////////////////////////////////
  window.map = new google.maps.Map(document.getElementById('map'), {
    zoom: 14,
    maxZoom: 18,
    mapTypeId: google.maps.MapTypeId.street,
    styles: [
        {
          "featureType": "poi.business",
          "stylers": [
            { "visibility": "off" }
          ]
        }
      ]
  });
  window.markers = [];

  $.ajax({
    type: "POST",
    url: bookingFolder+'/ajax/map-all-results.cfm',
    data: $('#refineForm, #sortForm').serialize(),
    dataType: 'json',
    success: function(data) {
      var props = serializeCFJSON(data);
      //console.log(props);
      drawMapAllResults(map, markers, props);
    },
    error: function(xhr, textStatus, error){
      //console.log(xhr.statusText);
      //console.log(textStatus);
      //console.log(error);
    }
  });

  function drawMapAllResults(map, markers, data, imagepath) {
    var infowindow = new google.maps.InfoWindow({
      size: new google.maps.Size(150, 50)
    });

    var oms = new OverlappingMarkerSpiderfier(map, {
      markersWontMove: true,
      markersWontHide: true,
      basicFormatEvents: true,
      keepSpiderfied: true,
      circleSpiralSwitchover: 'Infinity',
    });

    if (markers.length) {
      var length = markers.length;
      for (var i = length - 1; i >= 0; i--) {
        markers[i].setMap(null);
        markers[i] = null;
        markers.splice(i, 1);
      }
    }

    // DRAW ALL NEW MARKERS
    ///////////////////////
    var bounds = new google.maps.LatLngBounds();
    //If no properties are returned
    if(!data.length){
      var latitude = 29.699594;
      var longitude = -85.376316;
      var myLatlng = new google.maps.LatLng(latitude, longitude);
      var marker = new google.maps.Marker({
        map: map,
        position: new google.maps.LatLng(latitude, longitude),
        icon: bookingFolder+'/images/marker.png',
        zIndex: 1
      });
      function animateit(marker) {
        google.maps.event.addListener(marker, 'mouseover', function() {
          var icon = {url:bookingFolder+'/images/marker-hover.png', scaledSize: new google.maps.Size(28,39)};
          marker.setIcon(icon);
        });

        google.maps.event.addListener(marker, 'mouseout', function() {
          var icon = {url:bookingFolder+'/images/marker.png', scaledSize: new google.maps.Size(28,39)};
          marker.setIcon(icon);
        });
      }
      (function(prop, marker) {

        // MAP PIN DESCRIPTION BOX
        //////////////////////////
        var desc = '<a href="/about-us/contact-us/" target="_blank"><h4>Our Office</h4></a>23110 US Hwy 6, Unit 6<br>Keystone, Colorado 80435';
        google.maps.event.addListener(marker, 'spider_click', function() {
          infowindow.setContent(desc);
          infowindow.open(map, marker);
        });

        google.maps.event.addListener(map, 'spider_click', function() {
          infowindow.close();
        });

        oms.addMarker(marker);
      })(prop, marker);

      bounds.extend(myLatlng);
      animateit(marker);
      bounds.extend(myLatlng);
    }else{ //If properties are returned
      for (var i = 0; i < data.length; i++) {
        var prop = data[i];
        if (prop.latitude != null || '') { // if null or empty, don't put this into the map
          var myLatlng = new google.maps.LatLng(prop.latitude, prop.longitude);
          var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(prop.latitude, prop.longitude),
            icon: bookingFolder+'/images/marker.png',
            zIndex: 1
          });

          function animateit(marker) {
            google.maps.event.addListener(marker, 'mouseover', function() {
              var icon = {url:bookingFolder+'/images/marker-hover.png', scaledSize: new google.maps.Size(28,39)};
              marker.setIcon(icon);
            });

            google.maps.event.addListener(marker, 'mouseout', function() {
              var icon = {url:bookingFolder+'/images/marker.png', scaledSize: new google.maps.Size(28,39)};
              marker.setIcon(icon);
            });

            $(".results-list-property").mouseover(function(){
              var markerid = $(this).attr('data-mapMarkerID');
              var icon = {url:bookingFolder+'/images/marker-hover.png', scaledSize: new google.maps.Size(28,39)};
              markers[markerid].setIcon(icon);
              markers[markerid].setZIndex(100);
            });

            $(".results-list-property").mouseout(function(){
              var markerid = $(this).attr('data-mapMarkerID');
              var icon = {url:bookingFolder+'/images/marker.png', scaledSize: new google.maps.Size(28,39)};
              markers[markerid].setIcon(icon);
              markers[markerid].setZIndex(1);
            });
          }
          (function(prop, marker) {

            // MAP PIN DESCRIPTION BOX
            //////////////////////////
            var desc = '<a href="' + bookingFolder + '/' + prop.seopropertyname + '" target="_blank"><img src="' + prop.mapphoto + '" width="180" height="100" /></a>' + '<h4><a href="' + bookingFolder + '/' + prop.seopropertyname + '" target="_blank">' + prop.unitshortname + '</a></h4>' + '<strong>' + prop.bedrooms + ' BR' + ' | ' + 'Sleeps ' + prop.maxoccupancy + ' | ' + prop.bathrooms + ' Baths</strong><br>' + '<a class="btn btn-mini site-color-1-bg site-color-1-lighten-bg-hover text-white" href="' + bookingFolder + '/' + prop.seopropertyname + '" target="_blank">Learn More</a>';
            google.maps.event.addListener(marker, 'spider_click', function() {
              infowindow.setContent(desc);
              infowindow.open(map, marker);
            });

            google.maps.event.addListener(map, 'spider_click', function() {
              infowindow.close();
            });

            oms.addMarker(marker);

            /*
            // STANDARD MAP MARKER CLICK
            google.maps.event.addListener(marker, 'click', function() {
              infowindow.setContent(desc);
              infowindow.open(map, marker);
            });

            google.maps.event.addListener(map, 'click', function() {
              infowindow.close();
            });
            */
          })(prop, marker);

          bounds.extend(myLatlng);
          animateit(marker);
          markers.push(marker);
        }// end if prop.lat...
      }
    }
    map.fitBounds(bounds);
  }
  window.drawMapAllResults = drawMapAllResults;
  window.serializeCFJSON = serializeCFJSON;


  // INFINITE SCROLL AJAX RESULTS
  var isLoading = false;
  $(window).on('scroll', function(e){
    var bottomResult = $("#bottom-result");
    var form = $('#refineForm, #sortForm');
    var position = bottomResult.offset().top;
    var scllwidth = $(window).scrollTop() + $(window).height();
    if (scllwidth > position) {
      var totalRecord = parseInt(bottomResult.attr('data-count'));
      var currentPage = parseInt(form.find('[name=page]').val());
      var totalPage = Math.ceil(totalRecord/12); // ALSO SET IN THE ajax/map-all-results.cfm CALL, BELOW
      if(currentPage+1<totalPage && !isLoading){
        bottomResult.addClass('loading');
        isLoading = true;
        form.find('[name=page]').val(currentPage+1);
        $.ajax({
          type: "POST",
          url: bookingFolder+'/ajax/results.cfm?scroll',
          data: form.serialize(),
          success: function(data) {
            setTimeout(function(){
              $('#list-all-results').append(data);
              bottomResult.removeClass('loading');
              isLoading = false;
              //drawMapAllResults(map, markers, props);
              console.log('This is from the inifinite scroll ajax');
              //adoute console.log(data); //this was just html
              // Load Owl Carousel on SRP
              if ($('.owl-carousel.result-property-carousel').length) {
                loadResultsOwl(); //this is in /rentals/components/footer-javascripts.cfm
              }
            },500);
          }
        });
      }
    }
  });

  // SELECT ALL/DESELECT ALL TOGGLE FOR MORE FILTERS SELECTS
  $('.refine-filter-select-all').on('click', function(){
    var filterCheckBox = $(this).closest('.refine-filter-section').find('.refine-filter-checkbox');
    var checked = $(this).prop('checked');
    filterCheckBox.prop('checked', checked);
    $(this).next().text($(this).next().text() == 'Deselect All' ? 'Select All' : 'Deselect All');
  });

  // SELECT ALL/DESELECT ALL TOGGLE WHEN A SINGLE OR ALL INDIVIDUAL ITEMS ARE SELECTED TO SWAP SELECT/DESELECT ALL
  $('.refine-filter-checkbox').on('click', function(){
    var refineFilterCheckbox = $(this).closest('.refine-filter-section').find('.refine-filter-checkbox');
    var refineFilterSelectAll = $(this).closest('.refine-filter-section').find('.refine-filter-select-all');
    var selectAll = $(this).closest('.refine-filter-section').find('.select-all');
    if (!$(refineFilterCheckbox).filter(':checked').length > 0) {
      $(refineFilterSelectAll).prop('checked',false);
      $(selectAll).text('Select All');
    }
    if ($(refineFilterCheckbox).filter(':checked').length == $(refineFilterCheckbox).length) {
      $(refineFilterSelectAll).prop('checked',true);
      $(selectAll).text('Deselect All');
    } else {
      $(refineFilterSelectAll).prop('checked',false);
      $(selectAll).text('Select All');
    }
  });

  // SPECIFIC PROPERTY JUMP TO (Name and Number)
  $('.refine-filter-specific-property-select').change(function(){
    var url = $(this).val();
    var redirectWindow = window.open(url, '_blank');
    redirectWindow.location;
  });


/////////////////////////////////////////
///////////   RESULTS LIST   ////////////
/////////////////////////////////////////

  // SORT BY FOR RESULTS LIST
  $('#sortForm').on('click', function(e){
    e.stopPropagation();
    $(this).find('ul').toggleClass('hidden');
  });
  $('#sortForm ul li').on('click', function(){
    var txt = $(this).find('span').text();
    $('#resultsListSortTitle i').text(txt);
    var sortFormData = $(this).attr('data-resultsList');
    $('#refineForm').find('input[name=strSortBy]').val(sortFormData);
    submitForm();
  });

  // VIEW GRID OR SPLIT (GRID/MAP) VIEW
  $('#viewListAndMap').on('click', function(){
    hideMoreFilters();
    // $(this).html($(this).html() == '<i class="fa fa-columns site-color-1" aria-hidden="true"></i><span class="site-color-1">Split View</span>' ? '<i class="fa fa-th-large site-color-1" aria-hidden="true"></i><span class="site-color-1">Grid View</span>' : '<i class="fa fa-columns site-color-1" aria-hidden="true"></i><span class="site-color-1">Split View</span>');
    if(!$('.results-list-wrap').hasClass('results-list-full-width')) {
      $(this).html($(this).html() == '<i class="fa fa-columns site-color-1" aria-hidden="true"></i><span class="site-color-1">Split View</span>' ? '<i class="fa fa-th-large site-color-1" aria-hidden="true"></i><span class="site-color-1">Grid View</span>' : '<i class="fa fa-columns site-color-1" aria-hidden="true"></i><span class="site-color-1">Split View</span>');
    } else {
      $(this).html($(this).html() == '<i class="fa fa-th-large site-color-1" aria-hidden="true"></i><span class="site-color-1">Grid View</span>' ? '<i class="fa fa-columns site-color-1" aria-hidden="true"></i><span class="site-color-1">Split View</span>' : '<i class="fa fa-th-large site-color-1" aria-hidden="true"></i><span class="site-color-1">Grid View</span>');
    }
    $('.results-list-wrap').toggleClass('results-list-full-width').removeClass('hidden');
    $('.map-wrap').toggleClass('hidden').removeClass('map-wrap-full');
    setTimeout(function() {
      var center = map.getCenter();
      google.maps.event.trigger(map, "resize");
      map.setCenter(center);
      $('.results-featured-carousel').trigger('refresh.owl.carousel');
      $('.result-property-carousel').trigger('refresh.owl.carousel');
    }, 500);
  });

  // VIEW MAP ONLY
  $('#viewMapOnly').on('click', function(){
    hideMoreFilters();
    $('.results-list-wrap').toggleClass('hidden').removeClass('results-list-full-width');
    $('.map-wrap').toggleClass('map-wrap-full').removeClass('hidden');
    // DISABLE SPLIT/GRID TOGGLE
    $('#viewListAndMap').toggleClass('inactive');

    if(!$('.results-list-wrap').hasClass('results-list-full-width') || $('.map-wrap').hasClass('map-wrap-full')) {
      // FULL WIDTH RESULTS
      $('#viewListAndMap').children('i').addClass('fa-th-large').removeClass('fa-columns');
    } else if($('.results-list-wrap').hasClass('results-list-full-width')) {
      // SPLIT VIEW
      $('#viewListAndMap').children('i').addClass('fa-columns').removeClass('fa-th-large');
    } else {
      // ELSE
      $('#viewListAndMap').children('i').addClass('fa-th-large').removeClass('fa-columns');
    }

    // IF REFINE IS OPEN, CLOSE IT
    if ($(window).width() < 1200){
      if ($('#viewFiltersMobile').html() === '<a href="javascript:;" id="viewFiltersMobile" rel="tooltip" data-placement="bottom" title="" data-original-title="Refine"><i class="fa site-color-1 fa-toggle-on" aria-hidden="true"></i> <span class="site-color-1">Close Refine</span></a>') {
        $('#viewFiltersMobile').html('<i class="fa site-color-1 fa-toggle-on" aria-hidden="true"></i> <span class="site-color-1">Close Refine</span>');
      } else {
        $('#viewFiltersMobile').html('<i class="fa fa-toggle-off site-color-1" aria-hidden="true"></i> <span class="site-color-1">Refine</span>');
      }
      $('.refine-form').addClass('mobile-hidden');
    }

    if ($(window).width() > 1025 && $(window).width() < 1200){
      var text = $(this).find('span');
      if (text.text() === 'Map View') {
        text.text('Grid View');
        $(this).children('i').addClass('fa-th-large').removeClass('fa-map-marker');
      } else {
        text.text('Map View');
        $(this).children('i').addClass('fa-map-marker').removeClass('fa-columns');
      }
    }
    if ($(window).width() < 1024){
      var text = $(this).find('span');
      if (text.text() === 'Map View') {
        text.text('Grid View');
        $(this).children('i').addClass('fa-th-large').removeClass('fa-map-marker');
      } else {
        text.text('Map View');
        $(this).children('i').addClass('fa-map-marker').removeClass('fa-th-large');
      }
    }
    if ($(window).width() < 736){
      $('.booking-footer-wrap').toggleClass('hidden');
    }
    setTimeout(function() {
      $.ajax({
        type: "POST",
        url: bookingFolder+'/ajax/map-all-results.cfm',
        data: $('#refineForm, #sortForm').serialize(),
        dataType: 'json',
        success: function(data) {
          var props = serializeCFJSON(data);
          //console.log(props);
          drawMapAllResults(map, markers, props);
        },
        error: function(xhr, textStatus, error){
          //console.log(xhr.statusText);
          //console.log(textStatus);
          //console.log(error);
        }
      });
      var center = map.getCenter();
      google.maps.event.trigger(map, "resize");
      map.setCenter(center);
    }, 500);
    console.log("map btn has been clicked");
  });

  // VIEW FILTERS MOBILE
  $('#viewFiltersMobile').on('click', function(){
    var text = $(this).find('span');
    if (text.text() === 'Refine') {
      text.text('Close Refine');
      $(this).children('i').addClass('fa-toggle-on').removeClass('fa-toggle-off');
    } else {
      text.text('Refine');
      $(this).children('i').addClass('fa-toggle-off').removeClass('fa-toggle-on');
    }
    $('.refine-form').toggleClass('mobile-hidden');
  });


  // SPECIALS MODAL HTML SWAP - IF YOU HAVE TO CHANGE THIS, UPDATE IN ajax/results.cfm
  $('.results-list-property-img-wrap').on('click','.results-list-property-special',function(){
    var test = $(this).parent().find('.special-modal-content').html();
    $('#specialModalContent').html(test);
  });


  $('form#noResultsContactForm').validate({
		submitHandler: function(form){
			$.ajax({
				type: "POST",
				url: "_submit.cfm",
				data: $('form#noResultsContactForm').serialize(),
				dataType: "text",
				success: function (response) {
					response = $.trim(response);
					console.log(response);
					if(response === "success") {
						$('.caption').hide();
						$('form#noResultsContactForm').hide();
						$('div#noResultsContactFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
					}
				}
			});
			return false;
		}
	});

  //////////////////////////////////////////////////////////////
  function serializeCFJSON(obj) {
    var json = [];
    for (var i = 0; i < obj.DATA.length; i++) {
      var o = {};
      var item = obj.DATA[i];
      for (var j = 0; j < obj.COLUMNS.length; j++) {
        o[obj.COLUMNS[j].toLowerCase()] = item[j];
      }
      json.push(o);
    }
    return json;
  }

});