include <conf.scad>
include <lazy.scad>
include <shapes.scad>

use <common.scad>
use <corners.scad>
use <feet.scad>
use <idlers.scad>
use <spool-holder.scad>

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
      tz(-th*2) explode([0, 0, -120], true) foot_assembly();
    }
    txz(-ew2, ew) explode([0,0,-110]) rz(-90) ry(90) bottom_corner_assembly();
    tx(-ew2) rz(180) spool_holder_assembly();
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
      tz(-th*2) explode([0, 0, -120], true) foot_assembly();
    }
    txz(-ew2, ew) explode([0, 0, -110]) {
      rz(90) ry(90) reversed_bottom_corner_assembly();
    }
    spool_holder_assembly();
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
