include <conf.scad>
include <lazy.scad>
include <shapes.scad>

use <common.scad>
use <corners.scad>
use <electronics.scad>
use <idlers.scad>
use <feet.scad>

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
      tz(-th*2) explode([0, 0, -120]) foot_assembly();
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) mirror([1,0,0]) explode([0, 0, -110]) {
      rz(90) ry(90) bottom_corner_assembly();
    }
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
      tz(-th*2) explode([0, 0, -120], true) foot_assembly();
      if ($label) {
        txz(20, fh/2) ry(90) label(str(fh, "mm"));
      }
    }
    txz(-ew2, ew) explode([0, 0, -110]) {
      mirror([1,0,0]) rz(90) ry(90) bottom_corner_assembly();
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
