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
	
	cursor_inst = -1;
	update_cursor = false; //cursor update bool
	if (instance_exists(oPXLUICursor)){
		with(oPXLUICursor){
			if (player_index == _player_index){
				other.cursor_inst = id;	
			}
		}
	}
	if (cursor_inst == -1){
		cursor_inst = instance_create_depth(0,0,-9999,oPXLUICursor,{player_index: _player_index});
	}
	
	//Staggered page loading
	loading_page = -1;
	loading_page_delay = -1;
	loading_page_delay_length = -1;
	loading_page_increment = 0;
	loading_pageName = "";
	loading_pageLayer = -1;
	
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
	
	///@Description create supplied element.
	///@param pageName Page name.
	///@param groupName.
	///@param element pxlui element.
	///@param _layer layer to create it on.
	function load_element(pageName, _group, _element, _layer){
		//get the group x and y
		var _group_x = _group.x;
		var _group_y = _group.y;
		var _group_t_x = 0;
		var _group_t_y = 0;
		
		//if string, position is percentage, so convert
		if (is_string(_group_x)){
			_group_t_x = PXLUI_UI_W * (real(_group_x) / 100);	
		} else{
			_group_t_x = _group_x;	
		}
		if (is_string(_group_y)){
			_group_t_y = PXLUI_UI_H * (real(_group_y) / 100);	
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
			t_x = (_group_t_x + _x) - _group_xoffset;	
		}
		if (is_string(_y)){
			t_y = (_group_t_y + _group.height * (real(_y) / 100)) + _group_yoffset;	
		} else{
			t_y = (_group_t_y + _y) - _group_yoffset;	
		}
		
		//create the instance
		var inst = instance_create_layer(t_x, t_y,_layer, oPXLUIHandler, {element: _element});
		inst.element.__.inst_id = inst;
		inst.element.__.page = pageName;
		inst.element.__.group = _group.name;
		inst.element.__.cursor_inst = cursor_inst;
		inst.element.__.player_index = player_index;
		inst.element.__.layer_id = _layer;
		
		inst.element.initialize();
		
		//give the instance a reference to this system
		inst.element.__.pxlui = self;
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
		
	function add_group(groupName, _x, _y, _groupArray, _config = {}){
		//add a group to the book
		var _w = _config[$ "width"] ?? PXLUI_UI_W;
		var _h = _config[$ "height"] ?? PXLUI_UI_H;
		var _halign = _config[$ "halign"] ?? fa_left;
		var _valign = _config[$ "valign"] ?? fa_top;
		var _struct = {
			name: groupName,
			x: _x,
			y: _y,
			width: _w,
			height: _h,
			halign: _halign,
			valign: _valign,
			array: array_reverse(_groupArray),
		}	
		uiBook.groups[$ groupName] = _struct; //reverse array for correct rendering order
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
		
		if (!instance_exists(cursor_inst)){
			instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,cursor_inst);
		}
	}
	
	///@description This destroys all renderers safely
	function unrender(){
		oPXLUIRenderer.graceful_destroy = true;
	}
	
	///@description This destroys all UI elements and renderers safely.
	function destroy(){
		instance_destroy(pPXLUIElement);
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
		
		if (!is_undefined(_page)) {
			if (!layer_exists(_layer[1])){
				__layer = layer_create(_layer[0],_layer[1]);
			} else{
				__layer = layer_get_id(_layer[1]);
			}
			
			for(var i = 0; i < array_length(_page); i++) {
				var _group = uiBook.groups[$ _page[i]];
				var _elements = _group.array;
				for(var j = 0; j < array_length(_elements); j++) {
					var _element = _elements[j];
					load_element(pageName, _group, _element, __layer);
				}
				
			}
			render(__layer);
		}
		
		pxlui_log($"PXLUI: Loaded page {pageName}");
	}
	
	///@description Load specified page using a staggered effect
	///@param pageName Page name
	///@param time in steps between each element creation
	function load_page_delay(pageName, _delay){
		var _page = uiBook.pages[$ pageName];
		var _layer = uiBook.layers[$ pageName];

		loading_page = _page;
		loading_page_delay = _delay;
		loading_page_delay_length = _delay;
		loading_pageName = pageName;
		
		if (!layer_exists(_layer[1])){
			loading_pageLayer = layer_create(_layer[0],_layer[1]);
		} else{
			loading_pageLayer = layer_get_id(_layer[1]);
		}
		
		render(loading_pageLayer);
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
		with(cursor_inst){
			with(oPXLUIHandler){
				if (variable_instance_exists(element,"is_cursor_in")){
					if (element.is_cursor_in()){
						element.__.hover = true;
			
						if (input_check_pressed("shoot",element.__.player_index)){
							element.__.pressed = true;
						}
						if (input_check("shoot",element.__.player_index)){
							element.__.held = true;	
						}
						//array_push(element_pos,id);
					}
				}
			}
		}
		
		if (input_check_repeat("up",player_index,,1)){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.VERTICAL){
							if (array_length(children) != 0){
								if (currentElement > 0){
									currentElement--;
								
									if (children[currentElement].y+y <= y){
										offset.y += children[currentElement].height+padding[1];
										refresh(id);
									
										exit;
									}
								
									var _x, _y;
									_x = children[currentElement].x+x;
									_y = children[currentElement].y+y;
		
									window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
									input_cursor_set(_x,_y);
						
									exit;
								}
							}
						}
					}
				}
			}
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_inst.yGui > id.y + PXLUI_NAV_PADDING){
						if (id.y != other.currentInteractable.y || other.currentInteractable = -1){
							var _x = id.x;
							var _y = id.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_inst.xGui, other.cursor_inst.yGui, _x, _y));
						}
					}
				}
			}
			update_cursor = true;
		}
		
		if (input_check_repeat("down",player_index,,1)){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.VERTICAL){
							if (array_length(children) != 0){
								if (currentElement < array_length(children)-1){
									currentElement++;
								
									if (children[currentElement].y+y >= y+height){
										offset.y -= children[currentElement].height+padding[1];
										refresh(id);
									
										exit;
									}
								
									var _x, _y;
									_x = children[currentElement].x+x;
									_y = children[currentElement].y+y;
		
									window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
									input_cursor_set(_x,_y);
						
									exit;
								}
							}
						}
					}
				}
			}
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_inst.yGui < id.y - PXLUI_NAV_PADDING){
						if (id.y != other.currentInteractable.y || other.currentInteractable = -1){
							var _x = id.x;
							var _y = id.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_inst.xGui, other.cursor_inst.yGui, _x, _y));
						}
					}
				}
			}
			
			update_cursor = true;
		}
		
		if (input_check_repeat("left",player_index,,1)){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUISlider) return;
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.HORIZONTAL){
							if (array_length(children) != 0){
								if (currentElement > 0){
									currentElement--;
								
									if (children[currentElement].x+x <= x){
										offset.x += children[currentElement].width+padding[0];
										refresh(id);
									
										exit;
									}
								
									var _x, _y;
									_x = children[currentElement].x+x;
									_y = children[currentElement].y+y;
		
									window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
									input_cursor_set(_x,_y);
						
									exit;
								}
							}
						}
					}
				}
			}
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_inst.xGui > id.x + PXLUI_NAV_PADDING){
						if (id.x != other.currentInteractable.x || other.currentInteractable = -1){
							var _x = id.x;
							var _y = id.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_inst.xGui, other.cursor_inst.yGui, _x, _y));
						}
					}
				}
			}
			update_cursor = true;
		}
		
		if (input_check_repeat("right",player_index,,1)){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUISlider) return;
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.HORIZONTAL){
							if (array_length(children) != 0){
								if (currentElement < array_length(children)-1){
									currentElement++;
								
									if (children[currentElement].x+x >= x+width){
										offset.x-= children[currentElement].width+padding[0];
										refresh(id);
									
										exit;
									}
								
									var _x, _y;
									_x = children[currentElement].x+x;
									_y = children[currentElement].y+y;
		
									window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
									input_cursor_set(_x,_y);
						
									exit;
								}
							}
						}
					}
				}
			}
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (other.cursor_inst.xGui <  id.x - PXLUI_NAV_PADDING){
						if (id.x != other.currentInteractable.x || other.currentInteractable = -1){
							var _x = id.x;
							var _y = id.y;
							//if (other.currentInteractable != -1){
							//	_x = other.currentInteractable.x;
							//	_y = other.currentInteractable.y;
							//}
							ds_priority_add(other.uiPriority, id, point_distance(other.cursor_inst.xGui, other.cursor_inst.yGui, _x, _y));
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
					case oPXLUISlider:
						_x = _nearest.id.x+_nearest.id.xalign+_nearest.id.width/2;
						_y = _nearest.id.y+_nearest.id.yalign+_nearest.id.height/2;
					break;
					
					case oPXLUIScrollView:
						if (array_length(_nearest.children) != 0){
							_x = _nearest.children[_nearest.currentElement].x+_nearest.x;
							_y = _nearest.children[_nearest.currentElement].y+_nearest.y;
						}
					break;
					
					case oPXLUICard:
						_x = _nearest.id.x;
						_y = _nearest.id.y;
					break;
					
					case oPXLUISlot:
						_x = _nearest.id.x;
						_y = _nearest.id.y;
					break;
					
					default:
						_x = _nearest.id.x+_nearest.id.xalign;
						_y = _nearest.id.y+_nearest.id.yalign;
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
			
		if (loading_page != -1){
			loading_page_delay--;
			
			if (loading_page_delay < 0){
				var _element = loading_page[loading_page_increment];
				load_element(loading_pageName, _element, loading_pageLayer);
				
				loading_page_increment++;
				loading_page_delay = loading_page_delay_length;
				
				if (loading_page_increment > array_length(loading_page)-1){
					loading_page = -1;
					loading_page_delay = -1;
					loading_page_delay_length = -1;
					
					loading_page_increment = 0;
					loading_pageName = "";
				}
			}
		}
	}
}