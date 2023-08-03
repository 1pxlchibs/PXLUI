event_inherited();


create = function(pageName, id){
	var _id = id;
	
	id.page = pageName;
	id.depth_original = depth;
	id.interactable = false;
	id.parent = -1;
	id._pickupUI = -1;
	id._pickupUIStruct = -1;
	id.alpha = 1;
	
	for(var i = 0; i < array_length(id.inventory); i++;){
		var xoffset = x + (i mod id.columns) * 36 +2;
		var yoffset = y +  (i div id.columns) * 36 +2;
	
		var _slot = instance_create_layer(xoffset, yoffset, id.layerId, oPXLUISlot, {
			page : pageName,
			sprite_index : sSlot,
			inventoryRef : id.inventory,
			inventoryPos : i,
			invID: _id,
			elementid: id.elementid+" slot "+string(i),
		});
		
		with(_slot){
			create(id.page,_slot)	
		}
	}
	
	id.created = true;
}

beginstep = function(id){
	global.inventoryManager.hoverPosition = -1;	
}

step = function(id){
	id.alpha = lerp(id.alpha,1,0.1);
	
	if (global.inventoryManager.hoverPosition != -1){
		var gun_struct = id.inventory[global.inventoryManager.hoverPosition];
		show_debug_message(gun_struct);
		if (!instance_exists(ui_pickup) and gun_struct != -1){
			
			with(instance_create_depth(PXLUI_CURSOR.xGui,PXLUI_CURSOR.yGui,-9999,ui_pickup)){
				_struct = gun_struct;
				_pickup = other.id;
				other._pickupUI = id;
				mode = 1;
			}
			id._pickupUIStruct = gun_struct;
		}
	}
	
	if (global.inventoryManager.hoverPosition = -1 or gun_struct != id._pickupUIStruct){
		instance_destroy(ui_pickup);
		id._pickupUI = -1;
	}
}

drawGUI = function(id){
	if (global.inventoryManager.itemCurrent != -1){
		draw_sprite_ext(asset_get_index("spr_"+global.inventoryManager.itemCurrent.id), 0, PXLUI_CURSOR.xGui-16, PXLUI_CURSOR.yGui,1,1,0,c_white,1);
		
		if (global.inventoryManager.itemCurrent.stack > 1){
			draw_text(PXLUI_CURSOR.xGui, PXLUI_CURSOR.yGui+10, string(global.inventoryManager.itemCurrent.stack));
		}
	}
}