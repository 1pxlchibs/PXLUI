// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_tabs(x, y, names, pages, width, height, elementid = PXLUI_DEFAULT_ID){
	return {
		object: oPXLUITabs,
		xx : x,
		yy : y,
		names : names,
		pages : pages,
		width : width,
		height : height,
		elementid: elementid
	};
}