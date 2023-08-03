// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_inventory(x, y, inventory_array, columns = 5, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUIInventory,
		xx : x,
		yy : y,
		inventory : inventory_array,
		columns: columns,
		elementid: elementid,
	};
}