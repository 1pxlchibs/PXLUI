event_inherited();

offset = {
	x: 0,
	y: 0
};

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;
	id.surf = -1;

	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].card;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.alpha = 1;
	
	id.children = [];
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	switch(id.halign){
		case fa_left:
			id.xalign = 0;
			
			id.x1collision = 0;
			id.x2collision = id.width;
			
			id.htextAlign = id.width/2;
		break;
		case fa_middle:
			id.xalign = -id.width/2;
			
			id.x1collision = -id.width/2;
			id.x2collision = id.width/2;
			
			id.htextAlign = 0;
		break;
		case fa_right:
			id.xalign = -id.width;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
			
			id.htextAlign = -id.width/2;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = 0;
			
			id.y1collision = 0;
			id.y2collision = id.height;
			
			id.vtextAlign = id.height/2;
		break;
		case fa_middle:
			id.yalign = -id.height/2;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
			
			id.vtextAlign = 0;
		break;
		case fa_bottom:
			id.yalign = -id.height;
			
			id.y1collision = -id.height;
			id.y2collision = 0;

			id.vtextAlign = -id.height/2;
		break;
	}
	
	if (!is_undefined(id.elements)){
		for(var i = 0; i < array_length(id.elements); i++) {
			var element = id.elements[i];
			
			var t_x = element.xx;
			var t_y = element.yy;
			if (is_string(element.xx)){
				t_x = id.width * (element.xx / 100);	
			}
			if (is_string(element.yy)){
				t_y = id.height * (element.yy / 100);	
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
	
refresh = function(id){
	if (!surface_exists(id.surf)) {
        id.surf = surface_create(id.width, id.height);
    }
	
	surface_set_target(id.surf);
		draw_clear_alpha(c_black,0);
		
		var tar_x = offset.x;
		var tar_y = offset.y;
		
		draw_sprite_ext(id.sprite, 1, tar_x + id.width/2, tar_y + id.height/2,
					id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite),
					0,id.color,id.alpha);
					
		draw_sprite_ext(id.sprite, 0, tar_x + id.width/2, tar_y + id.height/2,
						id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite),
						0,id.color,1);
		
		for(var i = 0; i < array_length(id.children); i++) {
			var element = id.children[i];
			
			element.x = tar_x + element.x;
			element.y = tar_y + element.y;
			element.drawGUI(element);
		}
	surface_reset_target();
}

beginStep = function(id){
	if (!cursorIn()){
		id.hover = false;
		id.pressed = false;
		if (id.interactable){
			id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
		} else{
			id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
		}
	}
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);
}

cursorIn = function(){
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, _x1, _y1, _x2, _y2);	
	}
}

onhover = function(id){
	id.yMod = lerp(id.yMod, 10, PXLUI_EASE_SPEED);
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
}

onclick = function(id){	
	//do something
}

onhold = function(id){
	//do something
}

onrelease = function(id){
	id.callback(id);
}

drawGUI = function(){
	id.refresh(id);

	draw_surface_ext(id.surf, id.x + id.xalign + id.xMod, id.y + id.yalign + id.yMod, 1 + id.xscaleMod, 1 + id.yscaleMod, 0, c_white, id.alpha);

					
	if (id.hover){
		id.onhover(id);
		
		if (input_check_pressed("item_active",player_index)) id.onclick(id);
		if (input_check("item_active",player_index)) id.onhold(id);
		if (input_check_released("item_active",player_index)) id.onrelease(id);
	}
	draw_sprite_ext(id.sprite, 1, id.x + id.xalign + id.xMod, id.y + id.yalign + id.yMod,
					id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite),
					0,id.color,1);
	draw_surface_ext(id.surf, id.x + id.xalign + id.xMod, id.y + id.yalign + id.yMod, 1 + id.xscaleMod, 1 + id.yscaleMod, 0, c_white, id.alpha);

					
	
}