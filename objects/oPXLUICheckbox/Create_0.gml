event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;
	
	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].checkbox;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.alpha = 1;
	
	id.toggle = false;
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	switch(id.halign){
		case fa_left:
			id.xalign = width/2;
			
			id.x1collision = 0;
			id.x2collision = width;
			
			id.htextAlign = width/2;
		break;
		case fa_middle:
			id.xalign = 0;
			
			id.x1collision = -width/2;
			id.x2collision = width/2;
			
			id.htextAlign = 0;
		break;
		case fa_right:
			id.xalign = -width/2;
			
			id.x1collision = -width;
			id.x2collision = 0;
			
			id.htextAlign = -width/2;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = id.height/2;
			
			id.y1collision = 0;
			id.y2collision = id.height;
			
			id.vtextAlign = id.height/2;
		break;
		case fa_middle:
			id.yalign = 0;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
			
			id.vtextAlign = 0;
		break;
		case fa_bottom:
			id.yalign = -id.height/2;
			
			id.y1collision = -id.height;
			id.y2collision = 0;

			id.vtextAlign = -id.height/2;
		break;
	}
	
	created = true;
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
}

cursorIn = function(){
	if (grandparent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui,id.grandparent.x + id.parent.x + id.x + id.x1collision, id.grandparent.y + id.parent.y + id.y + id.y1collision, id.grandparent.x + id.parent.x + id.x + id.x2collision, id.grandparent.y + id.parent.y + id.y + id.y2collision);
	if (parent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.parent.x + id.x + id.x1collision, id.parent.y + id.y + id.y1collision, id.parent.x + id.x + id.x2collision, id.parent.y + id.y + id.y2collision);
	return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, x +x1collision, y + y1collision, x + x2collision, y + y2collision);	
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);
}

onhover = function(id){
	if (id.hover){
		id.xscaleMod = lerp(id.xscaleMod, -0.1, PXLUI_EASE_SPEED);
		id.yscaleMod = lerp(id.yscaleMod, -0.1, PXLUI_EASE_SPEED);
	
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	}
}

onclick = function(id){
	id.toggle = !id.toggle;
	
	switch(id.checktype){
		case PXLUI_VARIABLETYPE.GLOBAL:
			variable_global_set(id.check[0],id.toggle);
		break;
		
		case PXLUI_VARIABLETYPE.LOCAL:
			variable_instance_set(id.check[0],id.check[1],id.toggle);
		break;
		
		case PXLUI_VARIABLETYPE.STRUCT:
			variable_struct_set(id.check[0],id.check[1],id.toggle);
		break;
	}
}

onhold = function(id){
	id.xscaleMod = lerp(id.xscaleMod, -0.2, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, -0.2, PXLUI_EASE_SPEED);
	
	id.yMod = 2;
}

drawGUI = function(id){
	id.onhover(id);
	
	draw_sprite_ext(id.sprite, id.toggle, id.x + id.xalign + id.xMod,  id.y + id.yalign + id.yMod, 
					id.width/sprite_get_width(id.sprite) + id.xscaleMod, id.height/sprite_get_height(id.sprite) + id.yscaleMod,
					0,id.color,id.alpha);			
	if (id.hover){
		if (PXLUI_CLICK_CHECK_PRESSED) id.onclick(id);
		if (PXLUI_CLICK_CHECK) id.onhold(id);
	}
}