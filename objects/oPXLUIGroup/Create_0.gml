event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.depth_original = depth;
	id.interactable = false;
	id.grandparent = -1;
	id.parent = -1;
	id.hover = false;

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
		break;
		case fa_right:
			id.xalign = -id.width/2;
			
			id.x1collision = -id.width;
			id.x2collision = 0;
		break;
	}
	switch(id.valign){
		case fa_top:
			id.yalign = id.height/2;
			
			id.y1collision = 0;
			id.y2collision = id.height;
		break;
		case fa_middle:
			id.yalign = 0;
			
			id.y1collision = -id.height/2;
			id.y2collision = id.height/2;
		break;
		case fa_bottom:
			id.yalign = -id.height/2;
			
			id.y1collision = -id.height;
			id.y2collision = 0;
		break;
	}
	
		
	if (!is_undefined(id.elements)){
		for(var i = 0; i < array_length(id.elements); i++) {
			var element = id.elements[i];
			
			var t_x = id.x1collision + element.xx;
			var t_y = id.y1collision + element.yy;
			if (is_string(element.xx)){
				t_x = id.x1collision + id.width * (element.xx / 100);	
			}
			if (is_string(element.yy)){
				t_y = id.y1collision + id.height * (element.yy / 100);	
			}

			show_debug_message("element_created: "+string(t_x)+"/"+string(t_y));
			var inst = instance_create_depth(t_x, t_y, id.depth_original - i-1, element.object, element);
			array_push(id.children,inst);
			with(inst){
				create(id.page, inst);
				grandparent = other.parent;
				parent = other.id;
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

drawGUI = function(id){

}