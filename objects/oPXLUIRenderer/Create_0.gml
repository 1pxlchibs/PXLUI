/// @description PXLUI RENDERER
render_surf = -1;
graceful_destroy = false;

refreshGUI = function(width = undefined, height = undefined){
	var tar_width = width ?? global.pxlui_settings.UIResW;
	var tar_height = height ?? global.pxlui_settings.UIResH;
	
	display_set_gui_size(tar_width,tar_height);
	//display_set_gui_maximize(1,1,0,0);
}

refreshGUI();

pxlui_draw_elements = function(id){
	draw_surface_ext(id.render_surf,0,0,1,1,0,c_white,1);
}

pxlui_drawGUI = function(id){
	id.pxlui_draw_elements(id);
}