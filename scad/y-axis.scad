include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <common.scad>
use <xy-motor.scad>

module y_rail_assembly() assembly("y_rail") {
  rail(y_rail, y_rail_l);
  n = M4_sliding_t_nut;
  sheet = 3;
  rail_screws(y_rail, y_rail_l, sheet + nut_thickness(n));
  rail_hole_positions(y_rail, y_rail_l, 0)
    tz(-sheet) vflip() sliding_t_nut(n);
  tx(pos[1]) explode([y_rail_l/2-pos[1]+20, 0, 0]) carriage_for_rail(y_rail);
}

module left_y_rail_assembly()
  pose([69.7, 0, 326.2], [22.98, 16.91, 8.02]) assembly("left_y_rail") {
  // rail and carriage
  txy(ew/2, y_rail_offset) {
    explode([0, y_rail_l*1.05, 0]) rz(90) y_rail_assembly();
    txy(-carriage_w(y_car)/2+microswitch_d(ms)/2-2,
      -y_rail_l/2-microswitch_h(ms)/2) {
        explode([0, -60, 0], offset = [-ew/2+1, 0, 5]) y_endstop_assembly();
    }
  }
  tz(-ew/2) rx(90) {
    rz(90) extrusion(e2040, fd-ew*2);
  }
  if ($label) {
    txz(40, 20) rz(90) label(str(fd-ew*2, "mm"));
  }
  ty(fd/2-ew) {
    txz(-ew/2, -ew) explode([0, 40, 0], offset = [0, -30, -5]) {
      rz(180) ry(90) cast_corner_bracket_assembly();
    }
  }
  txyz(-ew-(-ew*2-motor_hole_offset+ew/2), -fd/2+ew2, th) {
    explode([0, -50, 0]) rx(180) left_motor_assembly();
  }
}

module right_y_rail_assembly()
  pose([54.3, 0, 322], [17.1, 70.38, 57.81]) assembly("right_y_rail") {
  // rail and carriage
  txy(-ew/2, y_rail_offset) {
    explode([0, y_rail_l*1.05, 0]) rz(90) y_rail_assembly();
  }
  tz(-ew/2) rx(90) {
    rz(90) extrusion(e2040, fd-ew*2);
  }
  if ($label) {
    txz(40, 20) rz(90) label(str(fd-ew*2, "mm"));
  }
  ty(fd/2-ew) {
    txz(-ew/2, -ew) explode([0, 40, 0], offset = [0, -30, -5]) {
      rz(180) ry(90) cast_corner_bracket_assembly();
    }
  }
  txyz(ew-ew*2-motor_hole_offset+ew/2, -fd/2+ew2, th) {
    explode([0, -50, 0]) rx(180) right_motor_assembly();
  }
}

module y_carriage_screws() {
  rz(90) {
    // carriage screws
    tz(th) carriage_hole_positions(y_car) {
      screw_washer(carriage_screw(y_car), 10);
    }
  }
}

module left_y_carriage_stl() {
  stl("left_y_carriage");
  clearance = 0.6;
  color(print_color) {
    render() {
      difference() {
        union() {
          // carriage top
          tz(y_car_h) rcc([y_car_w, y_car_l, th]);
          // carriage side
          tx(y_car_w/2+th/2) rcc([th, y_car_l, y_car_h+th]);

          // extrusion holder
          txz(ew/2+y_car_w/2,
              bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
            rcc([ew, ew+th*2,
                 y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th]);
          }
          tx(y_car_w/2+th+ew/2+4.5) rcc([ew, ew, th]);
          hull() {
            txyz(motor_hole_offset-pbr+bbr, +20.5,
                 bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                       h = y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
            txz(motor_hole_offset-pbr+bbr,
                bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                       h = y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
          }
          hull() {
            txyz(motor_hole_offset+pbr+bbr, -20.5,
                 top_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                       h = y_car_h-top_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
            tyz(-20.5,
                top_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                       h = y_car_h-top_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
          }
        }

        // clearance for carriage
        txz(-50+y_car_w/2, -50+y_car_h) cc([100,100,100]);

        // carriage mount holes
        carriage_hole_positions(y_car) {
          cylinder(d = screw_clearance_d(carriage_screw(y_car)),
                   h = 100, center = true);
        }

        txyz(motor_hole_offset-pbr+bbr, +20.5, bottom_belt_h) {
          // upper idler cutout
          ty(+2.5) cc([35, 20, idler_h+clearance]);
          // upper idler screw hole
          cylinder(d = screw_clearance_d(idler_screw), h = 1000, center = true);
          tz(idler_h/2+th) {
            cylinder(d = washer_od(screw_washer(idler_screw))+2, h = 1000);
          }
        }

        txyz(motor_hole_offset+pbr+bbr, -20.5, top_belt_h) {
          // lower idler cutout
          ty(-2.5) cc([15, 20, idler_h+clearance]);
          // lower idler screw hole
          cylinder(d = screw_clearance_d(idler_screw), h = 1000, center = true);
          tz(idler_h/2+th) {
            cylinder(d = washer_od(screw_washer(idler_screw))+2, h = 1000);
          }
        }

        // upper belt clearance
        txz(y_car_w/2, top_belt_h) {
          cc([3, 200, idler_h]);
          txz(-0.5, -idler_h/2) ry(45) cc([2.8, 200, 2.8]);
        }

        // extrusion cutout
        tx(ew+y_car_w/2+th) tz(-ew) rcc([ew*2, ew+0.5, ew+0.5]);

        // extrusion mount holes
        tx(y_car_w/2+th+ew/2) {
          cylinder(d = screw_clearance_d(ex_screw), h = 1000, center = true);
        }

        // extrusion mount screw cutout
        txz(ew/2+y_car_w/2+th, th) rcc([ew+0.5, ew, 100]);

        // testing
        //ty(50) cc([100,100,100]);
      }
      // extrusion mount hole bridges
      txz(y_car_w/2+th+ew/2, th-0.3) {
        cylinder(d = screw_clearance_d(ex_screw)+2, h = 0.3);
      }
      txz(y_car_w/2+th+ew/2, -ew-0.3) {
        cylinder(d = screw_clearance_d(ex_screw)+2, h = 0.3);
      }

      // lower idler hole bridges
      txyz(motor_hole_offset+pbr+bbr, -20.5, top_belt_h) {
        tz(idler_h/2+th-0.3) {
          cylinder(d = screw_clearance_d(idler_screw)+2, h = 0.3);
        }
        tz(-idler_h/2-0.3-clearance/2) {
          cylinder(d = screw_clearance_d(idler_screw)+2, h = 0.3);
        }
      }

      // upper idler hole bridges
      txyz(motor_hole_offset-pbr+bbr, +20.5, bottom_belt_h) {
        tz(idler_h/2+th-0.3) {
          cylinder(d = screw_clearance_d(idler_screw)+2, h = 0.3);
        }
        tz(-idler_h/2-0.3-clearance/2) {
          cylinder(d = screw_clearance_d(idler_screw)+2, h = 0.3);
        }
      }
    }
  }
}

module right_y_carriage_stl() {
  stl("right_y_carriage");
  clearance = 0.6;
  color(print_color) {
    render() {
      difference() {
        union() {
          // carriage top
          tz(y_car_h) rcc([y_car_w, y_car_l, th]);
          // carriage side
          tx(-y_car_w/2-th/2) rcc([th, y_car_l, y_car_h+th]);

          // extrusion holder
          txz(-ew/2-y_car_w/2,
              bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
            rcc([ew, ew+th*2,
                 y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th]);
          }
          tx(-y_car_w/2-th-ew/2-4.5) rcc([ew, ew, th]);
          hull() {
            txyz(-(motor_hole_offset-pbr+bbr), +20.5,
                 top_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                        h = y_car_h-top_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
            txz(-(motor_hole_offset-pbr+bbr),
                 top_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                        h = y_car_h-top_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
          }
          hull() {
            txyz(-(motor_hole_offset+pbr+bbr), -20.5,
                 bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                        h = y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
            tyz(-20.5,
                 bottom_belt_h-idler_h/2-washer_h(M3_washer)-th) {
              cylinder(d = th*2+screw_clearance_d(M3_cap_screw),
                        h = y_car_h-bottom_belt_h+th+idler_h/2+washer_h(M3_washer)+th);
            }
          }
        }

        // clearance for carriage
        txz(50-y_car_w/2, -50+y_car_h) cc([100,100,100]);

        // carriage mount holes
        carriage_hole_positions(y_car) {
          cylinder(d = screw_clearance_d(carriage_screw(y_car)),
                   h = 100, center = true);
        }

        txyz(-(motor_hole_offset-pbr+bbr), +20.5, top_belt_h) {
          // upper idler cutout
          ty(+2.5) cc([35, 20, idler_h+clearance]);
          // upper idler screw hole
          cylinder(d = screw_clearance_d(idler_screw), h = 1000, center = true);
          tz(idler_h/2+th) {
            cylinder(d = washer_od(screw_washer(idler_screw))+2, h = 1000);
          }
        }

        txyz(-(motor_hole_offset+pbr+bbr), -20.5, bottom_belt_h) {
          // lower idler cutout
          ty(-2.5) cc([15, 20, idler_h+clearance]);
          // lower idler screw hole
          cylinder(d = screw_clearance_d(idler_screw), h = 1000, center = true);
          tz(idler_h/2+th) {
            cylinder(d = washer_od(screw_washer(idler_screw))+2, h = 1000);
          }
        }

        // lower belt clearance
        txz(-y_car_w/2, bottom_belt_h) {
          cc([3, 200, idler_h]);
          txz(0.5, -idler_h/2) ry(45) cc([2.8, 200, 2.8]);
        }

        // extrusion cutout
        tx(-ew-y_car_w/2-th) tz(-ew) rcc([ew*2, ew+0.5, ew+0.5]);

        // extrusion mount holes
        tx(-y_car_w/2-th-ew/2) {
          cylinder(d = screw_clearance_d(ex_screw), h = 1000, center = true);
        }

        // extrusion mount screw cutout
        txz(-ew/2-y_car_w/2-th, th) rcc([ew+0.5, ew, 100]);

        // testing
        //ty(50) cc([100,100,100]);
      }
      // extrusion mount hole bridges
      txz(-(y_car_w/2+th+ew/2), th-0.3) {
        cylinder(d = screw_clearance_d(ex_screw)+2, h = 0.3);
      }
      txz(-(y_car_w/2+th+ew/2), -ew-0.3) {
        cylinder(d = screw_clearance_d(ex_screw)+2, h = 0.3);
      }
      // lower idler hole bridges
      txyz(-(motor_hole_offset+pbr+bbr), -20.5, bottom_belt_h) {
        tz(idler_h/2+th-0.3) {
          cylinder(d = screw_clearance_d(idler_screw), h = 0.3);
        }
        tz(-idler_h/2-0.3-clearance/2) {
          cylinder(d = screw_clearance_d(idler_screw), h = 0.3);
        }
      }
      // upper idler hole bridges
      txyz(-(motor_hole_offset-pbr+bbr), +20.5, top_belt_h) {
        tz(idler_h/2+th-0.3) {
          cylinder(d = screw_clearance_d(idler_screw), h = 0.3);
        }
        tz(-idler_h/2-0.3-clearance/2) {
          cylinder(d = screw_clearance_d(idler_screw), h = 0.3);
        }
      }
    }
  }
}

module y_endstop_mount_stl() {
  stl("y_endstop_mount");
  // TOFIX: reprint!
  color(print_color) {
    render() {
      // narrower to avoid motor mount
      ty(-th*1.5) {
        difference() {
          rcc([ew-2, microswitch_h(ms)+th*3, th]);
          txy(1, -th) {
            cylinder(d = screw_clearance_d(ex_screw),
                     h = 1000, center = true);
          }
        }
      }
      tx(ew/2-microswitch_d(ms)/2-3) {
        difference() {
          rcc([th, microswitch_h(ms), microswitch_l(ms)+th]);
          tz(th+microswitch_l(ms)/2) {
            ry(90) {
              microswitch_hole_positions(ms) {
                cylinder(d = screw_clearance_d(microswitch_screw),
                         h = 1000, center = true);
              }
            }
          }
        }
      }
    }
  }
}

module y_endstop_assembly()
  pose([61.6, 0, 228.4], [6.25, -17.17, 0]) assembly("y_endstop") {
  // y min endstop
  txyz(-0.5, microswitch_h(ms)/4, th+microswitch_l(ms)/2) {
    ry(-90) microswitch(ms);
  }
  txy(-ew/2, microswitch_h(ms)/4) {
    y_endstop_mount_stl();
    txyz(1, -th*2.5, th) {
      screw_washer(ex_screw, ex_screw_l);
      tz(-8) explode([0, 0, -5]) tnut(M4_tnut);
    }
    tx(ew/2-microswitch_d(ms)/2-th-0.5) {
      tz(th+microswitch_l(ms)/2) {
        ry(-90) {
          microswitch_hole_positions(ms) {
            screw_washer(microswitch_screw, th+microswitch_d(ms));
          }
        }
      }
    }
  }
}

module left_y_carriage_assembly()
  pose([67.6, 0, 122.3], [-47.7, -42.57, -29.06]) assembly("left_y_carriage") {
  // extrusion mount screw
  txz(ew/2+y_car_w/2+th, -ew/2) {
    mxy(ew/2+th) {
      screw_washer(ex_screw, ex_screw_l);
      tz(-8) rz(90) tnut(M4_tnut);
    }
  }

  // idlers
  w = screw_washer(idler_screw);
  n = screw_nut(idler_screw);
  for (p = [[motor_hole_offset+pbr+bbr, -20.5, top_belt_h],
             [motor_hole_offset-pbr+bbr, +20.5, bottom_belt_h]]) {
    translate(p) {
      idler_assembly();
      explode([0, 0, 20], true) {
        tz(idler_h/2+th) {
          screw_washer(idler_screw, idler_h+th*2+0.5+nut_h(n)+washer_h(w));
        }
      }
    }
    translate(p) {
      tz(idler_h/2+th-(idler_h+th*2+0.5+washer_h(w))) {
        explode([0, 0, -5], true) {
          washer(w);
          explode([0, 0, -5]) {
            tz(-nut_h(n)) {
              nut(n);
            }
          }
        }
      }
    }
  }

  left_y_carriage_stl();
}

module right_y_carriage_assembly()
  pose([76, 0, 289], [-40.9, -26.97, 13.13]) assembly("right_y_carriage") {

  // extrusion mount screw
  txz(-ew/2-y_car_w/2-th, -ew/2) {
    mxy(ew/2+th) {
      screw_washer(ex_screw, ex_screw_l);
      tz(-8) rz(90) tnut(M4_tnut);
    }
  }

  // idlers
  w = screw_washer(idler_screw);
  n = screw_nut(idler_screw);
  for (p = [[-(motor_hole_offset+pbr+bbr), -20.5, bottom_belt_h],
            [-(motor_hole_offset-pbr+bbr), +20.5, top_belt_h]]) {
    translate(p) {
      idler_assembly();
      explode([0, 0, 20], true) {
        tz(idler_h/2+th) {
          screw_washer(idler_screw, idler_h+th*2+0.5+nut_h(n)+washer_h(w));
        }
      }
    }
    translate(p) {
      tz(idler_h/2+th-(idler_h+th*2+0.5+washer_h(w))) {
        explode([0, 0, -5], true) {
          washer(w);
          explode([0, 0, -5]) {
            tz(-nut_h(n)) {
              nut(n);
            }
          }
        }
      }
    }
  }

  right_y_carriage_stl();
}

if ($preview) {
  //$explode = 1;
  //y_rail_assembly();
  left_y_rail_assembly();
  //right_y_rail_assembly();
  //y_endstop_assembly();
  //left_y_carriage_assembly();
  //right_y_carriage_assembly();
}
