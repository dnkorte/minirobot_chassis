/*
 * Module: minirobot_mainline.scad is the module for minirobot box
 * this works in conjunction with minirobot_core.scad which has the core
 *  functions that actually generate and place the components
 *
 * note that in order for customizer to work, the "Hide Customizer"
 *    checkbox in the "View" menu must be UNCHECKED
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
 * ****************************************
 * calculate these working parameters
 * once their preprequisites are defined
 * ****************************************
 */

// correct for potential non-manifold errors if the lip height is same as mount dia  
use_lid_lip_height = (TI30_mount_diameter == lid_lip_height) ? (lid_lip_height + 0.1) : lid_lip_height;

// and ensure that mount is at least "far enough" away from lid panel that it can be fully round
mount_center_offset_from_boxtop = (lid_lip_height < TI30_mount_diameter) ? (TI30_mount_diameter/2) : (use_lid_lip_height / 2);

wheel_radius = wheel_diameter / 2;
// note motor shaft is lowered by small gap in order to raise box a bit
// so that bumps or surface irregularities don't lift wheels off the ground
shaft_height_above_box_bottom = wheel_radius - ground_clearance - caster_to_ground_gap;

echo("wheel radius: ", wheel_radius);
echo("ground clearance: " , ground_clearance);
echo("shaft over box bottom: ", shaft_height_above_box_bottom);

LED_OPTIMAL_HEIGHT = 5;

if ((linesensor_snout != "none") && (ground_clearance < 12)) {
    echo("<span style='background-color:red'>NOTICE: line follower works best with 12 - 20mm caster; please use a taller caster</span>");
}
if ((linesensor_snout != "none") && (ground_clearance > 20)) {
    echo("<span style='background-color:red'>NOTICE: line follower works best with 12 - 20mm caster; please use a shorter caster</span>");
}

/*
 * *******************************************************************************
 * pre-calculate some basic parameters to help with placement in placer module
 * *******************************************************************************
 */

// x,y location of box and lid walls (remember that lid is generated "upside down"
box_front_x = -(box_length/2);
box_back_x = +(box_length/2);
box_L_y = -(box_width/2);
box_R_y = +(box_width/2);

lid_front_x = +(box_length/2);
lid_back_x = -(box_length/2);
lid_L_y = -(box_width/2);
lid_R_y = +(box_width/2);

// this means that the battery box (any style) will reach no closer than XX mm above inside box bottom
max_length_for_battbox = height_of_box - body_bottom_thickness - airgap_under_batterybox;

/*
 * *****************************************************************
 * mainl box-building code for drawing parts
 * most standard components are already handled here, by means
 * of configuration parameters, however custom parts may be
 * added by adding appropriate code to these modules
 * *****************************************************************
 */


module box() {
    difference() {
        union() {
            // the basic hollow box
            if (show_box_walls) {
                difference() {
                    roundedbox(box_length, box_width, box_corner_radius, height_of_box);
                    translate([0, 0, body_bottom_thickness])  
                        roundedbox((box_length - 2*body_wall_thickness), 
                                   (box_width - 2*body_wall_thickness), 
                                   box_corner_inner_radius, 
                                   (height_of_box - body_wall_thickness+1));
                }
            } else {
                roundedbox(box_length, box_width, box_corner_radius, body_bottom_thickness);
            }
            
            // now enter the parts that are added to the box 
            place_box_bottom_combo("adds");
            place_box_boards_invokes("adds");
            place_switches_and_buttons_invokes("adds");

            place_motors_invokes("adds"); 

            place_battery("adds");
            place_power_distribution("adds");
            place_boost_buck("adds");
            place_lid_wire_ports("adds");
            place_front_mount_grid("adds");
            place_linefollower_snout("adds");
            place_caster_mounts("adds");

            place_alacarte("adds");

        
            // now if we want to check for collisions, we show a blue image of lid lip
            if (show_lid_parts_for_collision_check) {
                lip_box_length = box_length - (2 * (body_wall_thickness + lid_clearance));
                lip_box_width = box_width - (2 * (body_wall_thickness + lid_clearance));
                lip_inner_x = lip_box_length - (2 * lid_lip_thickness);
                lip_inner_y = lip_box_width - (2 * lid_lip_thickness);
                
                translate([ 0, 0, height_of_box-lid_lip_height ]) color([ 0, 0, 1 ]) difference() {
                    roundedbox(lip_box_length, lip_box_width, lip_corner_radius, use_lid_lip_height);
                    translate([ 0, 0, -0.5 ]) roundedbox(lip_inner_x, lip_inner_y, lip_corner_radius-2, use_lid_lip_height+1);
                }
            }
        }

       // create mounting holes along y side (by removal...)
        translate([-(box_length/2)-0.1, 0, (height_of_box - mount_center_offset_from_boxtop)]) rotate([0,90,0])  
              cylinder(h=box_length+0.2, r=screwhole_radius_M30_passthru);
      
        // create mounting holes along x side
        translate([0, -(box_width/2)-0.1, (height_of_box - mount_center_offset_from_boxtop)]) rotate([0,90,90])  
              cylinder(h=box_width+0.2, r=screwhole_radius_M30_passthru);

        
        // now enter all the parts that are removed from the box

        place_switches_and_buttons_invokes("holes");
        place_box_bottom_combo("holes");
        place_box_boards_invokes("holes");
        place_motors_invokes("holes");

        place_battery("holes");
        place_power_distribution("holes");
        place_boost_buck("holes");
        place_lid_wire_ports("holes");
        place_front_mount_grid("holes");
        place_linefollower_snout("holes");
        place_caster_mounts("holes");
        place_alacarte("holes");
    }

    // now add the component visualizations
    place_box_bottom_combo("vis");
    place_box_boards_invokes("vis");
    place_switches_and_buttons_invokes("vis");

    place_motors_invokes("vis"); 

    place_battery("vis");
    place_power_distribution("vis");
    place_boost_buck("vis");
    place_lid_wire_ports("vis");
    place_front_mount_grid("vis");
    place_linefollower_snout("vis");
    place_caster_mounts("vis");
    place_alacarte("vis");

}

module lid() {    

    difference() {

        union() {
            roundedbox(box_length, box_width, box_corner_radius, lid_thickness);
            translate([0, 0, lid_thickness]) lip();  

            // now enter the parts that are added to the lid
            place_switches_and_buttons_invokes("adds");

            //place_power_components("adds");
            place_battery("adds");
            place_power_distribution("adds");
            place_boost_buck(mode="adds");
            place_lid_wire_ports("adds");
            place_lid_mount_grid("adds");
            place_alacarte("adds");
        }
        
        // here enter all the parts that "remove" from the lid
        // here enter all the parts that are "removed" from the lid

        place_switches_and_buttons_invokes("holes");

        //place_power_components(mode="holes");
        place_battery("holes");
        place_power_distribution("holes");
        place_boost_buck(mode="holes");
        place_lid_wire_ports("holes");
        place_lid_mount_grid("holes");
        place_alacarte("holes");
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



/*
 * ***************************************************************************
 * this makes a mount line follower sensor board
 * mount holes are on 28 x 46 mm centers; board is 35 x 54mm
 *
 * this is generated in xy plane, with the box-front interface line
 *  running along Y axis, at x=0 -- with "forward" side running towards -x
 *  on Z axis, the box bottom (external) is at z=0, with platform toward +z
 *
 * snout mounts a mint-tin sized permaproto circuitboard for line sensor 
 * when board is mounted, the LEDs sit 12 mm below the bottom of the permaproto
 * snout itself is 3mm thick, so with no lift the LEDs would be 9 mm below box bottom
 * height of LEDs (without adjustment) = ground_clearance - 9
 *
 * optimal distance for sensor-to-floor = 5 mm LED_OPTIMAL_HEIGHT
 *  (per: https://www.pololu.com/category/245/medium-density-md-qtr-arrays)
 *
 * so desired_linesens_lift = LED_OPTIMAL_HEIGHT - (ground_clearance - 9)
 *    negative numbers suggest that sensor will be too high ( up to aboout -5 is ok)
 *
 * @param style == "Standard Size", "Extended", "SuperLong"
 *
 * ***************************************************************************
 */

snout_screw_x = 46;
snout_screw_y = 28;
snout_board_x = 54; 
snout_board_y = 35;
x_loc_board = 0;
y_loc_board = 20;

OPTIMAL_LED_HEIGHT = 5; // optimal height above ground
    
module component_linefollower_snout(mode="holes", style="Standard Size") {  

    // polygon reference https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#polygon
    points_standard = [ [-38,0], [38,0], [28,40], [-28,40], [-38,0] ];
    points_extended = [ [-38,0], [38,0], [28,70], [-28,70], [-38,0] ];

    if (mode == "holes") {
        // nothing to do
    }  

    if (mode == "adds") {
        if (style == "Standard Size") {
            difference() {
                union() {
                    difference(){
                        linear_extrude(height=3) polygon( points_standard );
                        translate([ 0, y_loc_board, 0 ]) subpart_linesens_board("preholes");
                    }
                    translate([ 0, y_loc_board, 0 ]) subpart_linesens_board("adds");
                }
                translate([ 0, y_loc_board, 0 ]) subpart_linesens_board("holes");
            }
        }
        if (style == "Extended") {
            x_loc_board_ext = 50;
            difference() {
                linear_extrude(height=3) polygon( points_extended );
                translate([ 0, (x_loc_board_ext - 10), -0.1 ]) roundedbox(40, 7, 1, 3.2); 
                translate([ 0, (x_loc_board_ext - 10), 2 ]) roundedbox(50, 30, 0.1, 2.2); 
            }
        }

    }
}

module subpart_linesens_board(mode="adds") {

    lift = OPTIMAL_LED_HEIGHT - ground_clearance + 15;
    if (lift < 3.5) {
        echo("NOTE: ground too far away; not able to achieve optimal LED height.  please use a smaller ground clearance");
        lift = 4;
    }

    if (mode=="adds") {
        //translate([ -snout_board_x/2, -snout_board_y/2, 0 ]) cube([ snout_board_x, snout_board_y, 1 ]); 
        translate([ -(snout_screw_x/2), -(snout_screw_y/2), 0]) cylinder(r=3, h=lift ); 
        translate([ -(snout_screw_x/2), +(snout_screw_y/2), 0]) cylinder(r=3, h=lift ); 
        translate([ +(snout_screw_x/2), -(snout_screw_y/2), 0]) cylinder(r=3, h=lift ); 
        translate([ +(snout_screw_x/2), +(snout_screw_y/2), 0]) cylinder(r=3, h=lift ); 
    }
    if (mode=="holes") {
        translate([ -(snout_screw_x/2), -(snout_screw_y/2), -4 ]) cylinder(r=screwhole_radius_M30_selftap, h=(lift + 4.1) ); 
        translate([ -(snout_screw_x/2), +(snout_screw_y/2), -4 ]) cylinder(r=screwhole_radius_M30_selftap, h=(lift + 4.1) ); 
        translate([ +(snout_screw_x/2), -(snout_screw_y/2), -4 ]) cylinder(r=screwhole_radius_M30_selftap, h=(lift + 4.1) ); 
        translate([ +(snout_screw_x/2), +(snout_screw_y/2), -4 ]) cylinder(r=screwhole_radius_M30_selftap, h=(lift + 4.1) ); 
        translate([ 0, -10, -4 ]) roundedbox(32, 7, 1, 12); 
    }
    if (mode=="preholes") {
        translate([ 0, 0, lift-2 ]) roundedbox(snout_board_x, snout_board_y, 1, 4); 
    }
    
}

