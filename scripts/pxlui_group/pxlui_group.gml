// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
<<<<<<< Updated upstream
function pxlui_group(x, y, width, height, halign = fa_middle, valign = fa_middle, elements, elementid = 0){
=======
<<<<<<<< Updated upstream:scripts/pxlui_checkbox/pxlui_checkbox.gml
function pxlui_checkbox(x, y, variable_array, width = 16, height = 16, halign = fa_middle, valign = fa_middle, elementid = 0){
========
function pxlui_group(x, y, width, height, halign = fa_middle, valign = fa_middle, elements, elementid = PXLUI_DEFAULT_ID){
>>>>>>>> Stashed changes:scripts/pxlui_group/pxlui_group.gml
>>>>>>> Stashed changes
	return {
		object: oPXLUIGroup,
		elementid: elementid,
		elements: elements,
		xx : x,
		yy : y,
		width: width,
		height: height,
		container_depth: 0,
		halign: halign,
		valign: valign
	};
}