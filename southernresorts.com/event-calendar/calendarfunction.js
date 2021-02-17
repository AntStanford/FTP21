function gotomo()
{
location.href = document.selmo.theselmo.value
}
function gotoyr()
{
location.href = document.selyr.theselyr.value
}
function toggleDisplay(theID) {
 var theElement = document.getElementById(theID);
 if (theElement.className == 'appointmentDetails'){
	theElement.className = 'appointmentDetailsShow'
	}
 else { 
 	theElement.className = 'appointmentDetails'
	}
}