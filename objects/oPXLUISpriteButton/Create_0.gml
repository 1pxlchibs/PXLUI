event_inherited();

create = function(pageName, id){
	//keep original depth
	id.depth_original = depth;
	id.page = pageName;
	
	id.hover = false;
	id.interactable = true;
	
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
			id.xalign = id.xoffset;
			
			id.x1collision = 0;
			id.x2collision = id.width;
		break;
		case fa_middle:
			id.xalign = id.xoffset-id.width/2;
			
			id.x1collision = -id.width/2;
			id.x2collision = id.width/2;
		break;
		case fa_right:
			id.xalign = id.xoffset-id.width;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
		break;
		case "origin":
			id.xalign = 0;
			
			id.x1collision = -id.xoffset;
			id.x2collision = -id.xoffset+id.width;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = id.yoffset;
			
			id.y1collision = 0;
			id.y2collision = id.height;
		break;
		case fa_middle:
			id.yalign = id.yoffset-id.height/2;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
		break;
		case fa_bottom:
			id.yalign = id.yoffset-id.height;
			
			id.y1collision = -id.height;
			id.y2collision = 0;
		break;
		case "origin":
			id.yalign = 0;
			
			id.y1collision = -id.yoffset;
			id.y2collision = -id.yoffset+id.height;
		break;
	}
	
	created = true;
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	
	if (id.interactable){
		id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	} else{
		id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
	}
}

cursorIn = function(){
	var _x1 = id.x + id.x1collision;
	var _x2 = id.x + id.x2collision;
	var _y1 = id.y + id.y1collision;
	var _y2 = id.y + id.y2collision;
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1) 
			return point_in_rectangle(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		return point_in_rectangle(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui, _x1, _y1, _x2, _y2);	
	}	
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);

	if (id.hover && id.interactable){
		if (PXLUI_CLICK_CHECK_PRESSED) id.onclick(id);
		if (PXLUI_CLICK_CHECK) id.onhold(id);
		if (PXLUI_CLICK_CHECK_RELEASED) id.onrelease(id);
	}
}

onhover = function(id){
	if (id.hover){
		id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
		
		if (id.parent.object_index = oPXLUIScrollView){
			id.parent.currentElement = scrollview_number;
		}
		id.yMod = lerp(id.yMod, 8, PXLUI_EASE_SPEED);
	}
}

onclick = function(id){
	 //callback(id);
}

onhold = function(id){
	id.xscaleMod = lerp(id.xscaleMod, -0.2, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, -0.2, PXLUI_EASE_SPEED);
	
	id.yMod = 2;
}

onrelease = function(id){
	callback(id);
}

drawGUI = function(id){
	id.onhover(id);
	draw_sprite_ext(id.sprite,id.image,id.x+id.xalign+id.xMod,id.y+id.yalign+id.yMod,id.xscale+id.xscaleMod,id.yscale+id.yscaleMod,id.angle,id.color1,id.alpha);
}