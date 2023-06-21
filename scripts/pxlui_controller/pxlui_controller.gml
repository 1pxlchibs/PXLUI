// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pxlui_create() constructor{
	//Create a struct for the ui controller, this will hold the pages.
	uiBook = {};

	uiBook.pages = {}; //pages where all ui elements are stored [arrays]
	uiBook.layers = {}; //layer info for each page [arrays]
	uiBook.customRender = {}; //layer custom render [function]
	
	uiPriority = ds_priority_create(); //ds_priority for keyboard/gamepad navigation
	currentInteractable = -1; //stores id of current ui element selected
	update_cursor = false; //cursor update bool
	
	//Staggered page loading
	loading_page = -1;
	loading_page_delay = -1;
	loading_page_delay_length = -1;
	loading_page_increment = 0;
	loading_pageName = "";
	loading_pageLayer = -1;
	
	///@Description find an element using it's element ID, returns the instance id.
	///@param elementid Element ID.
	function find(elementid){
		with(pPXLUIElement){
			if (id.elementid == elementid){
				return id;
			}
		}
	}
	
	///@Description create supplied element.
	///@param pageName Page name.
	///@param element pxlui element.
	///@param _layer layer to create it on.
	function load_element(pageName, element, _layer){
		//get the x and y
		var t_x = element.xx;
		var t_y = element.yy;
		
		//if string, position is percentage, so convert
		if (is_string(element.xx)){
			t_x = global.pxlui_settings.UIResW * (element.xx / 100);	
		}
		if (is_string(element.yy)){
			t_y = global.pxlui_settings.UIResH * (element.yy / 100);	
		}
		
		//If element has these variables, override the default ones.
		var _drawGUI = -1, _step = -1;
		if (variable_struct_exists(element,"drawGUI")){
			_drawGUI = element.drawGUI;	
		}
		if (variable_struct_exists(element,"step")){
			_step = element.step;	
		}
		
		//creat the instance
		var inst = instance_create_layer(t_x, t_y,_layer, element.object, element);
		with(inst){
			create(pageName, inst);	
			
			if (_drawGUI != -1){
				drawGUI = _drawGUI;	
			}
			if (_step != -1){
				step = _step;	
			}
			if (variable_struct_exists(element,"interactable")){
				interactable = element.interactable;	
			}
		}
		//give the instance a reference to this system
		inst.pxlui = self;
	}
	
	///@description Add a page to PXLUI populated with the elements supplied
	///@param pageName Page name.
	///@param pageArray Array of UI elements.
	///@param [_layer] Layer to apply the UI elements to.
	///@param [_depth] Depth of the layer.
	function add_page(pageName, pageArray, _layer = "PXLUI_Layer", _depth = PXLUI_DEPTH_MIDDLE){
		//add a page to the book
		uiBook.pages[$ pageName] = pageArray;
		uiBook.layers[$ pageName] = [_depth,_layer];
	}
	
	///@description Delete a page from PXLUI
	///@param pageName Page Name
	function delete_page(pageName){
		//delete a page from the book
		variable_struct_remove(uiBook.pages,pageName);
	}
	
	///@description This creates a renderer for PXLUI assigned to the layer specified.
	///@param _layer Layer to draw on renderer's surface.
	function render(_layer){
		var _layerName = layer_get_name(_layer);
			
		if (!instance_exists(oPXLUIRenderer)){
			var _inst = instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,oPXLUIRenderer,{layerId: _layer});
			if (uiBook.customRender[$ _layerName] != undefined){
				_inst.pxlui_drawGUI = uiBook.customRender[$ _layerName];
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
					_inst.pxlui_drawGUI = uiBook.customRender[$ _layerName];
				}
			}
		}
		
		if (!instance_exists(oPXLUICursor)){
			instance_create_depth(0,0,PXLUI_DEPTH_MIDDLE,oPXLUICursor);
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
				var element = _page[i];
				load_element(pageName, element, __layer);
			}
		}
		
		render(__layer,pageName);
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

		with(pPXLUIElement){
			if (id.page = _pageName){
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
	function step(){
		if (PXLUI_UP){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.VERTICAL){
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
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (oPXLUICursor.yGui > id.y + PXLUI_NAV_PADDING){
						ds_priority_add(other.uiPriority,id,distance_to_point(oPXLUICursor.xGui,oPXLUICursor.yGui));
					}
				}
			}
			update_cursor = true;
		}
		
		if (PXLUI_DOWN){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.VERTICAL){
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
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (oPXLUICursor.yGui < id.y - PXLUI_NAV_PADDING){
						ds_priority_add(other.uiPriority,id,distance_to_point(oPXLUICursor.xGui,oPXLUICursor.yGui));
					}
				}
			}
			
			update_cursor = true;
		}
		
		if (PXLUI_LEFT){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUISlider) return;
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.HORIZONTAL){
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
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (oPXLUICursor.xGui > id.x + PXLUI_NAV_PADDING){
						ds_priority_add(other.uiPriority,id,distance_to_point(oPXLUICursor.xGui,oPXLUICursor.yGui));
					}
				}
			}
			update_cursor = true;
		}
		
		if (PXLUI_RIGHT){
			//find the nearest interactable from the cursor
			if (currentInteractable != -1){
				if (currentInteractable.object_index = oPXLUIInputField){
					if (currentInteractable.type) return;
				}
				
				if (currentInteractable.object_index = oPXLUISlider) return;
				
				if (currentInteractable.object_index = oPXLUIScrollView){
					with(currentInteractable){
						if (layout = PXLUI_ORIENTATION.HORIZONTAL){
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
			
			with(pPXLUIElement){
				if (id.interactable && id.visible && id != other.currentInteractable){
					if (oPXLUICursor.xGui < id.x - PXLUI_NAV_PADDING){
						ds_priority_add(other.uiPriority,id,distance_to_point(oPXLUICursor.xGui,oPXLUICursor.yGui));
					}
				}
			}
			update_cursor = true;
		}
		
		if (update_cursor){
			if (!ds_priority_empty(uiPriority)){
				var _nearest = ds_priority_find_min(uiPriority);
				var _x, _y;
				switch(_nearest.object_index){
					case oPXLUISlider:
						_x = _nearest.id.x+_nearest.id.xalign+_nearest.id.width/2;
						_y = _nearest.id.y+_nearest.id.yalign+_nearest.id.height/2;
					break;
					
					case oPXLUIScrollView:
						_x = _nearest.children[_nearest.currentElement].x+_nearest.x;
						_y = _nearest.children[_nearest.currentElement].y+_nearest.y;
					break;
					
					default:
						_x = _nearest.id.x+_nearest.id.xalign;
						_y = _nearest.id.y+_nearest.id.yalign;
					break;
				}
				
				window_mouse_set(_x*pxlui_get_gui_xscale(),_y*pxlui_get_gui_yscale());
				input_cursor_set(_x,_y);
				currentInteractable = _nearest;
			}
			ds_priority_clear(uiPriority);	
			update_cursor = false;
		}
			
		if (loading_page != -1){
			loading_page_delay--;
			
			if (loading_page_delay < 0){
				var element = loading_page[loading_page_increment];
				load_element(loading_pageName, element, loading_pageLayer);
				
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