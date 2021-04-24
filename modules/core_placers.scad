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
 * this makes a mount line follower sensor board
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

module place_linefollower_snout(mode) {
//echo(linesensor_snout);
    
    if ((linesensor_snout == "Standard Size") && (part == "box")) {
        translate([ box_front_x, 0, 0 ]) rotate([ 0, 0, 90 ]) component_linefollower_snout(mode, "Standard Size");
    }
    if ((linesensor_snout == "Extended") && (part == "box")) {
        translate([ box_front_x, 0, 0 ]) rotate([ 0, 0, 90 ]) component_linefollower_snout(mode, "Extended");
    }
}
