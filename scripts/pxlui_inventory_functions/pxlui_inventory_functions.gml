// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_inv_clear_current(inventory){
	//clear item
	inventory.itemCurrent = -1;
	inventory.itemCurrentInv = -1;
	inventory.itemOldPos = {x: -1, y: -1};
	inventory.itemOldInventory= -1;
}

function pxlui_inv_update_current(inventory,item, invID, oldInv, oldPos){
	//add item
	inventory.itemCurrent = variable_struct_copy(item); //take the item
	inventory.itemCurrentInv = invID; //take note of inventory ID
	inventory.itemOldInventory = oldInv; //take note of old inventory
	inventory.itemOldPos = oldPos; //take note of old position
}

#region BACKEND DATA FUNCTION
function pxlui_inv_can_place(inventory,x,y,width,height,rotated){
	var _canPlace = true;
	switch(rotated){
		case false:
			for (var i = 0; i < width; i++;){
				for (var j = 0; j < height; j++;){
					if (x+i < array_length(inventory) && y+j < array_length(inventory[i]) && x+i > -1 && y+j > -1){
						if (inventory[x+i][y+j] != -1){
							_canPlace = false;
						}
					} else{
						_canPlace = false;	
					}
				}
			}
		break;
		case true:
			for (var i = 0; i < height; i++;){
				for (var j = 0; j < width; j++;){
					if (x+i < array_length(inventory) && y+j < array_length(inventory[i])){
						if (inventory[x+i][y+j] != -1){
							_canPlace = false;
						}
					} else{
						_canPlace = false;	
					}
				}
			}
		break;
	}
	return _canPlace;

}

function pxlui_inv_place(inventory,x,y,width,height,rotated){
	switch(rotated){
		case 0:
			//place item to new slot
			var _array = [];
			for (var i = 0; i < width; i++;){
				for (var j = 0; j < height; j++;){
					array_push(_array,[x+i,y+j]);
				}
			}
			inventory.itemCurrent.pos = _array;
			
			for (var i = 0; i < width; i++;){
				for (var j = 0; j < height; j++;){
					inventory.array[x+i][y+j] = [x,y];
				}
			}

			inventory.array[x][y] = variable_struct_copy(inventory.itemCurrent);
				
			pxlui_inv_clear_current(inventory);
		break;
		case 1:
			//place item to new slot
			var _array = [];
			for (var i = 0; i < height; i++){
				for (var j = 0; j < width; j++){
					array_push(_array,[x+i,y+j]);
				}
			}
			inventory.itemCurrent.pos = _array;
			
			for (var i = 0; i < height; i++;){
				for (var j = 0; j < width; j++;){
					inventory.array[x+i][y+j] = [x,y];
				}
			}
			inventory.array[x][y] = variable_struct_copy(inventory.itemCurrent);
				
			pxlui_inv_clear_current(inventory);
		break;
	}
}

function pxlui_inv_find_place(inventory,item){
	for (var i = 0; i < array_length(inventory); i++;){
		for (var j = 0; j < array_length(inventory[i]); j++;){
			if (pxlui_inv_can_place(inventory,i,j,item.size.w,item.size.h,false)){
				return {x: i, y: j, rotated: false};
			}
			if (pxlui_inv_can_place(inventory,i,j,item.size.w,item.size.h,true)){
				return {x: i, y: j, rotated: true};
			}
		}
	}
	return -1;
}
	
function pxlui_inv_add_to(inventory,item,x,y,rotated,amount){
	var _item = variable_struct_copy(item);
	var width = _item.size.w;
	var height = _item.size.h;
	
	switch(rotated){
		case 0:
			//place item to new slot
			var _array = [];
			for (var i = 0; i < width; i++){
				for (var j = 0; j < height; j++){
					array_push(_array,[x+i,y+j]);
				}
			}
			_item.pos = _array;
			_item.stack = amount;
			
			for (var i = 0; i < width; i++;){
				for (var j = 0; j < height; j++;){
					inventory[x+i][y+j] = [x,y];
				}
			}
			//ds_grid_set_region(inventory,x, y,x + width-1, y + height-1,[x, y]);
			inventory[x][y] = _item;
				
		break;
		case 1:
			//place item to new slot
			var _array = [];
			for (var i = 0; i < height; i++){
				for (var j = 0; j < width; j++){
					array_push(_array,[x+i,y+j]);
				}
			}
			_item.pos = _array;
			_item.stack = amount;
			
			for (var i = 0; i < width; i++;){
				for (var j = 0; j < height; j++;){
					inventory[x+i][y+j] = [x,y];
				}
			}
			//ds_grid_set_region(inventory,x, y,x + height-1, y + width-1,[x, y]);
			inventory[x][y] = _item;

		break;
	}
}

function pxlui_inv_add(inventory,item,amount = 1){
	var _place = pxlui_inv_find_place(inventory,item);
	if (_place != -1 && _place != -2){
		item.rotated = _place.rotated;
		pxlui_inv_add_to(inventory,item,_place.x,_place.y,_place.rotated,amount);
	}
}
	
function pxlui_inv_find(inventory,item){
	for (var i = 0; i < array_length(inventory); i++;){
		for (var j = 0; j < array_length(inventory[i]); j++){
			var _x = i;
			var _y = j;
			var _slot = inventory[_x][ _y];

			if (_slot != -1 && _slot != -2){
				if (is_array(_slot)){
					_x = _slot[0];
					_y = _slot[1];
				}
				_slot = inventory[_x][ _y];
				
				pxlui_log($"PXLUI: {_slot}");
				if (_slot.id = item){
					return {x: _x, y: _y};
				}
			}
		}
	}
	return -1;
}

function pxlui_inv_remove(inventory,x,y,amount = -1){
	var _slot = inventory[x][y];
	var _stack_transfer = _slot.stack-amount;

	
	if (amount = -1 || _stack_transfer <= 1){
		for(var i = 0; i < array_length(_slot.pos); i++;){
			var _pos = _slot.pos[i];
					
			inventory[_pos[0]][_pos[1]] = -1;
		}
		return _slot.stack;
	}
	_slot.stack -= amount;
	return amount;
}
#endregion

#region INVENTORY UI FUNCTION
function pxlui_inv_draw_grid_placement(inventoryId,x,y,width,height,rotated,col){
	switch(rotated){
		case 0:
			for(var i = 0; i < width; i++;){
				for(var j = 0; j < height; j++;){
					with(oPXLUISlot){
						if (inventoryPos.x == i+x && inventoryPos.y = j+y && inventoryId == invID){
							gridcolor = col;
						}
					}	
				}
			}
		break;
		case 1:
			for(var i = 0; i < height; i++;){
				for(var j = 0; j < width; j++;){
					with(oPXLUISlot){
						if (inventoryPos.x == i+x && inventoryPos.y = j+y && inventoryId == invID){
							gridcolor = col;
							
						}
					}	
				}
			}
		break;
	}
}

function pxlui_inv_draw_rect_placement(x,y,width,height,rotated){
	var _alpha = sine_wave(current_time/1000,1,0.4,0.5);
	draw_set_alpha(_alpha);
	draw_set_color(#10908e);
	switch(rotated){
		case 0:
			draw_rectangle(x,y,x-2+width*8,y-2+height*8,false);
		break;
		case 1:
			draw_rectangle(x,y,x-2+height*8,y-2+width*8,false);
		break;
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
}
	
function pxlui_inv_highlight(inventory,inventoryId,xx,yy,col){
	var _id = pxlui_inv_get(inventory,inventoryId,xx,yy);
	if (_id != -1){
		_id.color = col;
	}
}

function pxlui_inv_get(inventory,inventoryId,xx,yy){
	var _slot = inventory[xx][yy];
	var _x = xx;
	var _y = yy;
	if (is_array(_slot)){
		_x = _slot[0];
		_y = _slot[1];
	}
	var _id = -1;
	with(oPXLUISlot){
		if (inventoryPos.x == _x && inventoryPos.y == _y && inventoryId == invID){
			_id = id;
		}
	}
	return _id;
}
#endregion