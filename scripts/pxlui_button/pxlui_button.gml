///@Description PXLUI Button. Text will automatically adjust the width and height of the button.
///@param x x position on the GUI layer, can be percentage if in string.
///@param y x position on the GUI layer, can be percentage if in string.
///@param text String to apply on button.
///@param [width] Width of the button.
///@param [height] Height of the button.
///@param [halign] Horizontal alignment of the button.
///@param [valign] Vertical alignment of the button.
///@param [callback] Function to execute on button activation.
///@param [elementid] Identifier for use in element referencing.
function pxlui_button(x, y, text, width = -1, height = -1, halign = fa_middle, valign = fa_middle, callback = function(){}, elementid = 0){
	return {
		object: oPXLUIButton,
		xx : x,
		yy : y,
		
		text: text,
		
		width: width,
		height: height,
		
		halign: halign,
		valign: valign,
		
		callback: callback,
		elementid: elementid
	};
}