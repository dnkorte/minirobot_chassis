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
 * ***************************************************************************
 * this module arranges power components (batteries, boost converters, power
 * distribution strip) on bottom of lid; note these are specified by "package"
 * ***************************************************************************
 */

module place_power_components(mode="holes") {
    // for now this is fake - it just puts one demo configuration

    // holes

    // adds
    if ((power_package == 10) && (part == "lid")) {

        // (simplified) box for 1200 mAH LiPo (34 x 62 x 5mm)  note really skinny boxes would need to use 500 mAH
        translate([ 0, 0, lid_thickness]) 
            color([ 1,0,0 ]) 
            roundedbox( 38, 66, 2, 7);

        // (simplified) Power Distribution Stripboard (50 x 13mm) raised 3mm
        translate([ (38/2)+(13/2)+1, ((box_width/2) - (50/2) - (body_wall_thickness + lid_lip_thickness) -2 ), lid_thickness]) union() {
            color([ 1,0,0 ]) roundedbox( 13, 50, 2, 4);
            translate([ 0, 0, 5 ]) color([ 0.8, 0.8, 0.8 ]) roundedbox( 11, 48, 1, 8);
        }

        // (simplified) adafruit miniboost 5v (11 x 17 x 6mm) raised 3mm (showing portrait for wide boxes)
        translate([ (38/2)+(11/2)+1, -((box_width/2) - (17/2) - (body_wall_thickness + lid_lip_thickness) -2 ), lid_thickness]) 
            color([ 1,0,0 ]) 
            roundedbox( 11, 17, 1, 6+3);

        // (simplified) adafruit miniboost 5v (11 x 17 x 6mm) raised 3mm (showing landscape for skinny boxes)
        translate([ (38/2)+(17/2)+1, -((box_width/2) - (11/2) - (body_wall_thickness + lid_lip_thickness) -2 ), lid_thickness]) 
            color([ 1,1,0 ]) 
            roundedbox( 17, 11, 1, 6+3);

        // (simplified) amazon adjustable boost (22 x 44 x 13mm) raised 3mm (showing portrait for long boxes)
        translate([ -(38/2)-(22/2)-1, ((box_width/2) - (44/2) - (body_wall_thickness + lid_lip_thickness) -2 ), lid_thickness]) 
            color([ 1,0,0 ]) 
            roundedbox( 22, 44, 1, 13+3);

        // (simplified) amazon adjustable boost (22 x 44 x 13mm) raised 3mm (showing landscape on "top" of batt lid for short boxes)
        translate([ (38/2)-(44/2), 0, lid_thickness + 7]) 
            rotate ([ 0, 0, 90 ])
            color([ 1,1,0 ]) 
            roundedbox( 22, 44, 1, 13+3);

        // note for short boxes the front arcade button will need to be lowered
    }

    // lidcheck
    
}


/*
 * ***************************************************************************
 * this module arranges multiple components (typically PCBs) on bottom of box
 * ***************************************************************************
 */
module place_box_bottom_combo() {
    if ((box_bottom_PCB == "Dual TB6612") && (part == "box")) {
        translate([ -18, 0, body_bottom_thickness]) component_tb6612();
        translate([ +18, 0, body_bottom_thickness]) component_tb6612();
    }
    
    if ((box_bottom_PCB == "TB6612 and Mint") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612();
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_small_smallmint_protoboard();
    }    
    
    if ((box_bottom_PCB == "Dual TB6612 and Mint") && (part == "box")) {
        translate([ -30, 12, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        translate([ -30, -12, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_small_smallmint_protoboard();
    }
    
    if ((box_bottom_PCB == "TB6612 and Feather") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612();
        // tb6612 is 30mm feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather();
    }   
    
    if ((box_bottom_PCB == "Dual TB6612 and Feather") && (part == "box")) {
        translate([ -30, 12, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        translate([ -30, -12, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        // tb6612 is 30mm and feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather();
    }
        
    if ((box_bottom_PCB == "L298 and Mint") && (part == "box")) {
        translate([ -19, 0, body_bottom_thickness]) component_L298motor_driver();
        // L298 is 47x47mm and permaproto mint is 54 x 25mm
        translate([ +22, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_smallmint_protoboard();
    }
        
    if ((box_bottom_PCB == "L298 and Feather") && (part == "box")) {
        translate([ -19, 0, body_bottom_thickness]) component_L298motor_driver();
        // L298 is 47x47mm and feather is 52 x 25mm
        translate([ +25, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather();
    }
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver") && (part == "box")) {
        // board is 35mm x 32mm
        translate([ -19, 0, body_bottom_thickness]) component_gearedstepper_driver();
        translate([ +19, 0, body_bottom_thickness]) component_gearedstepper_driver();
    }
    
    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver") && (part == "box")) {
        // board is 48mm x 24mm
        translate([ 0, 12.5, body_bottom_thickness]) component_easydriver();
        translate([ 0, -12.5, body_bottom_thickness]) component_easydriver();
    }
    
    if ((box_bottom_PCB == "Dual Small-Mint") && (part == "box")) {
        // permaproto mint is 54mm x 33mm
        translate([ -17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_smallmint_protoboard();
        translate([ +17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_smallmint_protoboard();
    }    
    
    if ((box_bottom_PCB == "Dual Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -14, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ +14, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
    }  
    
    if ((box_bottom_PCB == "Triple Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ 0, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ +28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
    }
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

module place_red_protoboard() {
    
    if ((box_bottom_PCB == "Red Tindie Proto") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_small_red_protoboard();
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

module place_smallmint_protoboard() {
    
    if ((box_bottom_PCB == "PermaProto Small-Mint") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_small_smallmint_protoboard();
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

module place_permaprotohalf() {
    
    if ((box_bottom_PCB == "PermaProto HalfSize") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_permaprotohalf();
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

module place_feather() {
    
    if ((box_bottom_PCB == "Feather") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_feather();
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

module place_feather_doubler() {
    
    if ((box_bottom_PCB == "Feather Doubler") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_feather_doubler();
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

module place_feather_tripler() {
    
    if ((box_bottom_PCB == "Feather Tripler") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_feather_tripler();
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

module place_tb6612() {    
    if ((box_bottom_PCB == "TB6612") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_tb6612();
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

module place_L298motor_driver() {
    
    if ((box_bottom_PCB == "L298_motor_driver") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_L298motor_driver();
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

module place_gearedstepper_driver() {
    
    if ((box_bottom_PCB == "Geared Stepper Driver") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_gearedstepper_driver();
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

module place_easydriver() {
    
    if ((box_bottom_PCB == "Sparkfun EasyDriver") && (part == "box")) {
        translate([ 0, 0, body_bottom_thickness]) component_easydriver();
    }
}


/*
 * ****************************************************************************************
 * standard mini toggle switch (for visualization, a DPDT switch is shown)
 * purchase:  https://www.adafruit.com/product/3220   or equivalent
 * purchase:  https://www.amazon.com/yueton-Terminals-Position-Toggle-Switch/dp/B013DZB6CO/
 * *****************************************************************************************
 */

module place_mini_toggle_switch(mode="holes") {
    keep_away_distance = 14 / 2;
    
    if ((has_toggle_back_ctr) && (part == "box") && (has_arcade_back)) {
        translate([ box_back_x,  0, (height_of_box - lid_lip_height - keep_away_distance - 36)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
    }
    
    if ((has_toggle_back_ctr) && (part == "box") && (!has_arcade_back)) {
        translate([ box_back_x,  0, (height_of_box - lid_lip_height - 10)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
    }
        
    if ((has_toggle_back_left) && (part == "box")) {
        translate([ box_back_x,  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 10)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
    }
        
    if ((has_toggle_back_right) && (part == "box")) {
        translate([ box_back_x,  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 10)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
    }
        
    if ((has_toggle_lid_right) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_mini_toggle_switch(mode);
    }
        
    if ((has_toggle_lid_left) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_mini_toggle_switch(mode);
    }
    
  
 /* this is an experiment */       
    if ((has_toggle_lid_right) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_mini_toggle_switch("lidcheck");
    }
        
    if ((has_toggle_lid_left) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_mini_toggle_switch("lidcheck");
    }
 /* end of experiment */
}


/*
 * ****************************************************************************************
 * adafruit illuminated pushbuttons
 * purchase:  https://www.adafruit.com/product/1440   or equivalent in different colors
 * *****************************************************************************************
 */

module place_pushbuttons(mode="holes") {
    keep_away_distance = 20 / 2;
    
   if ((has_button_back_left) && (part == "box")) {
        translate([ box_back_x,  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 4  -keep_away_distance)]) rotate([ 0, -90, 0]) component_adafruit_illuminated_pushbutton(mode); 
    } 
    
    if ((has_button_back_right) && (part == "box")) {
        translate([ box_back_x,  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 4 - keep_away_distance)]) rotate([ 0, -90, 0]) component_adafruit_illuminated_pushbutton(mode); 
    } 
        
    if ((has_button_lid_left) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_adafruit_illuminated_pushbutton(mode);
    }
        
    if ((has_button_lid_right) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_adafruit_illuminated_pushbutton(mode); 
    } 
     
 /* this is an experiment */   
    if ((has_button_lid_right) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_adafruit_illuminated_pushbutton("lidcheck"); 
    }   
    if ((has_button_lid_left) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_adafruit_illuminated_pushbutton("lidcheck"); 
    } 
 /* end of experiment */
}



/*
 * ****************************************************************************************
 * large arcade style pushbutton (really soft push)
 * purchase:  https://www.amazon.com/Original-OBSF-30-Buttons-Arcade-Joystick-Console/dp/B01LYN7MTI/ 
 * *****************************************************************************************
 */

module place_arcade_buttons(mode="holes") {
    keep_away_distance = 36 / 2;
    
    if ( (has_arcade_back) && (part == "box")) {
        translate([ (box_length)/2,  0, (height_of_box - lid_lip_height - keep_away_distance) ]) 
            rotate([ 0, -90, 0]) 
            component_arcade_button(mode);
    }
        
    if ( (has_arcade_front) && (part == "box")) {
        // if box is tall enough we lower the button enouth to clear power power distribution strip
        // for boxes that are less than 70mm high we put button closer to top and user would need
        // to not install the power distribution board

        if (height_of_box < 70) {
            translate([ -(box_length)/2, 0, (height_of_box - lid_lip_height - keep_away_distance) ]) 
                rotate([ 0, 90, 0]) 
                component_arcade_button(mode); 
        } else {
            translate([ -(box_length)/2, 0, (height_of_box - lid_lip_height - keep_away_distance - 11) ]) 
                rotate([ 0, 90, 0]) 
                component_arcade_button(mode);         
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

module place_geared_stepper_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 8;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 6) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }
        
    
    if ( (motor_type == "Geared Stepper") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_geared_stepper_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_geared_stepper_motor(mode);
    }
}


/*
 * ****************************************************************************************
 * Sparkfun Stepper Motor Ungeared 7.5 degrees
 * purchase: https://www.sparkfun.com/products/10551
 * Note mount holes are tapped for M3 screws
 * *****************************************************************************************
 */

module place_sparkfun_stepper_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 0;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 6) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }        
    
    if ( (motor_type == "Sparkfun Stepper") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_sparkfun_stepper_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_sparkfun_stepper_motor(mode);
    }
}


/*
 * ****************************************************************************************
 * N20 motor
 * purchase: https://www.adafruit.com/product/4638
 * Note mount holes are tapped for M2 screws
 * *****************************************************************************************
 */

module place_n20_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 0;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 6) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }        
    
    if ( (motor_type == "N20 Geared with Encoder") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_n20_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_n20_motor(mode);
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

module place_TT_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 0;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 10) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }        
    
    if ( (motor_type == "Blue TT Horizontal") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_blue_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_blue_motor(mode);
    }     
    
    if ( (motor_type == "Blue TT Vertical") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_blue_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_blue_motor(mode);
    }      
    
    if ( (motor_type == "Yellow TT Horizontal") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_yellow_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_yellow_motor(mode);
    }     
    
    if ( (motor_type == "Yellow TT Vertical") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_yellow_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_yellow_motor(mode);
    }
      
    
    if ( (motor_type == "DFR TT with Encoder H") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_DFR_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_DFR_motor(mode);
    }     
    
    if ( (motor_type == "DFR TT with Encoder V") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_DFR_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_DFR_motor(mode);
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

module place_pololu_miniplastic_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 0;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 10) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }        
    
    if ( (motor_type == "Pololu MiniPlastic Horizontal") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);
    }     
    
    if ( (motor_type == "Pololu MiniPlastic Vertical") && (part == "box")) {
        // right-side motor
        translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-side motor
        translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
    }
}