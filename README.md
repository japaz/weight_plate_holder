# Weight Plate Holder Documentation

## Project Overview
This project contains files for a 3D-printable weight plate holder designed for body pump exercises. The design consists of two cylindrical parts that screw together, with bases at opposite ends to prevent weight plates from falling off.

## Design Specifications
- **Total Length**: 8 cm
- **Outer Diameter**: 3 cm (to fit through standard 3 cm weight plate holes)
- **Base Diameter**: 4 cm (to prevent weight plates from sliding off)
- **Inner Structure**: Hollow cylinders to reduce weight
- **Connection**: Full-length threaded connection between the two parts

## Files
- `weight_plate_holder.scad` - OpenSCAD source file for the design
- `weight_plate_holder_inner.stl` - STL file for the inner connector (male thread)
- `weight_plate_holder_outer.stl` - STL file for the outer connector (female thread)

## Design Evolution
The design went through several iterations to improve:

1. Initial concept with two cylinders, one fitting into the other
2. Addition of bases at opposite ends to hold weight plates
3. Implementation of visible threads along the full length of both cylinders
4. Thread optimization to ensure the design is manifold and 3D-printable

## Thread Implementation Notes
The final thread implementation uses:
- Linear extrusion with twist to create continuous spiral threads
- Simplified thread profile using octagonal shapes for better manifold geometry
- Thread pitch of 5mm and depth of 2mm
- Reduced complexity in geometry to prevent non-manifold warnings during STL export

## 3D Printing Recommendations
- Print with at least 20% infill for structural integrity
- Both parts can be printed without supports if oriented correctly
- Test the thread fit after printing - you might need to adjust your printer's tolerance settings if the fit is too tight or loose

## OpenSCAD Usage
- The file is set up to display both parts stacked vertically by default
- To view the assembled version, uncomment the `display_assembly()` line and comment out the `display_stacked()` line
- Adjust thread parameters if needed for your specific printer's tolerances

## Generating STL Files
The STL files were generated with the following commands:
```
openscad -o weight_plate_holder_inner.stl -D "inner_connector();" weight_plate_holder.scad
openscad -o weight_plate_holder_outer.stl -D "outer_connector();" weight_plate_holder.scad
```

## Design Notes
- The outer cylinder has a diameter of 3 cm to fit inside weight plate holes
- Both cylinders have a base of around 4 cm in diameter at opposite ends
- The inner cylinder is hollow to reduce material usage and weight
- The threaded connection runs the full length of both cylinders for a secure fit