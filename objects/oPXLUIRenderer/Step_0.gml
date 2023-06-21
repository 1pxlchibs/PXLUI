if (graceful_destroy){
	if (surface_exists(render_surf)){
		surface_free(render_surf);
		instance_destroy();
	}
}