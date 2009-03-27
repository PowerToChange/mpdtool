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

function countChars(source, update, max) {
    $(update).innerHTML = (max - $F(source).length);
}