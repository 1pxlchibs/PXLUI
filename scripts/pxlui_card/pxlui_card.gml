// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_card(x, y, width, height, halign = fa_middle, valign = fa_middle, callback = function(){}, elements, elementid = 0){
	return {
		object: oPXLUICard,
		xx : x,
		yy : y,
		width: width,
		height: height,
		halign: halign,
		valign: valign,
		callback: callback,
		elements: elements,
		elementid: elementid,
	};
}