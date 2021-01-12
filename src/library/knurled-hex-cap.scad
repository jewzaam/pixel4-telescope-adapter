/*

Simple knurl with ridges.

*/

module knurled_hex_cap(
    // Outer diameter of the cap.
    cap_od=15,

    // Height of the cap.
    cap_h=15,

    // Distance from one flat edge of hex to other.  Consider adding a bit for printer over excrusion.
    hex_w=7.2,

    // Diameter of the threaded screw.  Consider adding a bit for printer over excrusion.
    screw_d=4.5,

    // Amount of material the hex will rest on
    buffer_h=0.75,

    // Number of knurled ridges.  This also drives the width of the knurles.
    knurl_count=15,

    // Knurl depth.  Go too far and you eat through the model..
    knurl_depth=1
)
{
    difference()
    {
        // 1. create basic shape
        cylinder(d=cap_od,h=cap_h);

        // 2. cut inner hex bit
        sides=6;
        angle=360/sides;

        hex_cube_w=hex_w/2*tan(angle/2)*2;

        color("purple")
        translate([0,0,buffer_h])
        for (i=[0:sides-1]) {
            rotate([0,0,i*angle])
            translate([hex_w/2-hex_cube_w,-hex_cube_w/2,0])
            cube([hex_cube_w,hex_cube_w,cap_h]);
        }
        
        // 3. cut threads bit
        cylinder(d=screw_d,h=buffer_h*4,center=true);
        
        // 4. cut simple knurl
        circumference=2*PI*(cap_od);
        
        knurl_xyz=[knurl_depth,circumference/(knurl_count*5-1),cap_h*2];
        knurl_angle=360/(knurl_count*2);

        color("green")
        translate([0,0,-1])
        for (i=[0:knurl_count-1]) {
            rotate([0,0,2*i*knurl_angle-knurl_angle/2])
            rotate_extrude(angle=knurl_angle,convexity=2)
            translate([cap_od/2-knurl_depth,0,0])
            square([knurl_depth+1,cap_h*2]);
        }
    }
}

