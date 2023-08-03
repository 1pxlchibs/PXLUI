event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;	
	id.xalign = 0;
	id.yalign = 0;
	
	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	
	created = true;
}

clicked = function(id){
	//if slot not empty
	if (id.inventoryRef[id.inventoryPos] != -1){
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){
			//if slot has same item as held and can be stacked, stack it
			if (global.inventoryManager.itemCurrent.id = id.inventoryRef[id.inventoryPos].id){
				if (id.inventoryRef[id.inventoryPos].stackable){
					id.inventoryRef[id.inventoryPos].stack += global.inventoryManager.itemCurrent.stack;
			
					//clear item
					global.inventoryManager.itemCurrent = -1;
					global.inventoryManager.itemOldPos = -1;
					global.inventoryManager.itemOldInventory = -1;
				}
			} else{
				//replace old slot with new slot
				array_set(global.inventoryManager.itemOldInventory, global.inventoryManager.itemOldPos, id.inventoryRef[id.inventoryPos]);
			
				//place item to new slot
				array_set(id.inventoryRef,id.inventoryPos,variable_struct_copy(global.inventoryManager.itemCurrent));
				
				//clear item
				global.inventoryManager.itemOldPos = -1;
				global.inventoryManager.itemOldInventory= -1;
				global.inventoryManager.itemCurrent = -1;
			}
		} else{
			//if not holding an item
			global.inventoryManager.itemCurrent = variable_struct_copy(id.inventoryRef[id.inventoryPos]); //take the item
			global.inventoryManager.itemOldPos = id.inventoryPos; //take note of old position
			global.inventoryManager.itemOldInventory= id.inventoryRef; //take note of old inventory
			
			array_set(id.inventoryRef,id.inventoryPos, -1);
		}
		
		if (id.inventoryPos == global.pl_weaponselect){
			plutus_update_held();
		}
	} else{
		//if slot empty
		//if currently holding an item
		if (global.inventoryManager.itemCurrent != -1){	
			//place item to new slot
			array_set(id.inventoryRef,id.inventoryPos,variable_struct_copy(global.inventoryManager.itemCurrent));
				
			//clear item
			global.inventoryManager.itemOldPos = -1;
			global.inventoryManager.itemOldInventory= -1;
			global.inventoryManager.itemCurrent = -1;
		}
	}
}
	
alt_clicked = function(id){
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
				
				array_set(id.inventoryRef,id.inventoryPos,variable_struct_copy(_heldItem));
				global.inventoryManager.itemCurrent = variable_struct_copy(_slotItem);
			}
		} else{
			//if not holding an item
			if (id.inventoryRef[id.inventoryPos].stack > 1){
				var stackSplit = round(inventoryRef[inventoryPos].stack/2);
				
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
			array_set(id.inventoryRef,id.inventoryPos,variable_struct_copy(global.inventoryManager.itemCurrent));
			id.inventoryRef[id.inventoryPos].stack = 1;
			
			global.inventoryManager.itemCurrent.stack--;
		}
	}
}

cursorIn = function(){
	return point_in_rectangle(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui, x - sprite_width / 2, y - sprite_height / 2 - 2, x + sprite_width / 2, y + sprite_height / 2 - 2);	
}

beginStep = function(id){
	id.hover = false;
	id.pressed = false;
	
	if (id.interactable){
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.base;
	} else{
		id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
	}
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
	var _color = c_white;
	if (id.hover){
		global.inventoryManager.hoverPosition = id.inventoryPos;
		_color = id.color2;	
		
		if (PXLUI_CLICK_CHECK_PRESSED){
			id.clicked(id);
		}
		if (PXLUI_ALTCLICK_CHECK_PRESSED){
			id.alt_clicked(id);
		}
	}
	
	draw_set_color(_color);
	draw_sprite_ext(spr_hud_inventory_slot_border2, 1, id.x, id.y,1,1,0,scr_get_ui_color(),1);	
	draw_sprite_ext(spr_hud_inventory_slot_interior, 0, id.x, id.y,1,1,0,_color,1);	

	if (id.inventoryRef[id.inventoryPos] != -1){
		var _sprite = asset_get_index("spr_"+id.inventoryRef[id.inventoryPos].id)
		var width = sprite_get_width(_sprite);
		var height = sprite_get_height(_sprite);

		var xoffset = sprite_get_xoffset(_sprite);
		var yoffset = sprite_get_yoffset(_sprite);
	
		var _ease = EaseOutSine;
		var _easeOut = EaseOutBounce;
	
		var xmid = width/2-xoffset;
		var ymid = height/2-yoffset;
		var _x = id.x-xmid;
		var _y = id.y-ymid;

	
		draw_sprite_ext(_sprite, 0, _x, _y, 1, 1, 0, _color, 1);
		
		if (id.inventoryRef[id.inventoryPos].stack > 1){
			draw_text(id.x+8, id.y+2, string(id.inventoryRef[id.inventoryPos].stack));
		}
	}
	draw_set_color(c_white);
}