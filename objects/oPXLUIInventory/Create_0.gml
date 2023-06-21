event_inherited();

create = function(pageName, id){
	id.page = pageName;
	id.depth_original = depth;
	id.interactable = false;
	id.parent = -1;
	
	for(var i = 0; i < array_length(inventory); i++;){
		var xoffset = x + (i mod columns) * 33;
		var yoffset = y +  (i div columns) * 33;
	
		var _slot = instance_create_depth(xoffset, yoffset, PXLUI_DEPTH_MIDDLE, oPXLUISlot, {
			page : pageName,
			sprite_index : sSlot,
			inventoryRef : inventory,
			inventoryPos : i
		});
		
		with(_slot){
			create(other.id.page,_slot)	
		}
	}
	
	created = true;
}