// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_divline(pos, orientation, width = 1, elementid = 0){
	var _x = 0;
	var _y = 0;
	switch(orientation){
		case PXLUI_ORIENTATION.VERTICAL:
			_x = pos; 
		break;
		
		case PXLUI_ORIENTATION.HORIZONTAL:
			_y = pos;
		break;
	}
		
	return {
		object: oPXLUIDivLine,
		elementid: elementid,
		xx: _x,
		yy: _y,
		orientation: orientation,
		width: width
	};
}