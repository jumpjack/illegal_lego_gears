
//////////////////////////////////// illegal lego gears library 

use <gears/gears.scad>; // https://github.com/chrisspen/gears
$fn=48;

module rounded_square(size, r=0.2) {
    $fn=24;
    if (is_num(size))
        translate([r, r, 0])
            minkowski() {
                circle(r);
                square([size-(2*r), size-(2*r)]);
        };
    if (is_list(size))
        translate([r, r, 0])
            minkowski() {
                circle(r);
                square([size[0]-(2*r), size[1]-(2*r)]);
        };
    }

module lego_axle(m=1, hole=false, tolerance=0.05) {
    module 2d_axle() {
        difference() {
            circle((4.8)/2);
            translate([.9, .9, 0]) rounded_square(4);
            translate([-4.9, .9, 0]) rounded_square(4);
            translate([.9, -4.9, 0]) rounded_square(4);
            translate([-4.9, -4.9, 0]) rounded_square(4);
        }
    }
        linear_extrude(m*8-0.15)
            if (hole) offset(r=tolerance) 2d_axle();
            else offset(r=-tolerance) 2d_axle();
        }

module lego_gear(s, flat_surface=true, central_axle=true, cross_hole=true, stud_radius_target=0, solid=false, stud_hole_tolerance=0.00, axle_hole_tolerance=0.05, bevel=false, bevel_angle=45, stud_cross_hole = false) {
    // Calcolo dei parametri per la libreria gears
    // Il modulo standard Lego è 1.
    // Per i bevel gears, il numero di denti è 16 * s
    teeth = 16 * s;

    difference() {
        union () {
            if (bevel) {
                // Generazione Bevel Gear
                // impostiamo bore=0 per forarlo successivamente
                bevel_herringbone_gear(modul=1, tooth_number=teeth, partial_cone_angle=bevel_angle, tooth_width=5, bore=0, pressure_angle=20, helix_angle=0);
            } else {
                // Generazione Spur Gear standard
                translate([0,0, 1.93]) spur_gear(1, teeth, 4, 0, pressure_angle=20, helix_angle=0, optimized=false);

                if (flat_surface || solid) cylinder(7.75, d=s*16-2.15);
                else {
                    // Supporti per fori standard
                    for (x = [round(-s)+0.5:1:round(s)-0.5]) {
                        for (y = [round(-s)+0.5:1:round(s)-0.5]){
                            if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2) {
                                translate([x*8, y*8, 0]) cylinder(7.75, d=7.6);
                            }
                        }
                    }
                    for (x = [round(-s)+1:1:round(s)-1]) {
                        for (y = [round(-s)+1:1:round(s)-1]){
                            if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2) {
                                translate([x*8, y*8, 0]) cylinder(7.75, d=5.85);
                            }
                        }
                    }
                }
            }
        }

        // Gestione foro centrale (funziona per entrambi i tipi)
        if (central_axle) {
            if (cross_hole) {
                // Nota: l'altezza del foro potrebbe richiedere aggiustamenti in base allo spessore del cono
                translate([0,0,-2]) lego_axle(2, hole=true, tolerance=axle_hole_tolerance);
            } else {
                translate([0,0,-2]) cylinder(h=20, d=4.8 + (2 * axle_hole_tolerance));
            }
        }

        // Fori Stud e Axle (solo per ingranaggi cilindrici standard)
if (!solid ) {
            // Creazione Stud Holes
            for (x = [round(-s)+0.5:1:round(s)-0.5]) {
                for (y = [round(-s)+0.5:1:round(s)-0.5]) {
                    dist_val = sqrt(pow(x,2)+pow(y,2));
                    is_at_target = (stud_radius_target == 0) || (abs(dist_val - stud_radius_target) < 0.2);

                    if (is_at_target && (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2)) {
                        // Modifica logica qui:
                        if (stud_radius_target != 0 && stud_cross_hole) {
                            // Crea foro a croce
                            translate([x*8, y*8, -1]) lego_axle(2, hole=true, tolerance=axle_hole_tolerance);
                        } else {
                            // Crea foro tondo standard (comportamento originale)
                            translate([x*8, y*8, -1]) cylinder(10, d=4.8 + stud_hole_tolerance);
                            translate([x*8, y*8, 6.95]) cylinder(10, d=6.2 + stud_hole_tolerance);
                            translate([x*8, y*8, -9.2]) cylinder(10, d=6.2 + stud_hole_tolerance);
                        }
                    }
                }
            }

            // Creazione Axle Holes
            if (stud_radius_target == 0) {
                for (x = [round(-s)+1:1:round(s)-1]) {
                    for (y = [round(-s)+1:1:round(s)-1]){
                        if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2){
                            if ((x!=0) || (y!=0)) translate([x*8, y*8, -1]) lego_axle(2, hole=true, tolerance=axle_hole_tolerance);
                            if ((s>=1) && ((x!=0) || (y!=0) || central_axle)) {
                                if ((x+y)%2==0) translate([x*8-4,y*8-0.4,-1]) cube([8,0.8,10]);
                                else translate([x*8-0.4,y*8-4,-1]) cube([0.8,8,10]);
                            }
                        }
                    }
                }
            }
        }
    }
}
