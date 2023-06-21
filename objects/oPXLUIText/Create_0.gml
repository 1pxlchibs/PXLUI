// Inherit the parent event
event_inherited();
create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.text.primary;
	id.font = global.pxlui_theme[$ global.pxlui_settings.theme].fonts.text1;
	id.alpha = 1;
	
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	
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
		id.scribbleText = scribble("["+id.font+"]"+string(_value));
	} else{
		id.scribbleText = scribble("["+id.font+"]"+id.text);
	}
	
	created = true;
}

beginStep = function(id){
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.text.primary;
	
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
		id.scribbleText = scribble("["+id.font+"]"+string(_value));
	} else{
		id.scribbleText = scribble("["+id.font+"]"+id.text);
	}
}

drawGUI = function(id){
	id.scribbleText.align(id.halign,id.valign).blend(id.color, id.alpha).transform(id.xscale + id.xscaleMod, id.yscale + id.yscaleMod, 0);
	
	if (id.width != -1){
		id.scribbleText.wrap(id.width);
	}
	if (id.height != -1){
		id.scribbleText.scale_to_box(id.width,id.height);
		id.scribbleText.fit_to_box(id.width,id.height);
	}
	
	id.scribbleText.draw(id.x + id.xMod, id.y + id.yMod);
}