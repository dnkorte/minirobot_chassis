/*
 * Module:  switches_and_lights_placers.scad  holds functions that create and place casters
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



module place_switches_and_buttons_invokes(mode="adds") {
    place_mini_toggle_switch(mode);
    place_pushbuttons(mode);
    place_arcade_buttons(mode);
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
        if ((has_toggle_lid_right) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_mini_toggle_switch("lidcheck");
        }
            
        if ((has_toggle_lid_left) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + box_corner_inner_radius + keep_away_distance),  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), 0 ]) component_mini_toggle_switch("lidcheck");
        }
    }
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
        translate([ box_back_x,  box_L_y + (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 4  -keep_away_distance)]) 
            rotate([ 0, -90, 0]) 
            component_adafruit_illuminated_pushbutton(mode); 
    } 
    
    if ((has_button_back_right) && (part == "box")) {
        translate([ box_back_x,  box_R_y - (body_wall_thickness + box_corner_inner_radius + keep_away_distance), (height_of_box - lid_lip_height - 4 - keep_away_distance)]) 
            rotate([ 0, -90, 0]) 
            component_adafruit_illuminated_pushbutton(mode); 
    } 
        
    if ((has_button_lid_left) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), 0 ])
            component_adafruit_illuminated_pushbutton(mode);
    }
        
    if ((has_button_lid_right) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), 0 ]) 
            component_adafruit_illuminated_pushbutton(mode); 
    } 
 
    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff)
     * these optionally show the lid components when generally displaying the box itself.  the "component" builders have a special
     * mode called "lidcheck" that shows them in blue but otherwise similar to normal mode.  this mode is only available on parts
     * that might be reasonably expected to live on the lid.       *
     *
     * note that the actual translatations/rotations of of these components is identical to the box placements above, excepting for the 
     * mode declaration ("lidcheck") and the fact that is called for part == "box" instead of "lid".  
     * the outer translate / rotate here takes care of moving all lidcheck pieces at once
     */
    
    translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {

        if ((has_button_lid_right) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), 0 ]) 
                component_adafruit_illuminated_pushbutton("lidcheck"); 
        }   
        if ((has_button_lid_left) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), 0 ])
                component_adafruit_illuminated_pushbutton("lidcheck");
        } 

    }

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


        
    if ((has_arcade_lid_left) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), 0 ])
            component_arcade_button(mode);
    }  

    if ((has_arcade_lid_center) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 12),  0, 0 ])
            component_arcade_button(mode);
    }
        
    if ((has_arcade_lid_right) && (part == "lid")) {
        translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), 0 ]) 
            component_arcade_button(mode); 
    } 
 
    /*
     * LIDCHECK VISUALIZATIONS (optional turnon/turnoff)
     * these optionally show the lid components when generally displaying the box itself.  the "component" builders have a special
     * mode called "lidcheck" that shows them in blue but otherwise similar to normal mode.  this mode is only available on parts
     * that might be reasonably expected to live on the lid.       *
     *
     * note that the actual translatations/rotations of of these components is identical to the box placements above, excepting for the 
     * mode declaration ("lidcheck") and the fact that is called for part == "box" instead of "lid".  
     * the outer translate / rotate here takes care of moving all lidcheck pieces at once
     */
    
    translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {

        if ((has_arcade_lid_right) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_R_y - (body_wall_thickness + keep_away_distance + 5), 0 ]) 
                component_arcade_button("lidcheck"); 
        }   

        if ((has_arcade_lid_center) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 12),  0, 0 ])
                component_arcade_button("lidcheck");
        }

        if ((has_arcade_lid_left) && (part == "box")) {
            translate([ lid_back_x + (body_wall_thickness + keep_away_distance + 5),  box_L_y + (body_wall_thickness + keep_away_distance + 5), 0 ])
                component_arcade_button("lidcheck");
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

module place_flora_neopixel(mode="holes") {    
    if (mode == "holes") {
        translate([ -neopixel_block_size/2, -neopixel_block_size, -0.1 ]) cube([neopixel_block_size/2, neopixel_block_size/2, body_wall_thickness+0.2 ]);
    }  

    if (mode == "adds") {
        difference() {
            cylinder(r=(16/2), h=body_wall_thickness+5);
            translate([0, 0, body_wall_thickness]) cylinder(r=(12.7/2), h=5.2);
        }
    }
}