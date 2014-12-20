function convTimeString(origTime) {
    var timeObj = new Object;
    var date, time;

    date = origTime.substr(0,16);
    time = origTime.substr(17);

    timeObj.month = date.substr(8,3);
    timeObj.day = date.substr(5,2);
    timeObj.dayWk = date.substr(0,3);
    timeObj.hour = parseInt(time.substr(0,2),10);
    timeObj.minute = parseInt(time.substr(3,2),10);
    timeObj.second = parseInt(time.substr(6,2),10);

    return timeObj;
}

function getDeltaTime (dTime)
{
    var oTime = convTimeString(dTime);

    var date = new Date();
    var now = new Object;
    var delta;

    now.hour = date.getUTCHours();
    now.minute = date.getUTCMinutes();

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
