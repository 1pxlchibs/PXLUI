// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_rectangle(x, y, width, height, halign = fa_middle, valign = fa_middle, outline = false, elementid = 0){
	return {
		object: oPXLUIRectangle,
		xx : x,
		yy : y,
		width: width,
		height: height,
		halign: halign,
		valign: valign,
		outline: outline,
		elementid: elementid
	};
}