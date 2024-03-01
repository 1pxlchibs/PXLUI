event_inherited();

create = function(pageName, id){
	//keep original depth
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
	id.xalign = 0;
	id.yalign = 0;
	id.x1collision = -sprite_get_xoffset(id.sprite)*id.xscale;
	id.x2collision = -sprite_get_xoffset(id.sprite)*id.xscale+id.width;
	id.y1collision = -sprite_get_yoffset(id.sprite)*id.yscale;
	id.y2collision = -sprite_get_yoffset(id.sprite)*id.yscale+id.height;
	
	created = true;
}

beginStep = function(id){
	if (!cursorIn()){
		id.hover = false;
		id.pressed = false;
	
		if (id.interactable){
			id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
		} else{
			id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
		}
	}
}

cursorIn = function(){
	var _x1 = id.x + id.x1collision;
	var _x2 = id.x + id.x2collision;
	var _y1 = id.y + id.y1collision;
	var _y2 = id.y + id.y2collision;
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, _x1, _y1, _x2, _y2);	
	}	
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);

	if (id.hover && id.interactable){
		if (input_check_pressed("item_active",player_index)) id.onclick(id);
		if (input_check("item_active",player_index)) id.onhold(id);
		if (input_check_released("item_active",player_index)) id.onrelease(id);
	}
}

onhover = function(id){
	if (id.hover){
		if (id.parent.object_index = oPXLUIScrollView){
			id.parent.currentElement = scrollview_number;
		}
		
		id.xscaleMod = lerp(id.xscaleMod, -0.1, PXLUI_EASE_SPEED);
		id.yscaleMod = lerp(id.yscaleMod, -0.1, PXLUI_EASE_SPEED);
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
	draw_sprite_ext(id.sprite,id.image,id.x+id.xMod,id.y+id.yMod,id.xscale+id.xscaleMod,id.yscale+id.yscaleMod,id.angle,id.color1,id.alpha);
	id.onhover(id);
}