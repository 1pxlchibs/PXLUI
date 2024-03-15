function pxlui_element(_x,_y,_config = {},_elementid = 0) constructor{
	var _self = self;
	__ = {};

	interactable = false;

	x = _x;
	y = _y;
	
	xoffset = _config[$ "xoffset"] ?? 0;
	yoffset = _config[$ "yoffset"] ?? 0;
	
	halign = _config[$ "halign"] ?? fa_left;
	valign = _config[$ "valign"] ?? fa_top;
	collision = {x1: 0, y1: 0, x2: 0, y2: 0};
	
	width = _config[$ "width"] ?? 0;
	height = _config[$ "height"] ?? 0;
	
	angle = _config[$ "angle"] ?? 0;
	color = _config[$ "color"] ?? c_white;
	alpha = _config[$ "alpha"] ?? 1;

	text = _config[$ "text"] ?? -1;
	
	var _padding =  _config[$ "padding"] ?? 0;
	padding = {
		top: _config[$ "padding_top"] ?? _padding,
		bottom: _config[$ "padding_bottom"] ?? _padding,
		left: _config[$ "padding_left"] ?? _padding,
		right: _config[$ "padding_right"] ?? _padding,
	}
	
	animation_xscale = _config[$ "animation_xscale"] ?? 0;
	animation_yscale = _config[$ "animation_yscale"] ?? 0;
	
	animation_duration = _config[$ "animation_duration"] ?? 1*game_get_speed(gamespeed_fps);
	var _anim_curve = _config[$ "animation_curve"] ?? PXLUI_CURVES.linear;
	animation_curve_in = _config[$ "animation_curve_in"] ?? _anim_curve;
	animation_curve_out = _config[$ "animation_curve_out"] ?? _anim_curve;
	animations = _config[$ "animations"] ?? {};
	
	// = PUBLIC =====================
	static on_initialize = function(_callback,_data = undefined){
		array_push(__.on_initialize_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
	static on_cleanup = function(_callback,_data = undefined){
		array_push(__.on_cleanup_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
	static on_begin_step = function(_callback,_data = undefined){
		array_push(__.on_begin_step_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
	static on_step = function(_callback,_data = undefined){
		array_push(__.on_step_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
	static on_end_step = function(_callback,_data = undefined){
		array_push(__.on_end_step_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
	static on_drawGUI = function(_callback,_data = undefined){
		array_push(__.on_drawGUI_callbacks, {
			callback: _callback,
			data: _data
		});
		return self;
	}
		
	static clear_initialize = function(){
		__.on_initialize_callbacks = [];
	}
	static clear_cleanup = function(){
		__.on_cleanup_callbacks = [];
	}
	static clear_begin_step = function(){
		__.on_begin_step_callbacks = [];
	}
	static clear_step = function(){
		__.on_step_callbacks = [];
	}
	static clear_end_step = function(){
		__.on_end_step_callbacks = [];
	}
	static clear_drawGUI = function(){
		__.on_drawGUI_callbacks = [];
	}
	static clear_all_events = function(){
		clear_initialize();
		clear_cleanup();
		clear_begin_step();
		clear_step();
		clear_end_step();
		clear_drawGUI();
	}

	static is_initalized = function(){
		return __.initalized;
	}
	static is_hovering = function(){
		return __.hover;
	}
	static is_pressed = function(){
		return __.pressed;
	}
	static is_cursor_in = function(){
		var _x1 = x + collision.x1;
		var _x2 = x + collision.x2;
		var _y1 = y + collision.y1;
		var _y2 = y + collision.y2;
		if (interactable){
			return point_in_rectangle(__.cursor_inst.xGui, __.cursor_inst.yGui, _x1, _y1, _x2, _y2);	
		}
	}
		
	static get_page = function(){
		return __.page;	
	}
	
	// = PRIVATE ====================
	with (__){
		inst_id = -1;
		pxlui = -1;
		elementid = _elementid;
		page = -1;
		group = -1;
	
		cursor_inst = -1;
		layer_id = -1;
	
		initalized = false;
		
		hover = false;
		pressed = false;
		held = false;
		
		animation_value = 0;
		animation_pos = 0;
		animation_previous_pos = 0;
		
		animation_speed = 1/_self.animation_duration;
		
		animations = {};
		
		var _animation = _self.animations;
		if (variable_struct_exists(_animation,"from") && variable_struct_exists(_animation,"to")){
			var _animation_from = _self.animations.from;
			var _animation_to = _self.animations.to;
			var _animation_array = variable_struct_get_names(_animation_to);
				
			for(var j = 0; j < array_length(_animation_array); j++;){	
				var _variable_from = _animation_from[$ _animation_array[j]];
				var _variable_to = _animation_to[$ _animation_array[j]];
					
				variable_struct_set(animations,_animation_array[j],{from: _variable_from, to: _variable_to});
			}
		}
		
		override_drawGUI = -1;
		if (_config[$ "override_drawGUI"] != undefined){
			override_drawGUI = method(_self,_config[$ "override_drawGUI"]);
		}
	
		on_initialize_callbacks = [];
		on_cleanup_callbacks = [];	
		on_begin_step_callbacks = [];	
		on_step_callbacks = [];	
		on_end_step_callbacks = [];	
		on_drawGUI_callbacks = [];
		
		static initialize = function(){
			x = __.inst_id.x;
			y = __.inst_id.y;
		
			for (var _i = 0, _len = array_length(__.on_initialize_callbacks); _i < _len; _i++;){
				var _on_initialize_insert = __.on_initialize_callbacks[_i];
				var _callback = _on_initialize_insert.callback;
				var _data = _on_initialize_insert.data;
			
				_callback(_data);
			};
		}		
		static cleanup = function(){
			for (var _i = 0, _len = array_length(__.on_cleanup_callbacks); _i < _len; _i++;){
				var _on_cleanup_insert = __.on_cleanup_callbacks[_i];
				var _callback = _on_cleanup_insert.callback;
				var _data = _on_cleanup_insert.data;
			
				_callback(_data);
			};
		}
		static begin_step = function(){
			for (var _i = 0, _len = array_length(__.on_begin_step_callbacks); _i < _len; _i++;){
				var _on_begin_step_insert = __.on_begin_step_callbacks[_i];
				var _callback = _on_begin_step_insert.callback;
				var _data = _on_begin_step_insert.data;
			
				_callback(_data);
			};
		}
		static step = function(){
			for (var _i = 0, _len = array_length(__.on_step_callbacks); _i < _len; _i++;){
				var _on_step_insert = __.on_step_callbacks[_i];
				var _callback = _on_step_insert.callback;
				var _data = _on_step_insert.data;
			
				_callback(_data);
			};
		}
		static end_step = function(){
			for (var _i = 0, _len = array_length(__.on_end_step_callbacks); _i < _len; _i++;){
				var _on_end_step_insert = __.on_end_step_callbacks[_i];
				var _callback = _on_end_step_insert.callback;
				var _data = _on_end_step_insert.data;
			
				_callback(_data);
			};
		}
		static drawGUI = function(){
			if (__.override_drawGUI != -1){
				__.override_drawGUI();
			} else{
				for (var _i = 0, _len = array_length(__.on_drawGUI_callbacks); _i < _len; _i++;){
					var _on_drawGUI_insert = __.on_drawGUI_callbacks[_i];
					var _callback = _on_drawGUI_insert.callback;
					var _data = _on_drawGUI_insert.data;
			
					_callback(_data);
				};
			}
		}
			
		static get_alignments = function(_xoffset = 0,_yoffset = 0){
			switch(halign){
				case fa_left:
					xalign = 0+_xoffset;
					
					text_xoffset = padding.left;
			
					collision.x1 = 0+_xoffset;
					collision.x2 = width+_xoffset;
				break;
				case fa_center:
					xalign = -width/2+_xoffset;
					
					text_xoffset = 0;
					
					collision.x1 = -width/2+_xoffset;
					collision.x2 = width/2+_xoffset;
			
				break;
				case fa_right:
					xalign = -width+_xoffset;
					
					text_xoffset = -padding.right;
			
					collision.x1 = -width+_xoffset;
					collision.x2 = 0+_xoffset;
				break;
			}
			switch(valign){
				case fa_top:
					yalign = 0+_yoffset;
					
					text_yoffset = padding.top;
			
					collision.y1 = 0+_yoffset;
					collision.y2 = height+_yoffset;
				break;
				case fa_middle:
					yalign = -height/2+_yoffset;
					
					text_yoffset = 0;
			
					collision.y1 = -height/2+_yoffset;
					collision.y2 = height/2+_yoffset;
				break;
				case fa_bottom:
					yalign = -height+_yoffset;
					
					text_yoffset = -padding.bottom;
			
					collision.y1 = -height+_yoffset;
					collision.y2 = 0+_yoffset;
				break;
			}
		}
	};
	
	// = EVENTS =====================
	on_begin_step(function(){
		__.hover = false;
		__.pressed = false;
		if (!input_check("shoot")){
			__.held = false;
		}
	});
}

function pxlui_sprite(_x,_y,_config = {}, _elementid = 0) : pxlui_element(_x,_y,_config,_elementid) constructor{
	var _self = self;
	
	sprite_index = _config[$ "sprite_index"] ?? noone;
	image_index = _config[$ "image_index"] ?? 0;
	image_speed = _config[$ "image_speed"] ?? 1;
	image_xscale = _config[$ "image_xscale"] ?? 1;
	image_yscale = _config[$ "image_yscale"] ?? 1;
	
	// = EVENTS =====================
	on_initialize(function(){
		width = sprite_get_width(sprite_index)*image_xscale;
		height = sprite_get_height(sprite_index)*image_yscale;
		get_alignments();
	});
	on_drawGUI(function(){
		var _sprite_xoffset = sprite_get_xoffset(sprite_index)*image_xscale;
		var _sprite_yoffset = sprite_get_yoffset(sprite_index)*image_yscale;
		
		draw_sprite_ext(sprite_index,image_index,x+xoffset+xalign+_sprite_xoffset,y+yoffset+yalign+_sprite_yoffset,image_xscale,image_yscale,angle,color,alpha);
	})
}

function pxlui_button(_x,_y, _config = {}, _elementid = 0) : pxlui_element(_x,_y,_config,_elementid) constructor{
	var _self = self;
	
	interactable = true;
	
	sprite_index = _config[$ "sprite_index"] ?? global.pxlui_theme.minimal.button;
	image_index = _config[$ "image_index"] ?? 0;
	image_speed = _config[$ "image_speed"] ?? 1;

	callback = _config[$ "callback"] ?? function(){
		pxlui_log("PXLUI: empty button has been pressed!");
	};
	
	// = EVENTS =====================
	on_initialize(function(){
		var _width = width;
		var _height = height;
		
		if (text != -1){
			scribbleText = scribble(text);
			scribbleText.align(halign,valign);
			
			_width = round(max(width,scribbleText.get_width()+padding.left+padding.right));
			_height = round(max(height,scribbleText.get_height()+padding.bottom+padding.top));
		}		
		
		if (!_width % 2 == 0){ //check if number is even, if not make it so
			_width++;	
		}
		
		if (!_height % 2 == 0){ //check if number is even, if not make it so
			_height++;	
		}
		
		width = _width;
		height = _height;
		
		get_alignments();
	});
	on_step(function(){
		var curveStruct = animcurve_get(pxlui_animation_curves);
		var _channel, _arg1, _arg2;
		
		if(is_hovering()){
			_arg1 = "from";
			_arg2 = "to";
			_channel = animcurve_get_channel(curveStruct,animation_curve_in);
			
			if (is_pressed()){
				callback();
			}
			if (__.animation_pos < 1){
				__.animation_pos+=__.animation_speed;
			}		
		} else{
			_arg1 = "to";
			_arg2 = "from";
			_channel = animcurve_get_channel(curveStruct,animation_curve_out);
			
			if (__.animation_pos > 0){
				__.animation_pos-=__.animation_speed;
			}
		}
		
		__.animation_value = animcurve_channel_evaluate(_channel,__.animation_pos);
		
		if (__.animation_pos != __.animation_previous_pos){
			var _animation_array = variable_struct_get_names(__.animations);
			for(var i = 0; i < array_length(_animation_array); i++;){
				var _animation = __.animations[$ _animation_array[i]];
				if (_animation_array[i] == "color"){
					if (variable_struct_exists(_animation,"from") && variable_struct_exists(_animation,"to")){
						color = merge_color(_animation.from,_animation.to,__.animation_value);
					} else{
						if (variable_struct_exists(_animation,"percent")){
							var _percent = _animation.percent;
							if (variable_struct_exists(_percent,string(__.animation_speed*100)+"%")){
								self[$ _animation_array[i]] = _percent[$ string(__.animation_speed*100)+"%"];
							}
						}
					}
				} else{
					if (variable_struct_exists(_animation,"from") && variable_struct_exists(_animation,"to")){
						self[$ _animation_array[i]] = _animation.from+(_animation.to-_animation.from)*__.animation_value;
					} else{
						if (variable_struct_exists(_animation,"percent")){
							var _percent = _animation.percent;
							if (variable_struct_exists(_percent,string(__.animation_speed*100)+"%")){
								self[$ _animation_array[i]] = _percent[$ string(__.animation_speed*100)+"%"];
							}
						}
					}
				}
			}
			
			//when animation is at 0% force inject from
			if (__.animation_pos = 0){
				var _animation_array = variable_struct_get_names(__.animations);
				for(var i = 0; i < array_length(_animation_array); i++;){
					var _animation = __.animations[$ _animation_array[i]];
					if (variable_struct_exists(_animation,"from") && variable_struct_exists(_animation,"to")){
						self[$ _animation_array[i]] = _animation.from;
					} else{
						if (variable_struct_exists(_animation,"percent")){
							var _percent = _animation.percent;
							if (variable_struct_exists(_percent,"0%")){
								self[$ _animation_array[i]] = _percent[$ "0%"];
							}
						}	
					}
				}
			}
			
			//when animation is at 100% force inject to
			if (__.animation_pos = 1){
				var _animation_array = variable_struct_get_names(__.animations);
				for(var i = 0; i < array_length(_animation_array); i++;){
					var _animation = __.animations[$ _animation_array[i]];
					
					if (variable_struct_exists(_animation,"from") && variable_struct_exists(_animation,"to")){
						self[$ _animation_array[i]] = _animation.to;
					} else{
						if (variable_struct_exists(_animation,"percent")){
							var _percent = _animation.percent;
							if (variable_struct_exists(_percent,"100%")){
								self[$ _animation_array[i]] = _percent[$ "100%"];
							}
						}		
					}
				}
			}
		}
		
		__.animation_previous_pos = __.animation_pos;
		
		
	});
	on_drawGUI(function(){
		var _sprite_xoffset = sprite_get_xoffset(sprite_index);
		var _sprite_yoffset = sprite_get_yoffset(sprite_index);
		
		var _sprite_ow = (width/sprite_get_width(sprite_index));
		var _sprite_oh = (height/sprite_get_height(sprite_index));
		var _sprite_w = (width/sprite_get_width(sprite_index))+(__.animation_value*animation_xscale);
		var _sprite_h = (height/sprite_get_height(sprite_index))+(__.animation_value*animation_yscale);
		
		draw_sprite_ext(sprite_index,image_index,x+xoffset+xalign+_sprite_xoffset*_sprite_ow,y+yoffset+yalign+_sprite_yoffset*_sprite_oh, _sprite_w,_sprite_h,angle,color,alpha);
		
		if (text != -1){
			scribbleText.draw(x+xoffset+text_xoffset,y+yoffset+text_yoffset);
		}
	});
}
	
function pxlui_checkbox(_x,_y, _config = {}, _elementid = 0) : pxlui_button(_x,_y,_config,_elementid) constructor{
	var _self = self;
	
	interactable = true;
	
	sprite_index = _config[$ "sprite_index"] ?? global.pxlui_theme.minimal.checkbox;
	image_index = _config[$ "image_index"] ?? 0;
	image_speed = _config[$ "image_speed"] ?? 1;
	
	width = _config[$ "width"] ?? 20;
	height = _config[$ "height"] ?? 20;
	
	toggle = false;
	check = _config[$ "variable_array"] ?? [_self,"toggle"];
	
	callback = function(){
		toggle = !toggle;
	
		if (check[0] == global){
			variable_global_set(check[0],toggle);
			return;
		}
		check[0][$ check[1]] = toggle;
	};

	static get_toggle = function(){
		if (check[0] == global){
			return variable_global_get(check[0]);
		}
		return check[0][$ check[1]];
	}
	
	// = EVENTS =====================
	on_initialize(function(){
		get_alignments();
	});
	on_step(function(){
		if (toggle != get_toggle()){
			toggle = get_toggle();	
		}
	});
	clear_drawGUI();
	on_drawGUI(function(){
		var _sprite_xoffset = sprite_get_xoffset(sprite_index);
		var _sprite_yoffset = sprite_get_yoffset(sprite_index);
		
		var _sprite_ow = (width/sprite_get_width(sprite_index));
		var _sprite_oh = (height/sprite_get_height(sprite_index));
		var _sprite_w = (width/sprite_get_width(sprite_index))+(__.animation_value*animation_xscale);
		var _sprite_h = (height/sprite_get_height(sprite_index))+(__.animation_value*animation_yscale);
		
		draw_sprite_ext(sprite_index,toggle,x+xoffset+xalign+_sprite_xoffset*_sprite_ow,y+yoffset+yalign+_sprite_yoffset*_sprite_oh, _sprite_w,_sprite_h,angle,color,alpha);
	});
}
	
function pxlui_slider(_x,_y,_config = {}, _elementid = 0) : pxlui_button(_x,_y,_config,_elementid) constructor{
	var _self = self;
	
	interactable = true;
	
	sprite_index = _config[$ "sprite_index"] ?? global.pxlui_theme.minimal.button;
	image_index = _config[$ "image_index"] ?? 0;
	image_speed = _config[$ "image_speed"] ?? 1;
	image_xscale = _config[$ "image_xscale"] ?? 1;
	image_yscale = _config[$ "image_yscale"] ?? 1;
	
	width = _config[$ "width"] ?? 100;
	height = _config[$ "height"] ?? 10;
	
	value = 0;
	
	tip_x = 0;
	minimum = _config[$ "minimum"] ?? 0;
	maximum = _config[$ "minimum"] ?? 1;
	increment = _config[$ "increment"] ?? 0.1;
	variable = _config[$ "variable"] ?? [self,"value"];
	
	set = function(_value) {
		// floor value to nearest interval amount
		_value = (floor(_value / increment) * increment);
	
		value = _value;
		
		// determine ending x-coord of slider, used for drawing
		tip_x = remap(value, minimum, maximum, x, x + width);
	
		if (variable[0] == global){
			variable_global_set(variable[0], _value);
			return;
		}
		variable_struct_set(variable[0],variable[1],_value);
	}
	
	get = function(){
		if (variable[0] == global){
			return variable_global_get(variable[0]);
		}
		return variable_struct_get(variable[0],variable[1]);
	}
	
	remap = function(val, min1, max1, min2, max2) {
		return min2 + (max2 - min2) * ((val - min1) / (max1 - min1));
	}

	// = EVENTS =====================
	on_initialize(function(){
		get_alignments();
		set(get());
	});
	on_step(function(){
		if (__.held){
			var _val = remap(clamp(__.cursor_inst.xGui, x + xalign, x + xalign + width), x + xalign, x + xalign + width, minimum, maximum);
			set(_val);
		} else{
			if (value != get()){
				set(get());
			}	
		}
	})
	clear_drawGUI();
	on_drawGUI(function(){
		var _sprite_xoffset = sprite_get_xoffset(sprite_index);
		var _sprite_yoffset = sprite_get_yoffset(sprite_index);
		
		var _sprite_ow = width;
		var _sprite_oh = height;
		var _w = width+(__.animation_value*animation_xscale);
		var _h = height+(__.animation_value*animation_yscale);
		
		draw_rectangle_color(x + xalign, y + yalign, tip_x + xalign, y + yalign + _h, color, color, color, color, false); // value box	
		draw_rectangle_color(x + xalign, y + yalign, x + xalign + _w, y + yalign + _h, color, color, color, color, true); // outer box
		//draw_sprite_ext(sprite_index,image_index,x+xoffset+xalign+_sprite_xoffset*_sprite_ow,y+yoffset+yalign+_sprite_yoffset*_sprite_oh,image_xscale,image_yscale,angle,color,alpha);
	})
}
