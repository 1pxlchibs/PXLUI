event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.hover = false;
	id.depth_original = depth;
	id.interactable = true;
	id.grandparent = -1;
	id.parent = -1;	
	
	id.color = c_white;
	id.gridcolor = c_white;
	id.color2 = global.pxlui_theme[$ global.pxlui_settings.theme].color.selection;
	
	id.assign = false;
	
	created = true;
}

clicked = function(id){
	var _slot_x = id.inventoryPos.x;
	var _slot_y = id.inventoryPos.y;
	var _slot = id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y];
	var _helditem = id.inventory.itemCurrent;
	
	//if slot not empty
	if (_slot != -1){
		if (is_array(_slot)){
			_slot_x = _slot[0];
			_slot_y = _slot[1];
			_slot = id.inventoryRef[_slot[0]][_slot[1]];
			
		}
		//if currently holding an item
		if (_helditem != -1){
			//if slot has same item as held and can be stacked, stack it
			if (_helditem.id = _slot.id){
				if (_slot.stack < _slot.stack_limit){
					var _stack = min(_slot.stack_limit-1,id.inventory.itemCurrent.stack);
					_slot.stack += _stack;
					
					if(_stack = id.inventory.itemCurrent.stack){
						//clear item
						pxlui_inv_clear_current(id.inventory);
					} else{
						id.inventory.itemCurrent.stack -= _stack;
					}	
				}
			} else{
				if (pxlui_inv_can_place(id.inventoryRef,id.inventory.hoverPosition.x,id.inventory.hoverPosition.y,
										_helditem.size.w,_helditem.size.h,_helditem.rotated)){
					if (pxlui_inv_can_place(id.inventoryRef,id.inventory.itemOldPos.x,id.inventory.itemOldPos.x,
										_slot.size.w,_slot.size.h,_slot.rotated)){
						//replace old slot with new slot
						id.inventory.itemOldInventory[id.inventory.itemOldPos.x][id.inventory.itemOldPos.y] = _slot;
			
						//place item to new slot
						_slot = variable_struct_copy(_helditem);
				
						//clear item
						pxlui_inv_clear_current(id.inventory);
					}
				}
			}
		} else{
			//if not holding an item	
			pxlui_inv_update_current(id.inventory,_slot,id.invID,id.inventoryPos,id.inventoryRef);
				
			for(var i = 0; i < array_length(_slot.pos); i++;){
				var _pos = _slot.pos[i];
					
				id.inventoryRef[_pos[0]][_pos[1]] = -1;
			}
			with(oPXLUISlot){
				if(inventoryPos.x == _slot_x && inventoryPos.y == _slot_y && other.invID == invID){
					id.invID.offset_x = x-cursor_instance.xGui;	
					id.invID.offset_y = y-cursor_instance.yGui;	
				}
			}
		}
	} else{
		//if slot empty
		//if currently holding an item
		if (_helditem != -1){		
			if (pxlui_inv_can_place(id.inventoryRef,id.inventory.hoverPosition.x, id.inventory.hoverPosition.y,
									_helditem.size.w,_helditem.size.h,_helditem.rotated)){
				//place item to new slot 
				pxlui_inv_place(id.inventory,id.inventoryPos.x,id.inventoryPos.y,_helditem.size.w,_helditem.size.h,_helditem.rotated);
			}
		}
	}
}
	
alt_clicked = function(id){
	var _slot_x = id.inventoryPos.x;
	var _slot_y = id.inventoryPos.y;
	var _slot = id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y];
	var _helditem = id.inventory.itemCurrent;
	//if slot not empty
	if (_slot != -1){
		if (is_array(_slot)){
			_slot_x = _slot[0];
			_slot_y = _slot[1];
			_slot = id.inventoryRef[_slot[0]][_slot[1]];
		}
		//if currently holding an item
		if (id.inventory.itemCurrent != -1){
			//if slot has same item as held and can be stacked, stack it
			if (id.inventory.itemCurrent.id = _slot.id){
				_slot.stack++;
				id.inventory.itemCurrent.stack--;
				
				if (id.inventory.itemCurrent.stack < 1){
					pxlui_inv_clear_current(id.inventory);
				}
			}
		} else{
			//if not holding an item	
			if (_slot.stack > 1){
				var stackSplit = round(_slot.stack/2);
				
				id.inventory.itemCurrent = variable_struct_copy(_slot);
				id.inventory.itemCurrentInv = id.invID; //take note of inventory ID
				id.inventory.itemCurrent.stack = stackSplit;
				
				_slot.stack -= stackSplit;
				
			} else{
				id.inventory.itemCurrent = variable_struct_copy(_slot);
				id.inventory.itemCurrentInv = id.invID; //take note of inventory ID
				
				for(var i = 0; i < array_length(_slot.pos); i++;){
					var _pos = _slot.pos[i];
					
					id.inventoryRef[_pos[0]][_pos[1]] = -1;
				}
			}
			
			with(oPXLUISlot){
				if(inventoryPos.x == _slot_x && inventoryPos.y == _slot_y && other.invID == invID){
					id.invID.offset_x = x-oPXLUICursor.xGui;	
					id.invID.offset_y = y-oPXLUICursor.yGui;	
				}
			}
		}
	} else{
		//if slot empty
		//if currently holding an item
		if (id.inventory.itemCurrent != -1){
			//place item to new slot
			if (pxlui_inv_can_place(id.inventoryRef,id.inventory.hoverPosition.x, id.inventory.hoverPosition.y,
									_helditem.size.w,_helditem.size.h,_helditem.rotated)){
				var _array = [];
				for (var i = 0; i < _helditem.size.w; i++){
					for (var j = 0; j < _helditem.size.h; j++){
						array_push(_array,[id.inventoryPos.x+i,id.inventoryPos.y+j]);
					}
				}
				id.inventory.itemCurrent.pos = _array;
				
				for (var i = 0; i < _helditem.size.w-1; i++;){
					for (var j = 0; j < _helditem.size.h-1; j++;){
						id.inventoryRef[id.inventoryPos.x+i][id.inventoryPos.y+j] = [id.inventoryPos.x, id.inventoryPos.y];
					}
				}
				//ds_grid_set_region(id.inventoryRef,id.inventoryPos.x, id.inventoryPos.y,id.inventoryPos.x + _helditem.size.w-1, id.inventoryPos.y + _helditem.size.h-1,[id.inventoryPos.x, id.inventoryPos.y]);
				id.inventoryRef[inventoryPos.x][id.inventoryPos.y] = variable_struct_copy(_helditem);
				id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y].stack = 1;
			
				id.inventory.itemCurrent.stack--;
				if (id.inventory.itemCurrent.stack < 1){
					pxlui_inv_clear_current(id.inventory);
				}
			}
		}
	}
}

cursorIn = function(){
	return point_in_rectangle(cursor_instance.xGui+invID.offset_x, cursor_instance.yGui+invID.offset_y, x + 1 - sprite_width / 2, y + 1 - sprite_height / 2, x + sprite_width / 2, y + sprite_height / 2);	
}

beginStep = function(id){
	if (!cursorIn()){
		id.hover = false;
		id.pressed = false;
		//if (id.interactable){
		//	id.color = c_white;
		//} else{
		//	id.color = global.pxlui_theme[$ global.pxlui_settings.theme].color.secondary;
		//}
	}
}

step = function(id){
	if (id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y] != -1 && !is_array(id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y])){
		if (id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y].stack < 1){
			id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y] = -1;
		}
	}
}

drawGUI = function(id){
	var _col = id.gridcolor;
	var _col2 = id.color;
	
	if (id.inventory.item_assign != -1){
		_col = c_dkgray;
		_col2 = c_dkgray;
		if (id.inventory.item_assign == id){
			_col2 = c_white;
		}
	}
	draw_sprite_ext(sSlot, 1, id.x, id.y,1,1,0,_col,1);	
	
	if (id.hover){
		id.color = color2;
		id.inventory.hoverPosition = id.inventoryPos;
		id.inventory.itemCurrentInv = id.invID;

		if (id.inventory.itemCurrent != -1){
			var _helditem = id.inventory.itemCurrent;
			var _color = c_red;
			if (pxlui_inv_can_place(id.inventory.array,id.inventory.hoverPosition.x,id.inventory.hoverPosition.y,
									_helditem.size.w,_helditem.size.h,_helditem.rotated)){
				var _color = c_green;
			}
			pxlui_inv_draw_rect_placement(id.x,id.y,
									_helditem.size.w,_helditem.size.h,_helditem.rotated);
		}
		
		
		if (input_check_pressed("item_active",player_index)){
			id.clicked(id);
		}
		if (input_check_pressed("item_focus",player_index)){
			id.alt_clicked(id);
		}
	}
						
	var _slot = id.inventoryRef[id.inventoryPos.x][id.inventoryPos.y];
	if (!is_array(_slot)){
		if (_slot != -1){
			var _sprite = asset_get_index("spr_"+_slot.id+"_icon");
			var _rotated = _slot.rotated;
			var _angle = _rotated*270;
			var _x = id.x;
			if (_rotated){
				_x = id.x+(_slot.size.h-1)*8;
			}
			
			draw_sprite_ext(_sprite, 0, _x, id.y, 1, 1, _angle, _col2, 1);
		
			if (_slot.stack > 1){
				var _offsetx = 1+(_slot.size.w-1)*8;
				var _offsety = (_slot.size.h-1)*8;
				if (_slot.rotated){
					_offsetx = 1+(_slot.size.h-1)*8;
					_offsety = (_slot.size.w-1)*8;
				}
				draw_text(id.x+_offsetx, id.y+_offsety, string(_slot.stack));
			}
		}
	}
	id.color = c_white;
	id.gridcolor = c_white;
	
	if (id.inventory.hoverPosition.x != -1 && id.inventory.hoverPosition.y != -1){
		//pxlui_inv_highlight(id.inventoryRef, id.invID, id.inventory.hoverPosition.x, id.inventory.hoverPosition.y, c_aqua);
	}
}