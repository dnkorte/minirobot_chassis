/*
 * Module: boards_components.scad  holds core modules for minirobot case maker
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
 * this makes a base for red tindie protoboard (small;  50 x 26mm)
 * its base is 1mm thick, and 52 x 28 mm
 * it has 4 M3 threaded insert mounts 43mm x 20.5mm spacing
 * 
 * the standard function uses 4 mount screws, lifted standard mount height
 * the _lifted function uses 2 (long axis) mounts + one small support on 
 *      other edge (no screws).  the whole assembly is lefted by "lift" mm
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

module component_small_red_protoboard(mode="adds") {


    // the "mount" itself handles the add/holes issues
    translate([ -(board_redproto_screw_x/2), -(board_redproto_screw_y/2), 1]) TI30a_mount(mode); 
    translate([ -(board_redproto_screw_x/2), +(board_redproto_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_redproto_screw_x/2), -(board_redproto_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_redproto_screw_x/2), +(board_redproto_screw_y/2), 1]) TI30a_mount(mode); 

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_redproto_length, board_redproto_width, 2, 1);
           
        translate([0, 0, 0]) linear_extrude(2) text("Red Proto", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    // visualizations for this device
    if (mode == "vis") {
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(vis_redproto_length, vis_redproto_width, 2, 1);
        }
    }
}


module component_small_red_protoboard_lifted(mode="adds", lift=17) {
    if (lift < 8) {
        component_small_red_protoboard(mode);

    } else {

        // the "mount" itself handles the add/holes issues
        translate([ -(board_redproto_screw_x/2), (board_redproto_screw_y/2), 1]) TI30a_mount(mode, lift); 
        translate([ +(board_redproto_screw_x/2), (board_redproto_screw_y/2), 1]) TI30a_mount(mode, lift);


        if (mode == "holes") {
            // no holes for this component
        }

        if (mode == "adds") {
            roundedbox(board_redproto_length, board_redproto_width, 2, 1);

            translate([ 0, -12, 1]) roundedbox(10, 3, 1, lift); 
            
            translate([0, 0, 0]) linear_extrude(2) text("Red Proto", 
                size=6,  halign="center", font = "Liberation Sans:style=Bold");
            translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
                size=6,  halign="center", font = "Liberation Sans:style=Bold");
        }
        
        // visualizations for this device
        if (mode == "vis") {
            if (show_internal_parts_for_collision_check) {
                translate([ 0, 0, 1 + lift ]) color([ 1, 0, 0 ]) 
                    roundedbox(vis_redproto_length, vis_redproto_width, 2, 1);
            }
        }
    }
}

/*
 * ********************************************************************************
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 * 
 * the standard function uses 4 mount screws, lifted standard mount height
 * the _lifted function uses 2 (long axis) mounts + one small support on 
 *      other edge (no screws).  the whole assembly is lefted by "lift" mm
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

module component_smallmint_protoboard(mode="adds") {

    // the "mount" itself handles the add/holes issues        
    translate([ -(board_smallmintproto_screw_x/2), -(board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode); 
    translate([ -(board_smallmintproto_screw_x/2), +(board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_smallmintproto_screw_x/2), -(board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_smallmintproto_screw_x/2), +(board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode); 

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
        
        translate([0, 0, 0]) linear_extrude(2) text("Small Mint", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }


    if (mode == "vis") {        
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
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
                roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
        }
    }
}

module component_smallmint_protoboard_lifted(mode="adds", lift=17) {
    if (lift < 8) {
        component_smallmint_protoboard(mode);

    } else {

        // the "mount" itself handles the add/holes issues
        translate([ -(board_smallmintproto_screw_x/2), (board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode, lift); 
        translate([ +(board_smallmintproto_screw_x/2), (board_smallmintproto_screw_y/2), 1]) TI30a_mount(mode, lift);



        if (mode == "holes") {
            // no holes for this component
        }

        if (mode == "adds") {

            roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
            
            translate([ 0, -15, 1]) roundedbox(10, 3, 1, lift); 
            
            translate([0, 0, 0]) linear_extrude(2) text("Small Mint", 
                size=6,  halign="center", font = "Liberation Sans:style=Bold");
            translate([0, -8, 0]) linear_extrude(2) text("Proto M3",
                size=6,  halign="center", font = "Liberation Sans:style=Bold");
        }
            
        if (mode == "vis") {  
            // visualizations for this device
            if (show_internal_parts_for_collision_check) {
                translate([ 0, 0, 1 + lift ]) color([ 1, 0, 0 ]) 
                    roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
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
                translate([ 0, 0, 1 + lift ]) color([ 0, 0, 1 ]) 
                    roundedbox(board_smallmintproto_length, board_smallmintproto_width, 2, 1);
            }
        }
        

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

module component_permaprotohalf(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ +(board_permaprotohalf_screw_x/2), 0, 1]) TI30a_mount(mode); 
    translate([ -(board_permaprotohalf_screw_x/2), 0, 1]) TI30a_mount(mode); 

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_permaprotohalf_length, board_permaprotohalf_width, 2, 1);
        
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
    }
    
    if (mode == "vis") {
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_permaprotohalf_length, board_permaprotohalf_width, 2, 1);
        }
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

module component_feather(mode="adds") {

    // the "mount" itself handles the add/holes issues
        translate([ -(board_feather_screw_x/2), -(board_feather_screw_y/2), 1]) TI25a_mount(mode); 
        translate([ -(board_feather_screw_x/2), +(board_feather_screw_y/2), 1]) TI25a_mount(mode);
        translate([ +(board_feather_screw_x/2), -(board_feather_screw_y/2), 1]) TI25a_mount(mode);
        translate([ +(board_feather_screw_x/2), +(board_feather_screw_y/2), 1]) TI25a_mount(mode); 

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_feather_length, board_feather_width, 2, 1);
        
        translate([0, 1, 0]) linear_extrude(2) text("Feather", 
            size=6, halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -8, 0]) linear_extrude(2) text("M2.5", 
            size=6, halign="center", font = "Liberation Sans:style=Bold");
    }
    
    
    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) visualize_featherstack();
        }
    }
}

module visualize_featherstack() {
        color([ 1, 0, 0 ]) 
        roundedbox(vis_feather_length, vis_feather_width, 2, 1);

    if (height_of_visualized_feathers == 2) {  
        translate([ 0, 0, 11 ]) color([ 1, 0, 0 ]) roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ 0, +10, 1   ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header
        translate([ 0, -10, 1   ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header
    }
    if (height_of_visualized_feathers == 3) {  
        translate([ 0, 0, 11 ]) color([ 1, 0, 0 ]) roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ 0, +10, 1  ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header
        translate([ 0, -10, 1 ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header

        translate([ 0, 0, + 11 + 11]) color([ 1, 0, 0 ]) roundedbox(vis_feather_length, vis_feather_width, 2, 1);
        translate([ 0, +10, 11 + 1 ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header
        translate([ 0, -10, 11 + 1 ]) color([ 0.4, 0.4, 0.4 ]) roundedbox(vis_feather_length, 2, 1, 10); // header
    }
}

module component_feather_lifted(mode, lift=17) {
    if (lift < 8) {
        component_feather(mode);

    } else {

        // the "mount" itself handles the add/holes issues
        translate([ -(board_feather_screw_x/2), (board_feather_screw_y/2), 1]) TI25a_mount(mode, lift); 
        translate([ +(board_feather_screw_x/2), (board_feather_screw_y/2), 1]) TI25a_mount(mode, lift);


        if (mode == "adds") {
            roundedbox(board_feather_length, board_feather_width, 2, 1);

            translate([ 0, -10, 1]) roundedbox(10, 3, 1, lift); 
            
            translate([0, 1, 0]) linear_extrude(2) text("Feather", 
                size=6, halign="center", font = "Liberation Sans:style=Bold");
            translate([0, -8, 0]) linear_extrude(2) text("M2.5", 
                size=6, halign="center", font = "Liberation Sans:style=Bold");
        }
         
        if (mode == "vis") {    
            // visualizations for this device
            if (show_internal_parts_for_collision_check) {
                translate([ 0, 0, 1 + lift ]) visualize_featherstack();
            }
        }
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

module component_feather_doubler(mode="adds") {


    // the "mount" itself handles the add/holes issues
    translate([ -(board_feather_doubler_screws_x), -(board_feather_doubler_screw_y/2), 1]) TI25a_mount(mode); 
    translate([ -(board_feather_doubler_screws_x), +(board_feather_doubler_screw_y/2), 1]) TI25a_mount(mode);
    translate([ +(board_feather_doubler_screws_x), -(board_feather_doubler_screw_y/2), 1]) TI25a_mount(mode);
    translate([ +(board_feather_doubler_screws_x), +(board_feather_doubler_screw_y/2), 1]) TI25a_mount(mode); 

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_feather_doubler_length, board_feather_doubler_width, 2, 1);
                
        translate([ -(board_feather_doubler_studs_x), -(board_feather_doubler_screw_y/2), 1]) support_stud(); 
        translate([ +(board_feather_doubler_studs_x), +(board_feather_doubler_screw_y/2), 1]) support_stud(); 
        
        translate([0, +8, 0]) linear_extrude(2) text("Feather", 
            size=8, , halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -4, 0]) linear_extrude(2) text("Doubler", 
            size=8, , halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -16, 0]) linear_extrude(2) text("M2.5", 
            size=8, , halign="center", font = "Liberation Sans:style=Bold");
    }

    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ -12, 0, 1 + TI30_default_height ]) rotate([ 0, 0, -90 ]) visualize_featherstack();
            translate([  12, 0, 1 + TI30_default_height ]) rotate([ 0, 0, -90 ]) visualize_featherstack();
        }
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

module component_feather_tripler(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -(board_feather_tripler_screws_x), -(board_feather_tripler_screw_y/2), 1]) TI25a_mount(mode); 
    translate([ -(board_feather_tripler_screws_x), +(board_feather_tripler_screw_y/2), 1]) TI25a_mount(mode);
    translate([ +(board_feather_tripler_screws_x), -(board_feather_tripler_screw_y/2), 1]) TI25a_mount(mode);
    translate([ +(board_feather_tripler_screws_x), +(board_feather_tripler_screw_y/2), 1]) TI25a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_feather_tripler_length, board_feather_tripler_width, 2, 1);
                
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
    }
        
    if (mode == "vis") {
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) rotate([ 0, 0, -90 ]) visualize_featherstack();
            translate([ -24, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ]) visualize_featherstack();
            translate([ 24, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) rotate([ 0, 0, -90 ]) visualize_featherstack();
        }
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

module component_tb6612(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -(board_tb6612_screw_x/2), board_tb6612_screw_y, 1]) TI25a_mount(mode);
    translate([ +(board_tb6612_screw_x/2), board_tb6612_screw_y, 1]) TI25a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_tb6612_length, board_tb6612_width, 2, 1);

        translate([ +12, -3, 1]) support_stud();
        translate([ -12, -3, 1]) support_stud();
           
        translate([0, -2, 0]) linear_extrude(2) text("6612", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -9, 0]) linear_extrude(2) text("M2.5",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
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

module component_L298motor_driver(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -(board_L298motor_screw_x/2), -(board_L298motor_screw_y/2), 1]) TI30a_mount(mode); 
    translate([ -(board_L298motor_screw_x/2), +(board_L298motor_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_L298motor_screw_x/2), -(board_L298motor_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_L298motor_screw_x/2), +(board_L298motor_screw_y/2), 1]) TI30a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_L298motor_length, board_L298motor_width, 2, 1);
           
        translate([0, 4, 0]) linear_extrude(2) text("L298 Motor", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -4, 0]) linear_extrude(2) text("Driver", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -12, 0]) linear_extrude(2) text("M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
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
}

/*
 * ***************************************************************************
 * this makes a base for Sparkfun QWIIC (I2C) motor driver board
 * its base is 1mm thick, and 44 x 44 mm
 * it has 4 M3 threaded insert mounts 37.5 x 37.5 mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 * it should be "added" to design, there are no holes needed at placement level
 *
 * purchase: https://www.sparkfun.com/products/15451
 * reference: https://learn.sparkfun.com/tutorials/hookup-guide-for-the-qwiic-motor-driver
 * this drives (2) DC brushed motors; up to 1.2A
 * ***************************************************************************
 */
board_qwiic_motor_length = 28;
board_qwiic_motor_width = 28;
board_qwiic_motor_screw_x = 20.3;
board_qwiic_motor_screw_y = 20.3;

module component_qwiic_motor_driver(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -(board_qwiic_motor_screw_x/2), -(board_qwiic_motor_screw_y/2), 1]) TI30a_mount(mode); 
    translate([ -(board_qwiic_motor_screw_x/2), +(board_qwiic_motor_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_qwiic_motor_screw_x/2), -(board_qwiic_motor_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_qwiic_motor_screw_x/2), +(board_qwiic_motor_screw_y/2), 1]) TI30a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_qwiic_motor_length, board_qwiic_motor_width, 2, 1);
           
        translate([0, 4, 0]) linear_extrude(2) text("QWIIC", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -4, 0]) linear_extrude(2) text("MotDrv", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -12, 0]) linear_extrude(2) text("M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + TI30_default_height ]) color([ 1, 0, 0 ]) 
                roundedbox(board_qwiic_motor_length, board_qwiic_motor_width, 2, 1);
            translate([ 0, 12, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
                roundedbox(6, 5, 1, 3);
            translate([ 0, -12, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
                roundedbox(6, 5, 1, 3);
            translate([ -11, -0, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
                roundedbox(6, 8, 1, 6);
            translate([ 11, -0, 1 + TI30_default_height + 1 ]) color([ 0.8, 0, 0 ]) 
                roundedbox(6, 12, 1, 6);
        }
    }
}


/*
 * ***************************************************************************
 * this makes a base for geared stepper driver board
 * its base is 1mm thick, and 35 x 32 mm
 * it has 4 M3 threaded insert mounts 29.5 x 26.5 mm spacing
 * 
 * the "upper" version is for a stacked upper board with only 2 screws (cantilevered mount)  
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

module component_gearedstepper_driver(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode); 
    translate([ -(board_gearedstepper_screw_x/2), +(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode);
    translate([ +(board_gearedstepper_screw_x/2), +(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_gearedstepper_length, board_gearedstepper_width, 2, 1);
                   
        translate([0, 4, 0]) linear_extrude(2) text("Geared", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -4, 0]) linear_extrude(2) text("Stepper", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -12, 0]) linear_extrude(2) text("M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
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
}

module component_gearedstepper_driver_upper(mode="adds") {
    lift_amount = 26;

    // the "mount" itself handles the add/holes issues
    translate([ -(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode, lift_amount); 
    translate([ -(board_gearedstepper_screw_x/2), +(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode, lift_amount);
    translate([ +(board_gearedstepper_screw_x/2), -(board_gearedstepper_screw_y/2), 1]) TI30a_mount(mode, lift_amount);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {

        roundedbox(board_gearedstepper_length, board_gearedstepper_width, 2, 1);
                   
        translate([0, 4, 0]) linear_extrude(2) text("Geared", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -4, 0]) linear_extrude(2) text("Stepper", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -12, 0]) linear_extrude(2) text("M3",
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
        // visualizations for this device
        if (show_internal_parts_for_collision_check) {
            translate([ 0, 0, 1 + lift_amount ]) color([ 1, 0, 0 ]) 
                roundedbox(board_gearedstepper_length, board_gearedstepper_width, 2, 1);
            
            translate([ -4, 5, 1 + lift_amount + 1 ]) color([ 0.8, 0, 0 ]) 
                roundedbox(10, 20, 1, 9);
            translate([ 5 , 6, 1 + lift_amount + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(6, 16, 1, 8);
            translate([ -11, 6, 1 + lift_amount + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(2, 10, 1, 8);
            translate([ -5, -10, 1 + lift_amount + 1 ]) color([ 0.8, 0.8, 0.8 ]) 
                roundedbox(10, 2, 1, 8);
            translate([ 12.5, -4, 1 + lift_amount + 1 ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=1.7, h=6);
            translate([ 12.5, 0, 1 + lift_amount + 1 ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=1.7, h=6);
            translate([ 12.5, 4, 1 + lift_amount + 1 ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=1.7, h=6);
            translate([ 12.5, 8, 1 + lift_amount + 1 ]) color([ 0.8, 0, 0 ]) 
                cylinder(r=1.7, h=6);
        }
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


module component_easydriver(mode="adds") {

    // the "mount" itself handles the add/holes issues
    translate([ -8.89, 0, 1]) TI30a_mount(mode); 
    translate([ 15.24, 3.81, 1]) TI30a_mount(mode);

    if (mode == "holes") {
        // no holes for this component
    }

    if (mode == "adds") {
        roundedbox(board_easydriver_length, board_easydriver_width, 2, 1);
           
        translate([-5, 5, 0]) linear_extrude(2) text("Sparkfun", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([+4, -3, 0]) linear_extrude(2) text("M3", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
        translate([0, -10, 0]) linear_extrude(2) text("EasyDriver", 
            size=6,  halign="center", font = "Liberation Sans:style=Bold");
    }
    
    if (mode == "vis") {    
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
}

