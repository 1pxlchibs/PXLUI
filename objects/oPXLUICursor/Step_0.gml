var _mouse_x = 0;
var _mouse_y = 0;

switch(input_profile_get(player_index)){
	default:
		input_cursor_limit_aabb(0,0,PXLUI_UI_W,PXLUI_UI_H,player_index);
		_mouse_x = input_cursor_x(player_index);
		_mouse_y = input_cursor_y(player_index);
	break;
}

xGui = _mouse_x;
yGui = _mouse_y;

xscale = lerp(xscale,xscale_lerp,0.5);
yscale = lerp(yscale,yscale_lerp,0.5);