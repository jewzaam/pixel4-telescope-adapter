
module debug_y(xyz=[0,0,0],value,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    rotate([-90,0,0])
    cylinder(d=10,h=value);
}

module debug_z(xyz=[0,0,0],value,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    rotate([0,0,90])
    cylinder(d=10,h=value);
}

module debug_point(xyz=[0,0,0],d=25,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    sphere(d=d);
}

module debug(value,xyz=[0,-50,0],s=2,c="red",t=0.5) {
    translate(xyz)
    rotate([0,0,0])
    scale(s)
    text(str(value));
}