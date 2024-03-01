/// @description PXLUI RENDERER
render_surf = -1;
graceful_destroy = false;

refreshGUI = function(width = undefined, height = undefined){
	var tar_width = width ?? PXLUI_UI_W;
	var tar_height = height ?? PXLUI_UI_H;
	
	var _gui_xscale = global.pxlui_settings.ResW/PXLUI_UI_W;
	var _gui_yscale = global.pxlui_settings.ResH/PXLUI_UI_H;
	
	display_set_gui_size(PXLUI_UI_W,PXLUI_UI_H);
	display_set_gui_maximize(_gui_xscale,_gui_xscale,0,0)
}

refreshGUI();

pxlui_draw_elements = function(id){ 
	draw_surface_ext(id.render_surf,0,0,1,1,0,c_white,1);
}

pxlui_drawGUI = function(id){
	id.pxlui_draw_elements(id);
}