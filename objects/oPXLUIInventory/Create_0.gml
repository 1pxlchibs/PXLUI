event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.depth_original = depth;
	id.interactable = false;
	id.parent = -1;
	id._pickupUI = -1;
	id._pickupUIStruct = -1;
	id.alpha = 1;
	id.offset_x = 0;
	id.offset_y = 0;
	id.angle_lerp = 0;
	id.offset_xlerp = 0;
	id.offset_ylerp = 0;
	
	id.width = array_length(id.inventory.array);
	id.height = array_length(id.inventory.array[0]);
	id.inv_xoffset = (id.width*8)/2;
	id.inv_yoffset = (id.height*8)/2;
	
	for(var i = 0; i < id.width; i++;){
		var xoffset = x + 4 + i* 8;
		for(var j = 0; j < id.height; j++;){
			var yoffset = y + 4 + j* 8;
			var _slot = instance_create_layer(xoffset - id.inv_xoffset, yoffset - id.inv_yoffset , id.layerId, oPXLUISlot, {
				page : pageName,
				sprite_index : sSlot,
				inventory: id.inventory,
				inventoryRef : id.inventory.array,
				inventoryPos : {x: i, y: j},
				invID: _id,
				elementid: id.elementid+" slot "+string(i),
			});
		
			with(_slot){
				cursor_instance = other.cursor_instance;
				player_index = other.player_index;
				create(id.page,_slot);
			}
		}
	}
	
	id.created = true;
}

beginstep = function(id){
	//id.inventoryhoverPosition = {x: -1, y: -1};
}

endstep = function(id){
	id.inventory.hoverPosition = {x: -1, y: -1};
	id.inventory.itemCurrentInv = -1;
}


_step = function(id){
	id.alpha = lerp(id.alpha,1,0.1);

	if (id.inventory.itemCurrentInv != -1){
		if (id.inventory.itemCurrentInv.inventory.array[id.inventory.hoverPosition.x][id.inventory.hoverPosition.y] != -1){
			if (input_check_pressed("interact",player_index)){
				var _id = pxlui_inv_get(id.inventory.itemCurrentInv.inventory.array,id.inventory.itemCurrentInv,id.inventory.hoverPosition.x, id.inventory.hoverPosition.y);
				var _ogslot = _id.inventoryRef[_id.inventoryPos.x][_id.inventoryPos.y];
				id.inventory.item_assign = _id;
			}
		
			if (id.inventory.item_assign != -1){
				if (input_check_pressed("slot1",player_index)){
					id.inventory.item_slots[0] = id.inventory.item_assign.inventoryRef[id.inventory.item_assign.inventoryPos.x][id.inventory.item_assign.inventoryPos.y];
					id.inventory.item_assign = -1;
				}
				if (input_check_pressed("slot2",player_index)){
					id.inventory.item_slots[1] = id.inventory.item_assign.inventoryRef[id.inventory.item_assign.inventoryPos.x][id.inventory.item_assign.inventoryPos.y];
					id.inventory.item_assign = -1;
				}
				if (input_check_pressed("slot3",player_index)){
					id.inventory.item_slots[2] = id.inventory.item_assign.inventoryRef[id.inventory.item_assign.inventoryPos.x][id.inventory.item_assign.inventoryPos.y];
					id.inventory.item_assign = -1;
				}
				if (input_check_pressed("slot4",player_index)){
					id.inventory.item_slots[3] = id.inventory.item_assign.inventoryRef[id.inventory.item_assign.inventoryPos.x][id.inventory.item_assign.inventoryPos.y];
					id.inventory.item_assign = -1;
				}
			}
		}
	}
	
	if (id.inventory.itemCurrent != -1 && id.inventory.itemCurrentInv == id){
		if (input_check_pressed("item_alt_active",player_index) && id.inventory.itemCurrent.rotatable){
			id.inventory.itemCurrent.rotated = !id.inventory.itemCurrent.rotated;
			
			if (id.inventory.itemCurrent.rotated){
				var _offsetx = id.offset_x;
				var _offsety = id.offset_y;
			
				id.offset_x = -_offsety;
				id.offset_y = _offsetx;
			} else{
				var _offsetx = id.offset_x;
				var _offsety = id.offset_y;
			
				id.offset_x = _offsety;
				id.offset_y = -_offsetx;
			}
		}
	}
}

drawGUI = function(id){
	//draw_rectangle(id.x - id.inv_xoffset-4, id.y - id.inv_yoffset-4,id.x - id.inv_xoffset+(id.width*8)-4, id.y - id.inv_yoffset+(id.height*8)-4,true);
	draw_sprite_ext(sInventory,0,id.x,id.y,id.width+2/8,id.height+2/8,0,c_white,1);
	if (id.inventory.itemCurrent != -1 && id.inventory.itemCurrentInv == id){
		var _rotate = -id.inventory.itemCurrent.rotated*90;
		id.angle_lerp = lerp(id.angle_lerp,_rotate,0.1);
		draw_sprite_ext(asset_get_index("spr_"+id.inventory.itemCurrent.id+"_icon"), 0, cursor_instance.xGui+id.offset_x, cursor_instance.yGui+id.offset_y,1,1,id.angle_lerp,c_white,1);
		
		var _offsetx = 1+(id.inventory.itemCurrent.size.w-1)*8;
		var _offsety = (id.inventory.itemCurrent.size.h-1)*8;
		if (id.inventory.itemCurrent.rotated){
			_offsetx = 1+(id.inventory.itemCurrent.size.h-1)*8;
			_offsety = (id.inventory.itemCurrent.size.w-1)*8;
		}
		
		id.offset_xlerp = lerp(id.offset_xlerp,_offsetx,0.1);
		id.offset_ylerp = lerp(id.offset_ylerp,_offsety,0.1);
		
		if (id.inventory.itemCurrent.stack > 1){
			draw_text(cursor_instance.xGui+id.offset_x+id.offset_xlerp, cursor_instance.yGui+id.offset_y+id.offset_ylerp, string(id.inventory.itemCurrent.stack));
		}
	}
}