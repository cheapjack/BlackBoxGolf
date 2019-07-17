// Golf ball official dimensions seem to range from 42.7-41.148mm. We'll round up to 43mm
golfball_diameter=43;
// How much of a rest we want the ball in.
golfball_rest_offset=2;

flipper_recess_scalar=1.25;

stepper_width = 13.5;
stepper_depth = 23.5;
//includes all the way up to just under the cam assembly
stepper_height = 26;

base_width = 160;
base_depth = 90;
base_height = 76;

run_opening = 70;
run_leaving = 55;
run_length = 140;
run_angle = 7;
run_level =4;
micro_run_level = -6;
divert_offset = 35;

solenoid_case_width = 10;
solenoid_case_depth = 13;
solenoid_case_height = 8;
solenoid_pin_diameter = 1.5;
solenoid_pin_length = 6;
solenoid_angle = 30;


// Main geometry

color("blue")translate([0,-150,0])section_2();

color("pink")translate([0,0,0])align_pin();
translate([0,-15,0])difference(){
    setup1();
    translate([0,21.25,-25])stepperCase();
}

//color("blue")translate([0,22,10])stepperCase();
//translate([0,-base_depth/4,2])sphere(d=golfball_diameter+golfball_rest_offset);
module setup1(){
    // comment out for build
    //allow for 
    //translate([0,21.25,-25])stepperCase();
    // comment out for build
    //translate([0,-100,-20])solenoid();
    difference(){
        section_flipper_recessed();
        translate([0,15,0])rotate([0,0,0])cylinder($fn=24,h=80,r=2,center=true);
        }
    //translate([0,21.25,-25])stepperCase();
    //color("red")flipper_recess();
    //section();
    color("red")translate([9,-10,-8])rotate([0,0,290])flipper();
    //translate([-28,-10,10])golf_ball();
    //translate([-13,-50,micro_run_level])micro_run();
    }
    
module align_pin(){
    rotate([180,0,0])cylinder($fn=24,h=150,r=1.5,center=true);
}
    

module solenoid() {
    rotate([360+solenoid_angle,0,0])cube([solenoid_case_width,solenoid_case_depth,solenoid_case_height], true);
    rotate([360+solenoid_angle,0,0])translate([0,(solenoid_case_depth-1),0])rotate([90,0,0])cylinder($fn=12,solenoid_pin_length,r=solenoid_pin_diameter,true);
}


module divert() {
    translate([0,-50,run_level])run();
    rotate([-run_angle,0,0])translate([-divert_offset,0,0])run_true();
    rotate([-run_angle,0,0])translate([divert_offset,0,0])run_false();
}

// Base geometry
module section(){
    difference(){
        base();
        translate([0,0,run_opening/4])divert();
        }
    }

module section_2(){
    difference(){
        base_2();
        translate([0,0,20])for (i=[0:40])
            translate([i-20,0,0])run(i+1);
        }
    }

module section_flipper_recessed(){
        difference(){
            section();
            flipper_recess();
            }
    }


module golf_ball(){
    sphere(d=golfball_diameter+golfball_rest_offset);
}
        
//translate([0,0,run_opening/4])rotate([270,0,0])run();

module run() {
    rotate([270,0,0])cylinder(h=run_length,r1=run_opening/2,r2=run_leaving/2,center=true);
}

module run_true() {
    rotate([0,0,20])run();
    }

module run_false() {
    rotate([0,0,-20])run();
    }


module base() {
    color("green")cube([base_width,base_depth,base_height], true);
}

module base_2() {
    color("green")cube([base_width,base_depth,base_height], true);
}


module stepperCam(){
    hull() {
        circle($fn = 24,d = 11.5);
        translate([0,6,0])circle($fn = 24,d = 5.25);
        }
    }


module stepperCase(){
    cube([stepper_width,stepper_depth,stepper_height], true);
    translate([0,stepper_depth/-2 + 5.25,stepper_height/2+2])
    difference(){
        stepperCamAssembly();
        //translate([0,0,-10])cylinder(h=50,r=3,center=true);
    }
}

module stepperCamAssembly(){
        linear_extrude(height = 6, center = true, convexity = 0, twist = 0)stepperCam();
}

//Flipper
module flipper(){
    flipper_scalar = 1.25;
    scale([flipper_scalar,flipper_scalar,1.5])import("builds/files/flipper.stl", convexity=3);
}

//Flipper recess
module flipper_recess(){
    for (i=[330:390])
        translate([0,0,10])rotate([0,0,i])linear_extrude(height = 40, center = true, convexity = 10, twist = 0)hull(i+1) {
        translate([0,-50,0])circle($fn = 24,d = 15);
        translate([0,20,0])circle($fn = 24,d = 40);
        } //resize([flipper_recess_scalar,flipper_recess_scalar,flipper_recess_scalar])import("builds/files/flipper.stl", convexity=3);
}