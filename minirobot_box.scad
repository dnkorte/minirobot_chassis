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
part="box";  // ["box", "lid", "TT Motor Clamp", "Pololu Motor Clamp", "Lid Feature Plate", "test" ]

/* [Main Box Size (outer)] */
// mm LONG front-to-back (outside)
box_length = 90;      // [90, 96, 100, 111, 120] 
// mm WIDE (outside). Note that 12mm wide wheels allow 76mm box, 10mm wheels allow 80mm box (4in/100mm competition rules)
box_width = 90;       // [76, 80, 90, 96, 101]  
// mm TALL NOT including thickness of lid (default 55) 
height_of_box = 55;  // [44, 55, 70, 90, 100] 
// radius of vertical box corners and lid corners in mm
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
has_grabber_mounts_narrow = false;
has_grabber_mounts_wide = false;
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
linesensor_snout = "none";    // ["none", "Standard Size", "Extended"]

/* [Inside-Box Electronics Boards] */
box_bottom_PCB = "PermaProto Mini-Tin"; // ["none", "PermaProto Small-Mint", "Dual Small-Mint", "PermaProto HalfSize", "Red Tindie Proto", "Dual Red Tindie", "Triple Red Tindie", "Feather", "Feather Doubler", "Feather Tripler", "TB6612", "Dual TB6612", "TB6612 and Small-Mint", "Dual TB6612 and Small-Mint", "TB6612 and Feather", "Dual TB6612 and Feather", "QWIIC I2C Motor Driver", "QWIIC I2C Motor Driver + Small-Mint", "QWIIC I2C Motor Driver + Feather",  "L298_motor_driver", "L298 and Small-Mint", "L298 and Feather", "Geared Stepper Driver", "Dual Geared Stepper Driver", "Dual Geared Stepper Driver and Small-Mint", "Dual Geared Stepper Driver and Feather", "Dual Sparkfun EasyDriver", "Dual Sparkfun EasyDriver + Small-Mint", "Dual Sparkfun EasyDriver + Feather", "3 Small-Mint Inline", "Front Small-Mint + Raised Ctr Small-Mint", "F/B Small-Mint + Raised Ctr Small-Mint", "Front Red Tindie + Raised Ctr Red Tindie", "F/B Red Tindie + Raised Ctr Red Tindie", "Front Small-Mint + Raised Ctr Feather", "F/B Small-Mint + Raised Ctr Feather", "Front Red Tindie + Raised Ctr Feather", "F/B Red Tindie + Raised Ctr Feather"]

// Some layouts allow a protoboards or Feathers to be raised higher than driver boards.  This allows you to avoid collisions with motors or other components if your box is tall enough
board_raise_amount = 7; // [7:"No Added Lift (7mm high)", 17:"Lift to 17mm", 22:"Lift to 22mm", 27:"Lift to 27mm"]

/* [Lid Features] */
has_button_lid_left = false;
has_button_lid_right = false;
has_toggle_lid_left = false;
has_toggle_lid_right = false;
has_wire_port_front = false;
has_wire_port_left = false;
has_wire_port_right = false;
has_wire_port_backleft = false;
has_wire_port_backcenter = false;
has_wire_port_backright = false;
has_neopixel_strip = false;


/* [Motors, Wheels and Casters] */

motor_type="Geared Stepper";   // ["Geared Stepper", "Sparkfun Stepper", "Yellow TT Horizontal", "Yellow TT Vertical", "Blue TT Horizontal", "Blue TT Vertical", "DFR TT with Encoder H", "DFR TT with Encoder V", "Pololu MiniPlastic Horizontal", "Pololu MiniPlastic Vertical", "N20 Geared with Encoder", "Micro Servo Case"]

motor_mount = "TT uses clamp";  // ["TT uses clamp", "TT uses long bolts through motor" ]

// Most desirably, the motor axle should be centered between the front and back of the box.  If the box is too short for this to happen with the selected motor the scripts will move the motor "forward" to keep it in the box.  If you check this box it will allow the motors to extend out the back of the box in order to keep the shafts centered.  
allow_motors_to_extend_out_back_of_box = false;

wheel_diameter = 59.8; // [ 59.8:Adafruit Skinny Wheel (any hub) 60, 65:Adafruit Thin White TT Wheel 65, 63:Adafruit Orange and Clear TT Wheel 63, 40:Pololu 40x7mm Wheel 40, 60:Pololu 60x8mm Wheel 60, 70:Pololu 70x8mm Wheel 70, 80:Pololu 80x10 Wheel 80, 42:DFR 42x19 Wheel 42, 65:DFR 65mm Rubber Wheel 65, 58:Custom 58x8mm Printed Wheel 58, 67:Custom 67x8mm Printed Wheel 67, 80:Custom 80x8mm Printed Wheel 80 ]

// The caster controls the distance from the bottom of the box to the floor.  The scripts will move the motors up or down to maintain this distance regardless of the wheel diameter selected.  Note if using a line sensor the caster should be 12-20mm
caster_height = 10.1; // [10.1:Pololu 3/8in no spacers (10.1), 11.7:Pololu 3/8in + 1/16 spacer (11.7), 13.3:Pololu 3/8in + 1/8 spacer (13.3), 13.5:Pololu 1/2in no spacers (13.5), 15.5:Pololu 1/2in + 1/16 spacer (15.1), 16.8:Pololu 1/2in + 1/8 spacer (16.8), 19:Custom Printed Peg (19), 19.5:Pololu 1/2in + custom 6mm spacer (19.5), 22.4:Pololu 3/4in no spacers (22.4), 25:Custom Printed Peg (25), 25.6:Pololu 3/4in + 1/8 spacer (25.6) ] 

// Note this clearance gap raises the box a bit and ensures that bumps or irregularities in the floor don't lift wheels off the ground
caster_to_ground_gap = 2; // [ 1, 2, 3 ]


/* [ Power Options] */

// this creates 3.3v from LiPo or NiMH (Feather, Itsy need of this)
want_3v_buck = true;

// this creates 5v from LiPo or NiMH (Teensy, NeoPixels need this, Itsy can use this)
want_5v_boost = true;

// this creates 6-30v from LiPo or NiMH for motors; 
boost_converter_for_motors = "None"; // ["None", "Front Adjustable", "Side Adjustable", "Front Pololu", "Side Pololu"]

power_distribution_buss = "Long Way"; // ["none", "Long Way", "Long Way Set Back", "Wide Way"]

battery="2200 mAH Cylindrical Front Right"; // ["2200 mAH Cylindrical Front Right", "2200 mAH Cylindrical Front Center", "1200 mAH LiPo Front Right", "1200 mAH LiPo Front Center", "500 mAH LiPo Front Right", "500 mAH LiPo Front Center"]

// minimum distance between bottom of battery box and bottom of box (airgap)
airgap_under_batterybox = 10; // [2, 10, 15, 20]


/* [Visualization] */
show_internal_parts_for_collision_check = false;
show_lid_parts_for_collision_check = false;
show_box_walls = true;
height_of_visualized_feathers = 1; // [ 1:1 Board, 2:2 Boards, 3:3 Boards ]

/*
 * ************************************************************************************
 * note this mainline module selects the part AND ALSO ends the configurator variables
 * ************************************************************************************
 */
module draw_part() {
    $fn = 24;

    if(part == "box") {
        box();
    } else if(part == "lid") {
        lid();
    } else if(part == "battery clamp") {
        // nothing
    } else if(part == "TT Motor Clamp") {
        component_tt_motor_clamp();
    } else if(part == "Pololu Motor Clamp") {
        component_pololu_miniplastic_motor_clamp();
    } else if(part == "test") {
        component_qwiic_motor_driver();
    }
}

/*
 * ******************************************************************
 * basic box construction parameters, rarely changed 
 * ******************************************************************
 */
// mm clearance between inner wall of box bottom and outer edge of lid lip
lid_clearance=0.4;  
// thickness of lip in mm (width of its "wall")
lid_lip_thickness = 2;
// height of lip in mm
lid_lip_height = 6; 
// thickness of lid in mm
lid_thickness = 3;   
// thickness of body wall in mm
body_wall_thickness = 2.4; 
// bottom usually same as wall, but may be different
body_bottom_thickness = body_wall_thickness; 
// radius of inside corners on box (1=rectangular inside; default (box_corner_radius-2)
box_corner_inner_radius = box_corner_radius - 2; 
// radius of outside corners on lip on the lid; default (box_corner_inner_radius)
lip_corner_radius = box_corner_inner_radius;  

/*
 * ***********************************************************************
 * basic user preference parameters (3d printer specific), rarely changed 
 * ***********************************************************************
 */
// parameters for holes that will be "self-tapped" by screws
// these may be fine-tuned for your printer
screwhole_radius_M30_passthru = 2;  
screwhole_radius_M30_selftap = 1.40;  
screwhole_radius_M25_passthru = 1.8;  
screwhole_radius_M25_selftap = 1.1; 
screwhole_radius_M20_passthru = 2;  
screwhole_radius_M20_selftap = 1.0;   

// parameters for threaded insert mount (M3; McMaster-Carr)
// note if TI_30_use_threaded_insert == false then self-tap holes are generated
TI30_use_threaded_insert = false;
TI30_mount_diameter = 7;
TI30_through_hole_diameter = 4.3;  
TI30_default_height = 6.0;

// parameters for threaded insert mount (M2.5; Amazon)
// note if TI_25_use_threaded_insert == false then self-tap holes are generated
TI25_use_threaded_insert = false;
TI25_mount_diameter = 7;
TI25_through_hole_diameter = 4.2;  
TI25_default_height = 6.0;

// parameters for threaded insert mount (M2; McMaster-Carr)
// note if TI_20_use_threaded_insert == false then self-tap holes are generated
TI20_use_threaded_insert = true;
TI20_mount_diameter = 6;
TI20_through_hole_diameter = 3.7; 
TI20_default_height = 6.0; 


 
include <core_components.scad>;
include <core_minirobot_placers.scad>;

/*
 * ****************************************
 * calculate these working parameters
 * once their preprequisites are defined
 * ****************************************
 */

// correct for potential non-manifold errors if the lip height is same as mount dia  
use_lid_lip_height = (TI30_mount_diameter == lid_lip_height) ? (lid_lip_height + 0.1) : lid_lip_height;

// and ensure that mount is at least "far enough" away from lid panel that it can be fully round
mount_center_offset_from_boxtop = (lid_lip_height < TI30_mount_diameter) ? (TI30_mount_diameter/2) : (use_lid_lip_height / 2);

wheel_radius = wheel_diameter / 2;
// note motor shaft is lowered by small gap in order to raise box a bit
// so that bumps or surface irregularities don't lift wheels off the ground
shaft_height_above_box_bottom = wheel_radius - caster_height - caster_to_ground_gap;

echo("wheel radius: ", wheel_radius);
echo("caster height: " , caster_height);
echo("shaft over box bottom: ", shaft_height_above_box_bottom);


if ((linesensor_snout != "none") && (caster_height < 12)) {
    echo("<span style='background-color:red'>NOTICE: line follower works best with 12 - 20mm caster; please use a taller caster</span>");
}
if ((linesensor_snout != "none") && (caster_height > 20)) {
    echo("<span style='background-color:red'>NOTICE: line follower works best with 12 - 20mm caster; please use a shorter caster</span>");
}

/*
 * *******************************************************************************
 * pre-calculate some basic parameters to help with placement in placer module
 * *******************************************************************************
 */

// x,y location of box and lid walls (remember that lid is generated "upside down"
box_front_x = -(box_length/2);
box_back_x = +(box_length/2);
box_L_y = -(box_width/2);
box_R_y = +(box_width/2);

lid_front_x = +(box_length/2);
lid_back_x = -(box_length/2);
lid_L_y = -(box_width/2);
lid_R_y = +(box_width/2);

// this means that the battery box (any style) will reach no closer than XX mm above inside box bottom
max_length_for_battbox = height_of_box - body_bottom_thickness - airgap_under_batterybox;

/*
 * *****************************************************************
 * mainline code for drawing parts
 * most standard components are already handled here, by means
 * of configuration parameters, however custom parts may be
 * added by adding appropriate code to these modules
 * *****************************************************************
 */

draw_part();

module box() {
    difference() {
        // the basic hollow box
        if (show_box_walls) {
            difference() {
                roundedbox(box_length, box_width, box_corner_radius, height_of_box);
                translate([0, 0, body_bottom_thickness])  
                    roundedbox((box_length - 2*body_wall_thickness), 
                               (box_width - 2*body_wall_thickness), 
                               box_corner_inner_radius, 
                               (height_of_box - body_wall_thickness+1));
            }
        } else {
            roundedbox(box_length, box_width, box_corner_radius, body_bottom_thickness);
        }
        
      
       // create mounting holes along y side
        translate([-(box_length/2)-0.1, 0, (height_of_box - mount_center_offset_from_boxtop)]) rotate([0,90,0])  
              cylinder(h=box_length+0.2, r=screwhole_radius_M30_passthru);
      
        // create mounting holes along x side
        translate([0, -(box_width/2)-0.1, (height_of_box - mount_center_offset_from_boxtop)]) rotate([0,90,90])  
              cylinder(h=box_width+0.2, r=screwhole_radius_M30_passthru);
        
        // now enter all the parts that are removed from the box
        place_mini_toggle_switch("holes");
        place_pushbuttons("holes");
        place_arcade_buttons("holes");
        place_geared_stepper_motor("holes");
        place_sparkfun_stepper_motor("holes");
        place_n20_motor("holes");
        place_TT_motor("holes");
        place_pololu_miniplastic_motor("holes");
        place_battery("holes");
        place_power_distribution("holes");
        place_boost_buck("holes");
        place_lid_wire_ports("holes");
    }
    
    // now if we want to check for collisions, we show a blue image of lid lip
    if (show_lid_parts_for_collision_check) {
        lip_box_length = box_length - (2 * (body_wall_thickness + lid_clearance));
        lip_box_width = box_width - (2 * (body_wall_thickness + lid_clearance));
        lip_inner_x = lip_box_length - (2 * lid_lip_thickness);
        lip_inner_y = lip_box_width - (2 * lid_lip_thickness);
        
        translate([ 0, 0, height_of_box-lid_lip_height ]) color([ 0, 0, 1 ]) difference() {
            roundedbox(lip_box_length, lip_box_width, lip_corner_radius, use_lid_lip_height);
            translate([ 0, 0, -0.5 ]) roundedbox(lip_inner_x, lip_inner_y, lip_corner_radius-2, use_lid_lip_height+1);
        }
    }
    
    // now enter the parts that are added to the box 
    place_mini_toggle_switch("adds");
    place_pushbuttons("adds");
    place_arcade_buttons("adds");
    place_geared_stepper_motor("adds");
    place_box_bottom_combo();
    place_red_protoboard();
    place_smallmint_protoboard();
    place_feather();
    place_feather_doubler();
    place_feather_tripler();
    place_permaprotohalf();
    place_tb6612();
    place_L298motor_driver();
    place_gearedstepper_driver();
    place_easydriver();
    place_sparkfun_stepper_motor("adds");
    place_n20_motor("adds");
    place_TT_motor("adds");
    place_pololu_miniplastic_motor("adds");    
    place_battery("adds");
    place_power_distribution("adds");
    place_boost_buck("adds");
    place_lid_wire_ports("adds");
}

module lid() {
    difference() {
        // here enter all the parts that "remove" from the lid
        union() {
            roundedbox(box_length, box_width, box_corner_radius, lid_thickness);
            translate([0, 0, lid_thickness]) lip();  
        }
        
        // here enter all the parts that are "removed" from the lid
        place_mini_toggle_switch("holes");
        place_pushbuttons("holes");
        //place_power_components(mode="holes");
        place_battery("holes");
        place_power_distribution("holes");
        place_boost_buck(mode="holes");
        place_lid_wire_ports("holes");
    }
    
    // now enter the parts that are added to the lid
    place_mini_toggle_switch("adds");
    place_pushbuttons("adds");  
    //place_power_components("adds");
    place_battery("adds");
    place_power_distribution("adds");
    place_boost_buck(mode="adds");
    place_lid_wire_ports("adds");
}

