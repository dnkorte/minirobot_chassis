/*
 * Module:  switches_and_lights_components.scad  holds functions that create and place casters
 *			note that there is no corresponding casters_components.scad file for this...
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
 * NOTE this tool attempts to place components in orientations/distances 
 *  to minimize internal collisions.  not all possible combinations of
 *  parts and box size are compatible.  before printing or committing to
 *  a particular BOM or layout, use the "visualization" tools to
 *  check for collisions with your particular configuration 
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

    if (mode == "holes") {
        // note make the holes lid_thickness instead of body_wall_thickness because the lid
        // is probably thicker than body wall; 
        if (mode == "holes") {
            translate([ 0, 0, -0.1 ]) cylinder( r=hole_radius, h=lid_thickness+0.2 );
        }
    }
    
    if (mode == "adds") {
        // no adds for this device
    }

    if (mode == "vis") {    
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
 
    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff) 
     * note that the component description is basically identical to the above except for the color
     * in some cases it might be appropriate to simplify the part when details wouldn't matter
     * note that this "lidcheck" mode is only needed for parts that would be reasonably expected
     * to be able to live on the lid; 
     */
    
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
            translate([ 0, 0, -0.1 ]) cylinder( r=(17/2), h=6);
            translate([ 0, 0, -0.1 ]) translate([-9,7.55,0]) cube([18,2,6]);
            translate([ 0, 0, -0.1 ]) translate([-9,-9.55,0]) cube([18,2,6]);
        }
    }
    if (mode == "adds") {
        // no adds for this device
    }
    
    if (mode == "vis") {    
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

 
    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff) 
     * note that the component description is basically identical to the above except for the color
     * in some cases it might be appropriate to simplify the part when details wouldn't matter
     * note that this "lidcheck" mode is only needed for parts that would be reasonably expected
     * to be able to live on the lid; 
     */
    
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
        translate([ 0, 0, -0.1 ]) cylinder( r=(hole_dia / 2), h=body_wall_thickness+0.2 );  // the pass-through hole
        translate([ 0, 0, push_thickness ]) cylinder( r=(finger_hole_dia / 2), h=body_wall_thickness + 0.1 );  // lip for switch fingers
    }
    
    if (mode == "adds") {
        // no adds for this device
    }

    if (mode == "vis") {    
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

 
    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff) 
     * note that the component description is basically identical to the above except for the color
     * in some cases it might be appropriate to simplify the part when details wouldn't matter
     * note that this "lidcheck" mode is only needed for parts that would be reasonably expected
     * to be able to live on the lid; 
     */
    
    if (mode == "lidcheck") {
        // visualizations for this device
        if (show_lid_parts_for_collision_check) {
            translate([ 0, 0, 1 ]) 
                color([ 0, 0, 1 ]) 
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
 * sparkfun QWIIC pushbutton
 * purchase:  https://www.sparkfun.com/products/15932
 * this is generated in xy plane with center of SWITCH at origin (not board)
 * putton is "down" (-Z direction) as generated and it is generated so that the flat of
 * the button case is at Z= 2.0 mm (so that it will be 2mm inside the box when placed)
 * mount holes are  at ( -Y ) as generated
 * when placed for a lid it will need to be rotated 180 degrees against Y axis
 *
 * NOTE THAT THIS switch for horizontal mounting has pillars for self-tap screw with screw on the "inside"
 *  (the similar one for vertical has passthru holes for bolt + nut)
 * *****************************************************************************************
 */
 

qs_mount_hole_dia = screwhole_radius_M30_selftap;
qs_board_size = 26;
qs_button_center_from_board_center = 5;
qs_mount_holes_from_board_edge_y = 2.54;
qs_mount_holes_from_board_ctr_x = 10.5;
qs_push_thickness = 2.0;       // how far the square part of switch sits BEHIND panel front
qs_switch_body_size = 12.5;    // the x/y dimension of the square part of the switch
qs_pushbutton_diameter = 9;    // diameter of thruhole for round part of switch

module component_qwiic_pb_horizontal(mode="holes") {  
   
    if (mode == "holes") {
        cylinder( r=(qs_pushbutton_diameter / 2), h=body_wall_thickness+0.2 );  // the pass-through hole for pushbutton
        translate([ 0, 0, push_thickness ]) cube( qs_switch_body_size, qs_switch_body_size, body_wall_thickness  );  // lip for square part
    }
    
    if (mode == "adds") {
        // no adds for this device
    }

    if (mode == "vis") {    
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
 * ***************************************************************************
 * this makes a mount for adafruit neopixel flora
 *
 * this is generated in xy plane, centered at origin, box outside skin is at 
 * z=0 (moving "into" box has +z) 
 *
 * purchase link: https://www.adafruit.com/product/1260
 * ***************************************************************************
 */

flora_neopixel_block_size = 5.5;
flora_pcb_dia = 13;
flora_pcb_thick = 1;
flora_mount_hole_spacing = 20;

module component_flora_neopixel(mode="holes") {  

    rotate([ 0, 0, -45 ]) union() {
        if (mode == "holes") {
            // make the hole for the white square part that is the actual neopixel
            translate([ -flora_neopixel_block_size/2, -flora_neopixel_block_size/2, -0.1 ]) 
                cube([flora_neopixel_block_size, flora_neopixel_block_size, body_wall_thickness+0.2 ]);

            translate([ 0, 0, (body_wall_thickness-flora_pcb_thick) ]) 
                cylinder(r=(flora_pcb_dia/2), h=body_wall_thickness+0.2);

            // make 2 mounting holes on a 45 degree angle from the neopixel so the strap won't hit wires
            translate([ ((flora_mount_hole_spacing/2) * 0.707), ((flora_mount_hole_spacing/2) * 0.707), -0.1 ]) 
                cylinder(r=(screwhole_radius_M30_passthru/2), h=body_wall_thickness+0.2);

            translate([ -((flora_mount_hole_spacing/2) * 0.707), -((flora_mount_hole_spacing/2) * 0.707), -0.1 ]) 
                cylinder(r=(screwhole_radius_M30_passthru/2), h=body_wall_thickness+0.2);
        }  

        if (mode == "adds") {
            // nothing to add
        }

        if (mode == "vis") {
            // nothing to visualize
        }
    }
}

module part_flora_clamp() {
    clamp_width = 3;
    clamp_length = flora_mount_hole_spacing - 4;

    difference() {
        union() {
            translate([ -clamp_length/2, -clamp_width/2, 0 ]) cube([ clamp_length, clamp_width, 5 ]);
            translate([ -flora_mount_hole_spacing/2, 0, 0 ]) cylinder(r=3, h=7);
            translate([ flora_mount_hole_spacing/2, 0, 0 ]) cylinder(r=3, h=7);
        }
        translate([ -flora_mount_hole_spacing/2, 0, -0.1 ]) cylinder(r=screwhole_radius_M30_selftap, h=7.2);
        translate([ flora_mount_hole_spacing/2, 0, -0.1 ]) cylinder(r=screwhole_radius_M30_selftap, h=7.2);
    }
}


