include <conf.scad>
include <lazy.scad>
include <shapes.scad>

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
