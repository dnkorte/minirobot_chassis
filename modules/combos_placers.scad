/*
 * Module: minirobot_box.scad is the module for minirobot box
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
 * ***************************************************************************
 * this module arranges multiple components (typically PCBs) on bottom of box
 * ***************************************************************************
 */
module place_box_bottom_combo(mode="adds") {
    if ((box_bottom_PCB == "Dual TB6612") && (part == "box")) {
        translate([ -18, 0, body_bottom_thickness]) component_tb6612(mode);
        translate([ +18, 0, body_bottom_thickness]) component_tb6612(mode);
    }
    
    if ((box_bottom_PCB == "TB6612 and Small-Mint") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612(mode);
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_smallmint_protoboard(mode);
    }    
    
    if ((box_bottom_PCB == "Dual TB6612 and Small-Mint") && (part == "box")) {
        translate([ -30, 3, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612(mode);
        translate([ -30, -18, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612(mode);
        // tb6612 is 30mm and permaproto mint is 54mm
        translate([ +12, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
    }
    
    if ((box_bottom_PCB == "TB6612 and Feather") && (part == "box")) {
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_tb6612(mode);
        // tb6612 is 30mm feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
    }   
    
    if ((box_bottom_PCB == "Dual TB6612 and Feather") && (part == "box")) {
        translate([ -30, 3, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612(mode);
        translate([ -30, -18, body_bottom_thickness]) rotate([ 0, 0, 180 ]) component_tb6612(mode);
        // tb6612 is 30mm and feather is 52mm
        translate([ +12, 0, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
    }
    
    if ((box_bottom_PCB == "QWIIC I2C Motor Driver + Small-Mint") && (part == "box")) {
        translate([ -28, -5, body_bottom_thickness]) rotate([ 0, 0, -90 ]) rotate([ 0, 0, 90 ]) component_qwiic_motor_driver(mode);
        // qwiic driver is 25mm square and permaproto mint is 54mm
        if (box_length > 90) {
            translate([ +17, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        } else {
            translate([ +14, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        }
    }

    if ((box_bottom_PCB == "QWIIC I2C Motor Driver + Feather") && (part == "box")) {
        translate([ -27, -5, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_qwiic_motor_driver(mode);
        // qwiic driver is 25mm square and feather is 52mm
        if (box_length > 90) {
            translate([ (box_back_x - 32), 0, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
        } else {
            translate([ +14, 0, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
        }
    }  
        
    if ((box_bottom_PCB == "L298 and Small-Mint") && (part == "box")) {
        //translate([ -19, 0, body_bottom_thickness]) component_L298motor_driver(mode);
        translate([ (box_front_x+28), 0, body_bottom_thickness ]) component_L298motor_driver(mode);
        // L298 is 47x47mm and permaproto mint is 54 x 25mm
        if (box_length > 110) {
            translate([ +22, 0, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        } else {     
            translate([ +22, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        }
    }
        
    if ((box_bottom_PCB == "L298 and Feather") && (part == "box")) {
        translate([ (box_front_x+28), 0, body_bottom_thickness]) component_L298motor_driver(mode);
        // L298 is 47x47mm and feather is 52 x 25mm
        translate([ +25, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather_lifted(mode, board_raise_amount);
    }
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver") && (part == "box")) {
        // board is 35mm x 32mm
        translate([ -19, 0, body_bottom_thickness]) component_gearedstepper_driver(mode);
        translate([ +19, 0, body_bottom_thickness]) component_gearedstepper_driver(mode);
    } 
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver and Small-Mint") && (part == "box")) {
        // board is 35mm x 32mm
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount); 
        translate([ (box_back_x-39), -5, body_bottom_thickness]) component_gearedstepper_driver_upper(mode);
        translate([ (box_back_x-24), +5, body_bottom_thickness]) rotate([ 0, 0, 180 ])component_gearedstepper_driver(mode);
    } 
    
    if ((box_bottom_PCB == "Dual Geared Stepper Driver and Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 14), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather(mode); 
        translate([ (box_back_x-47), -5, body_bottom_thickness]) component_gearedstepper_driver_upper(mode);
        translate([ (box_back_x-32), +5, body_bottom_thickness]) rotate([ 0, 0, 180 ])component_gearedstepper_driver(mode);
    } 
    
    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver") && (part == "box")) {
        // board is 48mm x 24mm
        translate([ 0, 12.5, body_bottom_thickness]) component_easydriver(mode);
        translate([ 0, -12.5, body_bottom_thickness]) component_easydriver(mode);
    }

    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver + Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 14), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_feather(mode); 
        translate([ 6, 12.5, body_bottom_thickness]) component_easydriver(mode);
        translate([ 6, -12.5, body_bottom_thickness]) component_easydriver(mode);
    }

    if ((box_bottom_PCB == "Dual Sparkfun EasyDriver + Small-Mint") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 20), -((box_width/2)-31), body_bottom_thickness]) 
            rotate([ 0, 0, 90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount); 
        //translate([ (box_back_x + body_wall_thickness -24), 0, body_bottom_thickness]) 
        //    rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount); 
        translate([ 15, 12.5, body_bottom_thickness]) component_easydriver(mode);
        translate([ 15, -12.5, body_bottom_thickness]) component_easydriver(mode);
    }
    
    if ((box_bottom_PCB == "Dual Small-Mint") && (part == "box")) {
        translate([ -17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        translate([ +17, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
    }   
            
    if ((box_bottom_PCB == "3 Small-Mint Inline") && (part == "box")) {
        translate([ -34, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ 0, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ +34, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
    }

    if ((box_bottom_PCB == "Dual Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -6, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) rotate([ 0, 0, 180 ]) component_small_red_protoboard_lifted(mode, board_raise_amount);
        translate([ +22, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(mode, board_raise_amount);
    }  
    
    if ((box_bottom_PCB == "Triple Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ -28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(mode, board_raise_amount);
        translate([ 0, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(mode, board_raise_amount);
        translate([ +28, 0, body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard_lifted(mode, board_raise_amount);
    }


    if ((box_bottom_PCB == "F/B Small-Mint + Raised Ctr Small-Mint") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ 0, 7, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
    }

    if ((box_bottom_PCB == "Front Small-Mint + Raised Ctr Small-Mint") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ 5, 7, body_bottom_thickness]) component_smallmint_protoboard_lifted(mode, board_raise_amount);
    }

    if ((box_bottom_PCB == "F/B Red Tindie + Raised Ctr Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
        translate([ 0, 4, body_bottom_thickness]) component_small_red_protoboard_lifted(board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 16), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
    }

    if ((box_bottom_PCB == "Front Red Tindie + Raised Ctr Red Tindie") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
        translate([ 5, 4, body_bottom_thickness]) component_small_red_protoboard_lifted(board_raise_amount);
    }

    if ((box_bottom_PCB == "F/B Small-Mint + Raised Ctr Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ 0, 7, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
    }

    if ((box_bottom_PCB == "Front Small-Mint + Raised Ctr Feather") && (part == "box")) {
        translate([ (box_front_x + body_wall_thickness + 19), -((box_width/2)-31), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_smallmint_protoboard(mode);
        translate([ 5, 7, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
    }

    if ((box_bottom_PCB == "F/B Red Tindie + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
        translate([ 0, 4, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
        translate([ (box_back_x - body_wall_thickness - 16), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
    }

    if ((box_bottom_PCB == "Front Red Tindie + Raised Ctr Feather") && (part == "box")) {
        // small_red_protoboard is 52mm x 28mm
        translate([ (box_front_x + body_wall_thickness + 18), -((box_width/2)-28), body_bottom_thickness]) rotate([ 0, 0, -90 ]) component_small_red_protoboard(mode);
        translate([ 5, 4, body_bottom_thickness]) component_feather_lifted(mode, board_raise_amount);
    }
    
}