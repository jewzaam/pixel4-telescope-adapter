/*

Simple knurl with ridges.

Example values are from M4.

*/

// Outer diameter of the cap.
input_cap_od=15;

// Height of the cap.
input_cap_h=15;

// Distance from one flat edge of hex to other.  Consider adding a bit for printer over excrusion.
input_hex_w=7.2;

// Diameter of the threaded screw.  Consider adding a bit for printer over excrusion.
input_screw_d=4.5;

// Amount of material the hex will rest on
input_buffer_h=0.75;

// Number of knurled ridges.  This also drives the width of the knurles.
input_knurl_count=15;

// Knurl depth.  Go too far and you eat through the model..
input_knurl_depth=1;

/* [Hidden] */
$fn=100;

difference()
{
    // 1. create basic shape
    cylinder(d=input_cap_od,h=input_cap_h);

    // 2. cut inner hex bit
    sides=6;
    angle=360/sides;

    hex_cube_w=input_hex_w/2*tan(angle/2)*2;

    color("purple")
    translate([0,0,input_buffer_h])
    for (i=[0:sides-1]) {
        rotate([0,0,i*angle])
        translate([input_hex_w/2-hex_cube_w,-hex_cube_w/2,0])
        cube([hex_cube_w,hex_cube_w,input_cap_h]);
    }
    
    // 3. cut threads bit
    cylinder(d=input_screw_d,h=input_buffer_h*4,center=true);
    
    // 4. cut simple knurl
    circumference=2*PI*(input_cap_od);
    
    knurl_xyz=[input_knurl_depth,circumference/(input_knurl_count*5-1),input_cap_h*2];
    knurl_angle=360/(input_knurl_count*2);

    color("green")
    translate([0,0,-1])
    for (i=[0:input_knurl_count-1]) {
        rotate([0,0,2*i*knurl_angle-knurl_angle/2])
        rotate_extrude(angle=knurl_angle,convexity=2)
        translate([input_cap_od/2-input_knurl_depth,0,0])
        square([input_knurl_depth+1,input_cap_h*2]);
    }
}