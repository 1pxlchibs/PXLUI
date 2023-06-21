// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function UIElement(x, y, depth, width, height){
	return {
		object: pUIElement,
		x : x,
		y : y,
		width: width,
		height: height,
		depth: depth
	};
}