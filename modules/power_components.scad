/*
 * Module:  power_components.scad  holds functions that create and place casters
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
 * **************************************************************************
 * LiPo Battery boxes
 * **************************************************************************
 */

battbox_wall_thickness = 2;
battbox_lid_thickness = 3;

batt_lipo_1200_width = 35;
batt_lipo_1200_length = 63;
batt_lipo_1200_thick = 6;


module component_battbox_lipo_1200(mode="holes") {
    // Dimensions: 34mm x 62mm x 5mm / 1.3" x 2.4" x 0.2"
    // this is generated in vertical orientation, as it would sit against front of box (portrait)
    // Purchase: https://www.adafruit.com/product/258

    length_of_battbox = min(max_length_for_battbox, (batt_lipo_1200_length));

    if (mode == "holes") {
        translate([ 0, 0, -0.1 ]) roundedbox( batt_lipo_1200_thick, batt_lipo_1200_width, 1, h=lid_thickness+0.2 );
    }
    
    if (mode == "adds") {
        difference() {
            roundedbox( batt_lipo_1200_thick + (2*battbox_wall_thickness), batt_lipo_1200_width + (2*battbox_wall_thickness), 2, length_of_battbox );
            roundedbox( batt_lipo_1200_thick, batt_lipo_1200_width, 1, length_of_battbox+0.2 );
            // make a through-hole at bottom for M3 retaining screw
            translate([ 0, 0, (length_of_battbox-3) ]) 
                rotate([ 0, -90, 0 ])
                translate([ 0, 0, -9 ])
                    cylinder(r=screwhole_radius_M30_selftap, h=18); 
        }   
    }

    if (mode == "vis") {
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, length_of_battbox - batt_lipo_1200_length - 6 ]) color([ 1, 0, 0 ]) 
                roundedbox( batt_lipo_1200_thick, batt_lipo_500_width, 1, batt_lipo_1200_length+0.2 );
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
            color([ 0, 0, 1 ])
                roundedbox( batt_lipo_1200_thick + (2*battbox_wall_thickness), batt_lipo_1200_width + (2*battbox_wall_thickness), 2, length_of_battbox );
        }      
    }    
}


batt_lipo_500_width = 30;
batt_lipo_500_length = 37;
batt_lipo_500_thick = 5.75;

module component_battbox_lipo_500(mode="holes") {
    // Dimensions: 30mm x 37mm x 6mm / 1.3" x 2.4" x 0.2"
    // this is generated in vertical orientation, as it would sit against front of box (portrait)
    // Purchase: https://www.adafruit.com/product/1578

    length_of_battbox = min(max_length_for_battbox, (batt_lipo_500_length));
    echo(length_of_battbox, batt_lipo_500_length, max_length_for_battbox);

    if (mode == "holes") {
        translate([ 0, 0, -0.1 ]) roundedbox( batt_lipo_500_thick, batt_lipo_500_width, 1, lid_thickness+0.2 );
    }
    
    if (mode == "adds") {
        difference() {
            roundedbox( batt_lipo_500_thick + (2*battbox_wall_thickness), batt_lipo_500_width + (2*battbox_wall_thickness), 2, length_of_battbox );
            roundedbox( batt_lipo_500_thick, batt_lipo_500_width, 1, length_of_battbox+0.2 );
            // make a through-hole at bottom for M3 retaining screw
            translate([ 0, 0, (length_of_battbox-3) ]) 
                rotate([ 0, -90, 0 ])
                translate([ 0, 0, -6 ])
                    cylinder(r=screwhole_radius_M30_selftap, h=12); 
        }  
    }

    if (mode == "vis") {
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, length_of_battbox - batt_lipo_500_length - 6 ]) color([ 1, 0, 0 ]) 
                roundedbox( batt_lipo_500_thick, batt_lipo_500_width, 1, batt_lipo_500_length+0.2 );
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
            color([ 0, 0, 1 ])
                roundedbox( batt_lipo_500_thick + (2*battbox_wall_thickness), batt_lipo_500_width + (2*battbox_wall_thickness), 2, length_of_battbox );
        }      
    }    
}


batt_lipo_cyl_dia = 18;
batt_lipo_cyl_length = 69;

module component_battbox_lipo_cylinder(mode="holes") {
    // Size: 69mm x 18mm dia 
    // Purchase: https://www.adafruit.com/product/1781

    length_of_battbox = min(max_length_for_battbox, (batt_lipo_cyl_length));
    
    if (mode == "holes") {
        translate([ 0, 0, -0.1 ]) cylinder(r=(batt_lipo_cyl_dia/2)+1, h=lid_thickness+0.2);
    }
    
    if (mode == "adds") {
        translate([ 0, 0, lid_thickness ]) difference() {
            // make outer walls of battery tube
            cylinder(r=(batt_lipo_cyl_dia/2)+battbox_wall_thickness, h=(length_of_battbox));  
            // hollow out the battery tube 
            translate([ 0, 0, -0.1 ]) cylinder(r=(batt_lipo_cyl_dia/2)+1, h=70);   
            // make a through-hole at bottom for M3 retaining screw
            translate([ 0, 0, (length_of_battbox-3) ]) 
                rotate([ 0, -90, 45 ])
                translate([ 0, 0, -20 ])
                    cylinder(r=screwhole_radius_M30_selftap, h=40); 
        }
    }

    if (mode == "vis") {
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, length_of_battbox - batt_lipo_cyl_length - 3 ]) color([ 1, 0, 0 ]) cylinder(r=(batt_lipo_cyl_dia/2), h=batt_lipo_cyl_length);
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
            translate([ 0, 0, lid_thickness ]) color([ 0, 0, 1 ]) cylinder(r=(batt_lipo_cyl_dia/2)+battbox_wall_thickness, h=(length_of_battbox));
        }      
    }   
}



/*
 * ***************************************************************************
 * this makes a base for schmartboard power distribution stripboard
 * its base is 1mm thick, and 12.7mm x 50.8mm (0.5 x 2in) 
 * it has 2 M3 threaded insert mounts on 43.2mm (1.7in) spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.tindie.com/products/Schmart/through-hole-power-ground-strip-05x2-grid/
 * purchase: https://www.digikey.com/en/products/detail/schmartboard-inc/201-0100-01/9559296
 * ***************************************************************************
 */
board_schmart_length = 50.8;
board_schmart_width = 12.7;
board_schmart_mount_spacing = 43.2;

module component_schmart(mode="adds") {

    // the "mount" itself handles the add/holes issues 
    translate([ -(board_schmart_mount_spacing/2), 0, 1]) TI30a_mount(mode);
    translate([ +(board_schmart_mount_spacing/2), 0, 1]) TI30a_mount(mode);
    
    if (mode == "holes") {
        // no holes for this device
    }
    
    if (mode == "adds") {
        roundedbox(board_schmart_length, board_schmart_width, 2, 1);
           
        translate([0, -3, 0]) linear_extrude(2) text("Buss M3", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }

     if (mode == "vis") {   
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_schmart_length, board_schmart_width, 2, 1);

            translate([ 0, +4.3, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(40, 2, 1, 8);
            translate([ 0, +1.4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(34, 2, 1, 8);
            translate([ 0, -1.4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(34, 2, 1, 8);
            translate([ 0, -4.3, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(40, 2, 1, 8);
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
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 0, 0, 1 ]) 
                roundedbox(board_schmart_length, board_schmart_width, 2, 1);

            translate([ 0, +4.3, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(40, 2, 1, 8);
            translate([ 0, +1.4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(34, 2, 1, 8);
            translate([ 0, -1.4, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(34, 2, 1, 8);
            translate([ 0, -4.3, 1 + TI30_default_height + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(40, 2, 1, 8);
        }      
    }
}



/*
 * ***************************************************************************
 * this makes a base for amazon adjustable boost converter
 * its base is 1mm thick, and 22mm x 44mm 
 * it has 2 M3 threaded insert mounts diagonally on 15mm x 30mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.amazon.com/Converter-Voltage-Adjustable-Step-up-Circuit/dp/B07XG323G8 or equiv
 *
 * ***************************************************************************
 */
board_amazon_boost_length = 44;
board_amazon_boost_width = 22;
mount_amazon_boost_x = 30;
mount_amazon_boost_y = 15;

module component_amazon_boost(mode="adds") {

    // the "mount" itself handles the add/holes issues 
    translate([ -mount_amazon_boost_x/2, mount_amazon_boost_y/2, 1]) TI30a_mount(mode);
    translate([ mount_amazon_boost_x/2, -mount_amazon_boost_y/2, 1]) TI30a_mount(mode);
    
    if (mode == "holes") {
        // no holes for this device
    }
    
    if (mode == "adds") {
        roundedbox(board_amazon_boost_length, board_amazon_boost_width, 2, 1);
           
        translate([ 4, +2, 0]) linear_extrude(2) text("Amazon", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([-2, -6, 0]) linear_extrude(2) text("Boost M3", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }

    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_amazon_boost_length, board_amazon_boost_width, 2, 1);
            translate([ -7, 5, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                roundedbox(10, 5, 1, 10);       // trimpot
            translate([ -7, -4, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                roundedbox(12, 12, 1, 7);       // toroid
            translate([ 6, -4, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                roundedbox(10, 8, 1, 4);       // ic
            translate([ 17, 0, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=4, h=10);       // cap
            translate([ -17, 0, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=4, h=10);       // cap
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
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 0, 0, 1 ]) 
                roundedbox(board_amazon_boost_length, board_amazon_boost_width, 2, 1);
            translate([ -7, 5, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                roundedbox(10, 5, 1, 10);       // trimpot
            translate([ -7, -4, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                roundedbox(12, 12, 1, 7);       // toroid
            translate([ 6, -4, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                roundedbox(10, 8, 1, 4);       // ic
            translate([ 17, 0, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                cylinder(r=4, h=10);       // cap
            translate([ -17, 0, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                cylinder(r=4, h=10);       // cap
        }      
    }
}


/*
 * ***************************************************************************
 * this makes a base for pololu boost converter
 * its base is 1mm thick, and 15.24mm x 40.64mm (0.6in x 1.6in)
 * it has 2 M2 threaded insert mounts diagonally on 10.9mm x 36.3 spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.amazon.com/Converter-Voltage-Adjustable-Step-up-Circuit/dp/B07XG323G8 or equiv
 *
 * ***************************************************************************
 */
board_pololu_boost_length = 42;
board_pololu_boost_width = 17;
mount_pololu_boost_x = 36.3;
mount_pololu_boost_y = 10.9;

module component_pololu_boost(mode="adds") {

    // the "mount" itself handles the add/holes issues 
    translate([ -mount_pololu_boost_x/2, mount_pololu_boost_y/2, 1]) TI20a_mount(mode);
    translate([ mount_pololu_boost_x/2, -mount_pololu_boost_y/2, 1]) TI20a_mount(mode);
    
    if (mode == "holes") {
        // no holes for this device
    }
    
    if (mode == "adds") {
        roundedbox(board_pololu_boost_length, board_pololu_boost_width, 2, 1);
           
        translate([ 4, +2, 0]) linear_extrude(2) text("Pololu", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([-2, -6, 0]) linear_extrude(2) text("Boost M2", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        
    }

    if (mode == "vis") {
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_amazon_boost_length, board_amazon_boost_width, 2, 1);
            translate([ -7, 5, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                roundedbox(10, 10, 1, 5);       // transistor
            translate([ 7, -4, 1 + TI30_default_height ]) color([ 0.8, 0, 0 ]) 
                roundedbox(7, 7, 1, 7);       // trimpot
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
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 0, 0, 1 ]) 
                roundedbox(board_amazon_boost_length, board_amazon_boost_width, 2, 1);
            translate([ -7, 5, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                roundedbox(10, 10, 1, 5);       // transistor
            translate([ 7, -4, 1 + TI30_default_height ]) color([ 0, 0, 0.8 ]) 
                roundedbox(7, 7, 1, 7);       // trimpot
        }      
    }
}


/*
 * ***************************************************************************
 * this makes a base for adafruit buck converter (3.3v output)
 * its base is 1mm thick, and 17mm x 10mm 
 * it has 1 M2.5 threaded insert mount centered at one end
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/4711   3.3v buck 1.2A from 3.4 - 5.5v input
 * purchase: https://www.adafruit.com/product/4683   3.3v buck 1.2A from 4.5 - 21v input
 *
 * ***************************************************************************
 */
board_adafruit_minibuck_length = 19;
board_adafruit_minibuck_width = 11;

module component_adafruit_minibuck(mode="adds") {

    // the "mount" itself handles the add/holes issues     
    translate([ -7, 0, 1]) M25_short_mount(mode, 5);
    
    if (mode == "holes") {
        // no holes for this device
    }
    
    if (mode == "adds") {
        roundedbox(board_adafruit_minibuck_length, board_adafruit_minibuck_width, 2, 1);
           
        translate([2, -3, 0]) linear_extrude(2) text("M25", 
            size=5,  halign="center", font = "Liberation Sans:style=Bold");
    }

    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + 5 ]) color([ 1, 0, 0 ]) 
                roundedbox(board_adafruit_minibuck_length, board_adafruit_minibuck_width, 2, 1);
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
            translate([ 0, 0, 1 + 5 ]) color([ 0, 0, 1 ]) 
                roundedbox(board_adafruit_minibuck_length, board_adafruit_minibuck_width, 2, 1);
        }      
    }
}

/*
 * ***************************************************************************
 * this makes a base for adafruit boost converter (5v output)
 * its base is 1mm thick, and 18mm x 11.3mm 
 * it has 1 M2.5 threaded insert mount at left edge of one end
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.adafruit.com/product/4654  5v boost 1.0A from 2-5v input
 *
 * ***************************************************************************
 */
board_adafruit_miniboost_length = 20;
board_adafruit_miniboost_width = 12;

module component_adafruit_miniboost(mode="adds") {

    // the "mount" itself handles the add/holes issues 
    translate([ -7, -3, 1]) M25_short_mount(mode, 5);
    
    if (mode == "holes") {
        // no holes for this device
    }
    
    if (mode == "adds") {
        roundedbox(board_adafruit_miniboost_length, board_adafruit_miniboost_width, 2, 1);
           
        translate([2, -3, 0]) linear_extrude(2) text("M25", 
            size=5,  halign="center", font = "Liberation Sans:style=Bold");
    }
       
    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + 5 ]) color([ 1, 0, 0 ]) 
                roundedbox(board_adafruit_minibuck_length, board_adafruit_minibuck_width, 2, 1);
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
            translate([ 0, 0, 1 + 5 ]) color([ 0, 0, 1 ]) 
                roundedbox(board_adafruit_minibuck_length, board_adafruit_minibuck_width, 2, 1);  
        }      
    }
}
