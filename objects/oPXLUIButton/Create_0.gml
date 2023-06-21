event_inherited();

create = function(pageName, id){
	//keep original depth
	id.depth_original = depth;
	id.page = pageName;
	
	id.hover = false;
	id.interactable = true;
	
	id.grandparent = -1;
	id.parent = -1;
	
	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].button;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	id.alpha = 1;
	
	//Button Text
	id.scribbleText = scribble("["+id.font+"]"+id.text);
	
	//Values for position and scale animating
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
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
	id.hover = false;
	id.pressed = false;
	
	if (id.interactable){
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	} else{
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
	}
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
}

cursorIn = function(){
	if (id.interactable){
		if (grandparent != -1) 
			return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui,id.grandparent.x + id.parent.x + id.x + id.x1collision, id.grandparent.y + id.parent.y + id.y + id.y1collision, id.grandparent.x + id.parent.x + id.x + id.x2collision, id.grandparent.y + id.parent.y + id.y + id.y2collision);
		if (parent != -1) 
			return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.parent.x + id.x + id.x1collision, id.parent.y + id.y + id.y1collision, id.parent.x + id.x + id.x2collision, id.parent.y + id.y + id.y2collision);
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x + id.x1collision, id.y + id.y1collision, id.x + id.x2collision, id.y + id.y2collision);	
	}
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
		
		id.yMod = lerp(id.yMod, 8, PXLUI_EASE_SPEED);
		
		draw_sprite_ext(id.sprite, 1, id.x + id.xalign + id.xMod,  id.y + id.yalign + id.yMod, 
					id.width/sprite_get_width(id.sprite) + id.xscaleMod, id.height/sprite_get_height(id.sprite) + id.yscaleMod,
					0,id.color2,id.alpha);
	}
}

onclick = function(id){
	//callback(id);
}

onhold = function(id){
	id.yMod = 6;
}

onrelease = function(id){
	callback(id);
}

drawGUI = function(id){
	id.onhover(id);
	draw_sprite_ext(id.sprite, 0, id.x + id.xalign + id.xMod,  id.y + id.yalign + id.yMod, 
					id.width/sprite_get_width(id.sprite) + id.xscaleMod, id.height/sprite_get_height(id.sprite) + id.yscaleMod,
					0,id.color,id.alpha);
	
					
	id.scribbleText.blend(id.color, id.alpha).align(fa_middle, fa_middle).transform(1 + id.xscaleMod,1 + id.yscaleMod).draw(id.x + id.htextAlign + id.xMod, id.y + id.vtextAlign + id.yMod);
}