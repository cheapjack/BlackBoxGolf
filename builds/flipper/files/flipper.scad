module outside() {
	union() {
		dxf_linear_extrude(file="flipper_drawings.dxf", layer="outside", height=7.9, convexity=1);
		dxf_linear_extrude(file="flipper_drawings.dxf", layer="setback", height=20, convexity=1);
		translate([0,0,16.8]) {
			dxf_linear_extrude(file="flipper_drawings.dxf", layer="outside", height=4, convexity=1);
		}
	}
}

module inside() {
	union() {
		dxf_linear_extrude(file="flipper_drawings.dxf", layer="cutout", height=4.8, convexity=1);
		dxf_linear_extrude(file="flipper_drawings.dxf", layer="holes", height=16, convexity= 2);
	}
}

translate([-20,0,20.8]) {
	rotate([180,0,0]) {
		difference() {
			outside();
			inside();
		}
	}
}
