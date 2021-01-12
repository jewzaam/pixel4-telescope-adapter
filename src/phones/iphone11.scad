/*

Load this to get variables for the iPhone 11.

include <phones/iphone11.scad>

*/

// we need constants from the shapes library
include <../library/shapes.scad>

// iphone11 phone location, dimensinos, and rotation
iphone11_phone_xyz=[0,0,0];
iphone11_phone_dim=[151,75.8,8.4];
iphone11_phone_rot=[0,0,0];

// iphone11 button location, dimensions, and rotation
iphone11_buttons_dim=[40,0.5,2.8];
iphone11_buttons_xyz=iphone11_phone_xyz+[33.5,iphone11_phone_dim[i_y],2.6];
iphone11_buttons_rot=iphone11_phone_rot;

// iphone11 power cord cut out width
iphone11_power_width=15;

// iphone11 camera housing location, dimensions, and rotation
iphone11_camera_dim=[25,25,1];
iphone11_camera_xyz=[iphone11_phone_xyz[i_x]+6.35,iphone11_phone_xyz[i_y]+iphone11_phone_dim[i_y]-iphone11_camera_dim[i_y]-6.35,-1];
iphone11_camera_rot=iphone11_phone_rot;

// iphone11 camera center location
iphone11_camera_center_xyz=iphone11_camera_xyz+[iphone11_camera_dim[i_x]/2,iphone11_camera_dim[i_y]-6.31,-iphone11_camera_xyz[i_z]];

