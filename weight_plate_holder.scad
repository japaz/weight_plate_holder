// Weight Plate Holder with Manifold-Safe Threads
// Simplified to prevent non-manifold geometry warnings

// Main Parameters
cylinder_length = 80; // 8 cm
inner_diameter = 25; // 2.5 cm for inner cylinder
outer_diameter = 30; // 3 cm to fit inside weight plate holes
base_diameter = 40; // 4 cm diameter for both bases
base_thickness = 5; // Thickness of the base
wall_thickness = 3; // Wall thickness for the hollow inner cylinder

// Thread parameters
thread_pitch = 5;    // Distance between thread peaks
thread_depth = 2;    // Slightly reduced depth for better manifold properties
thread_segments = 60; // Reduced for cleaner geometry

// Simplified approach for external threads (male)
module external_thread(diameter, height, pitch, depth, segments) {
    num_turns = floor(height / pitch);
    cylinder_radius = diameter / 2;
    
    // Base cylinder
    cylinder(h = height, d = diameter, $fn = segments);
    
    // Add thread as a continuous spiral
    for (i = [0:num_turns-1]) {
        translate([0, 0, i * pitch]) {
            linear_extrude(height = pitch, twist = 360, slices = segments, convexity = 10) {
                translate([cylinder_radius - depth/2, 0, 0])
                circle(d = depth, $fn = 8); // Use octagon instead of circle for better manifold
            }
        }
    }
}

// Simplified approach for internal threads (female)
module internal_thread_negative(diameter, height, pitch, depth, segments) {
    num_turns = floor(height / pitch);
    cylinder_radius = diameter / 2;
    
    union() {
        // Core hole
        cylinder(h = height, d = diameter, $fn = segments);
        
        // Add thread cuts as a continuous spiral
        for (i = [0:num_turns-1]) {
            translate([0, 0, i * pitch]) {
                linear_extrude(height = pitch, twist = 360, slices = segments, convexity = 10) {
                    translate([cylinder_radius, 0, 0])
                    circle(d = depth * 1.2, $fn = 8); // Slightly larger for clearance
                }
            }
        }
    }
}

// Inner Connector Cylinder (male part) - hollow design with full-length threads
module inner_connector() {
    effective_length = cylinder_length - base_thickness;
    
    difference() {
        union() {
            // Base plate at the bottom
            cylinder(h = base_thickness, d = base_diameter, $fn = thread_segments);
            
            // Threaded main body
            translate([0, 0, base_thickness])
            external_thread(
                inner_diameter - thread_depth, 
                effective_length, 
                thread_pitch, 
                thread_depth, 
                thread_segments
            );
        }
        
        // Hollow out the cylinder and base
        translate([0, 0, -0.1])
        cylinder(h = cylinder_length + base_thickness + 0.2, 
                d = inner_diameter - 2*wall_thickness, 
                $fn = thread_segments);
    }
}

// Outer Connector Cylinder (female part) with full-length threads
module outer_connector() {
    effective_length = cylinder_length - base_thickness;
    
    difference() {
        union() {
            // Main cylinder
            cylinder(h = effective_length, d = outer_diameter, $fn = thread_segments);
            
            // Base plate at the top
            translate([0, 0, effective_length])
            cylinder(h = base_thickness, d = base_diameter, $fn = thread_segments);
        }
        
        // Core hole with threads
        translate([0, 0, -0.1])
        internal_thread_negative(
            inner_diameter, 
            effective_length + 0.2, 
            thread_pitch, 
            thread_depth, 
            thread_segments
        );
            
        // Hollow out the base center
        translate([0, 0, effective_length - 0.1])
        cylinder(h = base_thickness + 0.2, 
                d = outer_diameter - 2*wall_thickness, 
                $fn = thread_segments);
    }
}

// Display pieces stacked vertically (not connected)
module display_stacked() {
    // Bottom piece (inner connector)
    inner_connector();
    
    // Top piece (outer connector) - positioned above but not connected
    translate([0, 0, cylinder_length + 10])
    outer_connector();
}

// Display the assembly (threaded together)
module display_assembly() {
    // Position inner connector
    inner_connector();
    
    // Position the outer connector to connect with the inner one
    translate([0, 0, base_thickness])
    outer_connector();
}

// Choose which display to use
display_stacked(); // Show pieces stacked vertically
//display_assembly(); // Show assembled version