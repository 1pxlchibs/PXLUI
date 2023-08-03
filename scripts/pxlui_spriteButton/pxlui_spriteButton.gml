// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_spriteButton(sprite, image, x, y, xscale = 1, yscale = 1, halign = fa_middle, valign = fa_middle, angle = 0, color = c_white, alpha = 1, callback = function(){}, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUISpriteButton,
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
		
		callback: callback,
		elementid: elementid
	};
}