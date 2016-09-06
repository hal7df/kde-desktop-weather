function getDeltaTimeString (dTime, curTime)
{
    var deltaMs = getDeltaTime(dTime, curTime)
    var delta;
    var unit;

    if (deltaMs <= 3600000)
    {
        delta = Math.floor((deltaMs/60000) + 0.5);
        unit = delta !== 1 ? "minutes" : "minute";
    }
    else if (deltaMs <= 86400000)
    {
        delta = Math.floor((deltaMs/3600000) + 0.5);
        unit = delta !== 1 ? "hours" : "hour";
    }
    else if (deltaMs <= 2678400000)
    {
        delta = Math.floor((deltaMs/86400000) + 0.5);
        unit = delta !== 1 ? "days" : "day";
    }
    else
    {
        delta = Math.floor((deltaMs/2678400000) + 0.5);
        unit = delta !== 1 ? "months" : "month";
    }

    return "Last updated " + delta.toString() + ' ' + unit + " ago";
}

function getDeltaTime (dTime, curTime)
{
    var oTime = new Date(dTime);

    console.log("Current time:", curTime, "Update time:", oTime)

    return curTime.getTime() - oTime.getTime();
}
