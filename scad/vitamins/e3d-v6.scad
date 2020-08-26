include <lazy.scad>
include <../conf.scad>
e3d_clamp_d = 16;
e3d_clamp_mid_d = 12;
e3d_clamp_top_h = 7;
e3d_clamp_mid_h = 6;
e3d_clamp_bottom_h = 3;
e3d_fin_d = 22.3;
e3d_fins_h = 26;
e3d_fins = 11;
e3d_fin_h = 1;
e3d_fin_gap = 1.5;
e3d_heat_break_d = 4;
e3d_heat_break_h = 2.1;
e3d_heat_block = [16, 20, 11.5];
e3d_heat_block_offset = [0, 5.5, 0];
e3d_nozzle_gap = 0.5;
e3d_nozzle_hex_h = 3;
e3d_nozzle_hex_r = 3.5/cos(30);
e3d_nozzle_h = 2;
e3d_nozzle_angle = 45;

function e3d_clamp_part(section) =
  section == "top" ? [e3d_clamp_d, e3d_clamp_top_h] :
   section == "middle" ? [e3d_clamp_mid_d, e3d_clamp_mid_h] :
   [e3d_clamp_d, e3d_clamp_bottom_h];

function e3d_clamp_part_d(section) = e3d_clamp_part(section)[0];
function e3d_clamp_part_h(section) = e3d_clamp_part(section)[1];

function e3d_clamp_height() = e3d_clamp_h();

function e3d_clamp_h() =
  (e3d_clamp_top_h + e3d_clamp_mid_h + e3d_clamp_bottom_h);

function e3d_clamp_d() = e3d_clamp_d;

function e3d_heatsink_height() =
   e3d_fin_gap*2 + e3d_fin_h +
   e3d_fins_h;

function e3d_height() =
  (e3d_clamp_height() +
   e3d_heatsink_height() +
   e3d_heat_break_h + e3d_heat_block[2] +
   e3d_nozzle_gap + e3d_nozzle_hex_h + e3d_nozzle_h);

module cylinder_stack(d, h, fn = 30, col = [0.8, 0.8, 0.8]) {
  translate([0, 0, -h]) {
    color(col) cylinder(d = d, h = h, $fn = fn);
    children();
  }
}

module e3d_clamp_cut(clearance = 0.3) {
  tz(-e3d_clamp_top_h) {
    cylinder(d = e3d_clamp_d, h = e3d_clamp_top_h+eta, $fn = 30);
    tz(-e3d_clamp_mid_h-eta/2) {
      cylinder(d = e3d_clamp_mid_d, h = e3d_clamp_mid_h+eta, $fn = 30);
      tz(-e3d_clamp_bottom_h-eta/2) {
        cylinder(d = e3d_clamp_d, h = e3d_clamp_bottom_h+eta, $fn = 30);
      }
    }
  }
}

module fin_stack(d1, h1, d2, h2, n) {
  color([0.8, 0.8, 0.8]) for (i = [ 0 : n-1 ]) {
    translate([0, 0, -h1-i*(h1+h2)]) {
      cylinder(d = d1+0.4*i, h = h1, $fa = 5);
    }
    translate([0, 0, -h2-(h1+i*(h1+h2))]) {
      cylinder(d = d2, h = h2, $fa = 5);
    }
  }
  translate([0, 0, -n*(h1+h2)]) children();
}

module e3d_v6_3mm_bowden() {
  cylinder_stack(d = e3d_clamp_d, h = e3d_clamp_top_h)
    cylinder_stack(d = e3d_clamp_mid_d, h = e3d_clamp_mid_h)
    cylinder_stack(d = e3d_clamp_d, h = e3d_clamp_bottom_h)
    fin_stack(8, 1.5, e3d_clamp_d, 1, 1)
    fin_stack(8, 1.5, e3d_fin_d, 1, 11)
    cylinder_stack(d = e3d_heat_break_d, h = e3d_heat_break_h) {
      translate(e3d_heat_block_offset) {
        translate([0, 0, -e3d_heat_block[2]/2]) {
          color([0.8, 0.8, 0.8]) cube(e3d_heat_block, center = true);
        }
      }
      translate([0,0, -e3d_heat_block[2]]) color("gold") {
        cylinder_stack(d = 5, h = e3d_nozzle_gap)
        cylinder_stack(d = e3d_nozzle_hex_r*2, h = e3d_nozzle_hex_h,
                       fn = 6, col = "gold") {
          translate([0, 0, -2]) {
            cylinder(r1 = 1/2, r2 = 2*tan(45), h = 2);
          }
        }
      }
    }
  translate([0, 0, -e3d_clamp_height()-e3d_heatsink_height()]) {
    rotate([0,0,180]) {
      rotate([90,0,0]) color("blue") import("e3d/V6.6_Duct.stl");
    }
    translate([20,0,30/2]) rotate([0,90,0]) color(grey(20)) fan(fan30x10);
  }
}

e3d_v6_3mm_bowden();
