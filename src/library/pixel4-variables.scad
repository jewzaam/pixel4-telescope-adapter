/*

Load this to get variables for the Pixel 4 phone.

include <pixel4-variables.scad>

*/

// we need constants from the shapes library
include <shapes.scad>

// pixel4 phone location, dimensinos, and rotation
pixel4_phone_xyz=[0,0,0];
pixel4_phone_dim=[147.13,68.8,8.24];
pixel4_phone_rot=[0,0,0];

// pixel4 button location, dimensions, and rotation
pixel4_buttons_dim=[40,0.5,2.8];
pixel4_buttons_xyz=pixel4_phone_xyz+[33.5,pixel4_phone_dim[i_y],2.6];
pixel4_buttons_rot=pixel4_phone_rot;

// pixel4 power cord cut out width
pixel4_power_width=15;

// pixel4 camera housing location, dimensions, and rotation
pixel4_camera_dim=[25,25,1];
pixel4_camera_xyz=[pixel4_phone_xyz[i_x]+6.35,pixel4_phone_xyz[i_y]+pixel4_phone_dim[i_y]-pixel4_camera_dim[i_y]-6.35,-1];
pixel4_camera_rot=pixel4_phone_rot;

// pixel 4 camera center location
pixel4_camera_center_xyz=pixel4_camera_xyz+[pixel4_camera_dim[i_x]/2,pixel4_camera_dim[i_y]-6.31,-pixel4_camera_xyz[i_z]];

