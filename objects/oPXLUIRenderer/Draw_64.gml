/// @description Insert description here
// You can write your code in this editor
if (!graceful_destroy){
	if (!surface_exists(render_surf)){
		render_surf = surface_create(global.pxlui_settings.UIResW,global.pxlui_settings.UIResH);
	} else{
		surface_set_target(render_surf);
		
		draw_clear_alpha(c_black,0);
	
		var _elements = layer_get_all_elements(layerId);
		for(var i = 0; i < array_length(_elements); i++;){
			var _element = _elements[i];
			var _id = layer_instance_get_instance(_element);
			with(_id){
				if (visible){
					drawGUI(id);
				}
			}
		}

		surface_reset_target();
	}
}

pxlui_drawGUI(id);
