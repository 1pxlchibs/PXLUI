event_inherited();

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
			id.xalign = id.width/2;
			
			id.x1collision = 0;
			id.x2collision = id.width;
			
			id.htextAlign = id.width/2;
		break;
		case fa_middle:
			id.xalign = 0;
			
			id.x1collision = -id.width/2;
			id.x2collision = id.width/2;
			
			id.htextAlign = 0;
		break;
		case fa_right:
			id.xalign = -id.width/2;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
			
			id.htextAlign = -id.width/2;
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
	
		
	if (!is_undefined(id.elements)){
		for(var i = 0; i < array_length(id.elements); i++) {
			var element = id.elements[i];
			
			var t_x = id.x + id.x1collision + element.xx;
			var t_y = id.y + id.y1collision + element.yy;
			if (is_string(element.xx)){
				t_x = id.x + id.x1collision + id.width * (element.xx / 100);	
			}
			if (is_string(element.yy)){
				t_y = id.y + id.y1collision + id.height * (element.yy / 100);	
			}

			//If element has these variables, override the default ones.
			var _drawGUI = -1, _step = -1, _onhover = -1, _onhold = -1;
			if (variable_struct_exists(element,"drawGUI")){
				_drawGUI = element.drawGUI;	
			}
			if (variable_struct_exists(element,"step")){
				_step = element.step;	
			}
			if (variable_struct_exists(element,"onhover")){
				_onhover = element.onhover;	
			}
			if (variable_struct_exists(element,"onhold")){
				_onhold = element.onhold;	
			}
			
			var inst = instance_create_depth(t_x, t_y, id.depth_original - i-1, element.object, element);
			array_push(id.children,inst);

			with(inst){
				cursor_instance = other.cursor_instance;
				player_index = other.player_index;
				create(id.page, inst);
				grandparent = other.parent;
				parent = other.id;
				visible = false;
				
				if (_drawGUI != -1){
					drawGUI = _drawGUI;	
				}
				if (_step != -1){
					step = _step;	
				}
				if (_onhover != -1){
					onhover = _onhover;	
				}
				if (_onhold != -1){
					onhold = _onhold;	
				}
				if (variable_struct_exists(element,"interactable")){
					interactable = element.interactable;	
				}
			}
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
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, _x1, _y1, _x2, _y2);	
	}
}

_cursorIn = function(){
	if (point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, x + x1collision, y + y1collision, x + x2collision, y + y1collision + 16) || drag){
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
	
	id.xdif = cursor_instance.xGui - id.x;
	id.ydif = cursor_instance.yGui - id.y;
}

onhold = function(id){
	if (id.drag){
		id.x = cursor_instance.xGui - id.xdif;
		id.y = cursor_instance.yGui - id.ydif;
	
		//for(var i = 0; i < array_length(id.children); i++){
		//	var element = id.children[i];
		
		//	var t_x = id.x + element.xx;
		//	var t_y = id.y + element.yy;
		//	if (is_string(element.xx)){
		//		t_x = id.x + id.width * (element.xx / 100);	
		//	}
		//	if (is_string(element.yy)){
		//		t_y = id.y + id.height * (element.yy / 100);	
		//	}
			
		//	if (element.object_index = oPXLUIScrollView){
		//		t_x = id.x + element.xx + element.xalign;
		//		t_y = id.y + element.yy + element.yalign;
				
		//		if (is_string(element.xx)){
		//			t_x = id.x + id.width * (element.xx / 100) + element.xalign;	
		//		}
		//		if (is_string(element.yy)){
		//			t_y = id.y + id.height * (element.yy / 100) + element.yalign;	
		//		}
		//	}
			
		//	element.x = t_x;
		//	element.y = t_y;
		//}
	}
}

onrelease = function(id){
	id.drag = false;
}

refresh = function(id){
	if (!surface_exists(id.surf)) {
        id.surf = surface_create(id.width, id.height);
    } else{
		surface_set_target(id.surf);
			draw_clear_alpha(c_black,0);

			for(var i = 0; i < array_length(id.children); i++) {
				var element = id.children[i];

				element.drawGUI(element);
			}
		surface_reset_target();
	}
}


drawGUI = function(id){
	id.onhover(id);
	
	if (id.hover || id.drag){
		if (id._cursorIn()){
			if (input_check_pressed("item_active",player_index)) id.onclick(id);
		}
		if (input_check("item_active",player_index)) id.onhold(id);
		if (input_check_released("item_active",player_index)) id.onrelease(id);
	}
	
	draw_sprite_ext(id.sprite, 1, id.x + id.xalign,  id.y + id.yalign, 
					id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite),
					0,id.color,id.alpha);
					
	refresh(id);
	draw_surface_part(id.surf,0,0,id.width,id.height,id.x,id.y);
	
}