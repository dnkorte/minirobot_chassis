/*
 * Module:  ports_and_grids_placers.scad  holds functions that create wire ports and mounting grids
 *			note that there is no corresponding ports_and_grids_components.scad file for this...
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
 * ***************************************************************************
 * this makes a rectangular port in lid for passing wires from inside of box
 * to outside of box
 *
 * this is generated in xy plane, centered at origin, box outside skin is at 
 * z=0 (moving "into" box has +z) it is generated in "landscape" shape
 * (as it would be on a box side)
 * ***************************************************************************
 */

module component_lid_wire_port(mode="holes") {    
    if (mode == "holes") {
        roundedbox(25, 7, 2, lid_thickness+0.2);
    }  

    if (mode == "lidcheck") {
        // visualizations for this device
        if (show_lid_parts_for_collision_check) {
            translate([ 0, 0, lid_thickness ]) color ([ 0.9, 0.9, 0.9 ]) roundedbox(25, 7, 2, 1);
        }
    }
}

/*
 * ***************************************************************************
 * this makes an M3 mount hole for a lid grid.  this is either self-tap screw
 * or threaded insert, based on TI30_use_threaded_insert;  the mount pad is
 * 5mm long, moving INTO the box 
 *
 * note that based on frontback and leftright it avoids back buttons, 
 * 	back switches, and back arcade buttons
 *
 * has_button_lid_left = false;		keep_away_distance = 20 / 2;
 * hhas_button_lid_right = false;	keep_away_distance = 20 / 2;
 * hhas_toggle_lid_left = false;	keep_away_distance = 14 / 2;
 * hhas_toggle_lid_right = false;	keep_away_distance = 14 / 2;
 * hhas_arcade_lid_left = false;	keep_away_distance = 36 / 2;
 * hhas_arcade_lid_center = false;	keep_away_distance = (36 / 2)  + 12;
 * hhas_arcade_lid_right = false;	keep_away_distance = 36 / 2;
 *
 * box_corner_inner_radius + keep_away_distance
 *
 * note for simplicity, all button / toggle / arcade are considered as arcade
 *
 * this is generated in xy plane, centered at origin, box outside skin is at 
 * z=0 (moving "into" box has +z) it is generated in "landscape" shape
 * (as it would be on a box side)
 * ***************************************************************************
 */

module component_lid_grid_mount(mode="holes", frontback=0, leftright=0) {  
	if ((has_arcade_lid_left) && (frontback < (lid_back_x+36+12)) && (leftright < (lid_L_y+36+8)) ) {
		// do nothing

	} else if ((has_button_lid_left || has_toggle_lid_left) && (frontback < (lid_back_x+20+12)) && (leftright < (lid_L_y+20+8)) ) {
		// do nothing

	} else if ((has_arcade_lid_right) && (frontback < (lid_back_x+36+12)) && (leftright > (lid_R_y-36-8)) ) {
		// do nothing

	} else if ((has_button_lid_right || has_toggle_lid_right) && (frontback < (lid_back_x+20+12)) && (leftright > (lid_R_y-20-8)) ) {
		// do nothing

	} else if ((has_arcade_lid_center) && (frontback < (lid_back_x+36+12)) && (abs(leftright) < 20) ) {
		// do nothing

	} else {
	    if (mode == "holes") {
	    	if (TI30_use_threaded_insert) {
	    		translate([ 0, 0, -0.1 ]) cylinder( r=(TI30_through_hole_diameter/2), h=5.2 );
	    	} else {
	        	translate([ 0, 0, -0.1 ]) cylinder( r=screwhole_radius_M30_selftap, h=5.2 );
	        }
	    }  

	    if (mode == "adds") {
	    	cylinder( r=(TI30_mount_diameter/2), h=5 );
	    }
    }
}

/*
 * ***************************************************************************
 * this makes an M3 mount hole for a front mount grid.  this is either self-tap screw
 * or threaded insert, based on TI30_use_threaded_insert;  the mount pad is
 * 5mm long, moving INTO the box 
 *
 * this is generated in xy plane, centered at origin, box outside skin is at 
 * z=0 (moving "into" box has +z) it is generated in "landscape" shape
 * (as it would be on a box side)
 * ***************************************************************************
 */

module component_front_grid_mount(mode="holes") {    
    if (mode == "holes") {
    	if (TI30_use_threaded_insert) {
    		translate([ 0, 0, -0.1 ]) cylinder( r=(TI30_through_hole_diameter/2), h=5.2 );
    	} else {
        	translate([ 0, 0, -0.1 ]) cylinder( r=screwhole_radius_M30_selftap, h=5.2 );
        }
    }  

    if (mode == "adds") {
    	//cylinder( r=(TI30_mount_diameter/2), h=5 );
    	translate([ -TI30_mount_diameter/2, -TI30_mount_diameter/2, 0 ]) cube([ TI30_mount_diameter, TI30_mount_diameter, 5 ]);

        translate([ TI30_mount_diameter+1, -TI30_mount_diameter/2, 0 ]) rotate([0, 0, 90 ]) prism(TI30_mount_diameter, 5, 5);
    }
}




/*
 * ***************************************************************************
 * this places mount holes for front accessory plates
 * ***************************************************************************
 */

module place_front_mount_grid(mode="holes") {
	if ((has_front_mount_grid) && (part == "box")) {
		for (updown = [ 8 : 8 : 24 ]) {
			for (across = [ 16 : 16 : (box_width/2)-12 ]) {
				translate([ (box_front_x-0.1), across, updown ]) rotate([ 0, 90, 0 ]) component_front_grid_mount(mode);
				translate([ (box_front_x-0.1), -across, updown ]) rotate([ 0, 90, 0 ]) component_front_grid_mount(mode);
			}
		}
	}

	if ((has_front_upper_mount_grid) && (part == "box")) {
		for (updown = [ height_of_box-10 : -8 : height_of_box-32 ]) {
			for (across = [ 16 : 16 : (box_width/2)-12 ]) {
				if (updown > 31) {
					translate([ (box_front_x-0.1), across, updown ]) rotate([ 0, 90, 0 ]) component_front_grid_mount(mode);
					translate([ (box_front_x-0.1), -across, updown ]) rotate([ 0, 90, 0 ]) component_front_grid_mount(mode);
				}
			}
		}
	}
}


/*
 * ***************************************************************************
 * this places mount holes for lid feature plate
 * ***************************************************************************
 */

module place_lid_mount_grid(mode="holes") {
	if ((has_lid_mount_grid) && (part == "lid")) {
		for (frontback = [ 0 : 16 : (box_length/2)-18 ]) {
			for (leftright = [ 16 : 16 : (box_width/2)-18 ]) {
				translate([ frontback, leftright, -0.1 ]) component_lid_grid_mount(mode, frontback, leftright);
				translate([ frontback, -leftright, -0.1 ]) component_lid_grid_mount(mode, frontback, -leftright);
				if (frontback > 0) {
					translate([ -frontback, leftright, -0.1 ]) component_lid_grid_mount(mode, -frontback, leftright);
					translate([ -frontback, -leftright, -0.1 ]) component_lid_grid_mount(mode, -frontback, -leftright);
				}
			}
		}
	}
}





/*
 * ***************************************************************************
 * this places wire portals around the periphery of the lid
 * ***************************************************************************
 */

module place_lid_wire_ports(mode="holes") {
    
    if ((has_wire_port_frontcenter) && (part == "lid")) {
        translate([ (lid_front_x - lid_lip_thickness - 10), 0, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_frontleft) && (part == "lid")) {
        translate([ (lid_front_x - lid_lip_thickness - 6), -16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_frontright) && (part == "lid")) {
        translate([ (lid_front_x - lid_lip_thickness - 6), 16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_backcenter) && (part == "lid")) {
        translate([ (lid_back_x + lid_lip_thickness + 10), 0, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_left) && (part == "lid")) {
        translate([ -15, (lid_L_y + lid_lip_thickness + 6 ), -0.1]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_right) && (part == "lid")) {
        translate([ -15, (lid_R_y - lid_lip_thickness - 6 ), -0.1]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_backleft) && (part == "lid")) {
        translate([ (lid_back_x + lid_lip_thickness + 6), -16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }
    
    if ((has_wire_port_backright) && (part == "lid")) {
        translate([ (lid_back_x + lid_lip_thickness + 6), 16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port(mode);
    }


    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff)
     * these optionally show the lid components when generally displaying the box itself.  the "component" builders have a special
     * mode called "lidcheck" that shows them in blue but otherwise similar to normal mode.  this mode is only available on parts
     * that might be reasonably expected to live on the lid.  
     *
     * note that the actual translatations/rotations of of these components is identical to the box placements above, excepting for the 
     * mode declaration ("lidcheck") and the fact that is called for part == "box" instead of "lid".  
     * the outer translate / rotate here takes care of moving all lidcheck pieces at once
     */
    
    translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {  
    
        if ((has_wire_port_frontcenter) && (part == "box")) {
            translate([ (lid_front_x - lid_lip_thickness - 10), 0, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_frontleft) && (part == "box")) {
            translate([ (lid_front_x - lid_lip_thickness - 6), -16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_frontright) && (part == "box")) {
            translate([ (lid_front_x - lid_lip_thickness - 6), 16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_backcenter) && (part == "box")) {
            translate([ (lid_back_x + lid_lip_thickness + 10), 0, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_left) && (part == "box")) {
            translate([ -15, (lid_L_y + lid_lip_thickness + 6 ), -0.1]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_right) && (part == "box")) {
            translate([ -15, (lid_R_y - lid_lip_thickness - 6 ), -0.1]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_backleft) && (part == "box")) {
            translate([ (lid_back_x + lid_lip_thickness + 6), -16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
        
        if ((has_wire_port_backright) && (part == "box")) {
            translate([ (lid_back_x + lid_lip_thickness + 6), 16, -0.1]) rotate([ 0, 0, 90 ]) component_lid_wire_port("lidcheck");
        }
    }


}