function addEvent(obj, evType, fn, useCapture){
  if (obj.addEventListener){
    obj.addEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.attachEvent){
    var r = obj.attachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be attached");
  }
}

function removeEvent(obj, evType, fn, useCapture){
  if (obj.removeEventListener){
    obj.removeEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.detachEvent){
    var r = obj.detachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be removed");
  }
}

function doCalc() {
    var total = 0;
    
    var fields = document.getElementById('calculator_fields').getElementsByTagName('INPUT');
    for (i =  0; i < fields.length; i++) {
        total += parseFloat(fields[i].value.replace(',',''));
    }
    
    var cost = parseFloat(document.getElementById('event_cost').value.replace(',',''));
    if (!isNaN(cost)) {
        total += cost;
    }
    document.getElementById('support_total').innerHTML = formatCurrency(total);
}

function formatCurrency(num) {
    num = num.toString().replace(/\$|\,/g,'');
    if(isNaN(num))
    num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    num = Math.floor(num/100).toString();
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
    num = num.substring(0,num.length-(4*i+3))+','+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + '$' + num);
}

function countChars(source, update, max){
	var i = 0;
	var total = 0;
	for (i = 0; i < source.length; i++) {
		total = (total + $F(source[i]).length);
	}
	if (total <= max) {
		if ((max-total) == 1) {$(update).innerHTML = "1 character remaining";}
		else {$(update).innerHTML = (max-total) + " characters remaining";}
	}else {
		if ((total-max) == 1) {$(update).innerHTML = "Your letter is 1 character <big>too long</big>.";}
		else {$(update).innerHTML = "Your letter is " + (total-max) + " characters <big>too long</big>.";}
	}
}

function other(){
	var total = 0;
	var toolong = 0;	
}

function updateContact(id, value){
	source = (id + '_' + value)
	$(source).toggleClassName('unchecked');
	var url = '/contacts/update_contact/' + id;
	var param = value + '=' + $((source + '_box')).checked;
	var ajax = new Ajax.Updater({success: $((source + '_box')).checked}, url, {method: 'post',parameters: param});
}

function showClass(names){
	for (var i = 0; i < names.length; i++) {
		$$('.' + names[i]).each(function(e){
			e.setStyle({display: ''});
		});
	}
}

function hideClass(names){
	for (var i = 0; i < names.length; i++) {
		$$('.' + names[i]).each(function(e){
			e.setStyle({display: 'none'});
		});
	}
}

function hideControl(names){hideClass(names);}
function showControl(names){
		for (var i = 0; i < names.length; i++) {
		$$('.' + names[i]).each(function(e){
			e.setStyle({display: 'inline'});
		});
	}
}


function selectInitialTab(show){
	hide = ['contact','contact_address','contact_phoneemail','donation','relationship','progress'] - show;
	show = show;
	selectTab(show,hide);
}


function selectTab(show, hide){
	var i = 0;
	hideClass(hide);
	showClass(show);
	for (i = 0; i < hide.length; i++) {
		$(hide[i] + '_tab').removeClassName('selectedTab');
	}
	for (i = 0; i < show.length; i++) {
		$(show[i] + '_tab').addClassName('selectedTab');
	}
}

function viewMinistryPartners(id){
	var url = '/dashboard/index/';
	var param = 'selection=' + $F(id);
	switch ($F(id)) {
		case 'Thank You Sent':
		case 'Post-Project Letter Sent':
		case 'Letter Sent':
			$('vmp_check_yes').innerHTML = 'Sent';
			$('vmp_check_no').innerHTML = 'Not Sent';
			break;
		case 'Contacted':
			$('vmp_check_yes').innerHTML = 'Contacted';
			$('vmp_check_no').innerHTML = 'Not Contacted';
			break;
		case 'Gift Pledged':
			$('vmp_check_yes').innerHTML = 'Pledged';
			$('vmp_check_no').innerHTML = 'Not Pledged';
			break;
		case 'Gift Received':
			$('vmp_check_yes').innerHTML = 'Received';
			$('vmp_check_no').innerHTML = 'Not Received';
			break;
		case 'Partner-Financial':
		case 'Partner-Prayer':
			$('vmp_check_yes').innerHTML = 'Partner';
			$('vmp_check_no').innerHTML = 'Not Partner';
			break;
	}
		
	switch($F(id)){
		case 'All':
		hideClass(['vmpGiftInput','vmpBoolInput','vmpTextInput']);
		break;
		case 'City':
		case 'State':
		case 'Zip':
		case 'Relationship':
		case 'Form Received':
		showControl(['vmpTextInput']);
		$('vmp_text').value = "";
		hideControl(['vmpGiftInput','vmpBoolInput']);
		break;
		case 'Gift Amount':
		showControl(['vmpGiftInput','vmpTextInput']);
		hideControl(['vmpBoolInput']);
		break;
		case 'Thank You Sent':
		case 'Post-Project Letter Sent':
		case 'Letter Sent':
		case 'Contacted':
		case 'Gift Pledged':
		case 'Gift Received':
		case 'Partner-Financial':
		case 'Partner-Prayer':
			showControl(['vmpBoolInput']);
			hideControl(['vmpGiftInput','vmpTextInput']);
		break;
	}
}
function updateMinistryPartners(id, div){
	var url = '/dashboard/index/';
	var param = 'selection=' + $F(id).replace(/[-\s]+/g, "_").toLowerCase();
	//Special cases
	switch ($F(id)) {
		case 'Gift Amount':
			param = param + '&compare=' + $F('vmp_gle_select');
			break;
		case 'Thank You Sent':
			param = 'selection=thankyou_sent';
			break;
		case 'Post-Project Letter Sent':
			param = 'selection=postproject_sent';
			break;
	}
	//Add show param for determining which fields will be visible
	switch ($F(id)) {
		case 'All':
		case 'Address':
		case 'City':
		case 'State':
		case 'Zip':
			param = param + '&show=contact_address';
			break;
		case 'Letter Sent':
		case 'Contacted':
		case 'Thank You Sent':
		case 'Post-Project Letter Sent':
			param = param + '&show=progress';
			break;
		case 'Date Added':
		case 'Relationship':
		case 'Partner-Financial':
		case 'Partner-Prayer':
			param = param + '&show=relationship';
			break;
		case 'Gift Pledged':
		case 'Gift Received':
		case 'Gift Amount':
		case 'Date Received':
		case 'Form Received':
			param = param + '&show=gift';
			break;	
	}
	//Add appropriate values
	switch ($F(id)) {
		case 'All':
			break;
		case 'Gift Amount':
		case 'City':
		case 'State':
		case 'Zip':
		case 'Relationship':
		case 'Form Received':
			param = param + '&value=' + $F('vmp_text') + "&type=contact";
			break;
		case 'Thank You Sent':
		case 'Post-Project Letter Sent':
		case 'Partner-Financial':
		case 'Partner-Prayer':
		case 'Letter Sent':
		case 'Contacted':
		case 'Gift Pledged':
		case 'Gift Received':			
			param = param + '&value=' + (($F('vmp_yes') == 'yes') ? 1 : 0) + "&type=action";
			break;
	}
	Element.show('spinner');
	var ajax = new Ajax.Updater(div,url, {method: 'post',parameters: param, evalScripts: true, onSuccess:function(request){Element.hide('spinner');}});
}
function deleteContact(id,div){
	var url = '/mpd_contact_actions/' + id.split("_")[0];
	var param = '_method=delete';
	Element.show('spinner');
	var ajax = new Ajax.Updater(div,url, {method: 'post',parameters: param, evalScripts: true, onSuccess:function(request){Element.hide('spinner');}});
}
	