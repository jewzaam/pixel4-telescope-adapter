include <shapes.scad>

/*

Pixel 4 case that mounts on a custom 2" to 1.25" adapter.

https://store.google.com/us/product/pixel_4

*/

/* [Case] */

input_case_thickness=2;
input_case_lip=2;

// width of cutout for power cord
input_case_power_width=15;

/* [Case Adapter] */

// Measured diameter is 50mm but it's a very tight fit.  Make it a little wider.
input_adapter_inner_diameter=57;
input_adapter_thickness=6;

// If this is made too high not all eyepieces can be attached.  Consider a short eyepiece.
input_adapter_height=35;

// Distance to put screws from bottom of adapter
input_adapter_screw_offset=5;

// if printing as though phone were on its face set this to 'true'.
input_adapter_screw_invert=true;

// Number of screws.
input_adapter_screw_count=3;

/* [Hidden] */

$fn=300;

i_x=0;
i_y=1;
i_z=2;
i_h=0;  // height
i_id=1; // inner diameter
i_od=2; // outer diameter

ORIGIN=[0,0,0];

// so I have a named variable and not burried in other places
const_camera_offset_y=6.31;

phone_xyz=[0,0,0];
phone_dim=[147.13,68.8,8.24];
phone_rot=[0,0,0];

case_xyz=[phone_xyz[i_x]-input_case_thickness,phone_xyz[i_y]-input_case_thickness,phone_xyz[i_z]-input_case_thickness];
case_dim=[phone_dim[i_x]+input_case_thickness*2,phone_dim[i_y]+input_case_thickness*2,phone_dim[i_z]+input_case_thickness*2];
case_rot=phone_rot;

camera_dim=[25,25,1];
camera_xyz=[phone_xyz[i_x]+6.35,phone_xyz[i_y]+phone_dim[i_y]-camera_dim[i_y]-6.35,-1];
camera_rot=phone_rot;

// simply cut off anything above the buttons
buttons_dim=[40,0.5,2.8];
buttons_xyz=phone_xyz+[33.5,phone_dim[i_y],2.6];
buttons_rot=phone_rot;

adapter_cyl=[input_adapter_height,input_adapter_inner_diameter,input_adapter_inner_diameter+input_adapter_thickness*2];
adapter_rot=ORIGIN;

// the adapter model is centered at ORIGIN, so needs z translation
// line up z with bottom of the phone, not camera
camera_center_xyz=camera_xyz+[camera_dim[i_x]/2,camera_dim[i_y]-const_camera_offset_y,-adapter_cyl[i_h]/2-camera_xyz[i_z]];

adapter_xyz=camera_center_xyz;

// cut material based on existing dimensions, reduces print time etc

// constant for corner cuts
const_corner_cut_h=10;

material_dim=phone_dim-[
    camera_center_xyz[i_x]+adapter_cyl[i_od]/2+phone_dim[i_z]*2+ const_corner_cut_h,
    phone_dim[i_z]*2,
    0
];

material_xyz=phone_xyz+[
    camera_center_xyz[i_x]+adapter_cyl[i_od]/2+phone_dim[i_z],
    phone_dim[i_z],
    case_xyz[i_z]-1 // we're using this to cut, this ensure it's clean
];
material_rot=case_rot;

// Make multiple cuts for the case.
// By index:
// 0 - main phone body
// 1 - phone screen area
// 2 - camera
// 3 - sides
// 4 - material reduction
// 5 - corner, top left
// 6 - corner, bottom left
// 7 - corner, bottom right
// 8 - power
case_cut_count=9;
case_cuts_xyz=[
    // phone body
    phone_xyz,
    // phone screen
    [phone_xyz[i_x]+input_case_lip,phone_xyz[i_y]+input_case_lip,phone_xyz[i_z]],
    // phone camera
    [camera_xyz[i_x]-input_case_thickness,camera_xyz[i_y]-input_case_thickness,camera_xyz[i_z]-input_case_thickness*.51],
    // case sides (based on buttons)
    [buttons_xyz[i_x]-input_case_thickness,case_xyz[i_y]-input_case_thickness,0],
    // remove material
    material_xyz,
    // corner, top left
    case_xyz-[const_corner_cut_h,const_corner_cut_h,case_dim[i_z]/2],
    // corner, bottom left
    case_xyz+case_dim-[const_corner_cut_h,const_corner_cut_h+case_dim[i_y],case_dim[i_z]*3/2],
    // corner, bottom right
    case_xyz+case_dim-[const_corner_cut_h,const_corner_cut_h,case_dim[i_z]*3/2],
    // power
    case_xyz+[case_dim[i_x]-input_case_thickness*3,case_dim[i_y]/2-input_case_power_width/2,input_case_thickness]
];
case_cuts_dim=[
    // phone body
    phone_dim,
    // phone screen
    [phone_dim[i_x]-input_case_lip*2,phone_dim[i_y]-input_case_lip*2,case_dim[i_z]*2],
    // phone camera
    [camera_dim[i_x]+input_case_thickness*2,camera_dim[i_y]+input_case_thickness*2,input_case_thickness*2],
    // case sides (based on buttons)
    [phone_dim[i_x]-2*(buttons_xyz[i_x]-phone_xyz[i_x])+input_case_thickness*2,case_dim[i_y]+input_case_thickness*2,phone_dim[i_z]+input_case_thickness*2],
    // remove material
    material_dim,
    // corner, top left
    [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
    // corner, bottom left
    [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
    // corner, bottom right
    [const_corner_cut_h*2,const_corner_cut_h*2,case_dim[i_z]*2],
    // power
    [input_case_thickness*6,input_case_power_width,phone_dim[i_z]+input_case_thickness*2]
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
    // remove material
    material_rot,
    // corner, top left
    ORIGIN,
    // corner, botom left
    ORIGIN,
    // corner, bottom right
    ORIGIN,
    // power
    ORIGIN
];

module adapter(c="purple",t=1) 
{
    color(c,t)
    difference()
    {
        // main body
        tube(xyz=adapter_xyz,cyl=adapter_cyl,rot=adapter_rot,top_h=input_case_thickness);
        
        // cut: mirror area only (do not cut anything else)
        case_cuts([2]);
        
        // cut: screw holes
        a=360/input_adapter_screw_count;
        translate(adapter_xyz)
        for (i=[0:input_adapter_screw_count]) {
            rotate([0,0,i*a+(input_adapter_screw_invert?a/2:0)])
            translate([0,0,-input_adapter_height/2+input_adapter_screw_offset])
            rotate([0,input_adapter_screw_invert?90:-90,0])
            screw_hole(d=input_adapter_screw_diameter,h=input_adapter_inner_diameter*2);
        }
    }
}

module phone(t=1) 
{
    box(phone_xyz,phone_dim,phone_rot,"lightblue",t);
    box(camera_xyz,camera_dim,camera_rot,"purple",t);
    box(buttons_xyz,buttons_dim,buttons_rot,"purple",t);
}

module case_cuts(cut_array=[0:case_cut_count-1]) 
{
    for (i=cut_array) {
        cut_xyz=case_cuts_xyz[i];
        cut_rot=case_cuts_rot[i];
        cut_dim=case_cuts_dim[i];
        
        translate(cut_xyz)
        rotate(cut_rot)
        cube(cut_dim);
    }
}

module case(xyz=case_xyz,dim=case_dim,rot=case_rot,c="lime",t=1,fancy=true) 
{
    // the sphere params
    s_d=fancy?input_case_thickness:0;
    
    color(c,t)
    difference()
    {
        // case body made from the base dimensions but w/ minkowski of a sphere
        minkowski()
        {
            translate(xyz+[s_d/2,s_d/2,s_d/2])
            rotate(rot)
            cube(dim-[s_d/2,s_d/2,s_d]);
            
            if (fancy) {
                // put the sphere on the sides
                translate([0,xyz[i_y]+s_d/2,0])
                sphere(d=s_d);
            }
        }

        // make the cuts
        case_cuts();
    }
}

union() {
    adapter();
    case(fancy=false);
}
