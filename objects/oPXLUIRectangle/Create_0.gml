event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	
	id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.rectangle;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.rectangle;
	id.color3 = global.pxlui_theme[$ global.pxlui_settings.theme].color.rectangle;
	id.color4 = global.pxlui_theme[$ global.pxlui_settings.theme].color.rectangle;
	id.alpha = 1;
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	//resolve any alignment according to set halign and valign
	switch(id.halign){
		case fa_left:
			id.xalign = 0;
		break;
		case fa_middle:
			id.xalign = -id.width/2;
		break;
		case fa_right:
			id.xalign = -id.width;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = 0;
		break;
		case fa_middle:
			id.yalign = -id.height/2;
		break;
		case fa_bottom:
			id.yalign = -id.height;
		break;
	}
	
	created = true;
}

drawGUI = function(id){
	draw_rectangle_color(id.x+id.xalign,id.y+id.yalign,id.x+id.width+id.xalign,id.y+id.height+id.yalign,id.color1,id.color2,id.color3,id.color4,id.outline);
}