include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <common.scad>

module dual_idler_assembly() assembly("dual_idler") {
  tz(-washer_h(M3_washer)/2) washer(M3_washer);
  mxy(washer_h(M3_washer)/2+ball_bearing_h(BBF623)) {
    explode([0, 0, 5], true) {
      tz(washer_h(M3_washer)/2) {
        tz(-washer_h(M3_washer)/2) washer(M3_washer);
        mxy(washer_h(M3_washer)/2) {
          explode([0, 0, 3], true) {
            tz(ball_bearing_h(BBF623)/2) {
              mirror([0,0,1]) ball_bearing(BBF623);
            }
          }
        }
        tz(washer_h(M3_washer)/2+ball_bearing_h(BBF623)) {
          explode([0, 0, 5]) washer(M3_washer);
        }
      }
    }
  }
}

module right_idler_stl() {
  stl("right_idler");
  idler_stl();
}

module idler_stl() {
  h = idler_h*2+washer_h(M3_washer)/2+th+ew*1.5;
  clearance = 0.6;
  color(print_color) {
    difference() {
      union() {
        tz(-idler_h*2-washer_h(M3_washer)/2-th) {
          tx(idler_offset-ew/2-th/4) rcc([th/2, ew, h-ew]);
          txy(idler_offset-ew/2, ew/2+th/2) rcc([ew*2, th, h]);
        }
        tz(-washer_h(screw_washer(idler_screw))+clearance/2) {
          hull() {
            tx(idler_offset-ew/2-th/4) rcc([th/2, ew, th-clearance/2]);
            cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                     h = th-clearance/2);
          }
          hull() {
            txyz(idler_offset-ew, ew/2+th/2, 0) rcc([ew, th, th-clearance/2]);
            cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                     h = th-clearance/2);
          }
        }
        tz(-idler_h*2-washer_h(M3_washer)/2-th) {
          hull() {
            tx(idler_offset-ew/2-th/4) rcc([th/2, ew, th-clearance/2]);
            cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                     h = th-clearance/2);
          }
          hull() {
            txyz(idler_offset-ew, ew/2+th/2, 0) rcc([ew, th, th-clearance/2]);
            cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                     h = th-clearance/2);
          }
        }
      }
      cylinder(d = screw_clearance_d(idler_screw), h = 1000, center = true);
      tx(idler_offset) {
        mxy(ew*1) {
          rx(90) {
            cylinder(d = screw_clearance_d(ex_screw), h = 1000, center = true);
          }
        }
      }
      txz(idler_offset-ew, ew) {
        rx(90) {
          cylinder(d = screw_clearance_d(ex_screw), h = 1000, center = true);
        }
      }
    }
  }
}

module back_right_idler_assembly()
  pose([54.3, 0, 298.2], [22.47, 8.54, -21.73]) assembly("back_right_idler") {
  tz((bottom_belt_h+top_belt_h)/2) dual_idler_assembly(); // stacked idlers

  w = screw_washer(idler_screw);
  n = screw_nut(idler_screw);
  tz(-idler_h*2-washer_h(w)/2-th) {
    screw_washer_up(idler_screw,
                    idler_h*2-washer_h(w)/2+th*2+washer_h(w)+nut_h(n));
  }
  tz(th) {
   explode([0, 0, 5], true) {
     tz(-washer_h(w)) washer(w);
     explode([0, 0, 5]) {
       nut(n);
     }
   }
  }

  ty(ew/2+th) {
    tx(idler_offset) {
      mxy(ew*1) {
        rx(-90) {
          screw_washer(ex_screw, ex_screw_l);
          tz(-8) tnut(M4_tnut);
        }
      }
    }
    txz(idler_offset-ew, ew) {
      rx(-90) {
        screw_washer(ex_screw, ex_screw_l);
        tz(-8) rz(90) tnut(M4_tnut);
      }
    }
  }
  right_idler_stl();
}

module left_idler_stl() {
  stl("left_idler");
  mirror([1,0,0]) idler_stl();
}

module back_left_idler_assembly()
  pose([61.3, 0, 64.2], [-10.87, 9.69, -18.57]) assembly("back_left_idler") {
  tz((bottom_belt_h+top_belt_h)/2) dual_idler_assembly(); // stacked idlers
  w = screw_washer(idler_screw);
  n = screw_nut(idler_screw);
  tz(-idler_h*2-washer_h(w)/2-th) {
    screw_washer_up(idler_screw,
                    idler_h*2-washer_h(w)/2+th*2+washer_h(w)+nut_h(n));
  }
  tz(th) {
   explode([0, 0, 5], true) {
     tz(-washer_h(w)) washer(w);
     explode([0, 0, 5]) {
       nut(n);
     }
   }
  }

  ty(ew/2+th) {
    tx(-idler_offset) {
      mxy(ew*1) {
        rx(-90) {
          screw_washer(ex_screw, ex_screw_l);
          tz(-8) tnut(M4_tnut);
        }
      }
    }
    txz(idler_offset-ew, ew) {
      rx(-90) {
        screw_washer(ex_screw, ex_screw_l);
        tz(-8) rz(90) tnut(M4_tnut);
      }
    }
  }
  left_idler_stl();
}

if ($preview) {
  $explode = 1;
  //back_right_idler_assembly();
  back_left_idler_assembly();
}

