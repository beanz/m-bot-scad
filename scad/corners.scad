include <conf.scad>
include <lazy.scad>
include <shapes.scad>

//! The two larger (5mm) holes should be empty.

module right_back_top_corner_assembly()
    pose([102.6, 0, 40.4], [22.11, -38.5, -1.33])
    assembly("right_back_top_corner") {
  back_top_corner_assembly();
}

//! The two larger (5mm) holes should be empty.

module left_back_top_corner_assembly()
    pose([102.6, 0, 40.4], [30, -32.6, 1.45])
    assembly("left_back_top_corner") {
  mirror([1, 0, 0]) back_top_corner_assembly();
}

module back_top_corner_assembly() {
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

//! The two larger (5mm) holes should be empty.

module right_front_top_corner_assembly()
    pose([102.6, 0, 40.4], [30, -32.6, 1.45])
    assembly("right_front_top_corner") {
  front_top_corner_assemlby();
}

//! The two larger (5mm) holes should be empty.

module left_front_top_corner_assembly()
    pose([102.6, 0, 40.4], [30, -32.6, 1.45])
    assembly("left_front_top_corner") {
  mirror([1, 0, 0]) front_top_corner_assemlby();
}

module front_top_corner_assemlby() {
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

module side_top_corner_assembly()
    pose([115.9, 0, 16.6], [45.62, -143.77, -62.26])
    assembly("side_top_corner") {
  side_top_corner_stl();
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

module side_top_corner_stl() {
  stl("side_top_corner");
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

module bottom_corner_assembly()
    pose([104.7, 0, 162.9], [-49.59, -38, 24.86])
    assembly("bottom_corner") {
  bottom_corner_unit();
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

module reversed_bottom_corner_assembly()
    pose([104.7, 0, 162.9], [-49.59, -38, 24.86])
    assembly("reversed_bottom_corner") {
  mirror([0, 1, 0]) bottom_corner_unit();
}

if ($preview) {
  $explode = 1;
  //right_back_top_corner_assembly();
  //left_back_top_corner_assembly();
  //right_front_top_corner_assembly();
  //left_front_top_corner_assembly();
  //side_top_corner_assembly();
  //bottom_corner_assembly();
  reversed_bottom_corner_assembly();
}
