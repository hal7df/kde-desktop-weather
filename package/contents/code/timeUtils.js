function convTimeString(origTime) {
    var timeObj = new Object;
    var dateTime = new Array;

    origTime = origTime.substring(origTime.indexOf("on")+3,origTime.lastIndexOf(" "));
    dateTime = origTime.split(",");
    dateTime[1] = dateTime[1].substr(1);

    timeObj.month = dateTime[0].split(" ")[0];
    timeObj.day = parseInt(dateTime[0].split(" ")[1],10);
    timeObj.minute = parseInt(dateTime[1].substr(dateTime[1].indexOf(":")+1,2),10);
    timeObj.hour = parseInt(dateTime[1].substring(0,dateTime[1].indexOf(":")),10);

    if (dateTime[1].search("AM") == -1 && timeObj.hour != 12)
        timeObj.hour = timeObj.hour+12;
    else if (dateTime[1].search("AM") != -1 && timeObj.hour == 12)
        timeObj.hour = 0;

    return timeObj;
}

function getDeltaTime (dTime)
{
    var oTime = convTimeString(dTime);
    var date = new Date();
    var now = new Object;
    var delta;

    now.hour = date.getHours();
    now.minute = date.getMinutes();

    if (now.hour == oTime.hour)
        delta = now.minute - oTime.minute;
    else
    {
        var extMins;
        extMins = (now.hour - oTime.hour)*60;
        delta = (now.minute + extMins) - oTime.minute;
    }

    return delta;
}
