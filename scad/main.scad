//! D-Bot-style printer with MGN rails

include <conf.scad>
include <lazy.scad>

use <frame.scad>
use <electronics.scad>
use <x-axis.scad>
use <z-axis.scad>
use <spool-holder.scad>
use <belts.scad>
use <vitamins/e3d-v6.scad>
use <x-carriage.scad>

clamp_h = e3d_clamp_h();
clamp_d = e3d_clamp_d();
clamp_top_h = e3d_clamp_part_h("top");
clamp_mid_h = e3d_clamp_part_h("middle");

//! Insert PSU

module main_assembly()
  pose([76.7, 0, 13.1], [6.53, -16.48, 139.66]) assembly("main") {
  duet_assembly();

  // add (heavy) PSU last
  psu_subassembly();
}

module duet_assembly()
  pose([52.9, 0, 325.5], [-214.28, -39.79, 69.45]) assembly("duet") {
  socket_assembly();

  w = screw_washer(pcb_mount_screw);
  n = screw_nut(pcb_mount_screw);
  txyz(-fw/2+ew+th+duet_standoff_h, -125/2-ew*1.5, ew*1.5) {
    ry(-90) {
      tx(duet_mount_w/2-ew/2) {
        tx(duet_clearance) {
          tz(duet_standoff_h+th) {
            explode([0, 0, 50], true) {
              rz(90) {
                duet_wifi();
                tz(duet_th) {
                  duet_wifi_mount_holes() {
                  screw_washer(pcb_mount_screw, duet_standoff_h+th+duet_th);
                  }
                }
              }
            }
          }
          tz(-washer_h(w)) {
            rz(90) {
              duet_wifi_mount_holes() {
                explode([0, 0, -5], true) {
                  washer(w);
                  tz(-washer_h(w)-nut_h(n)) {
                    explode([0, 0, -5], true) {
                      nut(n);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

module socket_assembly()
  pose([76, 0, 335.3], [-284.47, 137.84, 109.14]) assembly("socket") {
  belts_assembly();

  txyz(-fw/2-th, fd/2-ew-iec_socket_cut_out_h()/2, ew2+psu_w/2+th) {
    explode([-60, 0, 0], offset = [20, 0, 0], true) {
      ry(-90) {
        iec_socket();
        tz(2.5) mxz(39.75/2) {
          screw(M3_cs_cap_screw, 6);
        }
      }
    }
  }
}

module belts_assembly()
  pose([81.6, 0, 38.3], [-25.88, 36.46, 233.69]) assembly("belts") {
  hotend_assembly();
  explode([0, 0, +100]) {
    tz(y_bar_h + top_belt_h) top_belt();
    tz(y_bar_h + bottom_belt_h) bottom_belt();
  }
}

module hotend_assembly()
  pose([68.3, 0, 317.8], [-5.49, -159.36, 344.71]) assembly("hotend") {
  frame_with_z_motor_assembly();
  txyz(pos[0], pos[1]+y_rail_offset, x_bar_h) {
    hotend_subassembly();
    explode([0, 0, -30], offset = [0, 0, -25]) duct_assembly();
  }
}

module frame_with_z_motor_assembly()
    pose([68.3, 0, 317.8], [-5.49, -159.36, 344.71])
    assembly("frame_with_z_motor") {
  frame_with_spool_holder_assembly();
  tz(ew2) myz(fw/2-ew/2) {
    txy(-z_shaft_offset+ew/2, 80) {
      z_motor_assembly();
      tz(5) {
        NEMA_hole_positions(NEMA17, 4) {
          screw_washer(motor_screw, 10);
        }
      }
    }
  }
}

module frame_with_spool_holder_assembly()
    pose([73.2, 0, 337.1], [151.43, 118.31, 167.12])
    assembly("frame_with_spool_holder") {
  frame_with_bed_assembly();
  mxz(-(fd/2-ew)) {
    txz(fw/2-ew2/2, sz+rod_z) {
      rx(-90) {
        tz(th*3) {
          h = (ew-nut_h(M8_nut)-washer_h(M8_washer))*2;
          explode([-60, 0, 0], offset = [-20, 0, 0]) {
            tx(-h/2) {
              rz(180) ry(90) {
                washer(M8_washer)
                  nut(M8_nut);
              }
            }
          }
          tx(h/2) {
            ry(90) {
              washer(M8_washer)
                nut(M8_nut);
            }
          }
        }
      }
    }
  }

  sx = fw/2+sp_h/2+th*2;
  sy = fd/2-ew-th*3;
  sz = fh/2;
  rod_z = spool_hub_bore(sp)/2-ball_bearing_od(BB608)/2;
  txz(sx, sz) {
    ty(-sy) {
      explode([60, 0, 0], true) {
        tz(rod_z) {
          ry(-90) spool_rod_assembly();
        }
        explode([80, 0, 20], offset = [0, 0, 22]) {
          ry(90) {
            spool(sp,
                  filament_depth = spool_depth(sp)/2, filament_d = 1.75,
                  filament_colour = "red");
          }
        }
      }
    }
    ty(sy) {
      explode([60, 0, 0], true) {
        tz(rod_z) {
          ry(-90) spool_rod_assembly();
        }
        explode([80, 0, 20], offset = [0, 0, 22]) {
          ry(90) {
            spool(sp,
                  filament_depth = spool_depth(sp)/2, filament_d = 1.75,
                  filament_colour = "blue");
          }
        }
      }
    }
  }
}

if ($preview) {
  $explode = 0;
  main_assembly();
  //duet_assembly();
  //socket_assembly();
  //belts_assembly();
  //hotend_assembly();
  //frame_with_z_motor_assembly();
  //frame_with_spool_holder_assembly();
}

