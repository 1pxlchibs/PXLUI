// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_spriteBlur(sprite, image, x, y, xscale = 1, yscale = 1, halign = fa_left, valign = fa_top, angle = 0, color = c_white, alpha = 1, elementid = 0){
	return {
		object: oPXLUISpriteBlur,
		elementid: elementid,
		xx : x,
		yy : y,
		sprite: sprite,
		image: image,
		xscale: xscale,
		yscale: yscale,
		halign: halign,
		valign: valign,
		angle: angle,
		color1: color,
		alpha: alpha,
		
		elementid: elementid
	};
}