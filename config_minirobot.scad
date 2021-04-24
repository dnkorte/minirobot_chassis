
/*
 * ******************************************************************
 * basic box construction parameters, rarely changed 
 * ******************************************************************
 */

// mm clearance between inner wall of box bottom and outer edge of lid lip
lid_clearance=0.4;  

// thickness of lip in mm (width of its "wall")
lid_lip_thickness = 2;

// height of lip in mm
lid_lip_height = 6; 

// thickness of lid in mm
lid_thickness = 3;   

// thickness of body wall in mm
body_wall_thickness = 2.4; 

// bottom usually same as wall, but may be different
body_bottom_thickness = body_wall_thickness; 

// radius of inside corners on box (1=rectangular inside; default (box_corner_radius-2)
box_corner_inner_radius = box_corner_radius - 2; 

// radius of outside corners on lip on the lid; default (box_corner_inner_radius)
lip_corner_radius = box_corner_inner_radius;  

// this controls the calculated gap between caster and ground if the box is balanced horizontal
// the gap helps the keep the caster from dragging all the time, and from getting stuck when
// it encounters small obstacles
caster_to_ground_gap = 2; 

// this variable decides if holes are generated in the back of box if motor would extend outside
allow_motors_to_extend_out_back_of_box = true;
/*
 * ***********************************************************************
 * basic user preference parameters (3d printer specific), rarely changed 
 * ***********************************************************************
 */

// depth of screw/TI hole below component base (typically used to allow extra
// room for the screw to pass into or through the box bottom or lid panel; default 4)
mount_hole_extra_depth = 4;

// parameters for holes that will be "self-tapped" by screws
// these may be fine-tuned for your printer
screwhole_radius_M30_passthru = 2;  
screwhole_radius_M30_selftap = 1.40;  
screwhole_radius_M25_passthru = 1.8;  
screwhole_radius_M25_selftap = 1.1; 
screwhole_radius_M20_passthru = 2;  
screwhole_radius_M20_selftap = 1.0;   

// parameters for threaded insert mount (M3; McMaster-Carr)
// note if TI_30_use_threaded_insert == false then self-tap holes are generated
TI30_use_threaded_insert = false;
TI30_mount_diameter = 7;
TI30_through_hole_diameter = 4.3;  
TI30_default_height = 6.0;

// parameters for threaded insert mount (M2.5; Amazon)
// note if TI_25_use_threaded_insert == false then self-tap holes are generated
TI25_use_threaded_insert = false;
TI25_mount_diameter = 7;
TI25_through_hole_diameter = 4.2;  
TI25_default_height = 6.0;

// parameters for threaded insert mount (M2; McMaster-Carr)
// note if TI_20_use_threaded_insert == false then self-tap holes are generated
TI20_use_threaded_insert = true;
TI20_mount_diameter = 6;
TI20_through_hole_diameter = 3.7; 
TI20_default_height = 6.0; 

