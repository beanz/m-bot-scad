include <conf.scad>
include <lazy.scad>
include <shapes.scad>

ml = 28;
l = 85;
nw = NEMA_width(NEMA17);

module titan_mount_stl() {
  stl("titan_mount");
  color(print_color) render() {
    tz(-1) linear_extrude(2) difference() {
      ty(2) square([46, 46], center = true);
      NEMA_hole_positions(NEMA17, 4) {
        circle(d = screw_clearance_d(motor_screw));
      }
      circle(r = NEMA_big_hole(NEMA17)+1);
    }

    ty(nw/2+th) rx(90) linear_extrude(th) difference() {
      union() {
        square([ew, l], center = true);
        ty(-ml/2+1) square([nw+4, ml], center = true);
      }
      mxz((l-screw_clearance_d(ex_screw)-th)/2) {
        circle(d = screw_clearance_d(ex_screw));
      }
    }
    myz(nw/2) ry(90) linear_extrude(2) {
      polygon(points = [[-1, -nw/2], [1, -nw/2],
                        [ml-1, nw/2], [ml-1, nw/2+th], [-1, nw/2]],
              paths = [[0, 1, 2, 3, 4, 0]]);
    }
  }
}

module titan_mount_assembly()
  assembly("titan_mount") {
  ty(-nw/2-th) {
    titan_mount_stl();
    tz(-1) rz(90) NEMA(NEMA17VS);
    vitamin("E3DTitan: E3D Titan Extruder");
    translate([0, 0, 14.5]) %cube([40, 40, 26], center = true);
    mxy((l-screw_clearance_d(ex_screw)-th)/2) {
      ty(nw/2) rx(90) {
        screw_washer(ex_screw, ex_screw_l);
        tz(-7) tnut(M4_tnut);
      }
    }
  }
}

if ($preview) {
  $explode = 0;
  titan_mount_assembly();
}
