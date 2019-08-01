// Golf ball official dimensions seem to range from 42.7-41.148mm. We'll round up to 43mm
golfball_diameter=43;
// How much of a rest we want the ball in.
golfball_rest_offset=2;

flipper_recess_scalar=1.25;


servo_width = 12.5;
servo_depth = 23.5;
//includes all the way up to just under the cam assembly
servo_height = 26;
// measure this before printing
servo_pin_height = 11;
servo_pin_depth = 32;
servo_pin_shelf_height = 2.5;
servo_recess_scalar = 1.25;

//servo_arm_scalar = 1.05;
servo_arm_scalar2 = 1.5;

base_width = 150;
base_depth = 85;
base_height = 76;
//alt height without golf divert overhang
base_height = 56;

short_run_length = base_width/2;

run_opening = 70;
run_leaving = 55;
run_length = 120;
run_angle = 9;
run_level =4;
micro_run_level = -6;
divert_offset = 35;

solenoid_case_width = 12.5;
solenoid_case_depth = 20.5;
solenoid_case_height = 15;//12
solenoid_pin_diameter = 7.5;
solenoid_pin_length = 14;
solenoid_pin_length_retracted = 8;
solenoid_angle = 30;
solenoid_recess_scalar = 1.1;



//////////////////////////////
// Main geometry            //
//////////////////////////////

//print("red");
//print("blue");
//print("green");
servo_arm();
translate([3,0,0])servo_arm(1.05);
translate([5,0,0])servo_arm(1.1);
translate([5,0,0])servo_arm(1.2);
//translate([-servo_width/2,-135,-18])rotate([90,90,180])servoCase(true);


// print the red, blue or green blocks
module print(state){
    if (state=="red"){
        red();
    } else if (state=="blue"){
        blue();
    } else if (state=="green"){
        green();
    } else {
    }
}


// 
// Section 1
// Uncomment when printing
module green(){
    translate([60,0,base_height/2])difference(){
    mainBox();
    servoPinHoles(-9);
}
}

// a servo for the golf release mechanism
// comment out for building
//translate([-servo_width/2,-135,-18])rotate([90,90,180])servoCase(true);

// a solenoid for the golf release mechanism
//translate([0,-90,-2.26*solenoid_case_height+7])rotate([82,0,0])scale(solenoid_recess_scalar,solenoid_recess_scalar,solenoid_recess_scalar)solenoid(false);

// Section 2
// Uncomment when printing

module blue(){
    translate([0,0,base_height/2])color("blue")setup3();
}

// check for flipper & servo alignment
//color("pink")translate([0,0,0])align_pin(150,3);

// Flipper: uncomment for printing
module red(){
    color("red")translate([0,-200,0])rotate([0,0,0])flipper();
}

module mainBox(){
    translate([0,-15,0])difference(){
        setup1();
        translate([0,21.25,-26])servoCase();
}
}

// Setup for recesses
module setup1(){
    // comment out for build
    //allow for servoCase(); 
    //translate([0,21.25,-25])servoCase();
    // comment out for build
    //translate([0,-100,-20])solenoid();
    section_flipper_recessed();
    //translate([-28,-10,10])golf_ball();
    }

module setup3(){
    difference(){
        release_mechanism();
        translate([-servo_width/2,-135,-18])rotate([90,90,180])servoCase(true);
        // allow void to install servo
        translate([-servo_width/2,-135,-28])rotate([90,90,180])servoCase(true);
        }
        }

module release_mechanism(){
    translate([0,-108,0])difference(){
        section_2(30);
        translate([0,1,14])golf_ball(1.15)translate([-servo_width/2,-135,-18])rotate([90,90,180])servoCase(true);
    }
}


// Pins & Bolt Geometry

// module for checking alignment and M sized fixing
module align_pin(length,diameter){
    rotate([180,0,0])cylinder($fn=24,h=length,r=diameter/2,center=true);
}

// Main section with Base geometry & golf runs removed
module section(){
    difference(){
        base();
        translate([0,0,run_opening/4])divert();
        }
    }

// A section for holding and releasing the ball, iterated cylinders
module section_2(spread){
    difference(){
        base_2();
        rotate([0,0,0])translate([0,-25,28])for (i=[0:spread]){
            translate([i-spread/2,0,0])short_run(i+1);
            }
            }
        }

// section with flipper recess
module section_flipper_recessed(){
        difference(){
            section();
            flipper_recess();
            }
    }
    
// Balls
// average golf ball size
module golf_ball(scale){
    sphere(d=(scale*golfball_diameter) + golfball_rest_offset);
}

// Main Runs Geometry
// 3 cylendrical golfball runs divert true or false
module divert() {
    translate([0,-50,run_level])run();
    rotate([-run_angle,0,0])translate([-divert_offset,0,0])run_true();
    rotate([-run_angle,0,0])translate([divert_offset,0,0])run_false();
}


// Shorter cylinder for golf run with parameters
module short_run(){
    rotate([270+run_angle,0,0])cylinder(h=short_run_length,r=run_opening/2,center=true);
    translate([0,base_depth/2,0])rotate([270-run_angle,0,0])cylinder(h=short_run_length-10,r=run_opening/2,center=true);
   
}

// Basic cylindrical golf run 
module run() {
    rotate([270,0,0])cylinder(h=run_length,r1=run_opening/2,r2=run_leaving/2,center=true);
}

// First bit of the flipper section
module pre_run() {
    rotate([270,0,0])cylinder(h=run_length,r1=run_opening/2,r2=run_leaving/2,center=true);
}

// golf run true direction
module run_true() {
    rotate([0,0,20])run();
    }

// golf run false direction
module run_false() {
    rotate([0,0,-20])run();
    }

// Base Geometrys

// Big chunk o' PLA
module base() {
    color("green")cube([base_width,base_depth,base_height], true);
}

// another base that needs less material
module base_2() {
    color("green")cube([base_width-30,base_depth-10,base_height], true);
}

module base_3() {
    color("green")cube([base_width-30,base_depth-10,base_height], true);
}

// Servo/servo Case

// the main servo case with the cam bits
module servoCase(state){
    //wider pin shelf recess
    translate([0,0,servo_height/2-(servo_pin_height/2)])scale([servo_recess_scalar,servo_recess_scalar,servo_recess_scalar])cube([servo_width,servo_pin_depth, servo_pin_shelf_height], true);
    translate([0,0,-servo_pin_height/6])cube([servo_width,servo_pin_depth,servo_height-(servo_height/8 )], true);
    // Main case
    cube([servo_width,servo_depth,servo_height], true);
    //cam top
    translate([0,servo_depth/-2 + 7.45,servo_height/2+2])scale([servo_recess_scalar,servo_recess_scalar,servo_recess_scalar])servoCamAssembly(11.5,5.25,6,4);
    // a lever left/up if true, otherwise straight
    if (state == true){
        translate([0,servo_depth/-2+6,servo_height/2+8])for (i=[0:180]){
            rotate([0,0,i])servoCamAssembly(7,4,15,4.5);
        }
    } else {
        translate([0,servo_depth/-2+6,servo_height/2+8])servoCamAssembly(7,4,15,4);
    }
}

// The Cam bits
module servoCamAssembly(first_cam_diameter,second_cam_diameter,distance, cam_height){
    //allow for a clean break throught the main box geometry
        linear_extrude(height = cam_height + 2, center = true, convexity = 0, twist = 0)servoCam(first_cam_diameter,second_cam_diameter,distance);
}

// cam hull for the cam top of a servo
module servoCam(first_cam_diameter,second_cam_diameter,distance){
    hull() {
        circle($fn = 24,d = first_cam_diameter);
        translate([0,distance,0])circle($fn = 24,d = second_cam_diameter);
        }
    }
    
// servo attachment pins
module servoPinHoles(ypos) {
    color("pink")translate([0,ypos + 0.6,0])align_pin(50,1.6);
    color("pink")translate([0,ypos + 26.6,6])align_pin(50,1.6);
    // last pin secures flipper and is positioned center of the larger servoCamAssembly hulled circle
    color("pink")translate([0,servo_depth/4-5.75,0])align_pin(75,2);    
}

// Imported Flipper from https://www.thingiverse.com/thing:1789
module flipper(){
    flipper_scalar = 1.25;
    scale([flipper_scalar,flipper_scalar,1.5])import("builds/flipper/files/flipper.stl", convexity=3);
}

//Flipper recess
module flipper_recess(){
    for (i=[330:390])
        translate([0,0,10])rotate([0,0,i])linear_extrude(height = 40, center = true, convexity = 10, twist = 0)hull(i+1) {
        translate([0,-50,0])circle($fn = 24,d = 15);
        translate([0,20,0])circle($fn = 24,d = 40);
        } //resize([flipper_recess_scalar,flipper_recess_scalar,flipper_recess_scalar])import("builds/files/flipper.stl", convexity=3);
}

// Solenoid
module solenoid(state) {
    cube([solenoid_case_width,solenoid_case_depth,solenoid_case_height], true);
    // solenoid pin extended
    if(state ==  false){
        translate([0,solenoid_case_depth,0])rotate([90,0,0])cylinder($fn=12,solenoid_pin_length,r=solenoid_pin_diameter/2,true);
    } else {
        translate([0,solenoid_case_depth/2+solenoid_pin_length_retracted,0])rotate([90,0,0])cylinder($fn=12,solenoid_pin_length_retracted,r=solenoid_pin_diameter/2,true);
    }
    // wire space
    translate([0,-solenoid_case_depth/4,solenoid_case_height/2])rotate([90,0,0])cylinder($fn=12,solenoid_pin_length,r=0.5,true);
}

// Wiring recess
module wire(wire_length) {
    rotate([90,0,0])cylinder($fn=12,wire_length,r=0.5,true);
}

//9g_servo_arm
module servo_arm(scalar){
    servo_arm = 1.25;
    scale([scalar, scalar, servo_arm_scalar2])import("builds/servo_arm/files/9g_servo_arm_single.stl", convexity=3);
}





