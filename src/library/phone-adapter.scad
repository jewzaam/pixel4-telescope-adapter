include <shapes.scad>
include <debug.scad>

/*

Pixel 4 case that mounts on a custom 2" to 1.25" adapter.

https://store.google.com/us/product/pixel_4

*/

/* [Hidden] */


module phone_adapter
(
    phone_xyz,
    phone_dim,
    phone_rot,
    phone_buttons_dim,
    phone_buttons_xyz,
    phone_buttons_rot,
    phone_camera_dim,
    phone_camera_xyz,
    phone_camera_rot,
    phone_camera_center_xyz,
    phone_power_width,

    // thickness of the case
    case_thickness=2,

    // width of the case lip
    case_lip=2,

    // Adapter inner diameter (this must be wider than the eyepiece adapter outer diameter!)
    adapter_inner_diameter=57,

    // Adapter thickness
    adapter_thickness=6,

    // If this is made too high not all eyepieces can be attached.  Consider a short eyepiece.
    adapter_height=35,

    // Distance to put screws from bottom of adapter
    adapter_screw_offset=5,

    // Number of screws.
    adapter_screw_count=3,

    // Diameter of the screws.
    adapter_screw_diameter=3.9
)
{

    // setup all the variables inside the module so they don't bleed out

    case_xyz=[phone_xyz[i_x]-case_thickness,phone_xyz[i_y]-case_thickness,phone_xyz[i_z]-case_thickness];
    case_dim=[phone_dim[i_x]+case_thickness*2,phone_dim[i_y]+case_thickness*2,phone_dim[i_z]+case_thickness*2];
    case_rot=phone_rot;

    adapter_cyl=[adapter_height,adapter_inner_diameter,adapter_inner_diameter+adapter_thickness*2];
    adapter_rot=[0,0,0];

    adapter_xyz=phone_camera_center_xyz-[0,0,adapter_cyl[i_h]/2];

    // cut material based on existing dimensions, reduces print time etc

    // constant for corner cuts
    const_corner_cut_h=10;

    case_back_material_dim=phone_dim-[
        phone_camera_center_xyz[i_x]+adapter_cyl[i_od]/2+phone_dim[i_z]*2+ const_corner_cut_h,
        phone_dim[i_z]*2,
        0
    ];

    case_back_material_xyz=phone_xyz+[
        phone_camera_center_xyz[i_x]+adapter_cyl[i_od]/2+phone_dim[i_z],
        phone_dim[i_z],
        case_xyz[i_z]-1 // we're using this to cut, this ensures it's clean
    ];
    case_back_material_rot=case_rot;

    // Make multiple cuts for the case.
    // By index:
    // 0 - main phone body
    // 1 - phone screen area
    // 2 - camera
    // 3 - sides
    // 4 - case back material reduction
    // 5 - corner, top left
    // 6 - corner, bottom left
    // 7 - corner, bottom right
    // 8 - power
    case_cut_count=9;
    case_cuts_xyz=[
        // phone body
        phone_xyz,
        // phone screen
        [phone_xyz[i_x]+case_lip,phone_xyz[i_y]+case_lip,phone_xyz[i_z]],
        // phone camera
        phone_camera_xyz-[case_thickness,case_thickness,case_thickness*.51],
        // case sides (based on buttons)
        [phone_buttons_xyz[i_x]-case_thickness,case_xyz[i_y]-case_thickness,0],
        // case back material reduction
        case_back_material_xyz,
        // corner, top left
        case_xyz-[const_corner_cut_h,const_corner_cut_h,case_dim[i_z]/2],
        // corner, bottom left
        case_xyz+case_dim-[const_corner_cut_h,const_corner_cut_h+case_dim[i_y],case_dim[i_z]*3/2],
        // corner, bottom right
        case_xyz+case_dim-[const_corner_cut_h,const_corner_cut_h,case_dim[i_z]*3/2],
        // power
        case_xyz+[case_dim[i_x]-case_thickness*3,case_dim[i_y]/2-phone_power_width/2,case_thickness]
    ];
    case_cuts_dim=[
        // phone body
        phone_dim,
        // phone screen
        [phone_dim[i_x]-case_lip*2,phone_dim[i_y]-case_lip*2,case_dim[i_z]*2],
        // phone camera
        [phone_camera_dim[i_x]+case_thickness*2,phone_camera_dim[i_y]+case_thickness*2,case_thickness*2],
        // case sides (based on buttons)
        [phone_dim[i_x]-2*(phone_buttons_xyz[i_x]-phone_xyz[i_x])+case_thickness*2,case_dim[i_y]+case_thickness*2,phone_dim[i_z]+case_thickness*2],
        // case back material reduction
        case_back_material_dim,
        // corner, top left
        [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
        // corner, bottom left
        [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
        // corner, bottom right
        [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
        // power
        [case_thickness*6,phone_power_width,phone_dim[i_z]+case_thickness*2]
    ];
    case_cuts_rot=[
        // phone body
        phone_rot,
        // phone screen
        case_rot,
        // phone camera,
        case_rot,
        // case sides (based on buttons)
        case_rot,
        // case back material reduction
        case_back_material_rot,
        // corner, top left
        case_rot,
        // corner, botom left
        case_rot,
        // corner, bottom right
        case_rot,
        // power
        phone_rot
    ];

    color("purple")
    rotate([0,180,0])
    union() {
        // the adapter
        difference()
        {
            // main body
            tube(xyz=adapter_xyz,cyl=adapter_cyl,rot=adapter_rot,top_h=case_thickness);
            
            // cut: camera area (index:2) only (do not cut anything else)
            translate(case_cuts_xyz[2])
            rotate(case_cuts_rot[2])
            cube(case_cuts_dim[2]);
            
            // cut: screw holes
            a=360/adapter_screw_count;
            translate(adapter_xyz)
            for (i=[0:adapter_screw_count]) {
                rotate([0,0,i*a+a/2])
                translate([0,0,-adapter_height/2+adapter_screw_offset])
                rotate([0,90,0])
                screw_hole(d=adapter_screw_diameter,h=adapter_inner_diameter*2);
            }
        }
        
        // the case
        difference()
        {
            // main body
            translate(case_xyz)
            rotate(case_rot)
            cube(case_dim);

            // make all the cuts
            for (i=[0:len(case_cuts_xyz)-1]) {
                translate(case_cuts_xyz[i])
                rotate(case_cuts_rot[i])
                cube(case_cuts_dim[i]);
            }
        }
    }
}