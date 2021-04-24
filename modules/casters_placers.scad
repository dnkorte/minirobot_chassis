/*
 * Module:  casters_placers.scad  holds functions that create and place casters
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


// stance = 0; // [ 0:no casters, 1:2 casters with central wheels, 15:tripod 15mm from wall, 20:tripod 20mm from wall, 30:tripod 30mm from wall, 40:tripod 40mm from wall ]

// caster_id = 0; // [ 0:Custom Printed Peg 10 mm, 1:Pololu 3/8 in 10.1 mm, 2:Pololu 1/2 in 13.5 mm, 3:Custom Printed Peg 15 mm, 4:Custom Printed Peg 20 mm, 5:Pololu 3/4 in 22.4 mm, 6:Custom Printed Peg 25 mm, 7:Pololu 1 in, 8:flappy caster 1 in  ]

// 0:Custom Printed Peg 10 mm, 
// 1:Pololu 3/8 in 10.1 mm, 
// 2:Pololu 1/2 in 13.5 mm, 
// 3:Custom Printed Peg 15 mm, 
// 4:Custom Printed Peg 20 mm, 
// 5:Pololu 3/4 in 22.4 mm, 
// 6:Custom Printed Peg 25 mm, 
// 7:Pololu 1 in, 
// 8:flappy caster 1 in  ]

ground_clearances = [ 10, 	10.1, 	13.5, 	15, 	20, 	22.4, 	25, 	28, 	27 ];
caster_type 	 = [ "C", 	"P", 	"P", 	"C", 	"C", 	"P", 	"C", 	"R", 	"F" ];
caster_separation = [ 0, 	13.46, 	14.73, 	0, 		0, 		6.10, 	0,		12.19, 	0 ];

ground_clearance = ground_clearances[ caster_id ];


/*
 * ********************************************************************************
 * this makes a flap that holds a pololu ball caster.
 * it is assumed that this flap goes on bottom of box, and is sprung
 * 
 * its base is 3mm thick, and 40 mm long x 35 mm wide
 * it has a pivot tube at the "front"
 * 
 * @param: style = "A" for 3/4 in pololu caster; "B" for 1 in pololu caster
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * 
 * ********************************************************************************
 */
flap_length = 40;
flap_width = 35;
flap_thick = 3;
tang_length = 9;
tang_width = 23;
spring_socket_outer_dia = 11;
spring_socket_inner_dia = 7;
spring_socket_height = 6;
spring_pin_dia = 3;
spring_pin_height = 4;
spring_socket_inset = 6;
caster_mount_sep_A = 6.1;             // mount hole separation for pololu 3/4in caster
caster_mount_radius_B = 14/2;              // mount hole radius for pololu 1in caster
flappy_clamp_width = 10;
flappy_clamp_height = 15;
flappy_clamp_mount_tower_height = 5;

module part_caster_flap(style="A") {
    difference() {
        union() {
            // the "flap" is the big rounded rectangle that is the base
            // the "tang" is the tall extension that has the hole that passes the M4 pivot screw
            // in both cases the (length) is the x dimension, the (width) is the y dimension 
            translate([ 0, 0, 0 ]) roundedbox(flap_length, flap_width, 3, flap_thick);
            translate([ -(flap_length/2)-tang_length, -(tang_width/2), 0 ]) cube([ tang_length, tang_width, flap_thick+tang_length ]);
        }
        translate([ -(flap_length/2)-(tang_length/2), (flap_width/2), (flap_thick+(tang_length/2))]) rotate ([ 90, 0, 0 ]) cylinder( r=(5/2), h=flap_width);

        if (style == "A") {
            // mount holes for pololu 3/4 in plastic caster
            translate([ 0, -(caster_mount_sep_A/2), -0.1]) cylinder( r=(3.4/2), h=(flap_thick+0.2));
            translate([ 0, +(caster_mount_sep_A/2), -0.1]) cylinder( r=(3.4/2), h=(flap_thick+0.2));
        } else {
            // mount holes for pololu 1 in plastic caster (3 holes equally spaced on 14mm radius circle)
            translate([ -1, -caster_mount_radius_B, -0.1]) cylinder( r=(3.4/2), h=(flap_thick+0.2));
            translate([ (caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), -0.1]) cylinder( r=(3.4/2), h=(flap_thick+0.2));
            translate([ -(caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), -0.1]) cylinder( r=(3.4/2), h=(flap_thick+0.2));
        }
    }
    translate([ (flap_length/2)-spring_socket_inset, -((flap_width/2)-spring_socket_inset), flap_thick ]) spring_socket();
    translate([ (flap_length/2)-spring_socket_inset, ((flap_width/2)-spring_socket_inset), flap_thick ]) spring_socket();
}

module component_flappy_caster_mount(mode="adds") {

    if (mode=="holes") {
        // hole for flap + 2mm on each side and 2mm on each end, 1mm raised
        //translate([ -((flap_length+4)/2), -((flap_width+2)/2), 1 ]) cube([ (flap_length+4), (flap_width+2), body_bottom_thickness+0.2 ]);
        translate([ -((flap_length+4)/2)+2, -((flap_width+2)/2), 1 ]) cube([ (flap_length+4)-2, (flap_width+2), body_bottom_thickness+0.2 ]);

        // hole for flap + 2mm on each side and 2mm on pivot end LESS 3mm for bottom-stop ledge, for first 1mm of height
        //translate([ -((flap_length+4)/2), -((flap_width+2)/2), -0.1]) cube([ (flap_length+2-2), (flap_width+2), 1.2 ]);
        translate([ -((flap_length+4)/2)+2, -((flap_width+2)/2), -0.1]) cube([ (flap_length+2-2)-2, (flap_width+2), 1.2 ]);

        // hole for tang + 2mm on each side and 4mm on "left" (outside)
        translate([ -(flap_length/2)-tang_length, -((tang_width+4)/2), -0.1 ]) cube([ tang_length+6, tang_width+4, body_bottom_thickness+0.2 ]);

        // holes for mounting spring bracket
        translate([ (flap_length/2)-spring_socket_inset, -((flap_width/2)+6), -0.1 ]) cylinder(r=(4/2), h=6);
        translate([ (flap_length/2)-spring_socket_inset, +((flap_width/2)+6), -0.1 ]) cylinder(r=(4/2), h=6);
    }

    if (mode=="adds") {
        translate([ -(flap_length/2)-tang_length/2-4, (tang_width/2)+2, 0 ]) caster_pivot_block();
        translate([ -(flap_length/2)-tang_length/2-4, -(tang_width/2)-2-5, 0 ]) caster_pivot_block();
        translate([ (flap_length/2)-spring_socket_inset-5, -(flap_width/2)-6-5, 0 ]) 
        	cube([ flappy_clamp_width, flappy_clamp_width, flappy_clamp_mount_tower_height ]);
        translate([ (flap_length/2)-spring_socket_inset-5, (flap_width/2)+6-5, 0 ]) 
        	cube([ flappy_clamp_width, flappy_clamp_width, flappy_clamp_mount_tower_height ]);
    }
    
    if (mode=="vis") {
        // nothing to visualize
    }
}

module spring_socket() {
    difference() {
        cylinder( r=(spring_socket_outer_dia/2), h=spring_socket_height);
        translate([ 0, 0, -0.1 ]) cylinder( r=(spring_socket_inner_dia/2), h=(spring_socket_height+0.2 ));
    }
    cylinder( r=(spring_pin_dia/2), h=spring_pin_height);
}

module caster_pivot_block() {
    difference() {
        translate([ 0,0,0 ]) cube([ tang_length, 5, flap_thick+tang_length+1 ]);
        translate([ (tang_length/2), 6, flap_thick+(tang_length/2)+1 ]) rotate ([ 90, 0, 0 ]) cylinder( r=(5/2), h=8);
    }
}

module part_spring_clamp() {
    difference() {
        union() {
            translate([ -(57/2),-5, 0 ]) cube ([ 57, flappy_clamp_width, 3 ]);

            translate([ (flap_width/2)+6-5, -5, 3 ]) cube([ flappy_clamp_width, flappy_clamp_width, flappy_clamp_height ]);
            translate([ -(flap_width/2)-6-5, -5, 3 ]) cube([ flappy_clamp_width, flappy_clamp_width, flappy_clamp_height ]);

            translate([ +((flap_width/2)-spring_socket_inset), 0, body_bottom_thickness ]) spring_socket();
            translate([ -((flap_width/2)-spring_socket_inset), 0, body_bottom_thickness ]) spring_socket();
        }
        translate([ +((flap_width/2)+6), 0, -0.1 ]) cylinder(r=(4/2), h=22);
        translate([ -((flap_width/2)+6), 0, -0.1 ]) cylinder(r=(4/2), h=22);
    }
    
}




// stance = 0; // [ 0:no casters, 1:2 casters with central wheels, 15:tripod 15mm from wall, 20:tripod 20mm from wall, 30:tripod 30mm from wall, 40:tripod 40mm from wall ]



module place_caster_mounts(mode="holes") {

	casterID = caster_id;

	if (stance == 1) {
		if (caster_type[casterID] == "F") {
			translate([ (box_front_x + 36), 0, 0 ]) component_caster_mount(mode, 7);	// force a pololu 1 in roller
			translate([ (box_back_x - 26), 0, 0 ]) component_caster_mount(mode, 8);		// force the flappy mount
		} else {
			translate([ (box_front_x + 20), 0, 0 ]) component_caster_mount(mode, casterID);
			translate([ (box_back_x - 20), 0, 0 ]) component_caster_mount(mode, casterID);
		}
	}

	if (stance > 1) {	
		if (caster_type[casterID] == "F") {
			translate([ (box_back_x - 26), 0, 0 ]) component_caster_mount(mode, casterID);
		} else {
			translate([ (box_back_x - 20), 0, 0 ]) component_caster_mount(mode, casterID);
		}
	}

}

module component_caster_mount(mode="holes", casterID) {

	if ((mode == "holes") && (part == "box")) {
		if (caster_type[ casterID ] == "C") {
			// custom peg, just needs single hole - an M3 passthru
			translate([ 0, 0, -0.1 ]) cylinder( r=screwhole_radius_M30_passthru, h=6.2 );
		}

		if (caster_type[ casterID ] == "P") {
			// 2-hole pololu caster -- needs M2 threaded insert
			translate([ 0, (caster_separation[casterID]/2), -0.1 ]) cylinder( r=(TI20_through_hole_diameter/2) , h=6.2 );
			translate([ 0, -(caster_separation[casterID]/2), -0.1 ]) cylinder( r=(TI20_through_hole_diameter/2) , h=6.2 );
		}

		if (caster_type[ casterID ] == "R") {
            // mount holes for pololu 1 in plastic caster (3 holes equally spaced on 14mm radius circle)-- needs M3 threaded insert
            translate([ -1, -caster_mount_radius_B, -0.1]) cylinder( r=(TI30_through_hole_diameter/2), h=6.2);
            translate([ (caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), -0.1]) cylinder( r=(TI30_through_hole_diameter/2), h=6.2);
            translate([ -(caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), -0.1]) cylinder( r=(TI30_through_hole_diameter/2), h=6.2);
		}

		if (caster_type[ casterID ] == "F") {
            // flappy mount
            component_flappy_caster_mount(mode);
		}

	}

	if ((mode == "adds") && (part == "box")) {
		if (caster_type[ casterID ] == "C") {
			// custom peg, just needs single hole - an M3 passthru
			cylinder( r=(TI30_mount_diameter/2), h=6 );
		}

		if (caster_type[ casterID ] == "P") {
			// 2-hole pololu caster -- needs M2 threaded insert
			translate([ 0, (caster_separation[casterID]/2), 0 ]) cylinder( r=(7/2) , h=6 );
			translate([ 0, -(caster_separation[casterID]/2), 0 ]) cylinder( r=(7/2) , h=6 );
		}

		if (caster_type[ casterID ] == "R") {
            // mount holes for pololu 1 in plastic caster (3 holes equally spaced on 14mm radius circle) -- needs M3 threaded insert
            translate([ -1, -caster_mount_radius_B, 0 ]) cylinder( r=(TI30_mount_diameter/2), h=6);
            translate([ (caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), 0 ]) cylinder( r=(TI30_mount_diameter/2), h=6);
            translate([ -(caster_mount_radius_B*cos(30))-1, (caster_mount_radius_B*sin(30)), 0 ]) cylinder( r=(TI30_mount_diameter/2), h=6);
		}

		if (caster_type[ casterID] == "F") {
            // flappy mount
            component_flappy_caster_mount(mode);
		}

	}

	if ((mode == "vis") && (show_wheels_and_casters) && (part == "box")) {
		if (caster_type[ casterID] == "F") {
			translate([ 0, 0, 1 ]) color("LightSkyBlue") part_caster_flap("B");
			translate([ 0, 0, -ground_clearance/2 ]) color("LightSkyBlue") cylinder( r=(ground_clearance/2)+2, h=ground_clearance/2);		
			translate([ 0, 0, -ground_clearance/2 ]) color("LightSkyBlue") sphere( r=ground_clearance/2);

			translate([ (flap_length/2)-spring_socket_inset, 0, flappy_clamp_height+flappy_clamp_mount_tower_height+body_bottom_thickness ]) 
				color("LightSkyBlue") rotate([ 180, 0, 90 ]) part_spring_clamp(); 

		} else {
			translate([ 0, 0, -ground_clearance/2 ]) color("LightSkyBlue") cylinder( r=(ground_clearance/2)+2, h=ground_clearance/2);	
			translate([ 0, 0, -ground_clearance/2 ]) color("LightSkyBlue") sphere( r=ground_clearance/2);

		}
	}
}