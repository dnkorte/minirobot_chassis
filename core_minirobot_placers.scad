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
 * these  modules arrange power components (batteries, boost converters, power
 * distribution strip) on bottom of lid; note these are specified by "package"
 * ***************************************************************************
 */

module place_battery(mode="holes") {  

    // TODO: needs to adjust height of cylinder to accomodate max height allowed (per box height)

    wall_standoff = body_wall_thickness + lid_lip_thickness + ((batt_lipo_cyl_dia + (2*battbox_wall_thickness))/2);

    if ((battery == "2200 mAH Cylindrical Front Right") && (part == "lid")) {
        translate([ lid_front_x - wall_standoff, (box_width/2) - wall_standoff, 0 ]) component_battbox_lipo_cylinder(mode);
    }

    if ((battery == "2200 mAH Cylindrical Front Center") && (part == "lid")) {
        translate([ lid_front_x - wall_standoff -3.5, 0, 0 ]) component_battbox_lipo_cylinder(mode);
    }

        
    /* visualization for lidcheck */   

    if ((battery == "2200 mAH Cylindrical Front Right") && (part == "box")) {
        translate([ box_front_x + wall_standoff, (box_width/2) - wall_standoff, height_of_box ]) rotate([ 0, 180, 0 ]) component_battbox_lipo_cylinder("lidcheck");
    }
         
    if ((battery == "2200 mAH Cylindrical Front Center") && (part == "box")) {
        translate([ box_front_x + wall_standoff + 3.5, 0, height_of_box ]) rotate([ 0, 180, 0 ]) component_battbox_lipo_cylinder("lidcheck");
    }

}

module place_power_distribution(mode="holes") {

    if ((power_distribution_buss == "Long Way") && (part == "lid")) {
        translate([ 0, 0, lid_thickness ]) component_schmart();
    }

    if ((power_distribution_buss == "Long Way Set Back") && (part == "lid")) {
        translate([ -11, 0, lid_thickness ]) component_schmart();
    }

    if ((power_distribution_buss == "Wide Way") && (part == "lid")) {
        translate([ (lid_front_x - 37), 0, lid_thickness ]) rotate([ 0, 0, 90 ]) component_schmart();
    }


    // TODO: still needs lidcheck
}


module place_boost_buck(mode="holes") {
    wall_standoff = body_wall_thickness + lid_lip_thickness;

    if ((boost_converter_for_motors == "Front Adjustable") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff -14), -((box_width/2) - wall_standoff -23), lid_thickness ]) rotate([ 0, 0, 90 ]) component_amazon_boost();
    }

    if ((boost_converter_for_motors == "Side Adjustable") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff -26), -((box_width/2) - wall_standoff - 13), lid_thickness ]) component_amazon_boost();
    }

    if ((boost_converter_for_motors == "Front Pololu") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff - 14), -((box_width/2) - wall_standoff -23), lid_thickness ]) rotate([ 0, 0, 90 ]) component_pololu_boost();
    }

    if ((boost_converter_for_motors == "Side Pololu") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff - 24 ), -((box_width/2) - wall_standoff - 13), lid_thickness ]) component_pololu_boost();
    }


    if (power_distribution_buss == "Wide Way") {

        if ((want_3v_buck) && (part == "lid")) {
            translate([ (lid_front_x - 54), -6, lid_thickness ]) component_adafruit_minibuck();
        }

        if ((want_5v_boost) && (part == "lid")) {
            translate([ (lid_front_x - 54), 6, lid_thickness ]) component_adafruit_miniboost();
        }

    } else {

        if ((want_3v_buck) && (part == "lid")) {
            translate([ 0, -13, lid_thickness ]) component_adafruit_minibuck();
        }

            if ((want_5v_boost) && (part == "lid")) {
                translate([ 0, 13, lid_thickness ]) component_adafruit_miniboost();
            }


            if ((want_5v_boost) && (part == "lid")) {
                translate([ 0, 13, lid_thickness ]) component_adafruit_miniboost();
            }
    }




    // TODO: still needs lidcheck
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
    
    if ((box_bottom_PCB == "TB6612 and Small-Mint") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612();
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_smallmint_protoboard();
    }    
    
    if ((box_bottom_PCB == "Dual TB6612 and Small-Mint") && (part == "box")) {
        translate([ -30, 3, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        translate([ -30, -18, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
    }
    
    if ((box_bottom_PCB == "TB6612 and Feather") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612();
        // tb6612 is 30mm feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
    }   
    
    if ((box_bottom_PCB == "Dual TB6612 and Feather") && (part == "box")) {
        translate([ -30, 3, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        translate([ -30, -18, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612();
        // tb6612 is 30mm and feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
    }


//QWIIC I2C Motor Driver
//QWIIC I2C Motor Driver + Small-Mint
//QWIIC I2C Motor Driver + Feather

    
    if ((box_bottom_PCB == "QWIIC I2C Motor Driver + Small-Mint") && (part == "box")) {
        translate([ -28, -5, body_bottom_thickness]) rotate([ 0, 0, -90 ]) rotate([ 0, 0, 90 ]) component_qwiic_motor_driver();
        // qwiic driver is 25mm square and permaproto mint is 54mm
        if (box_length > 90) {
            translate([ +17, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
        } else {
            translate([ +14, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
        }
    }

    if ((box_bottom_PCB == "QWIIC I2C Motor Driver + Feather") && (part == "box")) {
        translate([ -27, -5, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_qwiic_motor_driver();
        // qwiic driver is 25mm square and feather is 52mm
        if (box_length > 90) {
            translate([ (box_back_x - 32), 0, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
        } else {
            translate([ +14, 0, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
        }
    }  



        
    if ((box_bottom_PCB == "L298 and Small-Mint") && (part == "box")) {
        //translate([ -19, 0, body_bottom_thickness]) component_L298motor_driver();
        translate([ (box_front_x+28), 0, body_bottom_thickness ]) component_L298motor_driver();
        // L298 is 47x47mm and permaproto mint is 54 x 25mm
        if (box_length > 110) {
            translate([ +22, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
        } else {     
            translate([ +22, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(board_raise_amount);
        }
    }
        
    if ((box_bottom_PCB == "L298 and Feather") && (part == "box")) {
        translate([ (box_front_x+28), 0, body_bottom_thickness]) component_L298motor_driver();
        // L298 is 47x47mm and feather is 52 x 25mm
        translate([ +25, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather_lifted(board_raise_amount);
    }
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver") && (part == "box")) {
        // board is 35mm x 32mm
        translate([ -19, 0, body_bottom_thickness]) component_gearedstepper_driver();
        translate([ +19, 0, body_bottom_thickness]) component_gearedstepper_driver();
    } 
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver and Small-Mint") && (part == "box")) {
        // board is 35mm x 32mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(board_raise_amount); 
        translate([ (box_back_x-39), -5, body_bottom_thickness]) component_gearedstepper_driver_upper();
        translate([ (box_back_x-24), +5, body_bottom_thickness]) rotate([ 0, 0, 180 ])component_gearedstepper_driver();
    } 
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver and Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 14), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather(); 
        translate([ (box_back_x-47), -5, body_bottom_thickness]) component_gearedstepper_driver_upper();
        translate([ (box_back_x-32), +5, body_bottom_thickness]) rotate([ 0, 0, 180 ])component_gearedstepper_driver();
    } 
    
    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver") && (part == "box")) {
        // board is 48mm x 24mm
        translate([ 0, 12.5, body_bottom_thickness]) component_easydriver();
        translate([ 0, -12.5, body_bottom_thickness]) component_easydriver();
    }

    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver + Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 14), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather(); 
        translate([ 6, 12.5, body_bottom_thickness]) component_easydriver();
        translate([ 6, -12.5, body_bottom_thickness]) component_easydriver();
    }

    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver + Small-Mint") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 20), -((box_width/2)-31), body_bottom_thickness]) 
            rotate([ 0, 0, 90 ]) component_smallmint_protoboard_lifted(board_raise_amount); 
        //translate([ (box_back_x + body_wall_thickness -24), 0, body_bottom_thickness]) 
        //    rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(board_raise_amount); 
        translate([ 15, 12.5, body_bottom_thickness]) component_easydriver();
        translate([ 15, -12.5, body_bottom_thickness]) component_easydriver();
    }
    
    if ((box_bottom_PCB == "Dual Small-Mint") && (part == "box")) {
        translate([ -17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(board_raise_amount);
        translate([ +17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(board_raise_amount);
    }   
            
    if ((box_bottom_PCB == "3 Small-Mint Inline") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -34, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ 0, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ +34, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
    }

    if ((box_bottom_PCB == "Dual Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -6, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) rotate([ 0, 0, 180 ]) component_small_red_protoboard_lifted(board_raise_amount);
        translate([ +22, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(board_raise_amount);
    }  
    
    if ((box_bottom_PCB == "Triple Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(board_raise_amount);
        translate([ 0, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(board_raise_amount);
        translate([ +28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(board_raise_amount);
    }


    if ((box_bottom_PCB == "F/B Small-Mint + Raised Ctr Small-Mint") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ 0, 7, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
    }

    if ((box_bottom_PCB == "Front Small-Mint + Raised Ctr Small-Mint") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ 5, 7, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
    }

    if ((box_bottom_PCB == "F/B Red Tindie + Raised Ctr Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ 0, 4, body_bottom_thickness]) component_small_red_protoboard_lifted(board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 16), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
    }

    if ((box_bottom_PCB == "Front Red Tindie + Raised Ctr Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ 5, 4, body_bottom_thickness]) component_small_red_protoboard_lifted(board_raise_amount);
    }




    if ((box_bottom_PCB == "F/B Small-Mint + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ 0, 7, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
    }

    if ((box_bottom_PCB == "Front Small-Mint + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard();
        translate([ 5, 7, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
    }

    if ((box_bottom_PCB == "F/B Red Tindie + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ 0, 4, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 16), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
    }

    if ((box_bottom_PCB == "Front Red Tindie + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard();
        translate([ 5, 4, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
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
        translate([ 9, 0, body_bottom_thickness]) component_small_red_protoboard_lifted(board_raise_amount);
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
        translate([ 9, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(board_raise_amount);
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
        translate([ 0, 0, body_bottom_thickness]) component_feather_lifted(board_raise_amount);
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
        //translate([ box_back_x,  0, (height_of_box - lid_lip_height - keep_away_distance - 44)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
        translate([ box_back_x,  0, 12]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
        if (height_of_box < 70) {
            echo("<span style='background-color:red'>NOTICE: There isn't room for an arcade button AND a center toggle switch in this short box.  You should either eliminate the back arcade button or use a toggle in one of the back side positions</span>");
        }
    }
    
    if ((has_toggle_back_ctr) && (part == "box") && (!has_arcade_back)) {
        translate([ box_back_x,  0, (height_of_box - lid_lip_height - 20)]) rotate([ 0, -90, 0]) component_mini_toggle_switch(mode);
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
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), 0 ]) component_adafruit_illuminated_pushbutton(mode);
    }
        
    if ((has_button_lid_right) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), 0 ]) component_adafruit_illuminated_pushbutton(mode); 
    } 
     
 /* this is an experiment */   
    if ((has_button_lid_right) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness +  keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_adafruit_illuminated_pushbutton("lidcheck"); 
    }   
    if ((has_button_lid_left) && (part == "box")) {
        translate([ box_back_x - (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), height_of_box + lid_thickness ]) rotate([ 0, 180, 0 ]) component_adafruit_illuminated_pushbutton("lidcheck"); 
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
        // if box is tall enough we lower the button enouth to clear power components on lid
        // for boxes that are less than 70mm high we put button closer to top 

        if (height_of_box < 70) {
            translate([ (box_length)/2,  0, (height_of_box - lid_lip_height - keep_away_distance) ]) 
                rotate([ 0, -90, 0]) 
                component_arcade_button(mode);
        } else {
            translate([ (box_length)/2,  0, (height_of_box - lid_lip_height - keep_away_distance - 11) ]) 
                rotate([ 0, -90, 0]) 
                component_arcade_button(mode);
        }
    }
        
    if ( (has_arcade_front) && (part == "box")) {
        // if box is tall enough we lower the button enouth to clear power components on lid
        // for boxes that are less than 70mm high we put button closer to top 

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
    shaft_to_longend = 58;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 10) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }        
    
    if ( (motor_type == "Blue TT Horizontal") && (part == "box")) {

        if (((shaft_to_longend+body_wall_thickness) < (box_back_x)) || allow_motors_to_extend_out_back_of_box) {
            // motor is short enough to fit inside (horizontally) so its centered in box
            // right-side motor
            translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_blue_motor(mode);
            // left-side motor
            translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_blue_motor(mode);
        } else {
            // motor is too long to fit inside so move it forward
            echo("<span style='background-color:yellow'>NOTICE: motor too long to fit in body if centered, so moved it forward ", (shaft_to_longend - box_back_x + body_wall_thickness), " mm</span>");
            // right-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_blue_motor(mode);
            // left-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_blue_motor(mode);
        }
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

        if (((shaft_to_longend+body_wall_thickness) < (box_back_x)) || allow_motors_to_extend_out_back_of_box) {
            // motor is short enough to fit inside (horizontally) so its centered in box
            // right-side motor
            translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_yellow_motor(mode);
            // left-side motor
            translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_yellow_motor(mode);
        } else {
            // motor is too long to fit inside so move it forward
            echo("<span style='background-color:yellow'>NOTICE: motor too long to fit in body if centered, so moved it forward ", (shaft_to_longend - box_back_x + body_wall_thickness), " mm</span>");
            // right-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_yellow_motor(mode);
            // left-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_yellow_motor(mode);
        }
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

        if (((shaft_to_longend+body_wall_thickness) < (box_back_x)) || allow_motors_to_extend_out_back_of_box) {
            // motor is short enough to fit inside (horizontally) so its centered in box
            // right-side motor
            translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_DFR_motor(mode);
            // left-side motor
            translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_DFR_motor(mode);
        } else {
            // motor is too long to fit inside so move it forward
            echo("<span style='background-color:yellow'>NOTICE: motor too long to fit in body if centered, so moved it forward ", (shaft_to_longend - box_back_x + body_wall_thickness), " mm</span>");
            // right-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_DFR_motor(mode);
            // left-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_DFR_motor(mode);
        }
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
    shaft_to_longend = 53;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    if (motor_lift < 10) {
        echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    }   
    
    if ( (motor_type == "Pololu MiniPlastic Horizontal") && (part == "box")) {
        if (((shaft_to_longend+body_wall_thickness) < (box_back_x)) || allow_motors_to_extend_out_back_of_box) {
            // motor is short enough to fit inside (horizontally) so its centered in box
            // right-side motor
            translate([ 0,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_pololu_miniplastic_motor(mode);
            // left-side motor
            translate([ 0,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_pololu_miniplastic_motor(mode);
        } else {
            // motor is too long to fit inside so move it forward and user allows it to be moved
            echo("<span style='background-color:yellow'>NOTICE: motor too long to fit in body if centered, so moved it forward ", (shaft_to_longend - box_back_x + body_wall_thickness), " mm</span>");
            // right-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_pololu_miniplastic_motor(mode);
            // left-side motor
            translate([ -((shaft_to_longend - box_back_x + body_wall_thickness)),  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_pololu_miniplastic_motor(mode);
        }

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