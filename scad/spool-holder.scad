include <conf.scad>
include <lazy.scad>
include <shapes.scad>

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

module spool_rod_assembly()
    pose([84.4, 0, 39], [182.87, -111.36, -20.4])
    assembly("spool_rod") {
  tz(-sp_h/2-ew/2) studding(8, sp_h/2+ew*5, center = false);
  explode([0, 0, -100], true) {
    mxy(-sp_h/2-washer_h(M8_penny_washer)-nut_h(M8_nut)) {
      explode([0, 0, -15], true)
      nut(M8_nut)
        explode([0, 0, 5], true) washer(M8_penny_washer)
        explode([0, 0, 5], true) washer(M8_washer)
        tz(washer_h(M8_penny_washer)+washer_h(M8_washer))
        explode([0, 0, 5], true) ball_bearing(BB608)
        explode([0, 0, 5], true) washer(M8_washer)
        explode([0, 0, 5]) nut(M8_nut);
    }
  }
}

module spool_holder_assembly() {
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

if ($preview) {
  $explode = 1;
  spool_rod_assembly();
  //spool_holder_assembly();
  //spool_rod_holder_stl();
}
