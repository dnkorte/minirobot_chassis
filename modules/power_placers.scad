/*
 * Module:  power_placers.scad  holds functions that create and place casters
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
 * ***************************************************************************
 * these  modules arrange power components (batteries, boost converters, power
 * distribution strip) on bottom of lid; note these are specified by "package"
 * ***************************************************************************
 */

module place_battery(mode="holes") {  

    wall_standoff = body_wall_thickness + lid_lip_thickness + ((batt_lipo_cyl_dia + (2*battbox_wall_thickness))/2);

    if ((battery == "2200 mAH Cylindrical Front Right") && (part == "lid")) {
        translate([ lid_front_x - wall_standoff + 1, (box_width/2) - wall_standoff + 1, 0 ]) component_battbox_lipo_cylinder(mode);
    }

    if ((battery == "2200 mAH Cylindrical Front Center") && (part == "lid")) {
        if (has_wire_port_frontcenter) {
            translate([ lid_front_x - wall_standoff - 14, 0, 0 ]) component_battbox_lipo_cylinder(mode);
        } else {
            translate([ lid_front_x - wall_standoff - 8, 0, 0 ]) component_battbox_lipo_cylinder(mode);
        }
    }

    if ((battery == "1200 mAH LiPo Front Right") && (part == "lid")) {
        if (box_width < 90) {
            translate([ lid_front_x - wall_standoff + 3, (box_width/2) - (batt_lipo_1200_width/2) - 7, 0 ]) component_battbox_lipo_1200(mode);
        } else {
            translate([ lid_front_x - wall_standoff + 5, (box_width/2) - (batt_lipo_1200_width/2) - 7, 0 ]) component_battbox_lipo_1200(mode);
        }
    }

    if ((battery == "1200 mAH LiPo Front Center") && (part == "lid")) {
        if (has_wire_port_frontcenter) {
            translate([ lid_front_x - wall_standoff -8, 0, 0 ]) component_battbox_lipo_1200(mode);
        } else {
            translate([ lid_front_x - wall_standoff -2, 0, 0 ]) component_battbox_lipo_1200(mode);
        }
    }

    if ((battery == "500 mAH LiPo Front Right") && (part == "lid")) {
        if (box_width < 90) {
            translate([ lid_front_x - wall_standoff + 1, (box_width/2) - (batt_lipo_1200_width/2) - 5, 0 ]) component_battbox_lipo_500(mode);
        } else {
            translate([ lid_front_x - wall_standoff + 5, (box_width/2) - (batt_lipo_1200_width/2) - 5, 0 ]) component_battbox_lipo_500(mode);
        }
    }

    if ((battery == "500 mAH LiPo Front Center") && (part == "lid")) {
        if (has_wire_port_frontcenter) {
            translate([ lid_front_x - wall_standoff -8, 0, 0 ]) component_battbox_lipo_500(mode);
        } else {
            translate([ lid_front_x - wall_standoff -2, 0, 0 ]) component_battbox_lipo_500(mode);
        }
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
        if ((battery == "2200 mAH Cylindrical Front Right") && (part == "box")) {
            translate([ lid_front_x - wall_standoff + 1, (box_width/2) - wall_standoff + 1, 0 ]) component_battbox_lipo_cylinder("lidcheck");
        }

        if ((battery == "2200 mAH Cylindrical Front Center") && (part == "box")) {
            if (has_wire_port_frontcenter) {
                translate([ lid_front_x - wall_standoff - 14, 0, 0 ]) component_battbox_lipo_cylinder("lidcheck");
            } else {
                translate([ lid_front_x - wall_standoff - 8, 0, 0 ]) component_battbox_lipo_cylinder("lidcheck");
            }
        }

        if ((battery == "1200 mAH LiPo Front Right") && (part == "box")) {
            if (box_width < 90) {
                translate([ lid_front_x - wall_standoff + 3, (box_width/2) - (batt_lipo_1200_width/2) - 7, 0 ]) component_battbox_lipo_1200("lidcheck");
            } else {
                translate([ lid_front_x - wall_standoff + 5, (box_width/2) - (batt_lipo_1200_width/2) - 7, 0 ]) component_battbox_lipo_1200("lidcheck");
            }
        }

        if ((battery == "1200 mAH LiPo Front Center") && (part == "box")) {
            if (has_wire_port_frontcenter) {
                translate([ lid_front_x - wall_standoff -8, 0, 0 ]) component_battbox_lipo_1200("lidcheck");
            } else {
                translate([ lid_front_x - wall_standoff -2, 0, 0 ]) component_battbox_lipo_1200("lidcheck");
            }
        }

        if ((battery == "500 mAH LiPo Front Right") && (part == "box")) {
            if (box_width < 90) {
                translate([ lid_front_x - wall_standoff + 1, (box_width/2) - (batt_lipo_1200_width/2) - 5, 0 ]) component_battbox_lipo_500("lidcheck");
            } else {
                translate([ lid_front_x - wall_standoff + 5, (box_width/2) - (batt_lipo_1200_width/2) - 5, 0 ]) component_battbox_lipo_500("lidcheck");
            }
        }

        if ((battery == "500 mAH LiPo Front Center") && (part == "box")) {
            if (has_wire_port_frontcenter) {
                translate([ lid_front_x - wall_standoff -8, 0, 0 ]) component_battbox_lipo_500("lidcheck");
            } else {
                translate([ lid_front_x - wall_standoff -2, 0, 0 ]) component_battbox_lipo_500("lidcheck");
            }
        }
    }
}

module place_power_distribution(mode="holes") {

    if ((power_distribution_buss == "Long Way") && (part == "lid")) {
        translate([ 0, 0, lid_thickness ]) component_schmart(mode);
    }

    if ((power_distribution_buss == "Long Way Set Back") && (part == "lid")) {
        translate([ -12, 0, lid_thickness ]) component_schmart(mode);
    }

    if ((power_distribution_buss == "Wide Way") && (part == "lid")) {
        translate([ (lid_front_x - 42), 0, lid_thickness ]) rotate([ 0, 0, 90 ]) component_schmart(mode);
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
        if ((power_distribution_buss == "Long Way") && (part == "box")) {
            translate([ 0, 0, lid_thickness ]) component_schmart("lidcheck");
        }

        if ((power_distribution_buss == "Long Way Set Back") && (part == "box")) {
            translate([ -12, 0, lid_thickness ]) component_schmart("lidcheck");
        }

        if ((power_distribution_buss == "Wide Way") && (part == "box")) {
            translate([ (lid_front_x - 42), 0, lid_thickness ]) rotate([ 0, 0, 90 ]) component_schmart("lidcheck");
        }
    }
}


module place_boost_buck(mode="holes") {
    wall_standoff = body_wall_thickness + lid_lip_thickness;

    if ((boost_converter_for_motors == "Front Adjustable") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff -14), -((box_width/2) - wall_standoff -23), lid_thickness ]) rotate([ 0, 0, 90 ]) component_amazon_boost(mode);
    }

    if ((boost_converter_for_motors == "Side Adjustable") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff -26), -((box_width/2) - wall_standoff - 13), lid_thickness ]) component_amazon_boost(mode);
    }

    if ((boost_converter_for_motors == "Front Pololu") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff - 14), -((box_width/2) - wall_standoff -23), lid_thickness ]) rotate([ 0, 0, 90 ]) component_pololu_boost(mode);
    }

    if ((boost_converter_for_motors == "Side Pololu") && (part == "lid")) {
        translate([ (lid_front_x - wall_standoff - 24 ), -((box_width/2) - wall_standoff - 13), lid_thickness ]) component_pololu_boost(mode);
    }


    if (power_distribution_buss == "Wide Way") {

        if ((want_3v_buck) && (part == "lid")) {
            translate([ (lid_front_x - 60), -6, lid_thickness ]) component_adafruit_minibuck(mode);
        }

        if ((want_5v_boost) && (part == "lid")) {
            translate([ (lid_front_x - 60), 6, lid_thickness ]) component_adafruit_miniboost(mode);
        }

    } else {

        if ((boost_converter_for_motors == "Side Adjustable") || (boost_converter_for_motors == "Side Pololu")) {
            if ((want_3v_buck) && (part == "lid")) {
                translate([ -12, -18, lid_thickness ]) rotate([ 0, 0, 90 ]) component_adafruit_minibuck(mode);
            }

            if ((want_5v_boost) && (part == "lid")) {
                translate([ -12, 18, lid_thickness ]) rotate([ 0, 0, 90 ])component_adafruit_miniboost(mode);
            }
        } else {
            if ((want_3v_buck) && (part == "lid")) {
                translate([ 0, -13, lid_thickness ]) component_adafruit_minibuck(mode);
            }

            if ((want_5v_boost) && (part == "lid")) {
                translate([ 0, 13, lid_thickness ]) component_adafruit_miniboost(mode);
            }
        }
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

        if ((boost_converter_for_motors == "Front Adjustable") && (part == "box")) {
            translate([ (lid_front_x - wall_standoff -14), -((box_width/2) - wall_standoff -23), lid_thickness ]) 
                rotate([ 0, 0, 90 ]) 
                component_amazon_boost("lidcheck");
        }

        if ((boost_converter_for_motors == "Side Adjustable") && (part == "box")) {
            translate([ (lid_front_x - wall_standoff -26), -((box_width/2) - wall_standoff - 13), lid_thickness ]) 
                component_amazon_boost("lidcheck");
        }

        if ((boost_converter_for_motors == "Front Pololu") && (part == "box")) {
            translate([ (lid_front_x - wall_standoff - 14), -((box_width/2) - wall_standoff -23), lid_thickness ]) rotate([ 0, 0, 90 ]) 
                component_pololu_boost("lidcheck");
        }

        if ((boost_converter_for_motors == "Side Pololu") && (part == "box")) {
            translate([ (lid_front_x - wall_standoff - 24 ), -((box_width/2) - wall_standoff - 13), lid_thickness ]) 
                component_pololu_boost("lidcheck");
        }


        if (power_distribution_buss == "Wide Way") {

            if ((want_3v_buck) && (part == "box")) {
                translate([ (lid_front_x - 60), -6, lid_thickness ]) component_adafruit_minibuck("lidcheck");
            }

            if ((want_5v_boost) && (part == "box")) {
                translate([ (lid_front_x - 60), 6, lid_thickness ]) component_adafruit_miniboost("lidcheck");
            }

        } else {

            if ((boost_converter_for_motors == "Side Adjustable") || (boost_converter_for_motors == "Side Pololu")) {
                if ((want_3v_buck) && (part == "box")) {
                    translate([ -12, -18, lid_thickness ]) rotate([ 0, 0, 90 ]) component_adafruit_minibuck("lidcheck");
                }

                if ((want_5v_boost) && (part == "box")) {
                    translate([ -12, 18, lid_thickness ]) rotate([ 0, 0, 90 ])component_adafruit_miniboost("lidcheck");
                }
            } else {
                if ((want_3v_buck) && (part == "box")) {
                    translate([ 0, -13, lid_thickness ]) component_adafruit_minibuck("lidcheck");
                }

                if ((want_5v_boost) && (part == "box")) {
                    translate([ 0, 13, lid_thickness ]) component_adafruit_miniboost("lidcheck");
                }
            }
        }
    }
}

