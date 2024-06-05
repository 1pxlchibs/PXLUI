// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_create(_player_index = 0) constructor{
	inst_id = other;
	debug = false;
	
	//Create a struct for the ui controller, this will hold the pages.
	uiBook = {};

	uiBook.pages = {}; //pages where all ui elements are stored [arrays]
	uiBook.layers = {}; //layer info for each page [arrays]
	uiBook.groups= {}; //group info for each group [arrays]
	uiBook.customRender = {}; //layer custom render [function]
	
	uiPriority = ds_priority_create(); //ds_priority for keyboard/gamepad navigation
	currentInteractable = -1; //stores id of current ui element selected
	player_index = _player_index;
	
	cursor_instance = -1;
	update_cursor = false; //cursor update bool
	if (instance_exists(oPXLUICursor)){
		with(oPXLUICursor){
			if (player_index == _player_index){
				other.cursor_instance = id;	
			}
		}
	}
	if (cursor_instance == -1){
		cursor_instance = instance_create_depth(0,0,-9999,oPXLUICursor,{player_index: _player_index});
	}
	
	///@Description find an element using it's element ID, returns the instance id.
	///@param elementid Element ID.
	function find(_elementid){
		with(oPXLUIHandler){
			if (element.__.elementid == _elementid){
				return id;
			}
		}
		return -1;
	}
		
	///@Description Calculates the position of the element accounting for its group
	///@param elementid Element ID.
	function calculate_position(_group,_element){
		//get the group x and y
		var _group_x = _group.x;
		var _group_y = _group.y;
		var _group_t_x = 0;
		var _group_t_y = 0;
		
		//if string, position is percentage, so convert
		if (is_string(_group_x)){
			_group_t_x = window_get_width() * (real(_group_x) / 100);	
		} else{
			_group_t_x = _group_x;	
		}
		if (is_string(_group_y)){
			_group_t_y = window_get_height() * (real(_group_y) / 100);	
		} else{
			_group_t_y = _group_y;	
		}
			
 		var _group_xoffset = 0;
		var _group_yoffset = 0;
		switch(_group.halign){
			case fa_middle: _group_xoffset = -_group.width/2; break;
			case fa_right: _group_xoffset = -_group.width; break;
		}
		switch(_group.valign){
			case fa_middle: _group_yoffset = -_group.height/2; break;
			case fa_bottom: _group_yoffset = -_group.height; break;
		}
		
		//get the element x and y
		var _x = _element.x;
		var _y = _element.y;
		var t_x = 0;
		var t_y = 0;
		
		//if string, position is percentage, so convert
		if (is_string(_x)){
			t_x =  (_group_t_x + _group.width * (real(_x) / 100)) + _group_xoffset;	
		} else{
			t_x = (_group_t_x + _x) + _group_xoffset;	
		}
		if (is_string(_y)){
			t_y = (_group_t_y + _group.height * (real(_y) / 100)) + _group_yoffset;	
		} else{
			t_y = (_group_t_y + _y) + _group_yoffset;	
		}
		
		return {x: t_x, y: t_y};
	}
	
	///@Description create supplied element.
	///@param pageName Page name.
	///@param groupName.
	///@param element pxlui element.
	///@param _layer layer to create it on.
	function load_element(pageName, _group, _element, _layer){
		var _pos = calculate_position(_group, _element);
		
		//create the instance
		var inst = instance_create_layer(_pos.x, _pos.y,_layer, oPXLUIHandler, {element: _element});
		inst.element.__.inst_id = inst;
		inst.element.__.page = pageName;
		inst.element.__.group = _group.__.elementid;
		inst.element.__.cursor_instance = cursor_instance;
		inst.element.__.player_index = player_index;
		inst.element.__.layer_id = _layer;
		
		//give the instance a reference to this system
		inst.element.__.pxlui = self;
		
		inst.element.initialize();
	}
	
	///@description Add a page to PXLUI populated with the elements supplied
	///@param pageName Page name.
	///@param pageArray Array of UI elements.
	///@param [_layer] Layer to apply the UI elements to.
	///@param [_depth] Depth of the layer.
	function add_page(pageName, pageArray, _layer = "PXLUI_Layer", _depth = PXLUI_DEPTH_MIDDLE){
		//add a page to the book
		uiBook.pages[$ pageName] = array_reverse(pageArray); //reverse array for correct rendering order
		uiBook.layers[$ pageName] = [_depth,_layer];
	}
	
	///@description Delete a page from PXLUI
	///@param pageName Page Name
	function delete_page(pageName){
		//delete a page from the book
		variable_struct_remove(uiBook.pages,pageName);
	}
		
	function add_group(groupName, _groupArray, _config = {}){
		//add a group to the book
		var _w = _config[$ "width"] ?? PXLUI_UI_W;
		var _h = _config[$ "height"] ?? PXLUI_UI_H;
		var _halign = _config[$ "halign"] ?? fa_left;
		var _valign = _config[$ "valign"] ?? fa_top;
		var _sprite = _config[$ "sprite_index"] ?? -1;
		var _struct = {
			name: groupName,
			x: 0,
			y: 0,
			width: _w,
			height: _h,
			halign: _halign,
			valign: _valign,
			sprite_index: _sprite,
			array: array_reverse(_groupArray) //reverse array for correct rendering order
		}	
		
		uiBook.groups[$ groupName] = _struct; 
		
		return uiBook.groups[$ groupName];
	}
		
	function load_group(pageName,group,__layer){
		var _elements = group.array;
		
		var _group_x = group.x;
		var _group_y = group.y;
		
		var _group_t_x = 0;
		var _group_t_y = 0;
		//if string, position is percentage, so convert
		if (is_string(_group_x)){
			_group_t_x = window_get_width() * (real(_group_x) / 100);	
		} else{
			_group_t_x = _group_x;	
		}
		if (is_string(_group_y)){
			_group_t_y = window_get_height() * (real(_group_y) / 100);	
		} else{
			_group_t_y = _group_y;	
		}
	
		
		var inst = instance_create_layer(_group_t_x, _group_t_y,__layer, oPXLUIHandler, {element: group});
		inst.element.__.inst_id = inst;
		inst.element.__.page = pageName;
		inst.element.__.group = group.__.elementid;
		inst.element.__.cursor_instance = cursor_instance;
		inst.element.__.player_index = player_index;
		inst.element.__.layer_id = __layer;
		
		//give the instance a reference to this system
		inst.element.__.pxlui = self;
		
		inst.element.initialize();
		for(var j = 0; j < array_length(_elements); j++) {
			var _element = _elements[j];
			load_element(pageName, group, _element, __layer);
		}
	}
	
	///@description This creates a renderer for PXLUI assigned to the layer specified.
	///@param _layer Layer to draw on renderer's surface.
	function render(_layer){
		var _layerName = layer_get_name(_layer);
		
		layerId = _layer;
		if (!instance_exists(oPXLUIRenderer)){
			var _inst = instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,oPXLUIRenderer,{layerId: _layer});
			if (uiBook.customRender[$ _layerName] != undefined){
				_inst.element.drawGUI = uiBook.customRender[$ _layerName];
			}
		} else{
			var _exists = false;
			with(oPXLUIRenderer){
				if (layerId = _layer){
					_exists = true;
				}
			}
			if (!_exists){
				var _inst = instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,oPXLUIRenderer,{layerId: _layer});
				if (uiBook.customRender[$ _layerName] != undefined){
					_inst.element.drawGUI = uiBook.customRender[$ _layerName];
				}
			}
		}
		
		if (!instance_exists(cursor_instance)){
			instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,cursor_instance);
		}
	}
	
	///@description This destroys all renderers safely
	function unrender(){
		oPXLUIRenderer.graceful_destroy = true;
	}
	
	///@description This destroys all UI elements and renderers safely.
	function destroy(){
		instance_destroy(oPXLUIHandler);
		unrender();
	}
	
	///@description This destroys the specified renderer safely
	function destroy_render(layerName){
		var _layerId = layer_get_id(layerName);
		if (_layerId != -1){
			with(oPXLUIRenderer){
				if(layerId = _layerId){
					graceful_destroy = true;
				}
			}
		}
	}
	
	///@description Customize the way PXLUI renders, don't forget to add pxlui_draw_elements(); to make sure it draws the elements
	///@param _layerName Layer to customize drawing
	///@param _draw function that replaces renderer's drawGUI
	function custom_render(_layerName,_draw){
		uiBook.customRender[$ _layerName] = _draw;
	}
	
	///@description Load specified page
	///@param pageName Page name
	function load_page(pageName){
		var _page = uiBook.pages[$ pageName];
		var _layer = uiBook.layers[$ pageName];
		var __layer;
		
		//check if page exists
		if (!is_undefined(_page)) {
			//check if layer for page exists
			if (!layer_exists(_layer[1])){
				__layer = layer_create(_layer[0],_layer[1]);
			} else{
				__layer = layer_get_id(_layer[1]);
			}
			
			//load elements with a for loop
			for(var i = 0; i < array_length(_page); i++) {
				var _group = _page[i];
				load_group(pageName,_group,__layer);
			}
			render(__layer);
		}
		
		pxlui_log($"PXLUI: Loaded page {pageName}");
	}
	
	///@description unload specified page
	///@param _pageName Page name
	function unload_page(_pageName){
		currentInteractable = -1;

		with(oPXLUIHandler){
			if (element.get_page() = _pageName){
				instance_destroy();	
			}
		}
	}
	
	///@description reload specified page
	///@param _pageName Page name
	function reload_page(pageName){
		unload_page(pageName);
		load_page(pageName);
	}
	
	///@description Step function for PXLUI, put this in the step event for the ui to work properly!
	step = function(){
		with(cursor_instance){
			with(oPXLUIHandler){
				if (variable_instance_exists(element,"is_cursor_in")){
					if (element.is_cursor_in()){
						element.__.hover = true;

						if (input_check_pressed(PXLUI_UI_BUTTON,element.__.player_index)){
							element.__.pressed = true;
						}
						if (input_check(PXLUI_UI_BUTTON,element.__.player_index)){
							element.__.held = true;	
						}
					}
				}
			}
		}
		
		if (input_check_repeat(PXLUI_UI_UP,player_index)){
			//find the nearest interactable from the cursor
			
			with(oPXLUIHandler){
				if (element.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_instance.yGui > element.y + PXLUI_NAV_PADDING){
						if (element.y != other.currentInteractable.element.y || other.currentInteractable = -1){
							var _x = element.x;
							var _y = element.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_instance.xGui, other.cursor_instance.yGui, _x, _y));
						}
					}
				}
			}
			update_cursor = true;
		}
		
		if (input_check_repeat(PXLUI_UI_DOWN,player_index)){
			//find the nearest interactable from the cursor
			
			with(oPXLUIHandler){
				if (element.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_instance.yGui < element.y - PXLUI_NAV_PADDING){
						if (element.y != other.currentInteractable.element.y || other.currentInteractable = -1){
							var _x = element.x;
							var _y = element.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_instance.xGui, other.cursor_instance.yGui, _x, _y));
						}
					}
				}
			}
			
			update_cursor = true;
		}
		
		if (input_check_repeat(PXLUI_UI_LEFT,player_index)){
			//find the nearest interactable from the cursor
			
			with(oPXLUIHandler){
				if (element.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_instance.xGui > element.x + PXLUI_NAV_PADDING){
						if (element.x != other.currentInteractable.element.x || other.currentInteractable = -1){
							var _x = element.x;
							var _y = element.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_instance.xGui, other.cursor_instance.yGui, _x, _y));
						}
					}
				}
			}
			update_cursor = true;
		}
		
		if (input_check_repeat(PXLUI_UI_RIGHT,player_index)){
			//find the nearest interactable from the cursor

			with(oPXLUIHandler){
				if (element.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_instance.xGui <  id.x - PXLUI_NAV_PADDING){
						if (element.x != other.currentInteractable.element.x || other.currentInteractable = -1){
							var _x = element.x;
							var _y = element.y;

							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_instance.xGui, other.cursor_instance.yGui, _x, _y));
						}
					}
				}
			}
			update_cursor = true;
		}
		
		if (update_cursor){
			if (!ds_priority_empty(uiPriority)){
				var _nearest = ds_priority_find_min(uiPriority);
				var _x = -1, _y = -1;
				switch(_nearest.object_index){
					default:
						var _ex = _nearest.element.x;
						var _ey = _nearest.element.y;
						
						var _x1 = _ex+_nearest.element.collision.x1;
						var _x2 = _ex+_nearest.element.collision.x2;
						
						var _y1 = _ey+_nearest.element.collision.y1;
						var _y2 = _ey+_nearest.element.collision.y2;
						
						var x_center = (_x1 + _x2) / 2;
						var y_center = (_y1 + _y2) / 2;
						
						_x = x_center;
						_y = y_center;
					break;
				}
				
				if (_x != -1 && _y != -1){
					window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
					input_cursor_set(_x,_y);
					currentInteractable = _nearest;
				}
			}
			ds_priority_clear(uiPriority);	
			update_cursor = false;
		}
	}
}