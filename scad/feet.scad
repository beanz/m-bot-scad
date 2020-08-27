include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module foot_assembly() {
  foot_stl();
  tz(th) myz(ew/2) screw_up(foot_screw, 12);
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
