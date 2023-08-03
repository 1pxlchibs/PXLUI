// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_inputfield(x, y, text, placeholder_text = "", width = -1, height = -1, halign = fa_middle, valign = fa_middle, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUIInputField,
		elementid: elementid,
		xx : x,
		yy : y,
		width: width,
		height: height,
		text: text,
		placeholder_text: placeholder_text,
		halign: halign,
		valign: valign
	};
}