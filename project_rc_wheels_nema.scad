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

/* [What PART do you want to model?] */
part="box";  // ["box", "lid", "TT Motor Clamp", "Pololu Motor Clamp", "Wheel Hub Adafruit Skinny to selected motor", "Custom Wheel as selected", "Flora Clamp", "Caster (size as selected)", "Caster Flap 1 in", "Spring Clamp", "Calibrate TI", "Calibrate Bolt", "test" ]

/* [Main Box Size (outer)] */
// mm LONG front-to-back (outside)
box_length = 90;      // [90, 96, 100, 111, 120, 150, 180, 200, 220] 
// mm WIDE (outside). 
box_width = 90;       // [76, 80, 90, 96, 101, 120, 145, 160, 180]  
// mm TALL NOT including thickness of lid  
height_of_box = 55;  // [44, 55, 70, 90, 100] 
// radius of vertical box corners 
box_corner_radius = 8;  // [6, 8, 10, 12]


/* [Basic Box Features] */
has_button_back_left = false;
has_button_back_right = false;
has_arcade_front = false;
has_arcade_back = false;
has_toggle_back_ctr = false;
has_toggle_back_left = false;
has_toggle_back_right = false;
has_beeper = false;

/* [Advanced Box Features] */
has_front_mount_grid = false;
has_front_upper_mount_grid = false;
has_flora_eyes = false;
has_front_neopixel_strip = false;
has_back_neopixel_strip_horizontal = false;
has_back_neopixel_strip_vertical = false;
has_front_sonar = false;
has_back_sonar = false;
has_front_TOF_sensor = false;
has_back_TOF_sensor = false;
has_side_TOF_sensors = false;
has_downshooting_edge_sensors = false;
linesensor_snout = "none";    // ["none", "Standard Size", "Extended", "SuperLong"]

/* [Inside-Box Electronics Packages] */
box_bottom_PCB = "PermaProto Mini-Tin"; // ["none", "PermaProto Small-Mint", "Dual Small-Mint", "PermaProto HalfSize", "Red Tindie Proto", "Dual Red Tindie", "Triple Red Tindie", "Feather", "Feather Doubler", "Feather Tripler", "TB6612", "Dual TB6612", "TB6612 and Small-Mint", "Dual TB6612 and Small-Mint", "TB6612 and Feather", "Dual TB6612 and Feather", "QWIIC I2C Motor Driver", "QWIIC I2C Motor Driver + Small-Mint", "QWIIC I2C Motor Driver + Feather",  "L298_motor_driver", "L298 and Small-Mint", "L298 and Feather", "Geared Stepper Driver", "Dual Geared Stepper Driver", "Dual Geared Stepper Driver and Small-Mint", "Dual Geared Stepper Driver and Feather", "Dual Sparkfun EasyDriver", "Dual Sparkfun EasyDriver + Small-Mint", "Dual Sparkfun EasyDriver + Feather", "3 Small-Mint Inline", "Front Small-Mint + Raised Ctr Small-Mint", "F/B Small-Mint + Raised Ctr Small-Mint", "Front Red Tindie + Raised Ctr Red Tindie", "F/B Red Tindie + Raised Ctr Red Tindie", "Front Small-Mint + Raised Ctr Feather", "F/B Small-Mint + Raised Ctr Feather", "Front Red Tindie + Raised Ctr Feather", "F/B Red Tindie + Raised Ctr Feather"]

board_raise_amount = 7; // [7:"No Added Lift (7mm high)", 17:"Lift to 17mm", 22:"Lift to 22mm", 27:"Lift to 27mm"]

/* [Lid Features] */
has_button_lid_left = false;
has_button_lid_right = false;
has_toggle_lid_left = false;
has_toggle_lid_right = false;
has_arcade_lid_left = false;
has_arcade_lid_center = false;
has_arcade_lid_right = false;
has_wire_port_frontleft = false;
has_wire_port_frontcenter = false;
has_wire_port_frontright = false;
has_wire_port_left = false;
has_wire_port_right = false;
has_wire_port_backleft = true;
has_wire_port_backcenter = false;
has_wire_port_backright = true;
has_neopixel_strip = false;
has_lid_mount_grid = false;


/* [Motors, Wheels and Casters] */

motor_type="Geared Stepper";   // ["Geared Stepper", "Sparkfun Stepper", "Yellow TT Horizontal", "Yellow TT Vertical", "Blue TT Horizontal", "Blue TT Vertical", "DFR TT with Encoder H", "DFR TT with Encoder V", "Pololu MiniPlastic Horizontal", "Pololu MiniPlastic Vertical", "N20 Geared with Encoder",  "NEMA 17 Stepper", "4 Pololu MiniPlastic Horizontal",  "4 Pololu MiniPlastic Vertical",  "4 Pololu MiniPlastic Diagonal", "4 N20 Geared with Encoder", "4 Yellow TT Horizontal", "4 Blue TT Horizontal"]

wheel_diameter = 59.8; // [ 59.8:Adafruit Skinny Wheel (any hub) 60, 65:Adafruit Thin White TT Wheel 65, 63:Adafruit Orange and Clear TT Wheel 63, 40:Pololu 40x7mm Wheel 40, 60:Pololu 60x8mm Wheel 60, 70:Pololu 70x8mm Wheel 70, 80:Pololu 80x10 Wheel 80, 42:DFR 42x19 Wheel 42, 65:DFR 65mm Rubber Wheel 65, 95:95x38 Rubber RC Buggy Wheels, 58:Custom 58x8mm Printed Wheel 58, 67:Custom 67x8mm Printed Wheel 67, 80:Custom 80x8mm Printed Wheel 80 ]

stance = 1; // [ 0:no casters, 1:2 casters with central wheels, 15:tripod 15mm from front, 20:tripod 20mm from front, 30:tripod 30mm from front, 40:tripod 40mm from front ]

caster_id = 0; // [ 0:Custom Printed Peg 10 mm, 1:Pololu 3/8 in 10.1 mm, 2:Pololu 1/2 in 13.5 mm, 3:Custom Printed Peg 15 mm, 4:Custom Printed Peg 20 mm, 5:Pololu 3/4 in 22.4 mm, 6:Custom Printed Peg 25 mm, 7:Pololu 1 in, 8:flappy caster 1 in  ]


/* [ Power Options] */

want_3v_buck = true;

want_5v_boost = true;

boost_converter_for_motors = "None"; // ["None", "Front Adjustable", "Side Adjustable", "Front Pololu", "Side Pololu"]

power_distribution_buss = "Long Way"; // ["none", "Long Way", "Long Way Set Back", "Wide Way"]

battery="2200 mAH Cylindrical Front Right"; // ["2200 mAH Cylindrical Front Right", "2200 mAH Cylindrical Front Center", "1200 mAH LiPo Front Right", "1200 mAH LiPo Front Center", "500 mAH LiPo Front Right", "500 mAH LiPo Front Center", "None Inside"]

airgap_under_batterybox = 10; // [2, 10, 15, 20]


/* [Visualization] */
show_internal_parts_for_collision_check = false;
show_lid_parts_for_collision_check = false;
show_box_walls = true;
show_wheels_and_casters = false;
height_of_visualized_feathers = 1; // [ 1:1 Board, 2:2 Boards, 3:3 Boards ]


/*
 * ************************************************************************************
 * note this mainline module selects the part AND ALSO ends the configurator variables
 * ************************************************************************************
 */

draw_part();

module draw_part() {
    $fn = 24;

    if(part == "box") {
        box();
    } else if(part == "lid") {
        lid();
    } else if(part == "battery clamp") {
        // nothing
    } else if(part == "TT Motor Clamp") {
        part_tt_motor_clamp("half");
    } else if(part == "Pololu Motor Clamp") {
        part_pololu_miniplastic_motor_clamp("half");
    } else if(part == "Flora Clamp") {   
        part_flora_clamp();
    } else if(part == "Caster Flap 3/4") {
        part_caster_flap("A");
    } else if(part == "Caster Flap 1 in") {
        part_caster_flap("B");
    } else if(part == "Spring Clamp") {
        part_spring_clamp();

    } else if(part == "test") {
        //component_linefollower_snout("adds");
        component_nema17_stepper_motor(mode="adds");

    } else if(part == "Calibrate TI") {
        part_calibrate_TI();
    } else if(part == "Calibrate Bolt") {
        part_calibrate_bolt();
    }
}

include <config_minirobot.scad>; 
include <modules/casters_placers.scad>;
include <modules/ports_and_grids_placers.scad>;
include <modules/core_components.scad>;
include <modules/core_placers.scad>;
include <modules/boards_components.scad>;
include <modules/boards_placers.scad>;
include <modules/combos_placers.scad>;
include <modules/motors_placers.scad>;
include <modules/motors_components.scad>;
include <modules/power_components.scad>;
include <modules/power_placers.scad>;
include <modules/switches_and_lights_components.scad>;
include <modules/switches_and_lights_placers.scad>;
include <modules/alacarte_placers.scad>;
include <modules/minirobot_box_and_lid.scad>; 


module place_alacarte( mode ) {
    /* 
     * put calls to alacarte placers here; most placers have the following parameters
     *
     * param: mode = "adds", "holes", "vis", "lidcheck"
     *
     * param: whereused = "boxbot", "lid", "plate", "boxback", "boxfront"
     *          (note "boxback", "boxfront" not available for all components)
     *
     * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
     *          note for "boxbot", +x is back, -x is front; 
     *          note for "boxlid" or "plate", +x is front, -x is back;
     *
     * param: y = distance left / right
     *          note for all whereused; +y is right, -y is left
     *
     * param: z = distance above box bottom (used only for "boxfront" and "boxback"
     *
     * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
     *                but may be any angle in degrees
     *
     * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
     *
     */

    //place_ala_smallmint_proto( mode, "boxbot", x= -30, y=0, angle=90, lift=7 );
    //place_ala_smallmint_proto( mode, "boxbot",  x= +30, y=0, angle=90, lift=7 );    
    //place_ala_smallmint_proto( mode, "lid", x= +20, y=0, angle=90, lift=7 );


    //place_ala_small_red_protoboard( mode, "boxbot", x= -30, y=0, angle=90, lift=7 );
    //place_ala_small_red_protoboard( mode, "boxbot",  x= +30, y=0, angle=0, lift=7 );    
    //place_ala_small_red_protoboard( mode, "lid", x= +20, y=0, angle=90, lift=7 );

    //place_ala_permaprotohalf( mode, "boxbot", x= -30, y=0, angle=90 );
    //place_ala_permaprotohalf( mode, "boxbot",  x= +20, y=0, angle=0 );    
    //place_ala_permaprotohalf( mode, "lid", x= +20, y=0, angle=90 );

    place_ala_feather_doubler( mode, "boxbot", x= -30, y=0, angle=90 );
    place_ala_feather_tripler( mode, "boxbot",  x= +30, y=0, angle=90 );    
    place_ala_feather( mode, "lid", x= +20, y=0, angle=90 );
} 

