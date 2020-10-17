/*
 * Module: minirobot_core.scad  holds core modules for minirobot case maker
 * 
 * note all "components" are designed such that the initial component is 
 *  centered on the origin in the xy plane with the surface that would strike
 *  the "outside" of the box lowermost and at Z=0. (moving "up" in original
 *  orientation represents motion "into" the box
 *
 * the matching "place" functions translate and rotate them as necessary to 
 *  put them where they belong.  
 *  (right hand rule [0, -90, 0] rotates component for back (right side of render) panel
 *  (right hand rule [0, +90, 0] rotates component for cront (left side of render) panel
 *
 * each component and place function should have a "add" mode and a "holes" mode
 *  parameter and it generates appropriate bodies per the call.  in the "add" mode
 *  the place functions should also generate a visualization body if the 
 *  "show_internal_parts_for_collision_check" flag is true.
 * note that the mainline program should call each place function twice -- once
 *  for "holes" mode and once for "add" mode
 
 *
 * Author(s): Don Korte
 *
 * github: https://github.com/dnkorte/minirobot_chassis.git
 *  
 * MIT License
 * 
 * Copyright (c) 2020 Don Korte
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */



/*
 * this generates a box with rounded corners
 * the box is centered on the origin, running "up" from z=0
 * reference: https://hackaday.com/2018/02/13/openscad-tieing-it-together-with-hull/
 */
module roundedbox(x, y, radius=3, height=3) {
    left_x = -(x/2) + radius;
    right_x = (x/2) - radius;
    bottom_y = -(y/2) + radius;
    top_y = +(y/2) - radius;
    
    points = [ [left_x, bottom_y,0], [left_x, top_y,0], [right_x, top_y,0], [right_x, bottom_y,0] ]; 
    hull() {
        for (p=points) {
            translate(p) cylinder(r=radius, h=height);
        }
    }
}

module lip() {
    lip_box_length = box_length - (2 * (body_wall_thickness + lid_clearance));
    lip_box_width = box_width - (2 * (body_wall_thickness + lid_clearance));
    lip_inner_x = lip_box_length - (2 * lid_lip_thickness);
    lip_inner_y = lip_box_width - (2 * lid_lip_thickness);
    TI30_mount_radius = TI30_mount_diameter / 2;
    
    // calculate potential positions for the mount holes
    locY_ctr = 0;
    locX_ctr = 0;
  
    union() {
        difference() {
            // create the basic lip
            roundedbox(lip_box_length, lip_box_width, lip_corner_radius, use_lid_lip_height);
            roundedbox(lip_inner_x, lip_inner_y, lip_corner_radius-2, use_lid_lip_height+1);
            
            // cut holes in lip for threaded insert mounts to go into (y side)
            // note that we make the radius slightly smaller than the mount to avoid non-manifold errors
            translate([ -(lip_box_length/2)-1,locY_ctr, mount_center_offset_from_boxtop]) rotate([0,90,0]) 
                cylinder(r=(TI30_mount_radius - 0.1), h=(lip_box_length+2));
            
            // cut holes in lip for threaded insert mounts to go into (x side)
            // note that we make the radius slightly smaller than the mount to avoid non-manifold errors
            translate([locX_ctr, -(lip_box_width/2)-1, mount_center_offset_from_boxtop]) rotate([270,0,0])
                cylinder(r=(TI30_mount_radius - 0.1), h=(lip_box_width+2));
        }
        
        // now put in the threaded insert mounts (x side; front/back)
        translate([ -(lip_box_length/2), locY_ctr, mount_center_offset_from_boxtop]) rotate([0,90,0]) 
            TI30_mount();
        translate([ +(lip_box_length/2), locY_ctr, mount_center_offset_from_boxtop]) rotate([0,270,0]) 
            TI30_mount();
        
        // now put in the threaded insert mounts (y side; L/R)
        translate([locX_ctr, +(lip_box_width/2), mount_center_offset_from_boxtop]) rotate([90,0,0])
            TI30_mount();
        translate([locX_ctr, -(lip_box_width/2), mount_center_offset_from_boxtop]) rotate([270,0,0])
            TI30_mount();
    }
}

// this makes a mount for a threaded insert M3 
module TI30_mount(mount_height = TI30_default_height) {
    
    if (TI30_use_threaded_insert) {
        difference() {
            cylinder(r=((TI30_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=(TI30_through_hole_diameter / 2), h=mount_height); 
        }
    } else {
        difference() {
            cylinder(r=((TI30_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=screwhole_radius_M30_selftap, h=mount_height); 
        }
    } 
}

// this makes a mount for a threaded insert M2 
module TI20_mount(mount_height = TI20_default_height) {
    
    if (TI20_use_threaded_insert) {
        difference() {
            cylinder(r=((TI20_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=(TI20_through_hole_diameter / 2), h=mount_height); 
        }
    } else {
        difference() {
            cylinder(r=((TI20_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=screwhole_radius_M20_selftap, h=mount_height); 
        }
    } 
}


// this makes a mount for a threaded insert M2.5 
module TI25_mount(mount_height = TI25_default_height) {
    
    if (TI25_use_threaded_insert) {
        difference() {
            cylinder(r=((TI25_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=(TI25_through_hole_diameter / 2), h=mount_height); 
        }
    } else {
        difference() {
            cylinder(r=((TI25_mount_diameter / 2) + 0.05), h=mount_height);
            cylinder(r=screwhole_radius_M25_selftap, h=mount_height); 
        }
    } 
}

// this makes a smaller diameter support mount equiv to the above mounts but no screw 
// the mount stud is 5mm in diameter (supports boards without bumping into bottom solder/etc)
module support_stud(mount_height = TI30_default_height) {
    cylinder(r=(5 / 2), h=mount_height);
}


/*
 * ***************************************************************************
 * this makes a base for red tindie protoboard (small;  50 x 26mm)
 * its base is 1mm thick, and 52 x 28 mm
 * it has 4 M3 threaded insert mounts 43mm x 20.5mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.tindie.com/products/DrAzzy/1x2-prototyping-board/
 * ***************************************************************************
 */
board_redproto_length = 52;
board_redproto_width = 28;
vis_redproto_length = 50;
vis_redproto_width = 26;
board_redproto_screw_x = 43;
board_redproto_screw_y = 20.5;

module component_small_red_protoboard() {
    roundedbox(board_redproto_length, board_redproto_width, 2, 1);
    
    translate([ -(board_redproto_screw_x/2), -(board_redproto_screw_y/2), 1]) TI30_mount(); 
    translate([ -(board_redproto_screw_x/2), +(board_redproto_screw_y/2), 1]) TI30_mount();
    translate([ +(board_redproto_screw_x/2), -(board_redproto_screw_y/2), 1]) TI30_mount();
    translate([ +(board_redproto_screw_x/2), +(board_redproto_screw_y/2), 1]) TI30_mount(); 
       
    translate([0, 0, 0]) linear_extrude(2) text("Red Proto", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(vis_redproto_length, vis_redproto_width, 2, 1);
    }
}

/*
 * ********************************************************************************
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/1214
 * ********************************************************************************
 */
board_smallmintproto_length = 54;
board_smallmintproto_width = 33;
board_smallmintproto_screw_x = 45.5;
board_smallmintproto_screw_y = 25.4;

module component_small_smallmint_protoboard() {
    roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
    
    translate([ -(board_smallmintproto_screw_x/2), -(board_smallmintproto_screw_y/2), 1]) TI30_mount(); 
    translate([ -(board_smallmintproto_screw_x/2), +(board_smallmintproto_screw_y/2), 1]) TI30_mount();
    translate([ +(board_smallmintproto_screw_x/2), -(board_smallmintproto_screw_y/2), 1]) TI30_mount();
    translate([ +(board_smallmintproto_screw_x/2), +(board_smallmintproto_screw_y/2), 1]) TI30_mount(); 
    
    translate([0, 0, 0]) linear_extrude(2) text("Small Mint", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
    }
}


/*
 * ********************************************************************************
 * this makes a base for adafruit permaproto half-size protoboard 
 * its base is 1mm thick, and 83 x 51 mm 
 *      (note permaproto is only 81 long; 83 allows room for end supports)
 * it has 2 M3 threaded insert mounts 73.7 mm apart
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/1609
 * ********************************************************************************
 */
board_permaprotohalf_length = 81;
board_permaprotohalf_width = 51;
board_permaprotohalf_screw_x = 73.7;

module component_permaprotohalf() {
    roundedbox(board_permaprotohalf_length, board_permaprotohalf_width, 2, 1);
    
    translate([ +(board_permaprotohalf_screw_x/2), 0, 1]) TI30_mount(); 
    translate([ -(board_permaprotohalf_screw_x/2), 0, 1]) TI30_mount(); 
    
    translate([ 0, 0, 1]) difference() {
        roundedbox(board_permaprotohalf_length, board_permaprotohalf_width, 2, TI30_default_height);
        roundedbox(board_permaprotohalf_length-4, board_permaprotohalf_width-4, 2, TI30_default_height+0.1);
    }
    
    translate([0, +8, 0]) linear_extrude(2) text("PermaProto", 
        size=8, , halign="center");
    translate([0, -4, 0]) linear_extrude(2) text("Half-Size", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -16, 0]) linear_extrude(2) text("M3", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(board_permaprotohalf_length, board_permaprotohalf_width, 2, 1);
    }
}



/*
 * ********************************************************************************
 * this makes a base for adafruit feather and feather protoboard
 * its base is 1mm thick, and 52 x 25mm (note feather itself is 50.8 x 22.86 mm)
 * it has 4 M2.5 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/2884
 * guide: https://learn.adafruit.com/featherwing-proto-and-doubler/overview
 * ********************************************************************************
 */
board_feather_length = 52;
board_feather_width = 25;
vis_feather_length = 50.8;
vis_feather_width = 22.86;
board_feather_screw_x = 45.72;
board_feather_screw_y = 17.78;

module component_feather() {
    roundedbox(board_feather_length, board_feather_width, 2, 1);
    
    translate([ -(board_feather_screw_x/2), -(board_feather_screw_y/2), 1]) TI25_mount(); 
    translate([ -(board_feather_screw_x/2), +(board_feather_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_screw_x/2), -(board_feather_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_screw_x/2), +(board_feather_screw_y/2), 1]) TI25_mount(); 
    
    translate([0, 1, 0]) linear_extrude(2) text("Feather", 
        size=6, halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -8, 0]) linear_extrude(2) text("M2.5", 
        size=6, halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
    }
}

/*
 * ********************************************************************************
 * this makes a base for adafruit feather doubler protoboard
 * its base is 1mm thick, and 49 x 52mm (note the doubler itself is 45.72 x 46.99 mm)
 * it has 4 M2.5 threaded insert mounts + 2 support mounts between "boards"
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/2890
 * guide: https://learn.adafruit.com/featherwing-proto-and-doubler/overview
 * ********************************************************************************
 */
board_feather_doubler_length = 49;   
board_feather_doubler_width = 52;
board_feather_doubler_screws_x = 21;
board_feather_doubler_studs_x = 0;
board_feather_doubler_screw_y = 45.72;

module component_feather_doubler() {
    roundedbox(board_feather_doubler_length, board_feather_doubler_width, 2, 1);
    
    translate([ -(board_feather_doubler_screws_x), -(board_feather_doubler_screw_y/2), 1]) TI25_mount(); 
    translate([ -(board_feather_doubler_screws_x), +(board_feather_doubler_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_doubler_screws_x), -(board_feather_doubler_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_doubler_screws_x), +(board_feather_doubler_screw_y/2), 1]) TI25_mount(); 
    
    translate([ -(board_feather_doubler_studs_x), -(board_feather_doubler_screw_y/2), 1]) support_stud(); 
    translate([ +(board_feather_doubler_studs_x), +(board_feather_doubler_screw_y/2), 1]) support_stud(); 
    
    translate([0, +8, 0]) linear_extrude(2) text("Feather", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -4, 0]) linear_extrude(2) text("Doubler", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -16, 0]) linear_extrude(2) text("M2.5", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ -12, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ])
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ 12, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ])
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
    }
}

/*
 * ********************************************************************************
 * this makes a base for adafruit feather tripler protoboard
 * its base is 1mm thick, and 73 x 52mm (note the doubler itself is 71.12 x 46.99 mm)
 * it has 4 M2.5 threaded insert mounts + 4 support mounts between "boards"
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/2890
 * guide: https://learn.adafruit.com/featherwing-proto-and-doubler/overview
 * ********************************************************************************
 */
board_feather_tripler_length = 73;   
board_feather_tripler_width = 52;
board_feather_tripler_screws_x = 33;
board_feather_tripler_studs_x = 12;
board_feather_tripler_screw_y = 45.72;

module component_feather_tripler() {
    roundedbox(board_feather_tripler_length, board_feather_tripler_width, 2, 1);
    
    translate([ -(board_feather_tripler_screws_x), -(board_feather_tripler_screw_y/2), 1]) TI25_mount(); 
    translate([ -(board_feather_tripler_screws_x), +(board_feather_tripler_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_tripler_screws_x), -(board_feather_tripler_screw_y/2), 1]) TI25_mount();
    translate([ +(board_feather_tripler_screws_x), +(board_feather_tripler_screw_y/2), 1]) TI25_mount(); 
    
    translate([ -(board_feather_tripler_studs_x), -(board_feather_tripler_screw_y/2), 1]) support_stud(); 
    translate([ -(board_feather_tripler_studs_x), +(board_feather_tripler_screw_y/2), 1]) support_stud();
    translate([ +(board_feather_tripler_studs_x), -(board_feather_tripler_screw_y/2), 1]) support_stud();
    translate([ +(board_feather_tripler_studs_x), +(board_feather_tripler_screw_y/2), 1]) support_stud(); 
       
    translate([0, +8, 0]) linear_extrude(2) text("Feather", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -4, 0]) linear_extrude(2) text("Tripler", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -16, 0]) linear_extrude(2) text("M2.5", 
        size=8, , halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ])
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ -24, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ])
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ 24, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ])
            roundedbox(vis_feather_length, vis_feather_width, 2, 1);
    }
}
/*
 * ***************************************************************************
 * this makes a base for Adafruit TB6612 H-Bridge module
 * its base is 1mm thick, and 30 x 22mm (note the TB6612 itself is 26.67 x 19.05 mm)
 * it has 2 M25 threaded insert mounts 21.95mm spacing (2.54 off edge)
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase:  https://www.adafruit.com/product/2448
 * reference: https://learn.adafruit.com/adafruit-tb6612-h-bridge-dc-stepper-motor-driver-breakout/overview
 * these drive (1) stepper, or (2) DC brushed motors; 2.7-5v logic, 4.5-13.5v motor; 1.2 A per channel
 * ***************************************************************************
 */
board_tb6612_length = 30;
board_tb6612_width = 22;
vis_tb6612_length = 26.67;
vis_tb6612_width = 19.05;
board_tb6612_screw_x = 21.59;
board_tb6612_screw_y = 6.985;

module component_tb6612() {
    roundedbox(board_tb6612_length, board_tb6612_width, 2, 1);
     
    translate([ -(board_tb6612_screw_x/2), board_tb6612_screw_y, 1]) TI25_mount();
    translate([ +(board_tb6612_screw_x/2), board_tb6612_screw_y, 1]) TI25_mount();
    translate([ +12, -3, 1]) support_stud();
    translate([ -12, -3, 1]) support_stud();
       
    translate([0, -2, 0]) linear_extrude(2) text("6612", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -9, 0]) linear_extrude(2) text("M2.5",
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(vis_tb6612_length, vis_tb6612_width, 2, 1);
        translate([ 0, 7, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(13, 2, 1, 8);
        translate([ 0, -7, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(23, 2, 1, 8);
        translate([ -9, 0, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(6, 7, 1, 8);
    }
}

/*
 * ***************************************************************************
 * this makes a base for red L298N motor driver board
 * its base is 1mm thick, and 44 x 44 mm
 * it has 4 M3 threaded insert mounts 37.5 x 37.5 mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.amazon.com/dp/B01J39FAK8/   or equivalent
 * this drives (1) stepper, or (2) DC brushed motors; up to 46v, 2A, max 25W
 * ***************************************************************************
 */
board_L298motor_length = 44;
board_L298motor_width = 44;
board_L298motor_screw_x = 37.5;
board_L298motor_screw_y = 37.5;

module component_L298motor_driver() {
    roundedbox(board_L298motor_length, board_L298motor_width, 2, 1);
    
    translate([ -(board_L298motor_screw_x/2), -(board_L298motor_screw_y/2), 1]) TI30_mount(); 
    translate([ -(board_L298motor_screw_x/2), +(board_L298motor_screw_y/2), 1]) TI30_mount();
    translate([ +(board_L298motor_screw_x/2), -(board_L298motor_screw_y/2), 1]) TI30_mount();
    translate([ +(board_L298motor_screw_x/2), +(board_L298motor_screw_y/2), 1]) TI30_mount();
       
    translate([0, 4, 0]) linear_extrude(2) text("L298 Motor", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -4, 0]) linear_extrude(2) text("Driver", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -12, 0]) linear_extrude(2) text("M3",
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(board_L298motor_length, board_L298motor_width, 2, 1);
        translate([ -14.5, 0, 1 + TI30_default_height + 1 ]) color([ 0.5, 0.5, 0.5 ]) 
            roundedbox(15, 23, 1, 25);
        translate([ 7, 17, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(10, 8, 1, 10);
        translate([ 7, -17, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(10, 8, 1, 10);
        translate([ 17, -8, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(8, 15, 1, 10);
        translate([ 17, +8, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(2, 15, 1, 8);
    }
}



/*
 * ***************************************************************************
 * this makes a base for geared stepper driver board
 * its base is 1mm thick, and 35 x 32 mm
 * it has 4 M3 threaded insert mounts 29.5 x 26.5 mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase:  https://www.amazon.com/Longruner-Stepper-Uln2003-arduino-LK67/dp/B015RQ97W8/  or equivalent
 * reference: http://www.4tronix.co.uk/arduino/Stepper-Motors.php
 * this drives (1) small unipolar stepper
 * ***************************************************************************
 */
board_gearedstepper_length = 35;
board_gearedstepper_width = 32;
board_gearedstepper_screw_x = 29.5;
board_gearedstepper_screw_y = 26.5;

module component_gearedstepper_driver() {
    roundedbox(board_gearedstepper_length, board_gearedstepper_width, 2, 1);
    
    translate([ -(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30_mount(); 
    translate([ -(board_gearedstepper_screw_x/2), +(board_gearedstepper_screw_y/2), 1]) TI30_mount();
    translate([ +(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30_mount();
    translate([ +(board_gearedstepper_screw_x/2), +(board_gearedstepper_screw_y/2), 1]) TI30_mount();
       
    translate([0, 4, 0]) linear_extrude(2) text("Geared", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -4, 0]) linear_extrude(2) text("Stepper", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -12, 0]) linear_extrude(2) text("M3",
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(board_gearedstepper_length, board_gearedstepper_width, 2, 1);
        
        translate([ -4, 5, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(10, 20, 1, 9);
        translate([ 5 , 6, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(6, 16, 1, 8);
        translate([ -11, 6, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(2, 10, 1, 8);
        translate([ -5, -10, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(10, 2, 1, 8);
        translate([ 12.5, -4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            cylinder(r=1.7, h=6);
        translate([ 12.5, 0, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            cylinder(r=1.7, h=6);
        translate([ 12.5, 4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            cylinder(r=1.7, h=6);
        translate([ 12.5, 8, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            cylinder(r=1.7, h=6);
    }
}

/*
 * ***************************************************************************
 * this makes a base for sparkfun_easydriver board
 * its base is 1mm thick, and 48.26 x 24.13 mm
 * it has 2 M3 threaded insert mounts at (-8.89, 0) and (15.24, 3.81)
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase:  https://www.sparkfun.com/products/12779
 * reference: http://www.schmalzhaus.com/EasyDriver/
 * this drives (1) small bipolar stepper
 * ***************************************************************************
 */
board_easydriver_length = 48.26;
board_easydriver_width = 24.13;

module component_easydriver() {
    roundedbox(board_easydriver_length, board_easydriver_width, 2, 1);
    
    translate([ -8.89, 0, 1]) TI30_mount(); 
    translate([ 15.24, 3.81, 1]) TI30_mount();
       
    translate([-5, 5, 0]) linear_extrude(2) text("Sparkfun", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([+4, -3, 0]) linear_extrude(2) text("M3", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    translate([0, -10, 0]) linear_extrude(2) text("EasyDriver", 
        size=6,  halign="center", font = "Liberation Sans:style=Bold");
    
    // visualizations for this device
    if (show_internal_parts_for_collision_check) {
        translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
            roundedbox(board_easydriver_length, board_easydriver_width, 2, 1);
        translate([ 5, 0, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            roundedbox(16, 8, 1, 1);
        translate([ 19, -2, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
            cylinder(r=4, h=6);
        translate([ 4, -10, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(38, 2, 1, 2);
        translate([ 4, +10, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
            roundedbox(38, 2, 1, 2);
    }
}


/*
 * ****************************************************************************************
 * standard mini toggle switch (for visualization, a DPDT switch is shown)
 * purchase:  https://www.adafruit.com/product/3220   or equivalent
 * purchase:  https://www.amazon.com/yueton-Terminals-Position-Toggle-Switch/dp/B013DZB6CO/
 * *****************************************************************************************
 */

module component_mini_toggle_switch(mode="holes") {    
    // makes a hole for standard mini-toggle switch 7.5mm dia
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    hole_dia = 7.5;
    hole_radius = hole_dia / 2;
    switch_body_width = 13;
    switch_body_depth = 10; 

    // note make the holes lid_thickness instead of body_wall_thickness because the lid
    // is probably thicker than body wall; 
    if (mode == "holes") {
        cylinder( r=hole_radius, h=lid_thickness+0.1 );
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, ((switch_body_depth/2) + 3) ]) 
                color([ 1, 0, 0 ]) 
                cube( size=[switch_body_width, switch_body_width, switch_body_depth], center=true );
            translate([ 0, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
            translate([ 4, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
            translate([ -4, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
        }
    }
    
    if (mode == "lidcheck") {
        // visualizations for this device
        if (show_lid_parts_for_collision_check) {
            translate([ 0, 0, ((switch_body_depth/2) + 3) ]) 
                color([ 0, 0, 1 ]) 
                cube( size=[switch_body_width, switch_body_width, switch_body_depth], center=true );
            translate([ 0, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
            translate([ 4, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
            translate([ -4, 0, (switch_body_depth+3) ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 9, 1, 5);
        }
    }
}

/*
 * ****************************************************************************************
 * adafruit illuminated pushbuttons
 * purchase:  https://www.adafruit.com/product/1440   or equivalent in different colors
 * *****************************************************************************************
 */

module component_adafruit_illuminated_pushbutton(mode="holes") {
    // the hole is 17 mm in dia; and 6mm thick; it has flats on 15.1mm apart
    // it should be DIFFERENCED from the body that it is installed in
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    if (mode == "holes") {
        difference() {
            cylinder( r=(17/2), h=6);
            translate([-9,7.55,0]) cube([18,2,6]);
            translate([-9,-9.55,0]) cube([18,2,6]);
        }
    }
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 0 ]) color([ 1, 0, 0 ]) cylinder( r=(20/2), h=18);
            translate([ 3, 0, 18 ]) color([ 0.5, 0.5, 0.5 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ -3, 0, 18 ]) color([ 1, 0.2, 0.2 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ 3.8, 5, 18 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ -3.8, 5, 18 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
        }
    }
    
    if (mode == "lidcheck") {
        // visualizations for this device
        if (show_lid_parts_for_collision_check) {
            translate([ 0, 0, 0 ]) color([ 0, 0, 1 ]) cylinder( r=(20/2), h=18);
            translate([ 3, 0, 18 ]) color([ 0.5, 0.5, 0.5 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ -3, 0, 18 ]) color([ 1, 0.2, 0.2 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ 3.8, 5, 18 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ -3.8, 5, 18 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
        }
    }
}



/*
 * ****************************************************************************************
 * large arcade style pushbutton (really soft push)
 * purchase:  https://www.amazon.com/Original-OBSF-30-Buttons-Arcade-Joystick-Console/dp/B01LYN7MTI/ 
 * *****************************************************************************************
 */

module component_arcade_button(mode="holes") {    
    // makes a hole for standard mini-toggle switch 7.5mm dia
    // note the passthru hole is 30.5, but it has a larger hole (40mm) 2.2mm "in" from outside wall
    //      (this is so that snap-fingers have a 2.2mm push-point)
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    hole_dia = 30.5;
    finger_hole_dia = 40;
    push_thickness = 2.2;
    switch_body_depth = 19;
    
    if (mode == "holes") {
        cylinder( r=(hole_dia / 2), h=body_wall_thickness );  // the pass-through hole
        translate([ 0, 0, push_thickness ]) cylinder( r=(finger_hole_dia / 2), h=body_wall_thickness + 0.1 );  // lip for switch fingers
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(hole_dia / 2), h=(switch_body_depth-1));            
            translate([ 0, 0, 19 ]) color([ 0.5, 0.5, 0.5 ]) 
                roundedbox(13, 13, 1, 6);
            
            translate([ -3, 2, 25 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
            translate([ +3, 2, 25 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 3, 1, 6);
        }
    }
}



/*
 * ****************************************************************************************
 * small geared stepper motor
 * purchase (16x) :https://www.adafruit.com/product/858
 * purchase (64x): https://www.amazon.com/Longruner-Stepper-Uln2003-arduino-LK67/dp/B015RQ97W8/ 
 * *****************************************************************************************
 */

module component_geared_stepper_motor(mode="holes") {  
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, -8, 0 ]) cylinder( r=(8 / 2), h=body_wall_thickness+0.1 );  // the shaft hole
        translate([ -(35/2), 0, 0 ]) cylinder( r=(screwhole_radius_M30_passthru), h=body_wall_thickness+0.1 );  // mount hole
        translate([ +(35/2), 0, 0 ]) cylinder( r=(screwhole_radius_M30_passthru), h=body_wall_thickness+0.1 );  // mount hole
        translate([ 0, 0, body_wall_thickness ]) cylinder( r=(30 / 2), h=20);    // might make dent in bottom for main motor body
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, body_wall_thickness ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(28 / 2), h=19);    // main motor body        
            translate([ 0, (17/2), body_wall_thickness ]) color([ 1, 0, 0 ]) 
                roundedbox(14, 17, 1, 16);      // square topper for wires         
            translate([ 0, 0, body_wall_thickness ]) color([ 1, 0, 0 ]) 
                roundedbox(42, 7, 1, 1);        // mounting tabs
            translate([ 0, -8, body_wall_thickness - 2 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(7.8 / 2), h=2);    // bearing housing 
            translate([ 0, -8, body_wall_thickness - 9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5 / 2), h=11);    // shaft       
        }
    }
}


/*
 * ****************************************************************************************
 * Sparkfun Stepper Motor Ungeared 7.5 degrees
 * purchase: https://www.sparkfun.com/products/10551
 * Note mount holes are tapped for M3 screws
 * *****************************************************************************************
 */

module component_sparkfun_stepper_motor(mode="holes") { 
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    
    // polygon reference https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#polygon
    points = [ [25,4], [4,18], [-4,18], [-25,4], [-25,-4], [-4,-18], [4,-18], [25,-4] ]; 
    
    if (mode == "holes") {
        translate([ 0, 0, 0 ]) cylinder( r=(12 / 2), h=body_wall_thickness+0.1 );  // the shaft hole
        translate([ -(42/2), 0, 0 ]) cylinder( r=(screwhole_radius_M30_passthru), h=body_wall_thickness+0.1 );  // mount hole
        translate([ +(42/2), 0, 0 ]) cylinder( r=(screwhole_radius_M30_passthru), h=body_wall_thickness+0.1 );  // mount hole
        translate([ 0, 0, body_wall_thickness ]) cylinder( r=(37 / 2), h=18);    // might make dent in bottom for main motor body     
        translate([ 0, 0, body_wall_thickness ]) linear_extrude(height=8) polygon( points ); // might make dent in bottom for flat plate
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, body_wall_thickness + 1 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(35 / 2), h=15);    // main motor body      
            translate([ 0, 0, body_wall_thickness ]) color([ 1, 0, 0 ]) 
                linear_extrude(height=1) polygon( points );
            translate([ 0, 0, body_wall_thickness - 1.5 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(10 / 2), h=1.5);    // bearing housing 
            translate([ 0, -0, body_wall_thickness - 9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(3 / 2), h=11);    // shaft       
        }
    }
}



/*
 * ****************************************************************************************
 * N20 motor
 * purchase: https://www.adafruit.com/product/4638
 * Note mount holes are tapped for M2 screws
 * *****************************************************************************************
 */

module component_n20_motor(mode="holes") { 
    // this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, 0, 0 ]) cylinder( r=(4 / 2), h=body_wall_thickness+0.1 );  // the shaft hole
        translate([ 0, 0, (body_wall_thickness-1) ]) cylinder( r=(5 / 2), h=1.2 );  // the bearing hole
        roundedbox(12, 2.3, 1, (body_wall_thickness+0.1));    // slot for mounting screws (prints better than 2 teeny holes
        //translate([ -(9/2), 0, 0 ]) cylinder( r=(screwhole_radius_M25_passthru), h=body_wall_thickness+0.1 );  // mount hole
        //translate([ +(9/2), 0, 0 ]) cylinder( r=(screwhole_radius_M25_passthru), h=body_wall_thickness+0.1 );  // mount hole        
        translate([ 0, 0, body_wall_thickness ]) roundedbox(14, 12, 1, 32);    // maybe dig a clearance ditch in box bottom if motor is low
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, body_wall_thickness ]) 
                color([ 1, 0, 0 ]) 
                roundedbox(12, 10, 1, 25);    // main motor body 
            translate([ 0, (4.5), body_wall_thickness+25 ]) 
                color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(12, 18, 1, 1);    // pcb 
            translate([ 0, 0, body_wall_thickness+26 ]) 
                color([ 0.3, 0.3, 0.3 ]) 
                cylinder(r=(12/2), h=5);    // magnet 
            translate([ 0, 11, body_wall_thickness + 26 ]) 
                color([ 1,1,1 ]) 
                roundedbox(10, 6, 1, 5);    // connector 
            translate([ 0, 0, body_wall_thickness - 1.5 ]) 
                color([ 1, 1, 1 ]) 
                cylinder( r=(4 / 2), h=1.5);    // bearing housing 
            translate([ 0, -0, body_wall_thickness - 9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(3 / 2), h=10);    // shaft       
        }
    }
}

/*
 * ****************************************************************************************
 * TT motors (various options)
 * purchase: https://www.adafruit.com/product/4638
 * "Yellow TT", "Blue TT", "DFR TT with Encoder Straight"
 *
 * purchase (yellow) plastic gears, bidirectional shaft 1:48 200 rpm: 
 *      https://www.adafruit.com/product/3777
 * purchase (blue) metal gears shaft only goes "out" 1:90 120rpm: 
 *      https://www.adafruit.com/product/3802 
 * purchase (with encoder) shaft only goes "out" 1:120 160 rpm: 
 *      https://www.dfrobot.com/product-1457.html
 *
 * Note internal dimensions from https://www.adafruit.com/product/3777
 *    but external dimensions inflated a little bit so it could dig body holes if needed
 * *****************************************************************************************
 */

module component_TT_blue_motor(mode="holes") { 
    // this is generated in xy plane, with shaft centered at origin and body running "right" (towards +x), 
    // shaft is pointing "down" (towards -z); body builds "up" ("into" the box; towards +z)
    // box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, 0, -body_wall_thickness-0.1 ]) cylinder( r=(7 / 2), h=body_wall_thickness+0.2 );  // the shaft hole
        translate([ 8, -(24/2), -2 ]) cube([ 6, 24, 2.1]);  // slot for internal gear shaft
        translate([ 11.25+8.60, +(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ 11.25+8.60, -(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ -(11+2.5), 0, -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3

        // under-hole in case it sits low in box
        translate([ (38/2)-11.5, 0, 0 ])  union() {
            roundedbox(38, 22.5, 2, 22);
            translate([ -(37/2)-5, (-5/2)-1, (19/2)-(3/2)-0.5 ])cube([ 5, 7, 4]);
        }
        translate([ 37-11-5, 0, (19/2) ]) rotate([ 0, 90, 0 ])cylinder( r=(23.5 / 2), h=27);    // motor body 
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {

            // build the gearbox (the rectangular part of the motor)
            translate([ (37/2)-11, 0, 0 ]) 
                color([ 1, 0, 0 ]) difference() {
                        union() {
                            roundedbox(37, 22.5, 2, 19);    // gear body
                            // end mounting tab
                            translate([ -(37/2)-5, (-5/2), (19/2)-(3/2) ]) difference() {
                                cube([ 5, 5, 3]);
                                translate([ (5/2), (5/2), -1 ]) cylinder( r=1.5, h=5 );
                            }
                        }
                        translate([ -(37/2)+11+11.25+8.60, +(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3
                        translate([ -(37/2)+11+11.25+8.60, -(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3

                    }

            // this part generates the motor body (the round part of the motor)
            translate([ 37-11, 0, (19/2) ])
                rotate([ 0, 90, 0 ])   union() {
                    difference() {
                        color([ 1, 0, 0 ])
                        cylinder( r=(22.5 / 2), h=26);    // motor body 
                        translate([ -(17.5/2)-4, -(22.5/2), -1]) cube([ 4, 22.5, 28 ]);
                        translate([ (17.5/2),  -(22.5/2), -1]) cube([ 4, 22.5, 28 ]);
                    }
                    translate([ (17.5/2),  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]);    // strap clamp
                    translate([ -(17.5/2)-3,  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]); // strap clamp
                }

            // dimple for internal gear shaft
            translate([ 11, 0, -2.2 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5 / 2), h=2.2);       

            // shaft
            translate([ 0, -0, -9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5.5 / 2), h=9);    // shaft       
        }
    }
}

module component_TT_yellow_motor(mode="holes") { 
    // this is generated in xy plane, with shaft centered at origin and body running "right" (towards +x), 
    // shaft is pointing "down" (towards -z); body builds "up" ("into" the box; towards +z)
    // box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, 0, -body_wall_thickness-0.1 ]) cylinder( r=(7 / 2), h=body_wall_thickness+0.2 );  // the shaft hole
        translate([ 8, -(24/2), -2 ]) cube([ 6, 24, 2.1]);  // slot for internal gear shaft
        translate([ 11.25+8.60, +(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ 11.25+8.60, -(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ -(11+2.5), 0, -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3

        // under-hole in case it sits low in box
        translate([ (38/2)-11.5, 0, 0 ])  union() {
            roundedbox(38, 22.5, 2, 22);
            translate([ -(37/2)-5, (-5/2)-1, (19/2)-(3/2)-0.5 ]) cube([ 5, 7, 4]);
        }
        translate([ 37-11-5, 0, (19/2) ]) rotate([ 0, 90, 0 ]) cylinder( r=(23.5 / 2), h=27);    // motor body 
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {

            // build the gearbox (the rectangular part of the motor)
            translate([ (37/2)-11, 0, 0 ]) 
                color([ 1, 0, 0 ]) difference() {
                        union() {
                            roundedbox(37, 22.5, 2, 19);    // gear body
                            // end mounting tab
                            translate([ -(37/2)-5, (-5/2), (19/2)-(3/2) ]) difference() {
                                cube([ 5, 5, 3]);
                                translate([ (5/2), (5/2), -1 ]) cylinder( r=1.5, h=5 );
                            }
                        }
                        translate([ -(37/2)+11+11.25+8.60, +(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3
                        translate([ -(37/2)+11+11.25+8.60, -(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3

                    }

            // this part generates the motor body (the round part of the motor)
            translate([ 37-11, 0, (19/2) ])
                rotate([ 0, 90, 0 ])   union() {
                    difference() {
                        color([ 1, 0, 0 ])
                        cylinder( r=(22.5 / 2), h=26);    // motor body 
                        translate([ -(17.5/2)-4, -(22.5/2), -1]) cube([ 4, 22.5, 28 ]);
                        translate([ (17.5/2),  -(22.5/2), -1]) cube([ 4, 22.5, 28 ]);
                    }
                    translate([ (17.5/2),  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]);    // strap clamp
                    translate([ -(17.5/2)-3,  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]); // strap clamp
                }

            // dimple for internal gear shaft
            translate([ 11, 0, -2.2 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5 / 2), h=2.2);       

            // shaft
            translate([ 0, -0, -9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5.5 / 2), h=37);    // shaft       
        }
    }
}


module component_TT_DFR_motor(mode="holes") { 
    // this is generated in xy plane, with shaft centered at origin and body running "right" (towards +x), 
    // shaft is pointing "down" (towards -z); body builds "up" ("into" the box; towards +z)
    // box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, 0, -body_wall_thickness-0.1 ]) cylinder( r=(7 / 2), h=body_wall_thickness+0.2 );  // the shaft hole
        translate([ 8, -(24/2), -2 ]) cube([ 6, 24, 2.1]);  // slot for internal gear shaft
        translate([ 11.25+8.60, +(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ 11.25+8.60, -(17.6/2), -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3
        translate([ -(11+2.5), 0, -body_wall_thickness-0.1 ]) 
            cylinder( r=1.5, h=body_wall_thickness+0.2 );    // mount hole M3

        // under-hole in case it sits low in box
        translate([ (38/2)-11.5, 0, 0 ])  union() {
            roundedbox(38, 22.5, 2, 22);
            translate([ -(37/2)-5, (-5/2)-1, (19/2)-(3/2)-0.5 ]) cube([ 5, 7, 4]);
        }
        translate([ 37-11-5, 0, (19/2) ]) rotate([ 0, 90, 0 ]) cylinder( r=(22.5 / 2), h=33);    // motor body 
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {

            // build the gearbox (the rectangular part of the motor)
            translate([ (37/2)-11, 0, 0 ]) 
                color([ 1, 0, 0 ]) difference() {
                        union() {
                            roundedbox(37, 22.5, 2, 19);    // gear body
                            // end mounting tab
                            translate([ -(37/2)-5, (-5/2), (19/2)-(3/2) ]) difference() {
                                cube([ 5, 5, 3]);
                                translate([ (5/2), (5/2), -1 ]) cylinder( r=1.5, h=5 );
                            }
                        }
                        translate([ -(37/2)+11+11.25+8.60, +(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3
                        translate([ -(37/2)+11+11.25+8.60, -(17.6/2), -1 ]) cylinder( r=1.5, h=22 );    // mount hole M3

                    }

            // this part generates the motor body (the round part of the motor)
            translate([ 37-11, 0, (19/2) ])
                rotate([ 0, 90, 0 ])   union() {
                    difference() {
                        color([ 1, 0, 0 ])
                        cylinder( r=(22.5 / 2), h=26);    // motor body  
                        translate([ -(17.5/2)-4, -(22.5/2), -1]) cube([ 4, 22.5, 32 ]);
                        translate([ (17.5/2),  -(22.5/2), -1]) cube([ 4, 22.5, 32 ]);
                    }
                    translate([ 0, 0, 27 ]) color([ 0.2, 0.2, 0.2 ]) cylinder( r=(18 / 2), h=3);    // magnet disc
                    translate([ (17.5/2),  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]);    // strap clamp
                    translate([ -(17.5/2)-3,  -(6/2), 4]) color([ 1, 0, 0 ]) cube([ 3, 6, 3 ]); // strap clamp
                    difference() {  
                        translate([ 0,  0, 19]) color([ 0.5, 0.5, 0.5 ]) cylinder( r=(28 / 2), h=2);    // sensor PCB 
                        translate([ (17.5/2),  -(28/2), -1]) cube([ 6, 28, 33 ]);       // flatten the side of the disc
                    }
                    translate([ -22,  -(19/2), 19]) color([ 0.5, 0.5, 0.5 ]) cube([ 25, 19, 2 ]);   // square part of PCB
                    translate([ -22,  -(12/2), 19-6]) color([ 0.8, 0.8, 0.8 ]) cube([ 8, 12, 6 ]);  // 4 pin connector
                    translate([ -22,  -(9/2), 19+2]) color([ 0.8, 0.8, 0.8 ]) cube([ 8, 9, 6 ]);    // 2 pin connector
                }

            // dimple for internal gear shaft
            translate([ 11, 0, -2.2 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5 / 2), h=2.2);       

            // shaft
            translate([ 0, -0, -9 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(5.5 / 2), h=9);    // shaft       
        }
    }
}


/*
 * ****************************************************************************************
 * Pololu MiniPlastic DC Motor (Straight/Extended Shaft)
 * purchase: https://www.pololu.com/product/1515/pictures
 * reference: https://www.pololu.com/file/0J824/mini-plastic-gearmotor-90-degree-extended-shaft-dimension-diagram.pdf
 * reference: https://www.pololu.com/file/0J1197/magnetic-encoder-pair-kit-for-mini-plastic-gearmotors-dimension-diagram.pdf
 * *****************************************************************************************
 */

module component_pololu_miniplastic_motor(mode="holes") { 
    // this is generated in xy plane, with shaft centered at origin and body running "right" (towards +x), 
    // shaft is pointing "down" (towards -z); body builds "up" ("into" the box; towards +z)
    // box outside skin is at z=0 (moving "into" box has +z)
    
    if (mode == "holes") {
        translate([ 0, 0, -body_wall_thickness-0.1 ]) cylinder( r=(5 / 2), h=body_wall_thickness+0.2 );  // the shaft hole

        // hole for body if it intersects back or bottom of box
        translate([ -10, -(23/2), 0 ]) cube([ 60, 23, 19 ]); 
        translate([ 27, -(26/2), 0 ]) cube([ 6, 26, 18 ]); 
    }
    
    if (mode == "adds") {
        // no adds for this device
        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {

            color([ 1, 0, 0 ]) cylinder( r=10, h=13.8);     // round end of main body
            translate([ 0, -(20/2), 0 ]) color([ 1, 0, 0 ]) cube([ 45, 20, 13.8 ]);    // main body
            translate([ 28.5, -(24.5/2), 0 ]) color([ 1, 0, 0 ]) cube([ 3, 24.5, 13.8 ]);    // flange
            translate([ 45, -(20/2), 1.2 ]) color([ 0.8, 0.8, 0.8 ]) cube([ 2, 20, 16.5 ]);    // encoder pcb
            translate([ 47, 0, 6.9 ]) rotate([ 0, 90, 0 ]) color ([ 0.4, 0.4, 0.4 ])cylinder( r=(10 / 2), h=3); 

            // shaft
            translate([ 0, -0, -10 ]) 
                color([ 1, 0, 0 ]) 
                cylinder( r=(3 / 2), h=10);    // shaft       
        }
    }
}