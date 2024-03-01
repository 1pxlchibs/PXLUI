// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_init(){
	window_set_size(global.pxlui_settings.ResW,global.pxlui_settings.ResH);
	
	var _gui_xscale = global.pxlui_settings.ResW/PXLUI_UI_W;
	var _gui_yscale = global.pxlui_settings.ResH/PXLUI_UI_H;
	
	display_set_gui_size(PXLUI_UI_W,PXLUI_UI_H);
	display_set_gui_maximize(_gui_xscale,_gui_xscale,0,0)
}