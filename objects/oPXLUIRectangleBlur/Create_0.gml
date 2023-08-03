event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	
	if (is_array(id.color)){
		id.color1 = id.color[0];
		id.color2 = id.color[1];
		id.color3 = id.color[2];
		id.color4 = id.color[3];
	} else{
		id.color1 = id.color;
		id.color2 = id.color;
		id.color3 = id.color;
		id.color4 = id.color;
	}
	
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
	area_draw_rect(id.x+id.xalign,id.y+id.yalign,id.width,id.height,10,10,obj_post_process.ppfx_blur_id);
	
	draw_set_alpha(id.alpha);
	draw_rectangle_color(id.x+id.xalign,id.y+id.yalign,id.x+id.width+id.xalign,id.y+id.height+id.yalign,id.color1,id.color2,id.color3,id.color4,id.outline);
	draw_set_alpha(1);
}