///@description pxlui_room_to_gui(x, y)
function pxlui_room_to_gui(_x, _y) {
	//insert the x position you want to follow and they will be relatively placed on the gui layer
	var cx = camera_get_view_x(view_camera[0]);
	var xx = (_x-cx);
	
	//insert the y position you want to follow and they will be relatively placed on the gui layer
	var cy = camera_get_view_y(view_camera[0]);
	var yy = (_y-cy);

	//returns x & y
	return {
		x : xx,
		y : yy
	}
}

///@description pxlui_gui_to_room(x, y)
function pxlui_gui_to_room(_x, _y){
	//insert the x gui position you want to follow and they will be relatively placed on in the room
	var cx = camera_get_view_x(view_camera[0]);
	var xx = _x+cx;
	
	//insert the y gui position you want to follow and they will be relatively placed on in the room
	var cy = camera_get_view_y(view_camera[0]);
	var yy = _y+cy;
	
	//returns x & y
	return {
		x : xx,
		y : yy
	}
}

function pxlui_get_gui_xscale(){
	return global.pxlui_settings.ResW/PXLUI_UI_W;
}

function pxlui_get_gui_yscale(){
	return global.pxlui_settings.ResH/global.pxlui_settings.UIResH;
}

function pxlui_debug_message(string){
	if (PXLUI_DEBUG){
		show_debug_message(string)	
	}
	return global.pxlui_settings.ResH/PXLUI_UI_H;
}

function pxlui_log(_log){
	if (PXLUI_DEBUG){
		show_debug_message(_log);
	}	
}