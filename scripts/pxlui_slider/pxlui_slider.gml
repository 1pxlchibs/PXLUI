// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_slider(x, y, variable_array, minimum, maximum, increment, width = 64, height = 16, halign = fa_middle, valign = fa_middle, elementid = 0){
	return {
		object: oPXLUISlider,
		elementid: elementid,
		variable: variable_array,
		xx : x,
		yy : y,
		minimum: minimum,
		maximum: maximum,
		increment: increment,
		width: width,
		height: height,
		halign: halign,
		valign: valign
	};
	
}