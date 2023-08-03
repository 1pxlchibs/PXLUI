// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_rectangleBlur(x, y, width, height, halign = fa_middle, valign = fa_middle, color = c_white, alpha = 1, outline = false, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUIRectangleBlur,
		xx : x,
		yy : y,
		width: width,
		height: height,
		halign: halign,
		valign: valign,
		color: color,
		alpha: alpha,
		outline: outline,
		elementid: elementid
	};
}