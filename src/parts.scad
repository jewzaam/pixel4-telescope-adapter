include <library/knurled-hex-cap.scad>
include <library/eyepiece-adapter.scad>
include <library/phone-adapter.scad>

include <phones/pixel4.scad>
include <phones/iphone11.scad>

part="pixel4_case"; // [pixel4_case:Pixel 4 Case,iphone11_case:iPhone11 Case,hex_cap:Hex Caps,eyepiece_adapter:Eyepiece Adapter]

/* [General] */
// Compensate for extra surface area added by extrusion for the inner and outer diameters.  NOT USED for the lip or extension!
input_over_extrusion=0.1;

// Diameter of your screw threads.  Assumes everything uses uniform bolts though lengths can vary.
input_screw_thread_diameter=3.9;


/* [Pixel 4 Case] */

// Thickness of the case.
input_case_thickness=2;

// Width of the case lip.
input_case_lip=2;

// Adapter inner diameter (this must be wider than the eyepiece adapter outer diameter!)
input_case_adapter_inner_diameter=57;

// Adapter thickness
input_case_adapter_thickness=6;

// If this is made too high not all eyepieces can be attached.  Consider a short eyepiece.
input_case_adapter_height=35;

// Distance to put screws from bottom of adapter
input_case_adapter_screw_offset=5;

// Number of screws.
input_case_adapter_screw_count=3;

/* [Eyepiece Adapter] */

// The outer diameter (inches) of the adapter.  This is what fits into the telescope (or some larger adapter).
input_eyepiece_adapter_outer_diameter_inches=2;

// The inner diameter (inches) of the adapter, also the outer diameter of your eyepiece.
input_eyepiece_adapter_inner_diameter_inches=1.25;

// The outer diameter (inches) of the lip (with screw).  Note this is also the OD of the extension.
input_eyepiece_adapter_lip_outer_diameter=56;

// Overall height (mm) of the adapter, including the lip.  Doesn't change per eyepiece.
input_eyepiece_adapter_height=30;

// Height (mm) of just the lip.  If zero (0) no screw is added.  Doesn't change per 
input_eyepiece_adapter_lip_height=10;

// Height from top of "lip" to top of the extension.
input_eyepiece_adapter_extension_height=20;

// Height from top of "lip" to top of the extension.
input_eyepiece_adapter_extension_thickness=5;

/* [Knurled Hex Caps] */

// Outer diameter of the cap.
input_cap_outer_diameter=15;

// Height of the cap.
input_cap_height=15;

// Distance from one flat edge of hex to other.  Consider adding a bit for printer over excrusion.
input_hex_width=7.2;

// Diameter of the threaded screw.  Consider adding a bit for printer over excrusion.
input_screw_diameter=4.5;

// Amount of material the hex will rest on
input_buffer_height=1;

// Number of knurled ridges.  This also drives the width of the knurles.
input_knurl_count=15;

// Knurl depth.  Go too far and you eat through the model..
input_knurl_depth=1;

/* [Hidden] */
$fn=300;

if (part == "pixel4_case") {
    phone_adapter
    (
        phone_xyz=pixel4_phone_xyz,
        phone_dim=pixel4_phone_dim,
        phone_rot=pixel4_phone_rot,
        phone_buttons_dim=pixel4_buttons_dim,
        phone_buttons_xyz=pixel4_buttons_xyz,
        phone_buttons_rot=pixel4_buttons_rot,
        phone_camera_dim=pixel4_camera_dim,
        phone_camera_xyz=pixel4_camera_xyz,
        phone_camera_rot=pixel4_camera_rot,
        phone_camera_center_xyz=pixel4_camera_center_xyz,
        phone_power_width=pixel4_power_width,
        case_thickness=input_case_thickness,
        case_lip=input_case_lip,
        adapter_inner_diameter=input_case_adapter_inner_diameter,
        adapter_thickness=input_case_adapter_thickness,
        adapter_height=input_case_adapter_height,
        adapter_screw_offset=input_case_adapter_screw_offset,
        adapter_screw_count=input_case_adapter_screw_count,
        adapter_screw_diameter=input_screw_thread_diameter
    );
} else if (part == "iphone11_case") {
    phone_adapter
    (
        phone_xyz=iphone11_phone_xyz,
        phone_dim=iphone11_phone_dim,
        phone_rot=iphone11_phone_rot,
        phone_buttons_dim=iphone11_buttons_dim,
        phone_buttons_xyz=iphone11_buttons_xyz,
        phone_buttons_rot=iphone11_buttons_rot,
        phone_camera_dim=iphone11_camera_dim,
        phone_camera_xyz=iphone11_camera_xyz,
        phone_camera_rot=iphone11_camera_rot,
        phone_camera_center_xyz=iphone11_camera_center_xyz,
        phone_power_width=iphone11_power_width,
        case_thickness=input_case_thickness,
        case_lip=input_case_lip,
        adapter_inner_diameter=input_case_adapter_inner_diameter,
        adapter_thickness=input_case_adapter_thickness,
        adapter_height=input_case_adapter_height,
        adapter_screw_offset=input_case_adapter_screw_offset,
        adapter_screw_count=input_case_adapter_screw_count,
        adapter_screw_diameter=input_screw_thread_diameter
    );
} else if (part == "hex_cap") {
    knurled_hex_cap(
        cap_od=input_cap_outer_diameter,
        cap_h=input_cap_height,
        hex_w=input_hex_width,
        screw_d=input_screw_diameter,
        buffer_h=input_buffer_height,
        knurl_count=input_knurl_count,
        knurl_depth=input_knurl_depth
    );
} else if (part == "eyepiece_adapter") {
    eyepiece_adapter(
        over_extrusion=input_over_extrusion,
        outer_diameter_inches=input_eyepiece_adapter_outer_diameter_inches,
        inner_diameter_inches=input_eyepiece_adapter_inner_diameter_inches,
        lip_outer_diameter=input_eyepiece_adapter_lip_outer_diameter,
        adapter_height=input_eyepiece_adapter_height,
        adapter_lip_height=input_eyepiece_adapter_lip_height,
        screw_thread_diameter=input_screw_thread_diameter,
        extension_height=input_eyepiece_adapter_extension_height,
        extension_thickness=input_eyepiece_adapter_extension_thickness
    );
}