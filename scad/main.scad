//! D-Bot-style printer with MGN rails

include <conf.scad>
include <lazy.scad>

use <frame.scad>
use <electronics.scad>
use <x-axis.scad>
use <z-axis.scad>
use <vitamins/e3d-v6.scad>

clamp_h = e3d_clamp_h();
clamp_d = e3d_clamp_d();
clamp_top_h = e3d_clamp_part_h("top");
clamp_mid_h = e3d_clamp_part_h("middle");

//! Insert PSU

module main_assembly()
  pose([76.7, 0, 13.1], [6.53, -16.48, 139.66]) assembly("main") {
  duet_assembly();

  // add (heavy) PSU last
  txyz(-fw/2+psu_l/2+ew2+80, fd/2-th, ew2+psu_w/2+th) {
    explode([100, 0, 0], offset = [-psu_l/2, 0, 0]) {
      rx(90) psu(PSU_S_350);
    }
    psu_mount_screws(); // TOFIX cover mount screws?
  }
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
    tyz(-carriage_w(x_car)/2-th/2-0.1, carriage_total_h(x_car)/2-th/4) {
      tyz(-th*1.5-e3d_clamp_d()/2, -(x_car_h/2+hotend_offset)) {
        explode([0, -clamp_d*1.5, 0], true) {
          rz(90) e3d_v6_3mm_bowden();
          explode([0, -10, 0], true) {
            hotend_clamp_stl();
            tz(-e3d_height()) translate(probe_offset) probe(probe);
            ty(-e3d_clamp_d()/2-th) rx(90) probe_mount_stl();
            tyz(-(probe_washer_d(probe)/2+e3d_clamp_d()/2)+0.5,
               -(clamp_top_h+clamp_mid_h/2)) {
              w = screw_washer(car_screw);
              n = screw_nut(car_screw);
              myz(10) {
                rx(-90) {
                  screw_washer_up(car_screw,
                                  th*3+clamp_d+0.5+washer_h(w)+nut_h(n));
                  tz(th*3+clamp_d+0.5) explode([0, 0, 40]) washer(w);
                  tz(th*3+clamp_d+0.5) explode([0, 0, 45]) nut(n);
                }
              }
            }
          }
        }
      }
    }
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

module spool_rod_assembly()
  assembly("spool_rod") {
  tz(-sp_h/2-ew/2) studding(8, sp_h/2+ew*5, center = false);
  mxy(-sp_h/2-washer_h(M8_penny_washer)-nut_h(M8_nut)) {
    nut(M8_nut)
      washer(M8_penny_washer)
      washer(M8_washer)
      tz(washer_h(M8_penny_washer)+washer_h(M8_washer)) ball_bearing(BB608)
      washer(M8_washer)
      nut(M8_nut);
  }
}

module top_belt() {
  /* thr = th/2+belt_thickness(GT2x6); */
  /* bt = belt_thickness(GT2x6); */
  /* path = */
  /*   [[pos[0]-x_car_l/2,        pos[1]+y_rail_offset-20.5+bbr-th, 0], // carriage */
  /*    [pos[0]-x_car_l/2+th*2,   pos[1]+y_rail_offset-20.5+bbr-th, 0], // carriage */
  /*    [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr, bt/2], // carriage */
  /*    [-motor_x+pbr+bbr, pos[1]+y_rail_offset-20.5, -bbr-bt/2], // left */
  /*    [-motor_x, -fd/2+motor_offset+ew/2, pbr+bt/2], // front left */
  /*    [-(motor_x+pbr-bbr), fd/2-ew/2, bbr+bt/2], // rear left */
  /*    [motor_x+pbr-bbr, fd/2-ew/2, bbr+bt/2], // rear right */
  /*    [motor_x+pbr-bbr, pos[1]+y_rail_offset+20.5, bbr+bt/2], // right */
  /*    [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr, bt/2], // carriage */
  /*    [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr+th, 0], // front */
  /*    [pos[0]+th, pos[1]+y_rail_offset+20.5-bbr+th, 0], // middle */
  /* ]; */

  /* belt(GT2x6, path, gap = 100, gap_pt = [pos[0], pos[1]+y_rail_offset], */
  /*      belt_colour = top_belt_color); */

  mbelt(GT2x6,
        [[pos[0]-x_car_l/2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
         [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
         [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr], // carriage
         [-(motor_x-pbr), pos[1]+y_rail_offset-20.5+bbr], // left
         [-(motor_x-pbr), -fd/2+motor_offset+ew/2-pbr], // front left
         [-(motor_x+pbr), -fd/2+motor_offset+ew/2-pbr],
         [-(motor_x+pbr), fd/2-ew/2+bbr], // rear left
         [motor_x+pbr, fd/2-ew/2+bbr], // rear right
         [motor_x+pbr, pos[1]+y_rail_offset+20.5-bbr], // right
         [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr], // carriage
         [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr+th], // front
         [pos[0]+x_car_l/2, pos[1]+y_rail_offset+20.5-bbr+th], // middle
        ],
        bcolor = top_belt_color);
}

module bottom_belt() {
  mbelt(GT2x6,
        [
          [pos[0]+x_car_l/2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
          [pos[0]+x_car_l/2-th*2, pos[1]+y_rail_offset-20.5+bbr-th], // front
          [pos[0]+x_car_l/2-th*2, pos[1]+y_rail_offset-20.5+bbr], // rear
          [motor_x-pbr, pos[1]+y_rail_offset-20.5+bbr], // right
          [motor_x-pbr, -fd/2+motor_offset+ew/2-pbr], // front right
          [motor_x+pbr, -fd/2+motor_offset+ew/2-pbr],
          [motor_x+pbr, fd/2-ew/2+bbr], // rear right
          [-(motor_x+pbr), fd/2-ew/2+bbr], // rear left
          [-(motor_x+pbr), pos[1]+y_rail_offset+20.5-bbr], // left
          [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset+20.5-bbr], // carriage rear
          [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset+20.5-bbr+th], // front
          [pos[0]-th, pos[1]+y_rail_offset+20.5-bbr+th], // middle
        ],
        bcolor = bottom_belt_color);
}

function dist(p1, p2) = sqrt((p1[0]-p2[0])*(p1[0]-p2[0])+
                             (p1[1]-p2[1])*(p1[1]-p2[1]));
function pdist(p, i = 0, a = 0) =
  len(p) > i+1 ? pdist(p, i+1, a+dist(p[i], p[i+1])) : a;

module mbelt(type, path, bcolor = top_belt_color) {
  th = belt_thickness(type);
  h = belt_width(type);
  vitamin(str("BELT: GT2 ", pdist(path)));
  color(bcolor) {
    for (i = [0:len(path)-2]) {
      hull() {
        txy(path[i][0], path[i][1]) cylinder(d = th, h = h, center = true);
        txy(path[i+1][0], path[i+1][1]) cylinder(d = th, h = h, center = true);
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
  //spool_rod_assembly();
  //spool_holder_assembly();
}

