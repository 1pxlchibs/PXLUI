/// @description Insert description here
// You can write your code in this editor
if (!graceful_destroy){
	if (!surface_exists(render_surf)){
		render_surf = surface_create(PXLUI_UI_W,PXLUI_UI_H);
	} else{
		surface_set_target(render_surf);
		
		draw_clear_alpha(c_black,0);
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		
		if (layer_exists(layerId)){
			var _elements = layer_get_all_elements(layerId);
			for(var i = 0; i < array_length(_elements); i++;){
				var _element = _elements[i];
				var _id = layer_instance_get_instance(_element);
				with(_id){
					if (visible){
						element.drawGUI(id);
					}
				}
			}
		}
		
		surface_reset_target();
		gpu_set_blendmode(bm_normal);
	}
}

pxlui_drawGUI(id);

