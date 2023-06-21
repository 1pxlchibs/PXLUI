// Inherit the parent event
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
	id.currentElement = 0;
	id.grandparent = -1;
	id.parent = -1;
	id.surf = -1;

	id.sprite = global.pxlui_theme[$ global.pxlui_settings.theme].scrollview;
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.alpha = 0.7;
	
	id.children = [];
	
	id.width = 0;
	id.height = 0;
	
	id.trueWidth = 0;
	id.trueHeight = 0;
	
	if (!is_undefined(id.elements)){
		for(var i = 0; i < array_length(id.elements); i++) {
			var element = id.elements[i];
			
			var inst = instance_create_depth(0, 0, id.depth_original - i-1, element.object, element);
			array_push(id.children,inst);

			with(inst){
				create(id.page, inst);
				grandparent = other.parent;
				parent = other.id;
				visible = false;
				scrollview_number = i;
			}
		}
	}
	set_dims(id);
	
	id.xMod = 0;
	id.yMod = 0;
	id.xscaleMod = 0;
	id.yscaleMod = 0;
	switch(id.halign){
		case fa_left: id.x = id.x; id.xalign = 0; break;
		case fa_middle: id.x -= id.width/2; id.xalign = -id.width/2; break;
		case fa_right: id.x -= id.width; id.xalign = -id.width break;
	}
	switch(id.valign){
		case fa_top: id.x = id.x; id.yalign = 0; break;
		case fa_middle:id.y -= id.height/2; id.yalign = -id.height/2; break;
		case fa_bottom: id.y -= id.height; id.yalign = -id.height; break;
	}	
	
	created = true;
}

_cursorIn = function(){
	if (grandparent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x + id.grandparent.x + id.parent.x, id.y + id.grandparent.y + id.parent.y, id.x + id.grandparent.x + id.parent.x + id.width + id.padding[0]*2, id.y + id.grandparent.y + id.parent.y + id.height + id.padding[1]*2);	
	if (parent != -1) 
		return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x + id.parent.x, id.y + id.parent.y, id.x + id.parent.x + id.width + id.padding[0]*2, id.y + id.parent.y + id.height + id.padding[1]*2);	
	return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, id.x, id.y, id.x + id.width + id.padding[0]*2, id.y + id.height + id.padding[1]*2);	
}

step = function(id){
	if (_cursorIn()){
		switch(layout) {
			case PXLUI_ORIENTATION.HORIZONTAL:
				if (PXLUI_SCROLL_UP){				
					offset.x += children[currentElement].width+padding[0];
					offset.x = clamp(offset.x,-id.trueWidth+id.width,0);
					refresh(id);
				}
	
				if (PXLUI_SCROLL_DOWN){	
					offset.x -= children[currentElement].width+padding[0];
					offset.x = clamp(offset.x,-id.trueWidth+id.width,0);
					refresh(id);
				}
			break;
			case PXLUI_ORIENTATION.VERTICAL:
				if (PXLUI_SCROLL_UP){				
					offset.y += children[currentElement].height+padding[1];
					offset.y = clamp(offset.y,-id.trueHeight+id.height,0);
					refresh(id);
				}
	
				if (PXLUI_SCROLL_DOWN){	
					offset.y -= children[currentElement].height+padding[1];
					offset.y = clamp(offset.y,-id.trueHeight+id.height,0);
					refresh(id);
				}
			break;
			
		}
	}
}

refresh = function(id){
	if (!surface_exists(id.surf)) {
        id.surf = surface_create(id.width, id.height);
    } else{
		surface_set_target(id.surf);
			draw_clear_alpha(c_black,0);
		
			var tar_x = offset.x + id.padding[0]/2;
			var tar_y = offset.y + id.padding[1]/2;
			
			id.trueWidth = 0;
			id.trueHeight = 0;
			for(var i = 0; i < array_length(id.children); i++) {
				var element = id.children[i];
			
				element.x = tar_x - element.x1collision;
				element.y = tar_y - element.y1collision;

				switch(id.layout) {
					case PXLUI_ORIENTATION.HORIZONTAL:
						id.trueWidth += element.width + id.padding[0];
						tar_x += element.width + id.padding[0];
					break;
				
					case PXLUI_ORIENTATION.VERTICAL:
						id.trueHeight += element.height + id.padding[1];
						tar_y += element.height + id.padding[1];
					break;
				}
				element.drawGUI(element);
			}
		surface_reset_target();
	}
}

set_dims = function(id){
    switch(layout) {
        case PXLUI_ORIENTATION.HORIZONTAL:
            for(var i=0; i<id.amount; i++) {
				if (i < array_length(id.children)){
					var element = id.children[i];
					
					id.height = element.height + id.padding[1];
					id.width += element.width + id.padding[0];
				}
            }
        break;
        case PXLUI_ORIENTATION.VERTICAL:
			for(var i=0; i<id.amount; i++) {
				if (i < array_length(id.children)){
					var element = id.children[i];

					id.width = element.width + id.padding[0];
					id.height += element.height + id.padding[1];
				}
	        }
        break;
    }
}

drawGUI = function(id){
	refresh(id);
	
	//draw_sprite_ext(id.sprite, 0, id.x + id.xalign,  id.y + id.yalign, id.width/sprite_get_width(id.sprite), id.height/sprite_get_height(id.sprite), 0,id.color,id.alpha);
	draw_surface(id.surf, id.x, id.y);	
}