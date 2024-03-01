depth = PXLUI_DEPTH_TOP;

input_cursor_coord_space_set(INPUT_COORD_SPACE.GUI);

input_cursor_set(PXLUI_UI_W/2, PXLUI_UI_H/2);
input_cursor_speed_set(20);
window_set_cursor(cr_none);

x = input_cursor_x();
y = input_cursor_y();

xGui = 0;
yGui = 0;

xscale = 3;
yscale = 3;
xscale_lerp = 3;
yscale_lerp = 3;

cursor_player = -1;
