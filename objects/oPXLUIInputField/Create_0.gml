event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;
	
	//keyboard_string = "";
	
	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].slider;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.text.primary;
	id.color3 = global.pxlui_theme[$ global.pxlui_settings.theme].color.text.secondary;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	id.alpha = 1;
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	id.scribbleText = scribble("["+id.font+"]"+id.text);
	id.scribblePlaceholderText = scribble("["+id.font+"]"+id.placeholder_text);
	id.type = false;
	id.blinker = "";
	
	if (id.width == -1){
		id.width = id.scribbleText.get_width()*1.2;
		id.width = max(id.width,sprite_get_width(id.sprite));
	}
	if (id.height == -1){
		id.height = id.scribbleText.get_height()*1.2;
		id.height = max(id.height,sprite_get_height(id.sprite));
	}
	
	switch(id.halign){
		case fa_left:
			id.xalign = width/2;
			
			id.x1collision = 0;
			id.x2collision = width;
			
			id.htextAlign = 10;
		break;
		case fa_middle:
			id.xalign = 0;
			
			id.x1collision = -width/2;
			id.x2collision = width/2;
			
			id.htextAlign = 10;
		break;
		case fa_right:
			id.xalign = -width/2;
			
			id.x1collision = -width;
			id.x2collision = 0;
			
			id.htextAlign = 10;
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
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.text.primary;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	
	if (id.type){
		id.blinker = floor((current_time * 0.002) % 2) == 0 ? "|" : "";
	} else{
		id.blinker = "";
	}
		
	id.scribbleText = scribble("["+id.font+"]"+id.text+id.blinker);
}

cursorIn = function(){
	var _x1 = id.x + id.x1collision;
	var _x2 = id.x + id.x2collision;
	var _y1 = id.y + id.y1collision;
	var _y2 = id.y + id.y2collision;
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(cursor_inst.xGui, cursor_inst.yGui, id.grandparent.x + id.parent.x + _x1, id.grandparent.y + id.parent.y + _y1, id.grandparent.x + id.parent.x + _x2, id.grandparent.y + id.parent.y + _y2);
		if (parent != -1) 
			return point_in_rectangle(cursor_inst.xGui, cursor_inst.yGui, id.parent.x + _x1, id.parent.y + _y1, id.parent.x + _x2, id.parent.y + _y2);
		return point_in_rectangle(cursor_inst.xGui, cursor_inst.yGui, _x1, _y1, _x2, _y2);	
	}	
}

step = function(id){
	id.xscaleMod = lerp(id.xscaleMod, 0, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, 0, PXLUI_EASE_SPEED);
	
	id.xMod = lerp(id.xMod, 0, PXLUI_EASE_SPEED);
	id.yMod = lerp(id.yMod, 0, PXLUI_EASE_SPEED);

	if (id.type){
		if(keyboard_string != ""){
			id.text += keyboard_string;
			keyboard_string = "";
		}
		if (input_check_repeat("backspace",player_index,4,3)){
			id.text = string_delete(id.text,string_length(id.text),1);
		}
	}
}

onhover = function(id){
	if (id.hover){
		id.xscaleMod = lerp(id.xscaleMod, -0.1, PXLUI_EASE_SPEED);
		id.yscaleMod = lerp(id.yscaleMod, -0.1, PXLUI_EASE_SPEED);
	}
	if (id.type){
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
		id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;	
	}
}

onclick = function(id){
	if (id.hover){	
		oController.pxlui.currentInteractable = id;
		id.type = true;
		keyboard_string = "";
	} else{
		id.type = false;
	}
}

onhold = function(id){
	id.xscaleMod = lerp(id.xscaleMod, -0.2, PXLUI_EASE_SPEED);
	id.yscaleMod = lerp(id.yscaleMod, -0.2, PXLUI_EASE_SPEED);
	
	//id.yMod = 2;
}

onrelease = function(id){

}

drawGUI = function(id){
	id.onhover(id);
	
	draw_sprite_ext(id.sprite, 0, id.x + id.xalign + id.xMod,  id.y + id.yalign + id.yMod, 
					id.width/sprite_get_width(id.sprite) + id.xscaleMod, id.height/sprite_get_height(id.sprite) + id.yscaleMod,
					0,id.color,id.alpha);
				
	id.scribbleText.blend(id.color2, 1).align(fa_left, fa_middle).transform(1 + id.xscaleMod,1 + id.yscaleMod).draw(id.x + id.htextAlign + id.xMod, id.y + id.vtextAlign + id.yMod);
	
	if (id.text = "" and !id.type){
		id.scribblePlaceholderText.blend(id.color3, 1).align(fa_left, fa_middle).transform(1 + id.xscaleMod,1 + id.yscaleMod).draw(id.x + id.htextAlign + id.xMod, id.y + id.vtextAlign + id.yMod);
	}

	if (input_check_pressed("item_active",player_index)) id.onclick(id);
	
	if (id.hover && id.interactable){	
		if (input_check("item_active",player_index)) id.onhold(id);
		if (input_check_released("item_active",player_index)) id.onrelease(id);
	}
}