// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_text(x, y, text, xscale = 1, yscale = 1, halign = fa_middle, valign = fa_middle, width = -1, height = -1, elementid = 0){
	return {
		object: oPXLUIText,
		elementid: elementid,
		xx: x,
		yy: y,
		xscale: xscale, 
		yscale: yscale, 
		width: width,
		height: height,
		text: text,
		font: global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1,
		halign: halign,
		valign: valign
	};
}