include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module rail_guard_stl() {
  stl("rail_guard");
  color(print_color) linear_extrude(rail_height(z_rail)) {
    difference() {
      rounded_square([ew, ew], r = 1.5, center = true);
      circle(d = screw_clearance_d(ex_screw));
    }
  }
}

module rail_guard_assembly()
  assembly("rail_guard") {
  rail_guard_stl();
  ry(180) {
    screw_washer(ex_screw, rail_height(z_rail)+6);
    tz(-rail_height(z_rail)-2) tnut(M4_tnut);
  }
}

if ($preview) {
  $explode = 1;
  rail_guard_assembly();
}
