include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <common.scad>
use <idlers.scad>
use <x-axis.scad>
use <y-axis.scad>
use <z-axis.scad>
use <electronics.scad>
use <xy-motor.scad>
use <titan-mount.scad>

module right_end_with_z_carriage_rail_assembly()
    pose([59.5, 0, 314.5], [71.76, 71.11, 146.26])
    assembly("right_end_with_z_carriage_rail") {
  right_end_frame_assembly();
  txz(-ew/2, (ph-pos[2])+z_offset+ew*2) {
    z_carriage_rail_assembly();
  }
}

module left_end_with_z_carriage_rail_assembly()
    pose([57.4, 0, 35], [13.22, 116.53, 160.49])
    assembly("left_end_with_z_carriage_rail") {
  left_end_frame_assembly();
  txz(ew/2, (ph-pos[2])+z_offset+ew*2) {
    mirror([1, 0, 0]) z_carriage_rail_assembly();
  }
}

module right_end_frame_assembly()
    pose([59.2, 0, 307], [-114.19, -201.17, 107.06])
    assembly("right_end_frame") {
  explode([0, 0, -fh-50]) {
    right_front_upright_assembly();
  }
  txyz(-ew, -fd/2+ew/2, fh+th) {
    myz(ew/2) {
      screw(ex_tap_screw, 12);
    }
  }
  right_central_and_rear_assembly();
}

module left_end_frame_assembly()
    pose([60.6, 0, 40.8], [-89.82, -223.04, 49.42])
    assembly("left_end_frame") {
  explode([0, 0, -fh-50]) {
    left_front_upright_assembly();
  }
  txyz(ew, -fd/2+ew/2, fh+th) {
    myz(ew/2) {
      screw(ex_tap_screw, 12);
    }
  }
  left_central_and_rear_assembly();
}

module right_central_and_rear_assembly()
    pose([34.7, 0, 292.3], [53.05, 111.09, -113.35])
    assembly("right_central_and_rear") {
  explode([0, 0, -fh-50], offset = [-ew, fd/2-ew/2, fh/2]) {
    right_rear_upright_assembly();
  }
  right_central_end_assembly();
  txyz(-ew, fd/2-ew/2, fh+th) {
    myz(ew/2) {
      screw(ex_tap_screw, 12);
    }
  }
}

module left_central_and_rear_assembly()
    pose([59.2, 0, 211.1], [-99.86, 168.58, 89.53])
    assembly("left_central_and_rear") {
  explode([0, 0, -fh-50], offset = [ew, fd/2-ew/2, fh/2]) {
    left_rear_upright_assembly();
  }
  left_central_end_assembly();
  txyz(-th, fd/2-ew-iec_socket_cut_out_h()/2, ew2+psu_w/2+th) {
    explode([0, -50, 0], offset = [ew+th, 0, 0], true) {
      ry(-90) socket_mount_assembly();
    }
  }
  txyz(ew, fd/2-ew/2, fh+th) {
    myz(ew/2) {
      screw(ex_tap_screw, 12);
    }
  }
}

module right_central_end_assembly()
    pose([63.7, 0, 320.6], [-92.29, -25.31, 289.37])
    assembly("right_central_end") {
  right_lower_end_with_z_assembly();
  explode([0, fd*0.7, 0], offset = [0, 0, fh-ew2]) right_upper_end_assembly();
  txyz(-ew/2, -(fd/2-ew), y_bar_h-ew) {
    ry(90) cast_corner_bracket_assembly();
  }
}

module left_central_end_assembly()
    pose([65.8, 0, 114.8], [36.16, 78.88, 294.35])
    assembly("left_central_end") {
  left_lower_end_with_z_assembly();
  explode([0, fd*0.7, 0], offset = [0, 0, fh-ew2]) left_upper_end_assembly();
  txyz(ew/2, -(fd/2-ew), y_bar_h-ew) {
    ry(90) cast_corner_bracket_assembly();
  }
}

module right_upper_end_assembly()
    pose([53.2, 0, 319.4], [150.37, 200.95, 225.02])
    assembly("right_upper_end") {
  txz(-ew, y_bar_h) right_y_rail_assembly();
  txz(-ew/2, fh-ew/2) {
    rx(90) {
      extrusion(e2020, fd-ew*2);
    }
    if ($label) {
      tz(20) rz(90) label(str(fd-ew*2, "mm"));
    }
    mxz(fd/2-ew) {
      tz(-ew/2) {
        explode([0, 140, 0]) rz(180) ry(90) cast_corner_bracket_assembly();
      }
    }
  }
  mxz(fd/2) {
    tyz(-ew*1.5, fh-ew*1.75) ry(90) {
      explode([0, 180, 0]) {
        side_frame_top_corner_stl();
        tz(th) {
          for (j = [-1, 0, 1]) {
            ty(j*ew) {
              for (i = [-1, 0, 1]) {
                txz(i*ew*1.25, -eta/2) {
                  if (i != 0 || j == 1) {
                    screw(ex_print_screw, 10);
                    rz(j == 1 ? 90 : 0) tz(-7) tnut(M4_tnut);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  txyz(-ew/2, fd/2-ew/2, fh) explode([0, 180, 0]) back_top_corner_unit();
  txyz(-ew/2, -fd/2+ew/2, fh) explode([0, -180, 0]) front_top_corner_unit();

  tyz(-60, fh-ew/2) explode([0, -180, 0]) {
    ry(90) rx(-90) titan_mount_assembly();
  }
  tyz(60, fh-ew/2) explode([0, 180, 0]) {
    ry(90) rx(-90) titan_mount_assembly();
  }
}

module left_upper_end_assembly()
  pose([61.6, 0, 49.7], [-9.05, 20.89, 393.67]) assembly("left_upper_end") {
  txz(ew, y_bar_h) left_y_rail_assembly();
  txz(ew/2, fh-ew/2) {
    rx(90) {
      extrusion(e2020, fd-ew*2);
    }
    if ($label) {
      tz(20) rz(90) label(str(fd-ew*2, "mm"));
    }
    mxz(fd/2-ew) {
      tz(-ew/2) {
        explode([0, 50, 0]) rz(180) ry(90) cast_corner_bracket_assembly();
      }
    }
  }
  mirror([1,0,0]) {
    mxz(fd/2) {
      tyz(-ew*1.5, fh-ew*1.75) ry(90) {
        explode([0, 90, 0]) {
          side_frame_top_corner_stl();
          tz(th) {
            for (j = [-1, 0, 1]) {
              ty(j*ew) {
                for (i = [-1, 0, 1]) {
                  txz(i*ew*1.25, -eta/2) {
                    if (i != 0 || j == 1) {
                      screw(ex_print_screw, 10);
                      rz(j == 1 ? 90 : 0) tz(-7) tnut(M4_tnut);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    txyz(-ew/2, fd/2-ew/2, fh) {
      explode([0, 140, 0]) back_top_corner_unit();
    }
    txyz(-ew/2, -fd/2+ew/2, fh) {
      explode([0, -140, 0]) front_top_corner_unit();
    }
  }
}

module right_lower_end_with_z_assembly()
    pose([63.7, 0, 218.8], [-51.59, -28.97, 194.08])
    assembly("right_lower_end_with_z") {
  right_lower_end_assembly();
  explode([0, -fw*0.4, 0], offset = [0, 0, ew]) {
    tx(-ew) right_z_axis_rail_assembly();
  }
  txyz(-ew/2, -fd/2+ew, ew2) {
    explode([0, -140, 0], offset = [0, -10, 10]) {
      ry(-90) cast_corner_bracket_assembly();
    }
  }
  tz(ew) {
    ty(fd/2-ew) {
      explode([0, 40, 0]) ry(90) bottom_corner_unit();
    }
    ty(-(fd/2-ew)) {
      explode([0, -fd/2+20, 0]) ry(90) mirror([0, 1, 0]) bottom_corner_unit();
    }
  }
}

module left_lower_end_with_z_assembly()
    pose([68.6, 0, 37.1], [142.98, -245.36, 194.7])
    assembly("left_lower_end_with_z") {
  left_lower_end_assembly();
  explode([0, -fw*0.4, 0], offset = [0, 0, ew]) {
    tx(ew) left_z_axis_rail_assembly();
    txyz(ew/2, -fd/2+ew, ew2) {
      explode([0, 100, 0], offset = [0, -10, 10]) {
        ry(-90) cast_corner_bracket_assembly();
      }
    }
  }
  tz(ew) {
    ty(fd/2-ew) {
      explode([0, 40, 0]) ry(-90) mirror([1,0,0]) bottom_corner_unit();
    }
    ty(-(fd/2-ew)) {
      explode([0, -fd/2-60, 0]) rz(180) ry(90) bottom_corner_unit();
    }
  }
}

//! The position of the motor mount is not crucial but the design has it
//! centered 80mm from the center. The rail guard should be positioned
//! at the centre.

module right_lower_end_assembly()
    pose([48.3, 0, 134.4], [93.95, 188.8, 194.16])
    assembly("right_lower_end") {
  lower_end_assembly();
}

//! The position of the motor mount is not crucial but the design has it
//! centered 80mm from the center. The rail guard should be positioned
//! at the centre.

module left_lower_end_assembly()
    pose([49.7, 0, 142.1], [113.75, 206.43, 164.43])
    assembly("left_lower_end") {
  mirror([1, 0, 0]) lower_end_assembly();
}

module lower_end_assembly() {
  tx(-ew/2) {
    tz(ew2/2) {
      rx(90) {
        extrusion(e2040, fd-ew*2);
      }
      if ($label) {
        txz(40, 20) rz(90) label(str(fd-ew*2, "mm"));
      }
      tz(ew) {
        ty(fd/2-ew) {
          explode([0, 140, 0], offset = [0, -10, 10]) {
            rz(180) ry(-90) cast_corner_bracket_assembly();
          }
        }
      }
    }
    explode([0, 180, 0]) z_motor_mount_assembly();
    txz(-ew, ew*1.5) explode([0, fd/2+10, 0]) ry(90) rail_guard_assembly();
  }

  tx(-ew) {
    ty(fd/2-ew) {
      tz(ew/2) rz(180) {
        explode([0, -140, 0]) milled_corner_bracket_assembly();
      }
    }
    ty(-(fd/2-ew)) {
      tz(ew/2) {
        explode([0, -40, 0]) rx(180) rz(180) milled_corner_bracket_assembly();
      }
    }
  }
}

//! Items should be slid into place as shown. The idler will need to
//! be slid down temporarily to allow the hidden corner bracket grub
//! screw to be tightened.

module right_rear_upright_assembly()
    pose([44.5, 0, 14.2], [40.56, 242.73, 179.62])
    assembly("right_rear_upright") {
  ty(fd/2) {
    // corner upright
    txy(-ew2/2, -ew/2) {
      rz(90) {
        extrusion(e2040, fh, center = false);
      }
      txz(-ew2/2, ew2) explode([0, 0, -80]) {
        rz(180) rx(90) cast_corner_bracket_assembly();
      }
      tz(-th*2) explode([0, 0, -120], true) {
        foot_stl();
        tz(th) myz(ew/2) screw_up(foot_screw, 12);
      }
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) explode([0, 0, -110]) {
      mirror([1, 0, 0]) rz(90) ry(90) bottom_corner_unit();
    }
    sz = fh/2;
    rod_z = spool_hub_bore(sp)/2-ball_bearing_od(BB608)/2;
    ty(-ew) {
      txz(-ew2/2, sz+rod_z) {
        rx(90) {
          explode([0, fh/2+20, 0]) {
            spool_rod_holder_stl();
            myz(10) mxz(ew-screw_clearance_d(ex_screw)-th/2) {
              tz(th) screw_washer(ex_screw, 10);
              tz(-3) tnut(M4_tnut);
            }
          }
        }
      }
    }
  }
  txyz(-ew2, fd/2-ew/2, fh-ew2/2-ew) {
    explode([0, 0, 140], offset = [0, 0, -20]) {
      ry(90) rx(-90) inside_hidden_corner_bracket();
    }
  }
  txyz(-ew*2-motor_hole_offset+ew/2+pbr-bbr, fd/2-ew/2, y_bar_h) {
    explode([0, 0, 80]) back_right_idler_assembly();
  }
}

//! Items should be slid into place as shown. The idler will need to
//! be slide down temporarily to allow the hidden corner bracket grub
//! screw to be tightened. The extra t-nuts are for the IEC socket mount
//! that is attached later.

module left_rear_upright_assembly()
    pose([44.5, 0, 14.2], [40.56, 242.73, 179.62])
    assembly("left_rear_upright") {
  mirror([1, 0, 0]) ty(fd/2) {
    // corner upright
    txy(-ew2/2, -ew/2) {
      rz(90) {
        extrusion(e2040, fh, center = false);
      }
      txz(-ew2/2, ew2) explode([0, 0, -80]) {
        rz(180) rx(90) cast_corner_bracket_assembly();
      }
      tz(-th*2) explode([0, 0, -120], true) {
        foot_stl();
        tz(th) myz(ew/2) screw_up(foot_screw, 12);
      }
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) explode([0, 0, -110]) {
      mirror([1,0,0]) rz(90) ry(90) bottom_corner_unit();
    }
  }
  txyz(ew2, fd/2-ew/2, fh-ew2/2-ew) {
    explode([0, 0, 200], offset = [0, 0, -20]) {
      rz(180) ry(90) rx(-90) inside_hidden_corner_bracket();
    }
  }
  txyz(-(-ew*2-motor_hole_offset+ew/2+pbr-bbr), fd/2-ew/2, y_bar_h) {
    explode([0, 0, 140]) back_left_idler_assembly();
  }
  txyz(-th, fd/2-ew-iec_socket_cut_out_h()/2, ew2+psu_w/2+th) {
    explode([0, 0, fh-70], offset = [25, 0, 0]) {
      ry(-90) socket_mount_preassembly();
    }
  }
}

module right_front_upright_assembly()
  pose([71.8, 0, 131.1], [124.79, -49.3, 201.78])
  assembly("right_front_upright") {
  ty(-fd/2) {
    // corner upright
    txy(-ew2/2, ew/2) {
      rz(90) {
        extrusion(e2040, fh, center = false);
      }
      txz(-ew2/2, ew2) explode([0, 0, -80]) {
        rz(180) rx(90) cast_corner_bracket_assembly();
      }
      tz(-th*2) explode([0, 0, -120], true) {
        foot_stl();
        tz(th) myz(ew/2) screw_up(foot_screw, 12);
      }
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) explode([0,0,-110]) rz(-90) ry(90) bottom_corner_unit();
    sz = fh/2;
    rod_z = spool_hub_bore(sp)/2-ball_bearing_od(BB608)/2;
    ty(ew) {
      txz(-ew2/2, sz+rod_z) {
        rx(-90) {
          explode([0, -fh/2-20, 0]) {
            spool_rod_holder_stl();
            myz(10) mxz(ew-screw_clearance_d(ex_screw)-th/2) {
              tz(th) screw_washer(ex_screw, 10);
              tz(-3) tnut(M4_tnut);
            }
          }
        }
      }
    }
  }
}

module left_front_upright_assembly()
  pose([71.8, 0, 131.10], [128.04, -53.03, 201.78])
  assembly("left_front_upright") {
  ty(-fd/2) rz(180) {
    // corner upright
    txy(-ew2/2, -ew/2) {
      rz(90) {
        extrusion(e2040, fh, center = false);
      }
      txz(-ew2/2, ew2) explode([0, 0, -80]) {
        rz(180) rx(90) cast_corner_bracket_assembly();
      }
      tz(-th*2) explode([0, 0, -120]) {
        foot_stl();
        tz(th) myz(ew/2) screw_up(foot_screw, 12);
      }
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) mirror([1,0,0]) explode([0, 0, -110]) {
      rz(90) ry(90) bottom_corner_unit();
    }
  }
}

module lower_back_frame_assembly()
  pose([82.3, 0, 308], [-199.39, -120.66, 90.82]) assembly("lower_back_frame") {
  lower_back_frame_unit();
  txyz(-fw/2+psu_l/2+ew2+80, th-ew/2, ew2+psu_w/2+th) {
    psu_mount_assembly();
  }
}

module lower_back_frame_unit() {
  tyz(-ew/2, ew2/2) {
    ry(90) rz(90) extrusion(e2040, fw-ew*4);
    if ($label) {
      tz(40) label(str(fw-ew*4, "mm"));
    }
  }
}

module xy_combined_assembly()
  pose([83.7, 0, 36.9], [-175.28, 151.92, 355.94]) assembly("xy_combined") {
  txyz(pos[0], pos[1]+y_rail_offset, x_bar_h) {
    x_axis_assembly();
  }
  txyz(-(fw/2-ew*1.5), pos[1]+y_rail_offset, y_bar_h) {
    explode([-50, 0, 0], offset = [0, 0, -ew/2]) {
      left_y_carriage_assembly();
    }
  }
  txyz(fw/2-ew*1.5, pos[1]+y_rail_offset, y_bar_h) {
    explode([50, 0, 0], offset = [-50, 0, -ew/2]) {
      right_y_carriage_assembly();
    }
  }
}

module xy_combined_assembly_with_fixings() {
  xy_combined_assembly();
  tyz(pos[1]+y_rail_offset, y_bar_h) myz(fw/2-ew*1.5) y_carriage_screws();
}

//! Loosen the t-nuts at either end of the z carriage extrusion and slide
//! one end in then the other.

module frame_with_bed_assembly()
  pose([67.9, 0, 25.2], [51.78, -1.41, 223.77])
  assembly("frame_with_bed") {

  frame_with_x_rail_assembly();
  explode([0, 0, -20]) z_axis_assembly();
}

module frame_with_x_rail_assembly()
    pose([68.6, 0, 31.5], [30.37, -8.04, 221.51])
    assembly("frame_with_x_rail") {
  frame_assembly();
  explode([0, 0, 100], true) xy_combined_assembly_with_fixings();
}

module frame_assembly()
    pose([67.9, 0, 24.3], [-1.52, 42.48, 200.56])
    assembly("frame") {
  tx(fw/2) explode([60, 0, 0]) right_end_with_z_carriage_rail_assembly();
  tx(-fw/2) explode([-60, 0, 0]) left_end_with_z_carriage_rail_assembly();

  ty(fd/2) {
    lower_back_frame_assembly();

    // upper back
    tyz(-ew/2, fh-ew2/2) {
      ry(90) rz(90) extrusion(e2040, fw-ew*4);
      if ($label) {
        tz(40) label(str(fw-ew*4, "mm"));
      }
    }
  }

  // lower front
  ty(-fd/2) {
    mirror([0,1,0]) {
      // mirror is safe as all components in unit are symmetrical
      lower_back_frame_unit();
    }
  }

  // optional front extrusion
  *color("green") tyz(-(fd/2-ew/2), motor_z-th-ew/2) {
    ry(90) extrusion(e2020, fw-ew*4);
    myz(fw/2-ew2) {
      txz(0, -ew/2) rz(90) ry(90) cast_corner_bracket_assembly();
    }
  }

}

module back_top_corner_unit() {
  back_top_corner_stl();
  for (p = [[0,0], [0,1], [0,2], [1,0], [2,0]]) {
    txyz(-p[0]*ew, -p[1]*ew, th) {
      if (!(p[1] == 0 && p[0] < 2)) {
        screw(ex_print_screw, 10);
        rz(p[1] == 0 ? 90 : 0) tz(-7) tnut(M4_tnut);
      }
    }
  }
}

module back_top_corner_stl() {
  stl("back_top_corner");
  color(print_color) render() {
    difference() {
      union() {
        ty(-ew) rrcf([ew, ew*3, th], r = 5);
        tx(-ew) rrcf([ew*3, ew, th], r = 5);
      }
      for (p = [[0,0], [0,1], [0,2], [1,0], [2,0]]) {
        txyz(-p[0]*ew, -p[1]*ew, -eta/2) {
          if (p[1] == 0 && p[0] < 2) {
            cylinder(d = screw_clearance_d(ex_tap_screw), h = th+eta);
          } else {
            cylinder(d = screw_clearance_d(ex_print_screw), h = th+eta);
          }
        }
      }
    }
  }
}

module front_top_corner_unit() {
  front_top_corner_stl();
  for (p = [[0,0], [0,1], [0,2], [1,0]]) {
    txyz(-p[0]*ew, p[1]*ew, th) {
      if (!(p[1] == 0 && p[0] < 2)) {
        screw(ex_print_screw, 10);
        rz(p[1] == 0 ? 90 : 0) tz(-7) tnut(M4_tnut);
      }
    }
  }
}

module front_top_corner_stl() {
  stl("front_top_corner");
  color(print_color) render() {
    difference() {
      union() {
        ty(ew) rrcf([ew, ew*3, th], r = 5);
        tx(-ew/2) rrcf([ew*2, ew, th], r = 5);
      }
      for (p = [[0,0], [0,1], [0,2], [1,0]]) {
        txyz(-p[0]*ew, p[1]*ew, -eta/2) {
          if (p[1] == 0 && p[0] < 2) {
            cylinder(d = screw_clearance_d(ex_tap_screw), h = th+eta);
          } else {
            cylinder(d = screw_clearance_d(ex_print_screw), h = th+eta);
          }
        }
      }
    }
  }
}

module side_frame_top_corner_stl() {
  stl("side_frame_top_corner");
  color(print_color) render() {
    difference() {
      union() {
        ty(ew) rrcf([ew*3.5, ew, th]);
        myz(ew*1.25) {
          rrcf([ew, ew*3, th]);
        }
      }
      for (j = [-1, 0, 1]) {
        ty(j*ew) {
          for (i = [-1, 0, 1]) {
            txz(i*ew*1.25, -eta/2) {
              if (i != 0 || j == 1) {
                cylinder(d = screw_clearance_d(ex_screw), h = th+eta);
              }
            }
          }
        }
      }
    }
  }
}

module bottom_corner_stl() {
  stl("bottom_corner");
  color(print_color) render() {
    difference() {
      hull() {
        txy(-ew/2, ew/2) rrcf([ew*3, ew, th], r = 5);
        rrcf([ew*2, ew*2, th], r = 5);
      }
      for (j = [0, 1]) {
        ty(j*ew-ew/2) {
          for (i = [-1, 0, 1]) {
            txz(i*ew-ew/2, -eta/2) {
              if (i != -1 || j == 1) {
                cylinder(d = screw_clearance_d(ex_screw), h = th+eta);
              }
            }
          }
        }
      }
    }
  }
}

module bottom_corner_unit() {
  bottom_corner_stl();
  tz(th) {
    for (j = [0, 1]) {
      ty(j*ew-ew/2) {
        for (i = [-1, 0, 1]) {
          txz(i*ew-ew/2, -eta/2) {
            if (i != -1 || j == 1) {
              screw(ex_print_screw, 10);
              rz(j == 0 ? 0 : 90) tz(-7) tnut(M4_tnut);
            }
          }
        }
      }
    }
  }
}

module rail_guard_stl() {
  stl("rail_guard");
  color(print_color) render() {
    difference() {
      rcc([ew, ew, rail_height(z_rail)]);
      tz(-eta/2) {
        cylinder(d = screw_clearance_d(ex_screw), h = rail_height(z_rail)+eta);
      }
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

module foot_stl() {
  stl("foot");
  color(flex_print_color) render() {
    difference() {
      rcc([40, 20, th*2]);
      myz(10) {
        tz(-eta) {
          cylinder(d = screw_clearance_d(foot_screw), h = th*3);
          cylinder(d = screw_head_d(foot_screw)*1.1, h = th);
        }
      }
    }
  }
}

module spool_rod_holder_stl() {
  stl("spool_rod_holder");
  color(print_color) render() {
    linear_extrude(th) {
      difference() {
        square([ew2, ew*2], center = true);
        myz(10) mxz(ew-screw_clearance_d(ex_screw)-th/2) {
          circle(d = screw_clearance_d(ex_screw));
        }
      }
    }
    tz(th*3) {
      ry(90) {
        h = (ew-nut_h(M8_nut)-washer_h(M8_washer))*2;
        tz(-h/2) linear_extrude(h) {
          difference() {
            union() {
              circle(r = 8/2+th);
              // narrower to allow for washers on extrusion mounting screws
              tx((8/2+th*2)/2) square([8/2+th*2, 8+th*1.75], center = true);
            }
            circle(r = 8/2+0.5);
          }
        }
      }
    }
  }
}

if ($preview) {
  $explode = 1;
  //frame_assembly();
  //frame_with_bed_assembly();
  //frame_with_x_rail_assembly();
  //left_central_and_rear_assembly();
  //left_central_end_assembly();
  //left_end_frame_assembly();
  //left_end_with_z_carriage_rail_assembly();
  //left_front_upright_assembly();
  //left_lower_end_assembly();
  //left_lower_end_with_z_assembly();
  //left_rear_upright_assembly();
  //left_upper_end_assembly();
  //lower_back_frame_assembly();
  //rail_guard_assembly();
  //right_central_and_rear_assembly();
  //right_central_end_assembly();
  //right_end_frame_assembly();
  //right_end_with_z_carriage_rail_assembly();
  //right_front_upright_assembly();
  //right_lower_end_assembly();
  //right_lower_end_with_z_assembly();
  //right_rear_upright_assembly();
  right_upper_end_assembly();
  //xy_combined_assembly();
}
