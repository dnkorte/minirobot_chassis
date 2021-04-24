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

module place_motors_invokes(mode="adds") {  
    place_geared_stepper_motor(mode);   
    place_sparkfun_stepper_motor(mode);       
    place_n20_motor(mode);
    place_TT_motor(mode);
    place_pololu_miniplastic_motor(mode); 
    place_nema17_stepper_motor(mode);
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
    //if (motor_lift < 6) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}
        
    
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
    //if (motor_lift < 6) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}     

    motor_x = (stance > 5) ? box_front_x + stance : 0;
    
    if ( (motor_type == "Sparkfun Stepper") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_sparkfun_stepper_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2, motor_lift ]) 
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
    //if (motor_lift < 6) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}       

    motor_x = (stance > 5) ? box_front_x + stance : 0;     
    
    if ( (motor_type == "N20 Geared with Encoder") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_n20_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_n20_motor(mode);
    }

    
    if ( (motor_type == "4 N20 Geared with Encoder") && (part == "box")) {
        // front right motor
        translate([ box_front_x+18,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_n20_motor(mode);
        // front left motor
        translate([ box_front_x+18,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_n20_motor(mode);

        // back right motor
        translate([ box_back_x-18,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_n20_motor(mode);
        // back left motor
        translate([ box_back_x-18,  -(box_width)/2, motor_lift ]) 
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
    motor_lift_minimum = 10 + body_bottom_thickness;        // color motor orange because its too low to mount safely
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    //if (motor_lift < 10) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}       

    motor_x = (stance > 5) ? box_front_x + stance : 0;     
    
    if ( (motor_type == "Blue TT Horizontal") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_blue_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_blue_motor(mode);
    }     
    
    if ( (motor_type == "Blue TT Vertical") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_blue_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_blue_motor(mode);
    }      
    
    if ( (motor_type == "Yellow TT Horizontal") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_yellow_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_yellow_motor(mode);
    }     
    
    if ( (motor_type == "Yellow TT Vertical") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_yellow_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_yellow_motor(mode);
    }
      
    
    if ( (motor_type == "DFR TT with Encoder H") && (part == "box")) {

        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_TT_DFR_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_TT_DFR_motor(mode);
    }     
    
    if ( (motor_type == "DFR TT with Encoder V") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_TT_DFR_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_TT_DFR_motor(mode);
    }   

    
    if ( (motor_type == "4 Blue TT Horizontal") && (part == "box")) {
        
            // right-front motor
            translate([ box_front_x+24,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_blue_motor(mode);
            // left-front motor
            translate([ box_front_x+24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_blue_motor(mode);
        
            // right-back motor
            translate([ box_back_x-24, (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 180, 0]) 
                component_TT_blue_motor(mode);
            // left-back motor
            translate([ box_back_x-24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 180, 0]) 
                component_TT_blue_motor(mode);
    }  

    
    if ( (motor_type == "4 Yellow TT Horizontal") && (part == "box")) {
        
            // right-front motor
            translate([ box_front_x+24,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 0, 0]) 
                component_TT_yellow_motor(mode);
            // left-front motor
            translate([ box_front_x+24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 0, 0]) 
                component_TT_yellow_motor(mode);
        
            // right-back motor
            translate([ box_back_x-24, (box_width)/2 - body_wall_thickness, motor_lift ]) 
                rotate([ 90, 180, 0]) 
                component_TT_yellow_motor(mode);
            // left-back motor
            translate([ box_back_x-24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
                rotate([ -90, 180, 0]) 
                component_TT_yellow_motor(mode);
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
    motor_lift_minimum = 20 + body_bottom_thickness;        // color motor orange because its too low to mount safely
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    //if (motor_lift < 10) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}   
    motor_x = (stance > 5) ? box_front_x + stance : 0;
    

    if ( (motor_type == "Pololu MiniPlastic Horizontal") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);

    }    
    
    if ( (motor_type == "Pololu MiniPlastic Vertical") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
    }

    
    if ( (motor_type == "4 Pololu MiniPlastic Horizontal") && (part == "box") ) {
    	// ========= nice long box use horizontal motors ==================
        // right-front motor
        translate([ box_front_x+20,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-front motor
        translate([ box_front_x+20,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 0, 0]) 
            component_pololu_miniplastic_motor(mode);
        // right-back motor
        translate([ box_back_x-20,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, 180, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-back motor
        translate([ box_back_x-20,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, 180, 0]) 
            component_pololu_miniplastic_motor(mode);
    }

	if ( (motor_type == "4 Pololu MiniPlastic Vertical") && (part == "box") ) {
    	// ========= horizontally short, but tall box use vertical motors ==================
        // right-front motor
        translate([ box_front_x+24,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-front motor
        translate([ box_front_x+24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
        // right-back motor
        translate([ box_back_x-24,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -90, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-back motor
        translate([ box_back_x-24,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -90, 0])
            component_pololu_miniplastic_motor(mode);
	}

	if ( (motor_type == "4 Pololu MiniPlastic Diagonal") && (part == "box") ) {
    	// ========= vertically short and horizontally short box use diagonal motors ==================
        // right-front motor
        translate([ box_front_x+17,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -35, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-front motor
        translate([ box_front_x+17,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -35, 0]) 
            component_pololu_miniplastic_motor(mode);
        // right-back motor
        translate([ box_back_x-20,  (box_width)/2 - body_wall_thickness, motor_lift ]) 
            rotate([ 90, -180, 0]) 
            component_pololu_miniplastic_motor(mode);
        // left-back motor
        translate([ box_back_x-20,  -(box_width)/2 + body_wall_thickness, motor_lift ]) 
            rotate([ -90, -180, 0]) 
            component_pololu_miniplastic_motor(mode);
	}


}


/*
 * ****************************************************************************************
 * NEMA 17 stepper motor
 * info: https://reprap.org/wiki/NEMA_17_Stepper_motor
 * 4 moounting molts (M3) on 31mm centers; central hub 22mm dia; 5mm shaft 24mm long
 * motor body depth varies per current/torque; 42mm square; typ 47 mm deep
 * *****************************************************************************************
 */

module place_nema17_stepper_motor(mode="holes") {
    // note 0=shaft same height as motor center; positive=shaft is BELOW motor center
    motor_center_to_shaft_z = 0;
    
    motor_lift = shaft_height_above_box_bottom + motor_center_to_shaft_z;
    //if (motor_lift < 22) {
    //    echo("<span style='background-color:red'>NOTICE: wheels too small; use shorter caster or wheels with bigger diameter</span>");
    //}        

    motor_x = (stance > 5) ? box_front_x + stance : 0; 
    
    if ( (motor_type == "NEMA 17 Stepper") && (part == "box")) {
        // right-side motor
        translate([ motor_x,  (box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 0]) 
            component_nema17_stepper_motor(mode);
        // left-side motor
        translate([ motor_x,  -(box_width)/2, motor_lift ]) 
            rotate([ 90, 0, 180]) 
            component_nema17_stepper_motor(mode);
    }
}

