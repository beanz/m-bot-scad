include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <vitamins/e3d-v6.scad>
include <vitamins/probe.scad>

clamp_h = e3d_clamp_h();
clamp_d = e3d_clamp_d();
clamp_top_h = e3d_clamp_part_h("top");
clamp_mid_h = e3d_clamp_part_h("middle");

module x_rail_assembly() assembly("x_rail") {
  rail(x_rail, x_rail_l);
  nut = M3_sliding_t_nut;
  sheet = 3;
  rail_screws(x_rail, x_rail_l, sheet + nut_thickness(nut));
  rail_hole_positions(x_rail, x_rail_l, 0)
    tz(-sheet) vflip() sliding_t_nut(nut);
  tx(pos[0]) explode([x_rail_l/2-pos[0]+20, 0, 0]) carriage_for_rail(x_rail);
}

module x_rail_extrusion_assembly()
    pose([72.5, 0, 301], [161.1, -11, 50.1])
    assembly("x_rail_extrusion") {
  // extrusion
  tx(-pos[0]) {
    explode([x_bar_l, 0, 0], offset = [-x_bar_l/2, 0, -ew/2]) {
      tz(-ew/2) rx(90) ry(90) extrusion(e2020, x_bar_l);
    }
    // rail
    x_rail_assembly();
  }
}

module x_rail_carriage_assembly()
    pose([64.8, 0, 319.2], [-58.1, 28.5, 7.5])
    assembly("x_rail_carriage") {
  x_rail_extrusion_assembly();
  explode([0, 0, 5], true) {
    // top
    tz(carriage_total_h(x_car)) x_carriage_mount_stl();
    // screws for MGN carriage
    carriage_hole_positions(x_car) {
      tz(screw_clearance_d(car_screw)+th) {
        screw_washer(carriage_screw(x_car), th+carriage_screw_depth(x_car));
      }
    }
  }
}

module x_axis_assembly()
  pose([78.8, 0, 70.5], [5.9, 13.91, 7.72]) assembly("x_axis") {

  tz(ew/2) {
    x_rail_carriage_assembly();
  }
  explode([0, 0, -x_car_h]) x_carriage_assembly();

  n = screw_nut(car_screw);
  w = screw_washer(car_screw);

  // screws for printed carriage
  ty(-(carriage_w(x_car)+th*2)/2) {
    tx((x_car_l-screw_clearance_d(car_screw)-th)/2) {
      tz(ew/2+carriage_total_h(x_car)+(screw_clearance_d(car_screw)+th)/2) {
        rx(90) screw_washer(car_screw,
                            carriage_w(x_car)+th*2+nut_h(n)+1);
      }
    }
    tx(-(x_car_l-screw_clearance_d(car_screw)-th)/2) {
      tz(ew/2+carriage_total_h(x_car)+(screw_clearance_d(car_screw)+th)/2) {
        // longer screw for end stop mount
        rx(90) screw_washer(car_screw,
                            carriage_w(x_car)+th*3+nut_h(n)+1);
      }
    }
  }

  // nuts for printed carriage
  ty((carriage_w(x_car)+th*2)/2) {
    tx((x_car_l-screw_clearance_d(car_screw)-th)/2) {
      tz(ew/2+carriage_total_h(x_car)+(screw_clearance_d(car_screw)+th)/2) {
        explode([0, 5, 0], true)
          rx(-90) washer(w) explode([0, 0, 5]) nut(n);
      }
    }
    tx(-(x_car_l-screw_clearance_d(car_screw)-th)/2) {
      tz(ew/2+carriage_total_h(x_car)+(screw_clearance_d(car_screw)+th)/2) {
        // longer screw for end stop mount
        ty(th) explode([0, 5, 0], true)
          rx(-90) washer(w) explode([0, 0, 5]) nut(n);
      }
    }
  }
}

module x_endstop_mount_stl() {
  stl("x_endstop_mount");
  color(print_color) render() {
    difference() {
      union() {
        tx(-10+th/2) cc([20, th, microswitch_l(ms)]);
        txy(-th*2.5, -1/2) {
          cc([microswitch_h(ms), th+1, microswitch_l(ms)]);
        }
        txz(th, -(x_car_h/2+th)/2+microswitch_l(ms)/2) {
          cc([th*2, th, x_car_h/2+th]);
        }
      }
      tx(-14) rz(90) ry(-90) microswitch_hole_positions(ms) {
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

module belt_clamp() {
  color(print_color) render() difference() {
    hull() {
      mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
        cylinder(d = th+screw_clearance_d(car_screw), h = th);
      }
    }
    tz(th-belt_width*0.9+eta) rcc([50, belt_h+2, belt_width*0.9]);
    mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
      cylinder(d = screw_clearance_d(car_screw), h = th*3, center = true);
    }
  }
}

module belt_clamp_stl() {
  stl("belt_clamp");
  belt_clamp();
}

module belt_clamp_cut_stl() {
  stl("belt_clamp_cut");
  color(print_color) render() difference() {
    belt_clamp();
    txy(th-screw_clearance_d(car_screw)/2-th/2,
        bottom_belt_h+ew/4+x_car_h/2-screw_clearance_d(car_screw)/2-th/2) {
      cylinder(d = 7.5, h = th*3, center = true);
    }
  }
}

module x_carriage_assembly()
  pose([119.4, 0, 47.4], [-17.81, -11.44, 10.81]) assembly("x_carriage") {

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
      mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
  txyz(x_car_l/2-th, -th*1.5, bottom_belt_h+ew/4) rx(-90) {
    explode([0, 0, -5], true) {
      belt_clamp_cut_stl();
      mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
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
        tyz(-clamp_h/2, -clamp_d/2) rx(90) e3d_clamp_cut();
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

module x_carriage_front_stl() {
  stl("x_carriage_front");
  color(print_color) {
    rx(-90) difference() {
      rcf([x_car_l, x_car_h, th]);
      mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
        myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
        }
      }
      txy(x_car_l/2, -bottom_belt_h-ew/4) {
        tx(-th*2) cc([2, belt_h+2, th*2]);
        txz(-th, th/2) cc([th*2+eta, belt_h+2, 4]);
        tx(-th) mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
          rz(30) {
            cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1,
                     h = 100, $fn=6);
          }
        }
      }
      txy(-x_car_l/2, -top_belt_h-ew/4) {
        tx(th*2) cc([2, belt_h+2, th*2]);
        txz(th, th/2) cc([th*2+eta, belt_h+2, 4]);
        tx(th) mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
          rz(30) {
            cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1,
                     h = 100, $fn=6);
          }
        }
      }
      hotend_mount_positions() {
        cylinder(d = screw_clearance_d(hotend_mount_screw),
                 h = 100, center = true);
        rz(30) {
          cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1,
                   h = 100, $fn=6);
        }
      }
    }
  }
}

module x_carriage_rear_assembly()
  pose([66.2, 0, 301.0], [-177.92, -110.93, 91.54]) assembly("x_carriage_rear") {
  x_carriage_rear_stl();
  n = screw_nut(car_screw);
  txz(-carriage_l(x_car)/2, carriage_total_h(x_car)/2+microswitch_l(ms)/2) {
    explode([0, -10, 0]) txy(-14, -2) rz(90) ry(-90) microswitch(ms);
    explode([0, 5, 0], true) {
      ty(th) x_endstop_mount_stl();
      txy(-14, th+2+0.5) {
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
  txyz(x_car_l/2-th*2, th*1.5, -top_belt_h-ew/4) rx(90) {
    explode([0, 0, -5], true) {
      belt_clamp_stl();
      mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
  txyz(-x_car_l/2+th*3, th*1.5, bottom_belt_h+ew/4) rx(90) {
    explode([0, 0, -5], true) {
      belt_clamp_stl();
      mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
        explode([0, 0, -5], true) {
          rz(30) screw_washer_up(car_screw, th*1.3+nut_h(n));
        }
      }
    }
    mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
      explode([0, 0, 10], true) {
        tz(th*1.3) rz(30) nut(screw_nut(car_screw));
      }
    }
  }
}

module x_carriage_rear_stl() {
  stl("x_carriage_rear");
  color(print_color) {
    rx(-90) difference() {
      rcf([x_car_l, x_car_h, th]);
      mxz((x_car_h-screw_clearance_d(car_screw)-th)/2) {
        myz((x_car_l-screw_clearance_d(car_screw)-th)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
        }
      }
      tx(-(x_car_l-screw_clearance_d(car_screw)-th)/2) {
        cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
        rx(180) {
          rz(30) {
            cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1, h = 100, $fn=6);
          }
        }
      }
      txy(-x_car_l/2, -bottom_belt_h-ew/4) {
        tx(th) cc([2, belt_h+2, th*2]);
        txz(th/2, -th/2) cc([th+eta, belt_h+2, 4]);
        tx(th*3) mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
          ry(180) rz(30) {
            cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1,
                     h = 100, $fn=6);
          }
        }
      }
      txy(x_car_l/2, -top_belt_h-ew/4) {
        tx(-th) cc([2, belt_h+2, th*2]);
        txz(-th/2, -th/2) cc([th+eta, belt_h+2, 4]);
        tx(-th*2) mxz(belt_h/2+th/2+screw_clearance_d(car_screw)/2) {
          cylinder(d = screw_clearance_d(car_screw), h = 100, center = true);
          ry(180) rz(30) {
            cylinder(d = nut_flats_d(screw_nut(car_screw))*1.1,
                     h = 100, $fn=6);
          }
        }
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

if ($preview) {
  //$explode = 1;
  //x_rail_assembly();
  //x_rail_extrusion_assembly();
  //x_rail_carriage_assembly();
  //x_axis_assembly();
  //x_carriage_assembly();
  x_carriage_front_assembly();
  //x_carriage_rear_assembly();
}
