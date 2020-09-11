include <conf.scad>
include <lazy.scad>
include <shapes.scad>

use <vitamins/e3d-v6.scad>
include <vitamins/probe.scad>
include <NopSCADlib/vitamins/blowers.scad>

clamp_h = e3d_clamp_h();
clamp_d = e3d_clamp_d();
clamp_top_h = e3d_clamp_part_h("top");
clamp_mid_h = e3d_clamp_part_h("middle");

belt_clamp_offset = belt_h/2+th/2+screw_clearance_d(car_screw)/2;
nut_trap_d = nut_flats_d(screw_nut(car_screw))*1.1;

module x_carriage_assembly()
    pose([119.4, 0, 47.4], [-17.81, -11.44, 10.81])
    assembly("x_carriage") {

  // bottom
  rx(180) tz(ew/2+th/2) x_carriage_mount_stl();

  // front
  explode([0, -5, 0], true) {
    tyz(-carriage_w(x_car)/2-th/2, carriage_total_h(x_car)/2-th/4) {
      x_carriage_front_assembly();
    }
  }

  // rear
  explode([0, 5, 0], true) {
    tyz(carriage_w(x_car)/2+th/2, carriage_total_h(x_car)/2-th/4) {
      x_carriage_rear_assembly();
    }
    ty((carriage_w(x_car)+th*2)/2) {
      myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
        tz(-(ew/2+th/2+(screw_clearance_d(car_screw)+th)/2)) {
          w = screw_washer(car_screw);
          n = screw_nut(car_screw);
          explode([0, 5, 0], true) {
            rx(-90) washer(w);
          }
          explode([0, 10, 0], true) {
            rx(-90) tz(washer_h(w)) nut(n);
          }
        }
      }
    }
  }

  ty(-(carriage_w(x_car)+th*2)/2) {
    myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
      tz(-(ew/2+th/2+(screw_clearance_d(car_screw)+th)/2)) {
        explode([0, -5, 0], true) {
          w = screw_washer(car_screw);
          n = screw_nut(car_screw);
          rx(90) {
            screw_washer(car_screw,
                         carriage_w(x_car)+th*2+nut_h(n)+washer_h(w)+0.5);
          }
        }
      }
    }
  }
}

module x_carriage_front_assembly()
  pose([73.2, 0, 34.8], [-11.92, 4.27, -8.99]) assembly("x_carriage_front") {
  x_carriage_front_stl();
  n = screw_nut(car_screw);
  txyz(-x_car_l/2+th, -th*1.5, -top_belt_h-ew/4) rx(-90) {
    explode([0, 0, -5], true) {
      belt_clamp_stl();
      mxz(belt_clamp_offset) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_clamp_offset) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
  txyz(x_car_l/2-th, -th*1.5, bottom_belt_h+ew/4) rx(-90) {
    explode([0, 0, -5], true) {
      belt_clamp_cut_stl();
      mxz(belt_clamp_offset) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_clamp_offset) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
  rx(-90) tz(-th*1.5) {
    explode([0, 0, -5], true) {
      hotend_mount_stl();
      explode([0, 0, -5], true) {
        hotend_mount_positions() {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    explode([0, 0, 10], true) {
      hotend_mount_positions() {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
}

module x_carriage_rear_assembly()
  pose([66.2, 0, 301.0], [-177.92, -110.93, 91.54]) assembly("x_carriage_rear") {
  x_carriage_rear_stl();
  n = screw_nut(car_screw);
  txz(-carriage_l(x_car)/2, carriage_total_h(x_car)/2+microswitch_l(ms)/2) {
    explode([0, -10, 0]) txy(-19, -2) rz(90) ry(-90) microswitch(ms);
    explode([0, 5, 0], true) {
      ty(th) x_endstop_mount_stl();
      txy(-19, th+2+0.5) {
        rz(90) ry(-90) microswitch_hole_positions(ms) {
          screw_washer_up(microswitch_screw, 2+th+microswitch_d(ms));
        }
      }
    }
  }

  // bottom endstop mount screw
  tx(-carriage_l(x_car)/2+screw_clearance_d(car_screw)+th/8) {
    ty(th*1.5) {
      explode([0, 10, 0], true) {
        rx(-90) rz(30) screw_washer(car_screw, th*1.3+nut_h(n));
      }
    }
    ty(-th*0.3) {
      explode([0, -5, 0], true) {
        rx(-90) rz(30) nut(screw_nut(car_screw));
      }
    }
  }

  // upper belt clamp
  txyz(x_car_l/2-th, th*1.5, -top_belt_h-ew/4) rx(90) {
    explode([0, 0, -5], true) {
      belt_clamp_stl();
      mxz(belt_clamp_offset) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_clamp_offset) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }

  // lower belt clamp
  txyz(-x_car_l/2+th*3, th*1.5, bottom_belt_h+ew/4) rx(90) {
    explode([0, 0, -5], true) {
      belt_clamp_stl();
      mxz(belt_clamp_offset) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_clamp_offset) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
}

module belt_clamp_holes(offset = th) {
  tx(-th*2) square([2, belt_h+2], center = true);
  tx(-th*2+offset) mxz(belt_clamp_offset) {
    circle(d = screw_clearance_d(car_screw));
  }
}

module belt_clamp_half_holes(offset = th) {
  tx(-th) square([th*2+eta, belt_h+2], center = true);
  tx(-th*2+offset) mxz(belt_clamp_offset) {
    rz(30) circle(d = nut_trap_d, $fn=6);
  }
}

module x_carriage_front_stl() {
  stl("x_carriage_front");
  rx(-90) color(print_color) {
    linear_extrude(th, center = true) {
      difference() {
        rounded_square([x_car_l, x_car_h], r = 1.5, center = true);
        mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
          myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
            circle(d = screw_clearance_d(car_screw));
          }
        }
        // bottom belt attachment and clamp
        txy(x_car_l/2, -bottom_belt_h-ew/4) belt_clamp_half_holes();

        // top belt attachment and clamp
        txy(-x_car_l/2, -top_belt_h-ew/4) mirror([1, 0, 0])
          belt_clamp_half_holes();

        // hotend mounting
        hotend_mount_positions() rz(30) circle(d = nut_trap_d, $fn=6);
      }
    }
    linear_extrude(th/2) {
      difference() {
        rounded_square([x_car_l, x_car_h], r = 1.5, center = true);
        mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
          myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
            circle(d = screw_clearance_d(car_screw));
          }
        }
        // bottom belt attachment and clamp
        txy(x_car_l/2, -bottom_belt_h-ew/4) belt_clamp_holes();

        // top belt attachment and clamp
        txy(-x_car_l/2, -top_belt_h-ew/4) mirror([1, 0, 0])
          belt_clamp_holes();

        // hotend mounting
        hotend_mount_positions() rz(30)
          circle(d = screw_clearance_d(car_screw));
      }
    }
  }
}

module x_carriage_rear_stl() {
  stl("x_carriage_rear");
  rx(-90) mirror([0, 0, 1]) color(print_color) {
    linear_extrude(th, center = true) {
      difference() {
        rounded_square([x_car_l, x_car_h], r = 1.5, center = true);
        mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
          myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
            circle(d = screw_clearance_d(car_screw));
          }
        }

        // endstop mount nut trap
        tx(-(x_car_l-screw_clearance_d(car_screw)-th)/2) {
          rz(30) circle(d = nut_trap_d, $fn = 6);
        }

        // bottom belt attachment and clamp
        txy(-x_car_l/2, -bottom_belt_h-ew/4) mirror([1, 0, 0])
          belt_clamp_half_holes(-th);

        // top belt attachment and clamp
        txy(x_car_l/2, -top_belt_h-ew/4) belt_clamp_half_holes();
      }
    }
    mirror([0, 0, 1]) linear_extrude(th/2) {
      difference() {
        rounded_square([x_car_l, x_car_h], r = 1.5, center = true);
        mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
          myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
            circle(d = screw_clearance_d(car_screw));
          }
        }
        // endstop mounting hole
        tx(-(x_car_l-screw_clearance_d(car_screw)-th)/2) {
          circle(d = screw_clearance_d(car_screw));
        }

        // bottom belt attachment and clamp
        txy(-x_car_l/2, -bottom_belt_h-ew/4) mirror([1, 0, 0])
          belt_clamp_holes(-th);

        // top belt attachment and clamp
        txy(x_car_l/2, -top_belt_h-ew/4) belt_clamp_holes();
      }
    }
  }
}

module x_carriage_mount_stl() {
  stl("x_carriage_mount");
  color(print_color) {
    tz((screw_clearance_d(car_screw)+th)/2) {
      difference() {
        rx(90) rcf([x_car_l, screw_clearance_d(car_screw)+th, carriage_w(x_car)]);
        carriage_hole_positions(x_car) {
          cylinder(d = screw_clearance_d(carriage_screw(x_car)), h = 100, center = true);
        }
        rx(90) myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
        }
      }
    }
  }
}

module belt_clamp() {
  color(print_color) render() difference() {
    hull() {
      mxz(belt_clamp_offset) {
        cylinder(d = th+screw_clearance_d(car_screw), h = th);
      }
    }
    tz(th-belt_width*0.9+eta) rcc([50, belt_h+2, belt_width*0.9]);
    mxz(belt_clamp_offset) {
      cylinder(d = screw_clearance_d(car_screw), h = th*3, center = true);
    }
  }
}

module belt_clamp_body() {
  difference() {
    hull() {
      mxz(belt_clamp_offset) {
        circle(d = th+screw_clearance_d(car_screw));
      }
    }
    mxz(belt_clamp_offset) {
      circle(d = screw_clearance_d(car_screw));
    }
  }
}

module belt_clamp_stl() {
  stl("belt_clamp");
  color(print_color) union() {
    linear_extrude(th-belt_width*0.9) belt_clamp_body();
    linear_extrude(th) difference() {
      belt_clamp_body();
      square([50, belt_h+2], center = true);
    }
  }
}

module belt_clamp_cut_stl() {
  stl("belt_clamp");
  module clearance_for_mount_screw() {
    txy(th-screw_clearance_d(car_screw)/2-th/2,
        bottom_belt_h+ew/4+x_car_h/2-screw_clearance_d(car_screw)/2-th/2) {
      circle(d = 7.5);
    }
  }
  color(print_color) union() {
    linear_extrude(th-belt_width*0.9) difference() {
      belt_clamp_body();
      clearance_for_mount_screw();
    }

    linear_extrude(th) difference() {
      belt_clamp_body();
      square([50, belt_h+2], center = true);
      clearance_for_mount_screw();
    }
  }
}

module hotend_mount_positions() {
  txy(0, -15) children();
  txy(10, 20) children();
  txy(-10, 20) children();
}

module hotend_mount_stl() {
  stl("hotend_mount");
  clearance = 0.3;
  color(print_color) render() {
    difference() { // carriage mount part
      union() {
        hull() {
          hotend_mount_positions() {
            cylinder(d = screw_clearance_d(hotend_mount_screw)+th/2,
                     h = th);
          }
          ty(x_car_h/2+e3d_clamp_h()
             +hotend_offset-(screw_clearance_d(hotend_mount_screw)+th/2)/2
            ) {
            myz(10) {
              cylinder(d = screw_clearance_d(hotend_mount_screw)+th/2,
                       h = th);
            }
          }
        }
        // cable tie arches
        ty(+th) {
          myz(th) difference() {
            tz(-th+eta) rcc([th*.6, th*2, th]);
            tz(-th/2+eta) rcc([th, th, th/2]);
          }
        }
        ty(x_car_h/2+hotend_offset+clamp_h/2) {
          hull() {
            mxz(clamp_h/2-(screw_clearance_d(hotend_mount_screw)+th/2)/2) {
              myz(10) {
                tz(-clamp_d/2) {
                  cylinder(d = screw_clearance_d(hotend_mount_screw)+th/2,
                           h = th+clamp_d/2);
                }
              }
            }
          }
        }
      }
      hotend_mount_positions() {
        cylinder(d = screw_clearance_d(hotend_mount_screw),
                 h = 100, center = true);
      }
      ty(x_car_h/2+hotend_offset+clamp_h/2) {
        ty(-clamp_h/2+(clamp_top_h+clamp_mid_h/2)) {
          myz(10) {
            cylinder(d = screw_clearance_d(hotend_mount_screw),
                     h = 100, center = true);
          }
        }
        tyz(-clamp_h/2, -clamp_d/2) rx(90) e3d_clamp_cut(0.5);
      }
    }
  }
}

module hotend_clamp_stl() {
  stl("hotend_clamp");
  clearance = 0.3;
  color(print_color) render() {
    difference() {
      hull() {
        tz(-clamp_h/2) mxy(clamp_h/2-(screw_clearance_d(hotend_mount_screw)+th/2)/2) {
          myz(10) {
            rx(90) {
              cylinder(d = screw_clearance_d(hotend_mount_screw)+th/2,
                       h = th+clamp_d/2);
            }
          }
        }
      }
      tz(-(clamp_top_h+clamp_mid_h/2)) {
        myz(10) {
          rx(90) {
            cylinder(d = screw_clearance_d(hotend_mount_screw),
                     h = 100, center = true);
          }
        }
      }
      e3d_clamp_cut();
    }
  }
}

module probe_mount_stl() {
  stl("probe_mount");
  clearance = 0.3;
  color(print_color) render() {
    w = 10+screw_clearance_d(hotend_mount_screw)+th/2+
      (probe_offset[0]+probe_washer_d(probe)/2)/2;
    difference() {
      union() {
        ty(-clamp_h/2) {
          tx(w/2-10-(screw_clearance_d(hotend_mount_screw)+th/2)/2) {
            rrcf([w, clamp_h, th],
                 r = (screw_clearance_d(hotend_mount_screw)+th/2)/2);
          }
        }
        l = e3d_height()-probe_offset[2]-15;
        txy(probe_offset[0], -l/2) {
          rrcf([probe_washer_d(probe), l, th],
               r = (screw_clearance_d(hotend_mount_screw)+th/2)/2);
        }
        h = probe_washer_d(probe)/2+e3d_clamp_d()/2+th*2;
        txyz(probe_offset[0], -(l-th), -h+th) {
          rrcf([probe_washer_d(probe), th*2, h],
               r = (screw_clearance_d(hotend_mount_screw)+th/2)/2);
        }
      }
      txz(probe_offset[0], -(e3d_clamp_d()/2+th)) {
        rx(90) cylinder(d = probe_d(probe)+clearance*2, h = 100);
      }
      ty(-(clamp_top_h+clamp_mid_h/2)) {
        myz(10) {
          cylinder(d = screw_clearance_d(hotend_mount_screw),
                   h = th*3, center = true);
        }
      }
    }
  }
}

module x_endstop_mount_stl() {
  stl("x_endstop_mount");
  color(print_color) render() {
    difference() {
      union() {
        tx(-12.5+th/2) cc([25, th, microswitch_l(ms)]);
        txy(-th*3.5, -1/2) {
          cc([microswitch_h(ms), th+1, microswitch_l(ms)]);
        }
        txz(th, -(x_car_h/2+th)/2+microswitch_l(ms)/2) {
          cc([th*2, th, x_car_h/2+th]);
        }
      }
      tx(-19) rz(90) ry(-90) microswitch_hole_positions(ms) {
        cylinder(d = screw_clearance_d(microswitch_screw),
                 h = 1000, center = true);
      }
      tx(screw_clearance_d(car_screw)+th/8) {
        tz(microswitch_l(ms)/2-screw_clearance_d(car_screw)-th/8) {
          rx(90) {
            cylinder(d = screw_clearance_d(car_screw),
                     h = 100, center = true);
          }
        }
        tz(microswitch_l(ms)/2-x_car_h/2) {
          rx(90) {
            cylinder(d = screw_clearance_d(car_screw),
                     h = 100, center = true);
          }
        }
      }
    }
  }
}

module x_carriage_mount_subassembly() {
  w = screw_washer(car_screw);
  explode([0, 0, 5], true) {
    // top
    tz(carriage_total_h(x_car)) x_carriage_mount_stl();
    // screws for MGN carriage
    carriage_hole_positions(x_car) {
      tz(screw_clearance_d(car_screw)+th) {
        screw_washer(carriage_screw(x_car),
                     th+carriage_screw_depth(x_car)+washer_h(w)+3);
      }
    }
  }
}

module hotend_subassembly() {
  tyz(-carriage_w(x_car)/2-th/2-0.1, carriage_total_h(x_car)/2-th/4) {
    tyz(-th*1.5-e3d_clamp_d()/2, -(x_car_h/2+hotend_offset)) {
      explode([0, -clamp_d*1.5, 0], true) {
        e3d_v6_3mm_bowden();
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
                                th*3+clamp_d+0.5+washer_h(w)+nut_h(n)+th);
                tz(th*3+clamp_d+0.5+th) explode([0, 0, 40]) washer(w);
                tz(th*3+clamp_d+0.5+th+washer_h(w)) explode([0, 0, 45]) nut(n);
              }
            }
          }
        }
      }
    }
  }
}

fan = RB5015;
fan_screw = M3_cap_screw;

module duct_stl() {
  stl("duct");
  clearance = 0.3;
  p = blower_screw_holes(fan);
  bh = blower_depth(fan);
  be = blower_exit(fan);
  color(print_color) render() {
    rz(90) rx(90) mxy(bh/2) {
      linear_extrude(th/2) {
        difference() {
          union() {
            hull() {
              txy(p[1][0], p[1][1])
                circle(d = screw_clearance_d(car_screw)+th);
              tx(-th/2) square([be+th, th]);
            }
          }
          for (sp = p) {
            txy(sp[0], sp[1]) circle(d = screw_clearance_d(car_screw));
          }
        }
      }
    }
    ty(be/2) mxz(be/2+clearance) {
      ty(th/4) rcc([bh+th, th/2-clearance, th/2]);
    }
    difference() {
      union() {
        tyz(be/2,-th/2) {
          hull() {
            tyz(+th/2, th/4) cc([bh+th, be+clearance, th/2]);
            tyz(-be/2, -th+th/2) cc([bh+th, th/2, th+th/2]);
          }
        }
        hb = [16, 20, 11.5]; // e3d heater block dimensions
        w = hb[0]+th*4;
        d = hb[1]+th*3;
        tyz(-carriage_w(x_car)/2-th*1-e3d_clamp_d()/2+th, -th*1.75) {
          scale([1, 1.25, 1]) rz(45) rotate_extrude($fn = 4) {
            tx((w+th)/2) {
              polygon(points = [[0, th*1.8], [th*1.2, th*1.8],
                                [th*1.2, th*1.25],
                                [th*0.6, 0], [th*0.2, 0],
                                [th*0.75, th*1.2], [th*0.25, th*1.2],
                                [-th*0.25, 0], [-th*0.75, 0]],
                      paths = [[0,1,2,3,4,5,6,7,8,0]]);
            }
          }
        }
      }
      ty(-clearance) {
        tyz(be/2,-th/2) {
          hull() {
            tz(+th/2) cc([bh, be+clearance, th/2]);
            tyz(-be/2, -th+th/2) rx(-30) cc([bh+th/2, th/2, th*0.75]);
          }
        }
      }
    }
  }
}

module duct_mount_stl() {
  stl("duct_mount");
  clearance = 0.3;
  bh = blower_depth(fan);
  be = blower_exit(fan);
  color(print_color) {
    l = carriage_pitch_x(x_car)+screw_clearance_d(car_screw)+th;
    w = carriage_pitch_y(x_car)/2+screw_clearance_d(car_screw)/2+th/2;
    d = 10+screw_clearance_d(car_screw)/2+th/2;
    side_th = (l-bh-th)/2;
    difference() {
      union() {
        tyz(-11, -th/2) cc([l-th, th*3, th]);
        ty(-carriage_w(x_car)/2) {
          hull() {
            tz(-clamp_h/2+1) {
              mxy(1+(screw_clearance_d(hotend_mount_screw)+th/2)/2) {
                myz(10) {
                  rx(90) {
                    cylinder(d = screw_clearance_d(hotend_mount_screw)+th/2,
                             h = th);
                  }
                }
              }
            }
          }
        }
        myz((bh+side_th)/2) {
          tz(-th/2) cc([side_th, w, th]);
          tz(-d/2) cc([side_th, screw_clearance_d(car_screw)+th, d]);
          tz(-d) ry(90) {
            cylinder(d = screw_clearance_d(car_screw)+th,
                     h = side_th, center = true);
          }
        }
      }
      ty(-carriage_w(x_car)/2) {
        tz(-(clamp_top_h+clamp_mid_h/2)+2) {
          myz(10) {
            rx(90) {
              cylinder(d = screw_clearance_d(hotend_mount_screw),
                       h = th*3, center = true);
            }
            rx(-90) {
              cylinder(d = washer_od(screw_washer(hotend_mount_screw))+0.5,
                       h = th);
            }
          }
        }
      }
      tz(-d+10/2) {
        hull() {
          mxy(10/2) {
            ry(90) cylinder(d = screw_clearance_d(car_screw),
                            h = 100, center = true);
          }
        }
      }
    }
  }
}

module duct_assembly()
    pose([46.6, 0, 208.20], [-15.3, 32.9, -28.9])
    assembly("duct") {
  tyz(-(screw_clearance_d(car_screw)+th)/2,
      -carriage_total_h(x_car)/2-th/4-e3d_height()) {
    rz(90) rx(90) tz(-blower_depth(fan)/2) blower(fan);
    duct_stl();
  }
  tz(-carriage_total_h(x_car)+0.5-screw_clearance_d(car_screw)-th)
    duct_mount_stl();
  n = screw_nut(car_screw);
  w = screw_washer(car_screw);
  mw = carriage_pitch_x(x_car)+screw_clearance_d(car_screw)+th;
  dmw = blower_depth(fan)+th;
  sl0 = mw + nut_h(n) + washer_h(w)*2;
  sl1 = dmw + nut_h(n) + washer_h(w)*2;

  tyz(-(screw_clearance_d(car_screw)+th)/2,
      -carriage_total_h(x_car)/2-th/4-e3d_height()) {
    rz(90) rx(90) {
      p = blower_screw_holes(fan);
      txy(p[0][0], p[0][1]) {
        tz(-mw/2) screw_washer_up(car_screw, sl0);
        explode([0, 0, 5], true) tz(mw/2) washer(w) {
          explode([0, 0, 5]) nut(n);
        }
      }
      txy(p[1][0], p[1][1]) {
        tz(-dmw/2) screw_washer_up(car_screw, sl1);
        explode([0, 0, 5], true) tz(dmw/2) washer(w) {
          explode([0, 0, 5]) nut(n);
        }
      }
    }
  }
}

if ($preview) {
  $explode = 1;
  //x_carriage_assembly();
  //tz(ew/2) x_carriage_mount_subassembly();
  //hotend_subassembly();
  duct_assembly();
  //x_carriage_front_assembly();
  //x_carriage_rear_assembly();
}

