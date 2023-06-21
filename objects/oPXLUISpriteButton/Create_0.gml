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
	id.xalign = 0;
	id.yalign = 0;
	id.x1collision = -sprite_get_xoffset(id.sprite)*id.xscale;
	id.x2collision = -sprite_get_xoffset(id.sprite)*id.xscale+id.width;
	id.y1collision = -sprite_get_yoffset(id.sprite)*id.yscale;
	id.y2collision = -sprite_get_yoffset(id.sprite)*id.yscale+id.height;
	
	created = true;
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	
	id.color1 = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
}

cursorIn = function(){
	if (grandparent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui,id.grandparent.x + id.parent.x + id.x + id.x1collision, id.grandparent.y + id.parent.y + id.y + id.y1collision, id.grandparent.x + id.parent.x + id.x + id.x2collision, id.grandparent.y + id.parent.y + id.y + id.y2collision);
	if (parent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.parent.x + id.x + id.x1collision, id.parent.y + id.y + id.y1collision, id.parent.x + id.x + id.x2collision, id.parent.y + id.y + id.y2collision);
	return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x + id.x1collision, id.y + id.y1collision, id.x + id.x2collision, id.y + id.y2collision);	
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);
	
	if (id.hover){
		if (PXLUI_CLICK_CHECK_PRESSED) id.onclick(id);
		if (PXLUI_CLICK_CHECK) id.onhold(id);
		if (PXLUI_CLICK_CHECK_RELEASED) id.onrelease(id);
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