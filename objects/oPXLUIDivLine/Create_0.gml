event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.xx = id.x;
	id.yy = id.y;
	
	created = true;
}

drawGUI = function(id){
	switch(id.orientation){
		case PXLUI_ORIENTATION.VERTICAL:
			id.yy = PXLUI_UI_H;
		break;
		
		case PXLUI_ORIENTATION.HORIZONTAL:
			id.xx = PXLUI_UI_W;
		break;
	}
	
	draw_line_width_color(id.x,id.y,id.xx,id.yy,id.width,id.color,id.color);
}