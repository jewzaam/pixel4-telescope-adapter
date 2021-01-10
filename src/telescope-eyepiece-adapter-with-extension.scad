/*

The "lip" is where the eyepiece sits.  Take the height of your EP and add the eye relief.  This is probably about where you want your camera.  But maybe not!  You cannot have the camera go _into_ the EP.  The minimum height should be your EP height from the lip.  Add more depending on the camera adapter height.

Let's look at an example.  Let's say your EP is 45mm high from the lip.  And let's say the eye relief for the EP is 15mm.  Furthermore, your camera adapter height is 30mm with screws at 10mm, so effectively about 20mm.  In this case you need your camera to be 15mm above the EP.  If the camera adapter is fully over the extension to get 15mm away from the EP means the extension is 15mm above the top of the EP.  You then have 20mm of play with the camera adapter.  You probably want some play that goes below the eye relief, I'd guess 5mm.  Therefore my recommended extension height is 45mm + 15mm - 5mm = 55mm.

With this setup you have to have many eyepiece adapters for different eyepieces because of EP height and ideal viewing distance (eye relief).  For the eyepieces you want to use do the math to figure out the extension height and print along 5mm spacing.  Therefore you're close enough if another eyepiece (borrowed, new, etc) is close to an existing eyepiece height.  And you're not printing one adapter per eyepiece.

This setup is for my shortest eyepiece, Celestron Omni 9mm Plossl.  Eyepiece height is 17mm.  Eye relief per Celestron is 6mm.  Super short at 23mm!  I selected 20mm and will have to make sure my camera adapter is probably 20mm too.  And place the screws as close to the lower edge as I can to get more flexibility.

I also have to think about my biggest eyepiece at this time, Celestron Omni 40mm Plossl.  The phone case will be printed with the lip OD, so getting it right on ALL the adapters means fewer phone cases, hopefully one!  The outer diameter of this eyepiece is 42mm.  With the extension thickness set to 5mm (beefy, but I don't want it to move) I can do a minimum lip OD of 47mm.  My stock 2" to 1.25" adapter is 2.2in (55.88mm).  So I am rounding up to 56 and having enough room for an even bigger EP if I want.  Yay flexibility!

NOTE in this model you change only the "Eyepiece / Camera Adapter" values per eyepiece.

*/

/* [2" to 1.25" Adapter] */

// Compensate for extra surface area added by extrusion for the inner and outer diameters.  NOT USED for the lip or extension!
input_over_extrusion=0.1;

// The outer diameter (inches) of the adapter.  This is what fits into the telescope (or some larger adapter).
input_outer_diameter_inches=2;

// The inner diameter (inches) of the adapter, also the outer diameter of your eyepiece.
input_inner_diameter_inches=1.25;

// The outer diameter (inches) of the lip (with screw).  Note this is also the OD of the extension.
input_lip_outer_diameter=56;

// Overall height (mm) of the adapter, including the lip.  Doesn't change per eyepiece.
input_adapter_height=30;

// Height (mm) of just the lip.  If zero (0) no screw is added.  Doesn't change per 
input_adapter_lip_height=10;

// Diameter of your screw threads.
input_screw_thread_diameter=3.91;

/* [Eyepiece / Camera Adapter] */
// Height from top of "lip" to top of the extension.
input_extension_height=20;

// Height from top of "lip" to top of the extension.
input_extension_thickness=5;

// Make it printable without support by having the extension 
/* [Hidden] */
$fn=300;

// raw shape for the adapter (hidden: standard sizes)
adapter_2125_h=input_adapter_height;
adapter_2125_id=input_inner_diameter_inches*25.4+input_over_extrusion*2;
adapter_2125_od=input_outer_diameter_inches*25.4-input_over_extrusion*2;
adapter_2125_lip_h=input_adapter_lip_height;
adapter_2125_lip_od=input_lip_outer_diameter;

adapter_2125_screw_thread_d=input_screw_thread_diameter;

// offset from lip top (hidden: standard location for screw into eyepiece)
adapter_2125_screw_offset_from_lip_top_z=3.8;

module adapter() {
    // built upside down, fip for printing.  -90 on Z is for thingieverse orientation
    rotate([0,0,-90])
    difference() 
    {
        rotate_extrude()
        union() 
        {
            // main adapter bit
            translate([adapter_2125_id/2,0,0])
            square([adapter_2125_od/2-adapter_2125_id/2,adapter_2125_h]);
            
            // lip so it doesn't fall in scope
            translate([adapter_2125_id/2,adapter_2125_h-adapter_2125_lip_h,0])
            square([adapter_2125_lip_od/2-adapter_2125_id/2,adapter_2125_lip_h]);
            
            // extension
            translate([adapter_2125_lip_od/2-input_extension_thickness,input_adapter_height,0])
            square([input_extension_thickness,input_extension_height]);
        }
        
        if (input_adapter_lip_height > 0) {
            // cut hole (extruded teardrop, easier print) for screw
            translate([0,0,-adapter_2125_screw_thread_d/2+adapter_2125_h-adapter_2125_screw_offset_from_lip_top_z])
            rotate([0,90,0]) // rotate on side
            rotate([0,0,180]) // flip teardrop over
            linear_extrude(adapter_2125_lip_od)
            hull()
            {
                circle(d=adapter_2125_screw_thread_d);
                translate([adapter_2125_screw_thread_d*0.75,0,0])
                circle(d=0.1);
            }
        }
    }
}

// Made it a module to make turning it off for debugging easy.
adapter();