include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <electronics.scad>
use <common.scad>

module bed_dxf() {
  dxf("bed");
  square([pw+14, pd+14], center = true);
}

module bed() {
  vitamin(str("AL: aluminium plate ", pw+14, "mm x ", pd+14, "mm x ", 3, "mm"));
  color(bed_color) linear_extrude(3) bed_dxf();
}

//! Be careful with the MGN carriage until it is attached to the rest of
//! the end frame.

module left_z_axis_rail_assembly()
    pose([66.9, 0, 123.2], [-262.39, -142.64, 170.83])
    assembly("left_z_axis_rail") {
  z_axis_rail_assembly();
  txyz(+th, -125/2-ew*1.5, ew*1.5) {
    explode([0, 0, -140], offset = [0, 0, 140]) ry(-90) duet_mount_assembly();
  }
}

//! Be careful with the MGN carriage until it is attached to the rest of
//! the end frame.

module right_z_axis_rail_assembly()
    pose([70.4, 0, 243.6], [-147.95, 48.26, 347.49])
    assembly("right_z_axis_rail") {
  rz(180) z_axis_rail_assembly();
}

module z_rail_assembly() assembly("z_rail") {
  rail(z_rail, z_rail_l);
  n = M4_sliding_t_nut;
  sheet = 3;
  rail_screws(z_rail, z_rail_l, sheet + nut_thickness(n));
  rail_hole_positions(z_rail, z_rail_l, 0)
    tz(-sheet) vflip() sliding_t_nut(n);
  //tx(pos[1]) explode([z_rail_l/2-pos[1]+20, 0, 0]) carriage(z_car);
}

module z_axis_rail_assembly() {
  txz(-ew/2, ew2) {

    extrusion(e2020, z_bar_l, center = false);

    explode([0, 0, 1.2 * z_rail_l]) {
      tx(ew/2) ry(90) tx(-z_rail_l/2) z_rail_assembly();
      tz((ph-pos[2])+z_offset) {
        z_carriage_assembly();
      }
    }
    tz(z_bar_l/2) mxy(z_bar_l/2) {
      mxz(ew/2) {
        explode([0, 0, 130]) {
          ry(90) cast_corner_bracket_assembly();
        }
      }
    }
  }
}

module z_motor_assembly()
  assembly("z_motor") {
  NEMA(NEMA17_47);
  tz(290/2+25) leadscrew(8, 250, 8, 4);
  tz(23) coupler();
}

module milled_corner_for_tapped_end_assembly()
  assembly("milled_corner_for_tapped_end") {
  milled_corner_bracket();
  txy(10, 3) rx(-90) {
    screw(M5_low_profile_screw, 12);
  }
  txy(3, 10) ry(90) {
    screw(M5_low_profile_screw, 10);
    rz(90) tz(-5.5) tnut(M5_tnut);
  }
}

module z_carriage_assembly()
  assembly("z_carriage") {
  txz(ew/2, carriage_screw_gap_l(z_car)/2) {
    ry(90) carriage(z_car);
    tx(carriage_total_h(z_car)+th) rz(180) {
      mxz(carriage_screw_gap_w(z_car)/2) {
        tz(carriage_screw_gap_l(z_car)/2) {
          ry(-90) screw_washer(carriage_screw(z_car), 10);
        }
        tz(-carriage_screw_gap_l(z_car)/2) {
          ry(-90) screw(carriage_screw(z_car), 10);
        }
      }
    }
  }
  tx(ew+th+carriage_total_h(z_car)) rz(180) {
    z_rail_mount_stl();
  }
}

module z_carriage_rail_assembly() {
  tx(-ew-z_car_h-th) {
    explode([-20, 0, 0], true) {
      rx(90) extrusion(e2020, pd+20);
      tz(-ew/2) {
        ty((pd+20)/2) explode([0, 10, 0]) ry(-90) {
          milled_corner_for_tapped_end_assembly();
        }
        ty(-(pd+20)/2) explode([0, -50, 0]) rz(180) ry(-90) {
          milled_corner_for_tapped_end_assembly();
        }
      }
      mxz(ew/2) {
        mxy(ew/2+th) {
          screw_and_washer(ex_screw, ex_screw_l);
        }
      }
      explode([0, -pd/2-30, 0]) mxz(ew/2) {
        mxy(ew/2+th) {
          tz(-7) tnut(M4_tnut);
        }
      }
      txy(-ew/2-acme_nut_w/2, 80) {
        tz(-10) {
          txz(-6+2, ew/2) explode([0, -pd-10, 0], offset = [ew/2, 15, 0]) {
            mxz(10) ry(-90) {
              tz(-12) tnut(M5_tnut);
            }
          }
        }
      }
    }
  }
  explode([-40, 0, 0], true) {
    txy(-z_shaft_offset+ew/2, 80) {
      tz(-10) {
        rz(-90) acme_anti_backlash_nut();
        txz(-6+2, ew/2) mxz(10) ry(-90) {
          screw_washer(M5_cap_screw, 14);
        }
      }
    }
  }
}

module aluminium_flat_bar_dxf() {
  dxf("aluminium_flat_bar");
  difference() {
    square([20, pd+ew*3], center = true);
    mxz((pd+ew*2)/2) {
      circle(d = screw_clearance_d(ex_screw));
    }
    mxz((pd)/2) {
      circle(d = screw_tap_d(bed_level_screw));
    }
  }
}

//! The screws should be screwed into tapped holes in the flat bar
//! with a nut each to lock against the bar.

module bed_assembly()
    pose([65.5, 0, 48.6], [63.46, 7.17, 122.95])
    assembly("bed") {
  tz((ph-pos[2])+z_offset+ew+ew/2) {
    myz((pw+14-20)/2) {
      color(aluminium_color) {
        vitamin(str("ALFB: aluminium flat bar 20mm x ",
                    pd+ew*3, "mm x ", th, "mm"));
        linear_extrude(th) aluminium_flat_bar_dxf();
      }
      mxz(pd/2) {
        tz(-6) explode([0, 0, -16]) {
          screw_up(bed_level_screw, 14);
          tz(2) nut(screw_nut(bed_level_screw));
        }
        txyz(10, -10, 11) explode([50, 0, 0]) {
          rz(180) swiss_clip(UKPFS1008_10, 10);
        }
      }
    }
    tz(th+3) explode([0, pd, 0]) bed();
  }
}

module z_axis_assembly()
    pose([66.9, 0, 50.7], [80.13, -62.33, 105.50])
    assembly("z_axis") {
  l = fw-(ew+z_car_h+th)*2;
  tz((ph-pos[2])+z_offset+ew) {
    mxz((pd+20+ew)/2) {
      ry(90) extrusion(e2020, l);
    }
    tz(ew/2) {
      myz((pw+14-20)/2) {
        tz(th) mxz((pd+ew*2)/2) {
          explode([0, 0, 5], true) screw_and_washer(ex_screw, ex_screw_l);
          rz(90) tz(-10) explode([0, -120, 0]) tnut(M4_tnut);
        }
      }
    }
  }
  explode([0, 0, 5]) bed_assembly();
}

module z_rail_mount_stl() {
  stl("z_rail_mount");
  clearance = 0.2;
  color(print_color) render() {
    //txz(ew/2+th, carriage_screw_gap_l(z_car)/2) {
    //  ry(-90) tz(-carriage_total_h(z_car)) carriage(z_car);
    //}
    difference() {
      tx(th/2) {
        mxy(ew/2+clearance) {
          rcc([ew+th,
               carriage_screw_gap_w(z_car)+th*2,
               th]);
        }
        tx(ew/2) {
          h = th+ew+th+carriage_screw_gap_l(z_car)/2+th;
          tz(-ew/2-th) rcc([th, carriage_screw_gap_w(z_car)+th*2, h]);
        }
      }
      mxz(ew/2) {
        cylinder(d = screw_clearance_d(ex_screw), h = 100, center = true);
      }
      tz(carriage_screw_gap_l(z_car)/2) {
        mxz(carriage_screw_gap_w(z_car)/2) {
          mxy(carriage_screw_gap_l(z_car)/2) {
            ry(90) {
              cylinder(d = screw_clearance_d(carriage_screw(y_car)),
                       h = 100, center = true);
            }
          }
        }
      }
    }
  }
}

module coupler(d1 = 5, d2 = 8, h = 22, od = 16, center = true) {
  color("gold") render() {
    tz(center ? -h/2 : 0) {
      difference() {
        cylinder(d = od, h = h);
        tz(-eta/2) cylinder(d = d1, h = h/2+eta);
        tz(h/2) cylinder(d = d2, h = h/2+eta);
      }
    }
  }
}


module z_motor_mount_assembly()
    pose([79.5, 0, 214.6], [-43.06, 96.57, 45.3])
    assembly("z_motor_mount") {
  tyz(80, ew2) {
    z_motor_mount_stl();
    mxz(ew/2) {
      tz(th) {
        screw_and_washer(ex_screw, ex_screw_l);
        tz(-8) tnut(M5_tnut);
      }
      txz(-ew+th, -ew) {
        mxy(ew/2) {
          ry(-90) {
            screw_and_washer(ex_screw, ex_screw_l);
            tz(-8) tnut(M5_tnut);
          }
        }
      }
    }
  }
}

module z_motor_mount_stl() {
  stl("z_motor_mount");
  color(print_color) render() difference() {
    l = z_shaft_offset+NEMA_hole_pitch(NEMA17_47)/2+th;
    union() {
      tx((ew-l)/2) rrcf([l, ew*2, th]);
      hull() {
        txz(-ew/2-th/2, -ew*2) rcc([th, ew*2, ew*2+th]);
        tx(-ew) rcc([ew, ew*2, th]);
      }
    }
    txz(-ew-th, -ew*2-eta) rcc([ew, ew*2-th*2, ew*2]);
    tx(-z_shaft_offset+ew/2) {
      cylinder(r = NEMA_big_hole(NEMA17_47)+1, h = 100, center = true);
      NEMA_screw_positions(NEMA17_47) {
        cylinder(d = screw_clearance_d(M3_cap_screw),
                 h = 100, center = true);
      }
    }
    mxz(ew/2) {
      cylinder(d = screw_clearance_d(nema_plate_screw),
               h = 100, center = true);
      tz(-ew) {
        mxy(ew/2) {
          ry(90) cylinder(d = screw_clearance_d(nema_plate_screw),
                          h = 100, center = true);
        }
      }
    }
  }
}

module acme_anti_backlash_nut() {
  vitamin("VSLOT-H-A-AB-NUT-B: Ooznest ACME anti-backlash nut");
  color(black_delrin_color) {
    import("ooznest/8mm-acme-anti-backlash-nut_VSLOT-H-A-AB-NUT-B.stl");
  }
}

if ($preview) {
  $explode = 1;
  //left_z_axis_rail_assembly();
  //right_z_axis_rail_assembly();
  //z_axis_rail_assembly();
  //z_rail_assembly();
  //z_motor_assembly();
  //milled_corner_for_tapped_end_assembly();
  //z_carriage_assembly();
  //bed_assembly();
  z_axis_assembly();
  //z_motor_mount_assembly();
}
