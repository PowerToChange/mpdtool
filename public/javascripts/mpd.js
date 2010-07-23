function doCalc() {
    var total = 0;
    
    var fields = document.getElementById('calculator_fields').getElementsByTagName('INPUT');
    for (i =  0; i < fields.length; i++) {
        total += parseFloat(fields[i].value.replace(',',''));
    }
    
    total += parseFloat(document.getElementById('project_expenses').value);
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
