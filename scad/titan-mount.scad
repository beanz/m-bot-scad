include <conf.scad>
include <lazy.scad>
include <shapes.scad>

ml = 28;
l = 92;
nw = NEMA_width(NEMA17_47);

module titan_mount_stl() {
  stl("titan_mount");
  color(print_color) render() {
    tz(-1) linear_extrude(2) difference() {
      ty(2) square([46, 46], center = true);
      NEMA_hole_positions(NEMA17_47, 4) {
        circle(d = screw_clearance_d(motor_screw));
      }
      circle(r = NEMA_big_hole(NEMA17_47)+1);
    }

    ty(nw/2+th) rx(90) linear_extrude(th) difference() {
      union() {
        ty(-7) square([ew, l], center = true);
        ty(-ml/2+1) square([nw+4, ml], center = true);
      }
      ty(-7) mxz((l-screw_clearance_d(ex_screw)-th)/2) {
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
    tz(-1) rz(90) NEMA(NEMA17_40);
    vitamin("E3DTitan: E3D Titan Extruder");
    translate([0, 0, 14.5]) %cube([40, 40, 26], center = true);
    tz(-7) mxy((l-screw_clearance_d(ex_screw)-th)/2) {
      ty(nw/2) rx(90) {
        screw_and_washer(ex_screw, ex_screw_l);
        tz(-7) tnut(M4_tnut);
      }
    }
  }
}

if ($preview) {
  $explode = 0;
  titan_mount_assembly();
}
