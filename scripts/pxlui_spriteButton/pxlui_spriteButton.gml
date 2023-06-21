// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_spriteButton(sprite, image, x, y, xscale = 1, yscale = 1, angle = 0, color = c_white, alpha = 1, callback = function(){}, elementid = 0){
	return {
		object: oPXLUISpriteButton,
		elementid: elementid,
		xx : x,
		yy : y,
		sprite: sprite,
		image: image,
		xscale: xscale,
		yscale: yscale,
		angle: angle,
		color1: color,
		alpha: alpha,
		callback: callback,
		elementid: elementid
	};
}