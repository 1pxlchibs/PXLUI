// Inherit the parent event
event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;
	
	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].slider;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	id.alpha = 1;
	
	id.tip_x = 0;
	id.held = false;
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
	switch(id.halign){
		case fa_left:
			id.xalign = 0;
			
			id.x1collision = 0;
			id.x2collision = width;
		break;
		case fa_middle:
			id.xalign = -width/2;
			
			id.x1collision = -width/2;
			id.x2collision = width/2;
		break;
		case fa_right:
			id.xalign = -width;
			
			id.x1collision = -width;
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
	set(get());
	
	created = true;
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
}

cursorIn = function(){
	if (grandparent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui,id.grandparent.x + id.parent.x + id.x + id.x1collision, id.grandparent.y + id.parent.y + id.y + id.y1collision, id.grandparent.x + id.parent.x + id.x + id.x2collision, id.grandparent.y + id.parent.y + id.y + id.y2collision);
	if (parent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.parent.x + id.x + id.x1collision, id.parent.y + id.y + id.y1collision, id.parent.x + id.x + id.x2collision, id.parent.y + id.y + id.y2collision);
	return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x + id.x1collision, id.y + id.y1collision, id.x + id.x2collision, id.y + id.y2collision);	
}

set = function(_value) {
	// floor value to nearest interval amount
	_value = (floor(_value / increment) * increment);
	
	value = _value;
		
	// determine ending x-coord of slider, used for drawing
	tip_x = remap(value, minimum, maximum, x, x + width);
	
	if (id.variable[0] == global){
		variable_global_set(id.variable[0], _value);
		return;
	}
	id.variable[0][$ id.variable[1]] = _value;
}

get = function(){
	if (id.variable[0] == global){
		return variable_global_get(id.variable[0]);
	}
	return id.variable[0][$ id.variable[1]];
}
	
remap = function(val, min1, max1, min2, max2) {
	return min2 + (max2 - min2) * ((val - min1) / (max1 - min1));
}

onhover = function(id){
	
}

onclick = function(id){
	id.held = true;
}

onhold = function(id){
	
}

step = function(id){
	if (id.held){
		var _val = remap(clamp(oPXLUICursor.xGui, id.x + id.xalign, id.x + id.xalign + id.width), id.x + id.xalign, id.x + id.xalign + id.width, id.minimum, id.maximum);
		set(_val);
	} else{
		if (value != id.get()){
			set(id.get());
		}
	}
	
	if (id.hover){
		if (PXLUI_LEFT){set(clamp(get()-id.increment,id.minimum,id.maximum));}
		if (PXLUI_RIGHT){set(clamp(get()+id.increment,id.minimum,id.maximum));}
		
		if (PXLUI_SCROLL_DOWN){set(clamp(get()-id.increment,id.minimum,id.maximum));}
		if (PXLUI_SCROLL_UP){set(clamp(get()+id.increment,id.minimum,id.maximum));}
	}
}

onrelease = function(id){
	id.held = false;
}

drawGUI = function(id){
	var _color = id.color;
	if (id.hover){
		_color = id.color2;

		if (PXLUI_CLICK_CHECK_PRESSED) id.onclick(id);
		if (PXLUI_CLICK_CHECK) id.onhold(id);
	}
	
	if (PXLUI_CLICK_CHECK_RELEASED) id.onrelease(id);
	
	draw_rectangle_color(id.x + id.xalign, id.y + id.yalign, id.tip_x + id.xalign, id.y + id.yalign + id.height, _color, _color, _color, _color, false); // value box	
	draw_rectangle_color(id.x + id.xalign, id.y + id.yalign, id.x + id.xalign + id.width, id.y + id.yalign + id.height, id.color, id.color, id.color, id.color, true); // outer box
}