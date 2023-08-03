// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_scrollview(x, y, amount, layout = PXLUI_ORIENTATION.VERTICAL, padding = [0,0], halign = fa_middle, valign = fa_middle, elements, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUIScrollView,
		elementid: elementid,
		elements: elements,
		xx : x,
		yy : y,
		amount: amount,
		layout: layout,
		padding: padding,
		halign: halign,
		valign: valign
	};
}