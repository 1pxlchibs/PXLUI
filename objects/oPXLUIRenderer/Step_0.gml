if (graceful_destroy){
	if (surface_exists(render_surf)){
		surface_free(render_surf);
		layer_destroy(layerId);
		pxlui_log($"destroyed {layer_get_name(layerId)} renderer");
		instance_destroy();
	}
}