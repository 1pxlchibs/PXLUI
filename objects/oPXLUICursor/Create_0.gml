depth = PXLUI_DEPTH_TOP;

input_source_mode_set(INPUT_SOURCE_MODE.HOTSWAP);
input_cursor_coord_space_set(INPUT_COORD_SPACE.GUI);

input_cursor_set(global.pxlui_settings.UIResW/2, global.pxlui_settings.UIResH/2);
input_cursor_speed_set(20);

x = input_cursor_x();
y = input_cursor_y();

xGui = 0;
yGui = 0;

event_user(15);