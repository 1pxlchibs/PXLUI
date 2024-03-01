// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_inventory(x, y, inventory_array, elementid = 0){
	return {
		object: oPXLUIInventory,
		elementid: elementid,
		xx : x,
		yy : y,
		inventory : inventory_array
	};
}
//function pxlui_inventory(x, y, inventory, elementid = PXLUI_DEFAULT_ID){
//	return {
//		object: oPXLUIInventory,
//		xx : x,
//		yy : y,
//		inventory : inventory,
//		elementid: elementid,
//	};
//}
