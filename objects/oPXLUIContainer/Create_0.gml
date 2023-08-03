event_inherited();

offset = {
	x: 0,
	y: 0
};

create = function(pageName, id){
	id.page = pageName;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	id.hover = false;
	id.surf = -1;

	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].container;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.alpha = 1;
	
	id.children = [];
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	id.xdif = 0;
	id.ydif = 0;
	
	id.drag = false;
	
	switch(id.halign){
		case fa_left:
			id.xalign = 0;
			
			id.x1collision = 0;
			id.x2collision = id.width;
		break;
		case fa_middle:
			id.xalign = -id.width/2;
			
			id.x1collision = -id.width/2;
			id.x2collision = id.width/2;
		break;
		case fa_right:
			id.xalign = -id.width;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = 0;
			
			id.y1collision = 0;
			id.y2collision = id.height;
		break;
		case fa_middle:
			id.yalign = -id.height/2;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
		break;
		case fa_bottom:
			id.yalign = -id.height;
			
			id.y1collision = -id.height;
			id.y2collision = 0;
		break;
	}
	
		
	if (!is_undefined(id.elements)){
		for(var i = 0; i < array_length(id.elements); i++) {
			var element = id.elements[i];
			
			var _inst = id.pxlui.load_element(id.page, element,id.layerId,id.width,id.height,id.pxlui);
			_inst.parent = id;
			_inst.grandparent = id.parent;
			_inst.visible = false;
		
			array_push(id.children,_inst);
		}
	}
	
	created = true;
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
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

_cursorIn = function(){
	if (point_in_rectangle(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui, x + x1collision, y + y1collision, x + x2collision, y + y1collision + 16) || drag){
		return true;	
	}
	return false;
}

onhover = function(id){
	if (id.hover){
		if (id._cursorIn()){
			id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
		}
	}
}

onclick = function(id){	
	id.drag = true;
	
	id.xdif = PXLUI_CURSOR.xGui - id.x;
	id.ydif = PXLUI_CURSOR.yGui - id.y;
}

onhold = function(id){
	if (id.drag){
		id.x = PXLUI_CURSOR.xGui - id.xdif;
		id.y = PXLUI_CURSOR.yGui - id.ydif;
	
		for(var i = 0; i < array_length(id.children); i++){
			var element = id.children[i];
		
			var t_x = id.x + element.xx;
			var t_y = id.y + element.yy;
			if (is_string(element.xx)){
				t_x = id.x + id.width * (element.xx / 100);	
			}
			if (is_string(element.yy)){
				t_y = id.y + id.height * (element.yy / 100);	
			}
			
			if (element.object_index = oPXLUIScrollView){
				t_x = id.x + element.xx + element.xalign;
				t_y = id.y + element.yy + element.yalign;
				
				if (is_string(element.xx)){
					t_x = id.x + id.width * (element.xx / 100) + element.xalign;	
				}
				if (is_string(element.yy)){
					t_y = id.y + id.height * (element.yy / 100) + element.yalign;	
				}
			}
			
			element.x = t_x;
			element.y = t_y;
		}
	}
}

onrelease = function(id){
	id.drag = false;
}

refresh = function(id){
	if (!surface_exists(id.surf)) {
        id.surf = surface_create(id.width, id.height);
    }
	
	surface_set_target(id.surf);
		draw_clear_alpha(c_black,0);
		
		var tar_x = offset.x;
		var tar_y = offset.y;
		
		for(var i = 0; i < array_length(id.children); i++) {
			var element = id.children[i];
			
			element.x = tar_x + element.x;
			element.y = tar_y + element.y;
			element.drawGUI(element);
		}
	surface_reset_target();
}


drawGUI = function(id){
	refresh(id);
	
	id.onhover(id);
	
	if (id.hover || id.drag){
		if (id._cursorIn()){
			if (PXLUI_CLICK_CHECK_PRESSED) id.onclick(id);
		}
		if (PXLUI_CLICK_CHECK) id.onhold(id);
		if (PXLUI_CLICK_CHECK_RELEASED) id.onrelease(id);
	}
	
	draw_sprite_ext(id.sprite, 1, id.x + id.xalign, id.y + id.yalign,
					id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite),
					0,id.color,1);
	draw_surface_ext(id.surf, id.x + id.xalign, id.y + id.yalign, 1, 1, 0, c_white, id.alpha);
	
}