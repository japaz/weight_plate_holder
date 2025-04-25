// Parameters
cylinder_length = 80; // 8 cm
inner_diameter = 25; // 2.5 cm for inner cylinder
outer_diameter = 30; // 3 cm to fit inside weight plate holes
base_diameter = 40; // 4 cm diameter for both bases
base_thickness = 5; // Thickness of the base
wall_thickness = 3; // Wall thickness for the hollow inner cylinder

// Thread parameters
thread_pitch = 3; // Distance between thread peaks
thread_depth = 1.5; // Depth of the thread
thread_length = 18; // Length of threaded section

// Module for creating a more visible external thread
module external_thread(diameter, height, pitch, depth) {
    segments = 100;
    turns = height / pitch;
    
    for (i = [0:segments-1]) {
        rotate([0, 0, i * (360 / segments)])
        translate([0, 0, (i / segments) * height])
        rotate_extrude(angle = 355 / segments, $fn = 30)
        translate([diameter/2 - depth/2, 0, 0])
        circle(d = depth, $fn = 20);
    }
}

// Module for creating a more visible internal thread
module internal_thread(diameter, height, pitch, depth) {
    segments = 100;
    turns = height / pitch;
    
    difference() {
        cylinder(h = height, d = diameter + 2*depth, $fn = 100);
        
        // Core cylinder
        translate([0, 0, -0.1])
        cylinder(h = height + 0.2, d = diameter, $fn = 100);
        
        // Thread grooves
        for (i = [0:segments-1]) {
            rotate([0, 0, i * (360 / segments)])
            translate([0, 0, (i / segments) * height])
            rotate_extrude(angle = 355 / segments, $fn = 30)
            translate([diameter/2 + depth/2, 0, 0])
            circle(d = depth, $fn = 20);
        }
    }
}

// Inner Connector Cylinder (male part) - hollow design with visible threads
module inner_connector() {
    difference() {
        union() {
            // Base plate at the bottom
            cylinder(h = base_thickness, d = base_diameter, $fn = 100);
            
            // Hollow main cylinder
            translate([0, 0, base_thickness]) {
                difference() {
                    union() {
                        // Main part of cylinder
                        cylinder(h = cylinder_length - thread_length, d = inner_diameter, $fn = 100);
                        
                        // Threaded end (top)
                        translate([0, 0, cylinder_length - thread_length]) {
                            cylinder(h = thread_length, d = inner_diameter - thread_depth, $fn = 100);
                            external_thread(inner_diameter - thread_depth, thread_length, thread_pitch, thread_depth);
                        }
                    }
                    
                    // Hollow out the cylinder
                    translate([0, 0, -0.1])
                        cylinder(h = cylinder_length + 0.2, d = inner_diameter - 2*wall_thickness, $fn = 100);
                }
            }
        }
        
        // Cut out center of base for weight reduction (but leave an outer ring for strength)
        translate([0, 0, -0.1])
            cylinder(h = base_thickness + 0.2, d = inner_diameter - 2*wall_thickness, $fn = 100);
    }
}

// Outer Connector Cylinder (female part) with visible threads
module outer_connector() {
    difference() {
        union() {
            // Base plate at the top
            translate([0, 0, cylinder_length - base_thickness])
                cylinder(h = base_thickness, d = base_diameter, $fn = 100);
            
            // Main cylinder
            cylinder(h = cylinder_length - base_thickness, d = outer_diameter, $fn = 100);
                
            // Add internal thread at the bottom
            translate([0, 0, 0])
                internal_thread(inner_diameter, thread_length, thread_pitch, thread_depth);
        }
        
        // Hollow out the main body above the threaded section
        translate([0, 0, thread_length - 0.1])
            cylinder(h = cylinder_length - thread_length + 0.2, d = inner_diameter + thread_depth, $fn = 100);
            
        // Hollow out the base center (but leave outer ring for strength)
        translate([0, 0, cylinder_length - base_thickness - 0.1])
            cylinder(h = base_thickness + 0.2, d = outer_diameter - 2*wall_thickness, $fn = 100);
    }
}

// Display the assembled model
module display_assembly() {
    // Position inner connector
    inner_connector();
    
    // Position the outer connector to connect with the inner one
    // The assembly will have bases at opposite ends
    translate([0, 0, base_thickness + cylinder_length - thread_length])
        outer_connector();
}

// Toggle between these views
display_assembly(); // Show correctly assembled version with bases at opposite ends