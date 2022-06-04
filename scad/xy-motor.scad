include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module right_motor_mount_stl() {
  stl("right_motor_mount");
  motor_mount_stl();
}

module motor_mount_stl() {
  color(print_color) render() {
    difference() {
      union() {
        rrcf([NEMA_width(NEMA17_47), NEMA_width(NEMA17_47), th], r = 5);
        rz(45) tx(motor_hole_offset) difference() {
          rrcf([ew, ew*2, th]);
          mxz(ew-th/2-screw_clearance_d(ex_screw)/2) {
            cylinder(d = screw_clearance_d(ex_screw), h = th*3, center = true);
          }
        }
        hull() {
         txy(NEMA_width(NEMA17_47)/2-5, -(NEMA_width(NEMA17_47)/2-5)) {
           cylinder(r = 5, h = th);
         }
         tx(motor_hole_offset-(ew-th)/2) {
           rz(-45) tx(ew-th/2) rrcf([ew+th, th, th]);
         }
        }
        tx(motor_hole_offset-(ew-th)/2) {
          rz(-45) tx(ew+th/4) rrcf([ew-th/2, th, ew+th]);
        }
      }
      NEMA_hole_positions(NEMA17_47, 4) {
        cylinder(d = screw_clearance_d(motor_screw)+1, h = th*3,
                 center = true);
      }
      cylinder(r = NEMA_big_hole(NEMA17_47)+1, h = th*3, center = true);
      tx(motor_hole_offset-(ew-th)/2) {
        rz(-45) txz(ew, ew/2+th) {
          rx(90) cylinder(d = screw_clearance_d(ex_screw), h = th*3,
                          center = true);
        }
      }
    }
  }
}

module right_motor_assembly() assembly("right_motor") {
  rz(-135) NEMA(NEMA17_47);
  tz(8) pulley(opulley);
  tz(th) rz(45) rx(180) {
    right_motor_mount_stl();
    rz(45) tx(motor_hole_offset) {
      mxz(ew-th/2-screw_clearance_d(ex_screw)/2) {
        tz(th) screw_and_washer(ex_screw, ex_screw_l);
        tz(-3) tnut(M4_tnut);
      }
    }
    tx(motor_hole_offset-(ew-th)/2) {
      rz(-45) txz(ew, ew/2+th) {
        rx(90) tz(th/2) {
          screw_and_washer(ex_screw, ex_screw_l);
          tz(-3-th) tnut(M4_tnut);

        }
      }
    }
  }

  tz(th) rz(45) {
    NEMA_hole_positions(NEMA17_47, 3) {
      screw_washer(motor_screw, 10);
    }
    rz(-90) NEMA_hole_positions(NEMA17_47, 1) { // washer_d > slot_w !
      screw(motor_screw, 10);
    }
  }
}

module left_motor_mount_stl() {
  stl("left_motor_mount");
  mirror([0,1,0]) motor_mount_stl();
}

module left_motor_assembly() assembly("left_motor") {
  rz(135) NEMA(NEMA17_47);
  tz(5.5) tz(pulley_length(opulley)) rx(180) pulley(opulley);
  tz(th) rz(135) rx(180) {
    left_motor_mount_stl();
    rz(-45) tx(motor_hole_offset) {
      mxz(ew-th/2-screw_clearance_d(ex_screw)/2) {
        tz(th) screw_and_washer(ex_screw, ex_screw_l);
        tz(-3) tnut(M4_tnut);
      }
    }
    tx(motor_hole_offset-(ew-th)/2) {
      rz(45) txz(ew, ew/2+th) {
        rx(-90) tz(th/2) {
          screw_and_washer(ex_screw, ex_screw_l);
          tz(-3-th) tnut(M4_tnut);
        }
      }
    }
  }

  tz(th) rz(45) {
    rz(180) NEMA_hole_positions(NEMA17_47, 3) {
      screw_washer(motor_screw, 10);
    }
    rz(90) NEMA_hole_positions(NEMA17_47, 1) { // washer_d > slot_w !
      screw(motor_screw, 10);
    }
  }
}

if ($preview) {
  tx(40) right_motor_assembly();
  tx(-40) left_motor_assembly();
}
