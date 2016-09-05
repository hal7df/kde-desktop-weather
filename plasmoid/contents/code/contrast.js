/* CONTRAST.JS
 *
 * Determines whether to use a white or black image
 * based on the color's background.
 *
 * Thanks to contrast calculation scripts found here:
 * http://www.24ways.org
 */

function getContrasting (hex)
{
    hex = hex.toString();
    var color = hex.substr(1);
    return (parseInt(color,16) > 0xffffff/2) ? "black" : "white";
}
