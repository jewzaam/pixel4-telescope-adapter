/* [Hidden] */

i_x=0;
i_y=1;
i_z=2;
i_h=0;  // height
i_id=1; // inner diameter
i_od=2; // outer diameter

module box(xyz,dim,rot)
{
    translate(xyz)
    rotate(rot)
    cube(dim);
}

module tube(xyz,cyl,rot,c="white",t=1,top_h=0,center=true)
{
    color(c,t)
    translate(xyz)
    rotate(rot)
    difference()
    {
        cylinder(h=cyl[i_h],d=cyl[i_od],center=center);
        
        // only remove center if there is an ID defined
        if (cyl[i_id] > 0) {
            // leave top_h mm of material remaining
            cut_xyz=[0,0,top_h==0?-1:-cyl[i_h]/2-top_h];
            color("red")
            translate(cut_xyz)
            cylinder(h=cyl[i_h]*2,d=cyl[i_id],center=center);
        }
    }
}

module screw_hole(d,h)
{
    // create a teardrop and extrude it
    linear_extrude(h)
    hull()
    {
        circle(d=d);
        translate([d*0.75,0,0])
        circle(d=0.1);
    }
}

module pie_slice(xyz,cyl,rot,degrees)
{
    t_x=cyl[i_id]<0?0:cyl[i_id];
    translate(xyz)
    rotate(rot)
    rotate_extrude(angle=degrees,convexity=2)
    translate([t_x,0,0])
    square([cyl[i_od]/2-cyl[i_id]/2,cyl[i_h]],false);
    
}
