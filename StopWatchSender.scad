// Measurements in mm
$fn = 80;

font1 = "FreeSans:style=Bold";
fontSize = 7;

wallThickness = 2.0;

depth = 150;
width = 150;
minH = 35;
maxH = 45;
slope = atan2(maxH-minH, depth);// pendenza superficie superiore

pushButton = 13;// Diametro pulsanti

lHeigth = 20;

// Cosa disegnare ?
upper = true;
lower = false;

//
// Moduli
//
module 
profile() {
    polygon(points=[[0, 0],
                     [depth, 0],
                     [depth, maxH],
                     [0, minH]]);
}
//
//
module
rinforzi() {
    union() {
        // Pareti laterali
        color("Red") {
            translate([0, wallThickness, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = wallThickness)
                        profile();

            translate([0, width, 0]) 
                rotate([90, 0, 0])
                    linear_extrude(height = wallThickness)
                        profile();
        }
        // Alloggiamenti viti fissaggio pannelli
        color("Blue") {
            translate([4.0, 5.5, 0])
                cylinder(d=10, h=minH);
            translate([depth-4.0, 5.5, 0])
                cylinder(d=10, h=maxH);
            translate([4.0, width-5.5, 0])
                cylinder(d=10, h=minH);
            translate([depth-4.0, width-5.5, 0])
                cylinder(d=10, h=maxH);
        }
    }
}
//
//
module
foriFissaggio() {
    union() {
        // Alloggiamenti viti fissaggio pannelli
        color("Yellow") {
            translate([4, 5.5, -3*wallThickness])
                cylinder(d=2.5, h=2*minH);
            translate([depth-4, 5.5,  -3*wallThickness])
                cylinder(d=2.5, h=2*maxH);
            translate([4, width-5.5, -3*wallThickness])
                cylinder(d=2.5, h=2*minH);
            translate([depth-4, width-5.5, -3*wallThickness])
                cylinder(d=2.5, h=2*maxH);
        }
    }
}
//
//
module
container() {
    difference() {
        union() {
            translate([0, width, 0])
            rotate([90, 0, 0])
                linear_extrude(height = width)
                    difference() {
                        offset(r = wallThickness)
                            profile();
                        profile();
                    }
            rinforzi();
        }
        foriFissaggio();
    }    
}
//
//
module
pedal_center(textLeft, textRight, textCenter) {
        difference() {
            union() {//1
                // Carcassa
                container();
                // Titolo Pannello Gara
                translate([110.0, width/2, 10.0*sin(slope)+minH+wallThickness-0.1]) 
                    rotate([0, -slope, 0]) 
                        translate([-0.5*fontSize, 0.0, 0])
                            rotate([0, -0, -90])
                                #linear_extrude(height = 1.5) 
                                    text("Cronometro Gara",
                                    font = font1, 
                                    size = fontSize, 
                                    halign = "center");
                // Scritta pulsante 1
                translate([25.0, width-30.0, 25.0*sin(slope)+minH+wallThickness-0.1]) 
                    rotate([0, -slope, 0]) 
                        translate([10, 0, 0])
                            rotate([0, -0, -90])
                                #linear_extrude(height = 1.5) 
                                    text("Start",
                                    font = font1, 
                                    size = fontSize, 
                                    halign = "center");
                // Scritta pulsante 2                     
                translate([25.0, 30.0, 25.0*sin(slope)+minH+wallThickness-0.1])
                    rotate([0, -slope, 0])
                        translate([10, 0, 0])
                            rotate([0, -0, -90])
                                #linear_extrude(height = 1.5)
                                    text("Stop",
                                    font = font1, 
                                    size = fontSize, 
                                    halign = "center");
                // Scritta pulsante 3
                translate([70.0, width-35.0, 70.0*sin(slope)+minH+wallThickness-0.1]) 
                    rotate([0, -slope, 0]) 
                        translate([10, 0, 0])
                            rotate([0, -0, -90])
                                #linear_extrude(height = 1.5) 
                                    text("Timeout",
                                    font = font1, 
                                    size = fontSize, 
                                    halign = "center");
                // Scritta pulsante 4                     
                translate([70.0, 35.0, 70.0*sin(slope)+minH+wallThickness-0.1])
                    rotate([0, -slope, 0])
                        translate([10, 0, 0])
                            rotate([0, -0, -90])
                                #linear_extrude(height = 1.5)
                                    text("Interval",
                                    font = font1, 
                                    size = fontSize, 
                                    halign = "center");
                // Cornicetta
                difference() {
                    d = 8.0;
                    translate([d, d, minH+0.9*wallThickness])
                        rotate([0, -slope, 0])
                            cube([width-2.0*d, width-2.0*d, wallThickness]);
                    translate([d+wallThickness, d+wallThickness, minH])
                        rotate([0, -slope, 0])
                            cube([width-2.0*(d+wallThickness), width-2.0*(d+wallThickness), 3.0*wallThickness]);
                }
            }// end union() 1
            //Scassi
            union() {//2
               // Scasso pulsante 1
                translate([25.0, width-35.0, 25.0*sin(slope)+minH+wallThickness-4]) 
                    rotate([0, -slope, 0])
                        #cylinder(d = pushButton, h = 8);
                // Scasso pulsante 2
                translate([25.0, 35.0, 25.0*sin(slope)+minH+wallThickness-4])
                    rotate([0, -slope, 0])
                        #cylinder(d = pushButton, h = 8);
                // Scasso pulsante 3
                translate([70.0, width-35.0, 80.0*sin(slope)+minH+wallThickness-4]) 
                    rotate([0, -slope, 0])
                        #cylinder(d = pushButton, h = 8);
                // Scasso pulsante 4
                translate([70.0, 35.0, 80.0*sin(slope)+minH+wallThickness-4])
                    rotate([0, -slope, 0])
                        #cylinder(d = pushButton, h = 8);
                // Fori altoparlante
                intersection() {
                    for (x= [-10.0:5.0:10.0])
                        for (y= [-10.0:5.0:10.0])
                            translate([width-x-25.0, 0.5*width-y, (width-20.0)*sin(slope)+minH+wallThickness-4]) 
                                rotate([0, -slope, 0])
                                    #cylinder(d = 3, h = 8);
                    translate([width-25.0, 0.5*width, (width-20.0)*sin(slope)+minH+wallThickness-4]) 
                        rotate([0, -slope, 0])
                            #cylinder(d = 20.0, h = 8);
                }
                // Foro Led Accensione
                translate([width-20.0, 27.0, 41]) 
                    rotate([0, -slope, 0])
                        #cylinder(d = 5, h = 8);
            }// end union() 2

        }// end difference() 1    
}
//
//
if(upper) {
    intersection() {
        pedal_center("Start", "Stop");
        rotate([0.0, -slope, 0.0])
            translate([-0.25*depth, -0.25*width, minH+0.08])
                cube([1.5*depth, 1.5*width, lHeigth]);
    }
}
if(lower) {
    difference() {
        pedal_center("Start", "Stop");
        rotate([0.0, -slope, 0.0])
            translate([-0.25*depth, -0.25*width, minH-0.08])
                cube([1.5*depth, 1.5*width, lHeigth]);
    }
}
