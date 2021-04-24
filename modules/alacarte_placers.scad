/*
 * ala-carte placers
 */


/*
 * ********************************************************************************
 *
 * pplace_ala_smallmint_proto()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees
 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 *
 * ********************************************************************************
 */

module place_ala_smallmint_proto( mode, whereused, x=0, y=0, angle=0, lift=7 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_smallmint_protoboard_lifted(mode, lift);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_smallmint_protoboard_lifted(mode, lift);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
    	translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
        	translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_smallmint_protoboard_lifted("lidcheck", lift);
        }
    }

}



/*
 * ********************************************************************************
 *
 * place_ala_small_red_protoboard()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees

 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 *
 * ********************************************************************************
 */

module place_ala_small_red_protoboard( mode, whereused, x=0, y=0, angle=0, lift=7 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_small_red_protoboard_lifted(mode, lift);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_small_red_protoboard_lifted(mode, lift);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
        translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
            translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_small_red_protoboard_lifted("lidcheck", lift);
        }
    }

}



/*
 * ********************************************************************************
 *
 * place_ala_permaprotohalf()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *          note "lift" is not available 
 *
 * ********************************************************************************
 */

module place_ala_permaprotohalf( mode, whereused, x=0, y=0, angle=0 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_permaprotohalf(mode);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_permaprotohalf(mode);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
        translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
            translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_permaprotohalf("lidcheck");
        }
    }

}



/*
 * ********************************************************************************
 *
 * place_ala_feather()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees

 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 *
 * ********************************************************************************
 */

module place_ala_feather( mode, whereused, x=0, y=0, angle=0, lift=7 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_feather_lifted(mode, lift);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_lifted(mode, lift);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
        translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
            translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_lifted("lidcheck", lift);
        }
    }

}

/*
 * ********************************************************************************
 *
 * place_ala_feather_doubler()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *          note "lift" is not available 
 *
 * ********************************************************************************
 */

module place_ala_feather_doubler( mode, whereused, x=0, y=0, angle=0 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_feather_doubler(mode);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_doubler(mode);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
        translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
            translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_doubler("lidcheck");
        }
    }

}

/*
 * ********************************************************************************
 *
 * place_ala_feather_tripler()
 *
 * this makes a base for adafruit small mint tin size protoboard 
 * its base is 1mm thick, and 54 x 33 mm
 * it has 4 M3 threaded insert mounts 45.5mm x 25.4mm spacing
 *  
 * this is generated in xy plane, centered at origin, box outside skin is at z=0 (moving "into" box has +z)
 * it is generated in "landscape" shape
 *
 * 
 * param: mode = "adds", "holes", "vis", "lidcheck"
 *
 * param: whereused = "boxbot", "lid", "plate"
 *          note  "boxback", "boxfront" are NOT AVAILBLE FOR THIS COMPONENT
 *
 * param: x = distance front/back (ignored for whereused == "boxback" or "boxfront")
 *          note for "boxbot", +x is back, -x is front; 
 *          note for "boxlid" or "plate", +x is front, -x is back;
 *
 * param: y = distance left / right
 *          note for all whereused; +y is right, -y is left
 *
 * param: angle = rotational angle for part; 0 = "long axis runs front/back", 90 = "wide way"
 *                but may be any angle in degrees
 *
 * PARAMETERS NOT AVAILABLE FOR THIS PART
 * param: z = distance above box bottom (used only for "boxfront" and "boxback"
 * param: lift = amount board is raised "above" (perpindicular to) box wall it is placed against
 *          note "lift" is not available 
 *
 * ********************************************************************************
 */

module place_ala_feather_tripler( mode, whereused, x=0, y=0, angle=0 ) {
    
    if ( (part == "box") && (whereused == "boxbot") ) {
        translate([ x, y, body_bottom_thickness]) rotate([ 0, 0, angle ]) component_feather_tripler(mode);
    }
    
    if ( (part == "lid") && (whereused == "lid") ) {
        translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_tripler(mode);
    }
    

    if ( (part == "box") && (whereused == "lid") ) {
        translate([ 0, 0, (height_of_box + lid_thickness) ]) rotate([ 0, 180, 0 ]) union() {
            translate([ x, y, lid_thickness]) rotate([ 0, 0, angle ]) component_feather_tripler("lidcheck");
        }
    }

}