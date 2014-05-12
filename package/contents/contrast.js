/* CONTRAST.JS
 *
 * Determines whether to use a white or black image
 * based on the color's background.
 *
 * Compiled with Hex-RGB-HSV conversion scripts from
 * here:
 * http://www.javascripter.net
 */

WorkerScript.onMessage = function (message) {
    var color;
    var hsv;

    color = hexToRGB(message);
    color = rgbToHSV(color);

    if (color.v > 0.5)
        WorkerScript.sendMessage("black");
    else if (color.v <= 0.5 && color.v > 0)
        WorkerScript.sendMessage("white");
    else
        WorkerScript.sendMessage("error");

}

function hexToRGB (hex)
{
    var r,g,b;

    hex = cutHex(hex);

    r = parseInt(hex.substring(0,2),16);
    g = parseInt(hex.substring(2,4),16);
    b = parseInt(hex.substring(4,6),16);

    return [r,g,b];
}

function rgbToHSV (colorObj)
{
    var r = colorObj.r;
    var g = colorObj.g;
    var b = colorObj.b;

    var computedH = 0;
    var computedS = 0;
    var computedV = 0;

    //remove spaces from input RGB values, convert to int
    r = parseInt( (''+r).replace(/\s/g,''),10 );
    g = parseInt( (''+g).replace(/\s/g,''),10 );
    b = parseInt( (''+b).replace(/\s/g,''),10 );

    if ( r==null || g==null || b==null ||
        isNaN(r) || isNaN(g)|| isNaN(b) ) {
      return [-1,-1,-1];
    }
    if (r<0 || g<0 || b<0 || r>255 || g>255 || b>255) {
      return [-1.-1,-1];
    }
    r=r/255; g=g/255; b=b/255;
    var minRGB = Math.min(r,Math.min(g,b));
    var maxRGB = Math.max(r,Math.max(g,b));

    // Black-gray-white
    if (minRGB==maxRGB) {
     computedV = minRGB;

     colorObj.h = 0;
     colorObj.s = 0;
     colorObj.v = computedV;
     return colorObj;
    }

    // Colors other than black-gray-white:
    var d = (r==minRGB) ? g-b : ((b==minRGB) ? r-g : b-r);
    var h = (r==minRGB) ? 3 : ((b==minRGB) ? 1 : 5);
    computedH = 60*(h - d/(maxRGB - minRGB));
    computedS = (maxRGB - minRGB)/maxRGB;
    computedV = maxRGB;

    colorObj.h = computedH;
    colorObj.s = computedS;
    colorObj.v = computedV;
    return colorObj;
   }
}

function cutHex(hex)
{
    return (hex.charAt(0) == "#" ? hex.substring(1,7) : hex);
}
