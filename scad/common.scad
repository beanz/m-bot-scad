include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module idler_assembly() assembly("idler") {
  tz(-washer_h(M3_washer)/2) washer(M3_washer);
  mxy(washer_h(M3_washer)/2) {
    explode([0, 0, 5], true) {
      tz(ball_bearing_h(BBF623)/2) {
        mirror([0,0,1]) ball_bearing(BBF623);
        explode([0, 0, 5], true) {
          tz(ball_bearing_h(BBF623)/2) {
            washer(M3_washer);
          }
        }
      }
    }
  }
}

module cast_corner_bracket_assembly() assembly("cast_corner_bracket") {
  extrusion_corner_bracket_assembly(E20_corner_bracket,
    screw_type = M5_low_profile_screw);
}

module milled_corner_bracket_assembly()
    pose([328.5, 0, 344.6], [10.74, 6.43, -5.7])
    assembly("milled_corner_bracket") {
  milled_corner_bracket();
  txy(10, 3) rx(-90) {
    screw(M5_low_profile_screw, 10);
    tz(-5.5) tnut(M5_tnut);
  }
  txy(3, 10) ry(90) {
    screw(M5_low_profile_screw, 10);
    rz(90) tz(-5.5) rz(90) tnut(M5_tnut);
  }
}

module milled_corner_bracket() {
  vitamin("VSLOT-B-90AC: Ooznest 90 Degree Angle Corner (VSLOT-B-90AC)");
  color(black_aluminium_color) {
    txy(10,10) ry(90) import("ooznest/90-degree-corner_VSLOT-B-90AC.stl");
  }
}

if ($preview) {
  //$explode = 1;
  //idler_assembly();
  //dual_idler_assembly();
  milled_corner_bracket_assembly();
}
