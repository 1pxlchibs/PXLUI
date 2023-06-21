event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;	
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	
	created = true;
}

clicked = function(id){
	//if slot not empty
	if (id.inventoryRef[id.inventoryPos] != -1){
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){
			show_debug_message("uyeer")
			//if slot has same item as held and can be stacked, stack it
			if (global.inventoryManager.itemCurrent.id = id.inventoryRef[id.inventoryPos].id){
				id.inventoryRef[id.inventoryPos].stack += global.inventoryManager.itemCurrent.stack;
				
				//clear old slot
				array_set(global.inventoryManager.itemOldInventory, global.inventoryManager.itemOldPos, -1);
			
				//clear item
				global.inventoryManager.itemCurrent = -1;
				global.inventoryManager.itemOldPos = -1;
				global.inventoryManager.itemOldInventory = -1;
			} else{
				//replace old slot with new slot
				array_set(global.inventoryManager.itemOldInventory, global.inventoryManager.itemOldPos, inventoryRef[inventoryPos]);
			
				//place item to new slot
				id.inventoryRef[id.inventoryPos] = variable_struct_copy(global.inventoryManager.itemCurrent);
				
				//clear item
				global.inventoryManager.itemOldPos = -1;
				global.inventoryManager.itemOldInventory= -1;
				global.inventoryManager.itemCurrent = -1;
			}
		} else{
			//if not holding an item
			global.inventoryManager.itemCurrent = variable_struct_copy(id.inventoryRef[id.inventoryPos]); //take the item
			global.inventoryManager.itemOldPos = id.inventoryPos; //take note of old position
			global.inventoryManager.itemOldInventory = id.inventoryRef; //take note of old inventory
			
			array_set(id.inventoryRef,id.inventoryPos, -1);
			show_debug_message("uye")
		}
	} else{
		//if slot empty
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){	
			//place item to new slot
			id.inventoryRef[id.inventoryPos] = variable_struct_copy(global.inventoryManager.itemCurrent);
				
			//clear item
			global.inventoryManager.itemOldPos = -1;
			global.inventoryManager.itemOldInventory= -1;
			global.inventoryManager.itemCurrent = -1;
		}
	}
}
	
alt_clicked = function(id){
	show_debug_message("yes")
	//if slot not empty
	if (id.inventoryRef[id.inventoryPos] != -1){
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){
			//if slot has same item as held and can be stacked, stack it
			if (global.inventoryManager.itemCurrent.id = id.inventoryRef[id.inventoryPos].id){
				id.inventoryRef[id.inventoryPos].stack++;
				global.inventoryManager.itemCurrent.stack--;
			} else{
				//switch items
				var _slotItem = id.inventoryRef[id.inventoryPos];
				var _heldItem = global.inventoryManager.itemCurrent;
				
				id.inventoryRef[id.inventoryPos] = variable_struct_copy(_heldItem);
				global.inventoryManager.itemCurrent = variable_struct_copy(_slotItem);
			}
		} else{
			//if not holding an item
			if (id.inventoryRef[id.inventoryPos].stack > 1){
				var stackSplit = round(id.inventoryRef[id.inventoryPos].stack/2);
				
				global.inventoryManager.itemCurrent = variable_struct_copy(id.inventoryRef[id.inventoryPos]);
				global.inventoryManager.itemCurrent.stack = stackSplit;
				
				id.inventoryRef[id.inventoryPos].stack -= stackSplit;
				
			} else{
				global.inventoryManager.itemCurrent = variable_struct_copy(id.inventoryRef[id.inventoryPos]);
				
				array_set(id.inventoryRef,id.inventoryPos, -1);
			}
		}
	} else{
		//if slot empty
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){
			id.inventoryRef[id.inventoryPos] = variable_struct_copy(global.inventoryManager.itemCurrent);
			id.inventoryRef[id.inventoryPos].stack = 1;
			
			global.inventoryManager.itemCurrent.stack--;
		}
	}
}

cursorIn = function(){
	return point_in_rectangle(oPXLUICursor.xGui, oPXLUICursor.yGui, x - sprite_width / 2, y - sprite_height / 2 - 2, x + sprite_width / 2, y + sprite_height / 2 - 2);	
}

step = function(id){
	if (id.inventoryRef[id.inventoryPos] != -1){
		if (id.inventoryRef[id.inventoryPos].stack	< 1){
			array_set(id.inventoryRef,id.inventoryPos, -1);
		}
	}
	
	if (global.inventoryManager.itemCurrent != -1){
		if (global.inventoryManager.itemCurrent.stack < 1){
			global.inventoryManager.itemCurrent = -1;
		}
	}
}

drawGUI = function(id){
	var _color = id.color;
	if (id.hover){
		_color = id.color2;	
		
		if (PXLUI_CLICK_CHECK_PRESSED){
			clicked(id);
		}
		if (PXLUI_ALTCLICK_CHECK_PRESSED){
			alt_clicked(id);
		}
	}
	
	draw_set_color(_color);
	draw_sprite(sprite_index, image_index, x, y);	
	if (id.inventoryRef[id.inventoryPos] != -1){
		draw_set_halign(fa_middle);
		draw_set_valign(fa_middle);
		draw_text(x, y, string(id.inventoryRef[id.inventoryPos].id));
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		if (id.inventoryRef[id.inventoryPos].stack > 1){
			draw_text(x, y, string(id.inventoryRef[id.inventoryPos].stack));
		}
	}
	draw_set_color(c_white);
}