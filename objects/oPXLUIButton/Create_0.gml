event_inherited();

create = function(pageName, id){
	//keep original depth
	id.page = pageName;
	id.interactable = true;
	
	id.hover = false;
	
	id.ancestry = [];
	id.grandparent = -1;
	id.parent = -1;
	
	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].button;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	id.alpha = 1;
	
	//Button Text
	id.original_text = id.text;
	id.scribbleText = scribble("["+id.font+"]"+id.text);
	
	//Values for position and scale animating
	id.xOffset = 0;
	id.xOffsetTarget = 0;
	id.xOffsetAmount = 0;
	id.yOffset = 0;
	id.yOffsetTarget = 0;
	id.yOffsetAmount = 0;

	id.xscale = 0;
	id.xscaleTarget = 0;
	id.xscaleAmount = 0;
	id.yscale = 0;
	id.yscaleTarget = 0;
	id.yscaleAmount = 0;
	
	//if width wasn't set, scale it to the text
	if (id.width == -1){
		id.width = id.scribbleText.get_width()*1.2;
		id.width = max(id.width,sprite_get_width(id.sprite));
	}
	
	//if height wasn't set, scale it to the text
	if (id.height == -1){
		id.height = id.scribbleText.get_height()*1.2;
		id.height = max(id.height,sprite_get_height(id.sprite));
	}
	
	//resolve any alignment according to set halign and valign
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
	
	created = true;
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
		id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	}
	
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	
	if (is_array(id.text)){
		var _value;
		switch(id.text[0]){
			case "global":
				_value = variable_global_get(id.text[1]);
			break;
		
			case "struct":
				_value = variable_struct_get(id.text[1],id.text[2]);
			break;
		
			default:
				_value = variable_instance_get(id.text[0],id.text[1]);
			break;
		}
		
		if (id.original_text != _value){
			id.scribbleText = scribble("["+id.font+"]"+string(_value));
			id.original_text = _value;
			
			pxlui_debug_message("PXLUI: Text updated for element "+string(id.elementid));
		}
	} 
}

cursorIn = function(){
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1){
			if (parent.object_index = oPXLUIScrollView){
				if (parent._cursorIn()){
					return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
				}
				return false;
			}
			return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		}
		return point_in_rectangle(cursor_instance.xGui, cursor_instance.yGui, _x1, _y1, _x2, _y2);	
	}
}

step = function(id){
	id.xscale = lerp(id.xscale, id.xscaleTarget, PXLUI_EASE_SPEED);
	id.yscale = lerp(id.yscale, id.xscaleTarget, PXLUI_EASE_SPEED);
	
	id.xOffset = lerp(id.xoffset, id.xOffsetTarget, PXLUI_EASE_SPEED);
	id.yOffset = lerp(id.yoffset, id.yOffsetTarget, PXLUI_EASE_SPEED);
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
		
		draw_sprite_ext(id.sprite, 1, id.x + id.xalign + id.xoffset,  id.y + id.yalign + id.yoffset, 
					id.width/sprite_get_width(id.sprite) + id.xscale, id.height/sprite_get_height(id.sprite) + id.yscale,
					0,id.color2,id.alpha);
	}
}

onclick = function(id){
	//callback(id);
}

onhold = function(id){
	id.yoffset = 6;
}

onrelease = function(id){
	callback(id);
}

drawGUI = function(id){
	id.onhover(id);
	draw_sprite_ext(id.sprite, 0, id.x + id.xalign + id.xoffset,  id.y + id.yalign + id.yoffset, 
					id.width/sprite_get_width(id.sprite) + id.xscale, id.height/sprite_get_height(id.sprite) + id.yscale,
					0,id.color,id.alpha);
			
	id.scribbleText.scale_to_box(id.width,id.height).blend(id.color, id.alpha).align(fa_middle, fa_middle).transform(1 + id.xscale,1 + id.yscale).draw(id.x + id.htextAlign + id.xoffset, id.y + id.vtextAlign + id.yoffset);
}