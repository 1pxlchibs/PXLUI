event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	id.width = sprite_get_width(id.sprite)*id.xscale;
	id.height = sprite_get_height(id.sprite)*id.yscale;
	id.xoffset = sprite_get_xoffset(id.sprite)*id.xscale;
	id.yoffset = sprite_get_yoffset(id.sprite)*id.yscale;
	
	//resolve any alignment according to set halign and valign
	switch(id.halign){
		case fa_left:
			id.xalign = -id.xoffset;
		break;
		case fa_middle:
			id.xalign = -id.xoffset-id.width/2;
		break;
		case fa_right:
			id.xalign = -id.xoffset-id.width;
		break;
		case "origin":
			id.xalign = 0;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = -id.yoffset;
		break;
		case fa_middle:
			id.yalign = -id.yoffset-id.height/2;
		break;
		case fa_bottom:
			id.yalign = -id.yoffset-id.height;
		break;
		case "origin":
			id.yalign = 0;
		break;
	}
	
	created = true;
}

drawGUI = function(id){
	draw_sprite_ext(id.sprite,id.image,id.x+id.xalign,id.y+id.yalign,id.xscale,id.yscale,id.angle,id.color1,id.alpha);
}