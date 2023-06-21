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
			id.yy = global.pxlui_settings.UIResH;
		break;
		
		case PXLUI_ORIENTATION.HORIZONTAL:
			id.xx = global.pxlui_settings.UIResW;
		break;
	}
	
	draw_line_width_color(id.x,id.y,id.xx,id.yy,id.width,id.color,id.color);
}