include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module psu_subassembly() {
  txyz(-fw/2+psu_l/2+ew2+80, fd/2-th, ew2+psu_w/2+th) {
    explode([100, 0, 0], offset = [-psu_l/2, 0, 0]) {
      ty(-psu_h) rx(-90) psu(PSU_S_350);
    }
    psu_mount_screws();
  }
}

module psu_mount_stl() {
  stl("psu_mount");
  color(print_color) {
    difference() {
      union() {
        tyz(-psu_h/2-th/2, -psu_w/2-th) rcc([ew, psu_h+th-0.5, th]);
        tyz(-ew/2-th*1.5, -psu_w/2-th-ew2) rcc([ew, th, th+ew2]);
        tyz(-psu_h-th/2, -psu_w/2-th) {
          rcc([ew, th, psu_w/2+50/2+th+th+screw_d(psu_screw)/2]);
        }
      }
      mxy(50/2) {
        ty(-psu_h-th/2) rx(90) {
          cylinder(d = screw_clearance_d(psu_low_screw)*1.1,
                   h = th*2, center = true);
        }
      }
      hull() {
        for (y = [0, 2.5]) ty(y) {
          tyz(-psu_h/2-25/2-th/2, -psu_w/2) {
            cylinder(d = screw_clearance_d(psu_screw)*1.1,
                     h = 100, center = true);
          }
        }
      }
      tz(-psu_w/2-th-ew2/2) mxy(20/2) {
        rx(90) cylinder(d = screw_clearance_d(ex_screw)*1.1,
                        h = 100, center = true);
      }
    }
  }
}

module iec_socket_mount_stl() {
  stl("iec_socket_mount");
  l = 60;
  clearance = 0.5;
  tz(-(l+th)) color(print_color) render() {
    difference() {
      union() {
        ty(-th/2) rcc([iec_socket_cut_out_w()+th*2,
                       iec_socket_cut_out_h()+th, l+th]);
        tz(l) {
          hull() {
            ty(ew/2-th/2) {
              rcc([iec_socket_cut_out_w()+th*2,
                   ew+iec_socket_cut_out_h()+th, th]);
            }
            ty(-iec_socket_screw_gap()/2) {
              cylinder(d = th*2, h = th);
            }
          }
          tyz(ew/2-th/2+iec_socket_cut_out_h()/2, -th-ew2) {
            rcc([iec_socket_cut_out_w()+th*2,
                 ew+th, th]);
          }
        }
      }
      tz(l+th-iec_socket_back_clearance_d()+eta) {
        rcc([iec_socket_cut_out_w()+clearance,
             iec_socket_cut_out_h()+clearance,
             iec_socket_back_clearance_d()]);
      }
      tyz(-th/2, th+eta) {
        rcc([iec_socket_cut_out_w()+clearance,
             iec_socket_cut_out_h()+clearance-th, l+th]);
      }
      // faceplate screw holes
      tz(l-eta) mxz(39.75/2) {
        cylinder(d = screw_tap_d(M3_cap_screw),
                 h = 10);
      }
      // mount screw holes
      ty(iec_socket_cut_out_h()/2+ew/2) myz(ew) {
        cylinder(d = screw_tap_d(ex_screw),
                 h = 1000, center = true);
      }
      // cable hole bottom
      txyz(-iec_socket_cut_out_w()/2-th+2,
          iec_socket_cut_out_h()/2-th*2, th*2) {
        ry(90) cylinder(d = 8, h = th);
      }
      // cable hole side
      txyz(-iec_socket_cut_out_w()/2+th,
           iec_socket_cut_out_h()/2-th*2, +2) {
        cylinder(d = 8, h = th);
      }
    }
  }
}

module socket_mount_assembly() {
  iec_socket_mount_stl();
  tz(-ew2/2-th) mxy(ew2/2+th) {
    ty(iec_socket_cut_out_h()/2+ew/2) myz(ew) {
      screw_and_washer(ex_screw, ex_screw_l);
    }
  }
}

module socket_mount_preassembly() {
  tz(-ew2/2-th) mxy(ew2/2+th) {
    ty(iec_socket_cut_out_h()/2+ew/2) myz(ew) {
      tz(-7) rz(90) tnut(M4_tnut);
    }
  }
}

module psu_cover_stl() {
  stl("psu_cover");
  l = psu_cover_l;
  ol = (psu_l-150)/2;
  clearance = 0.5;
  color(print_color) render() {
    difference() {
      union() {
        txy(-l/2+ol/2+th/2, -(psu_h+th)/2+th/2)
          cc([l+ol+th, psu_h+th*2, psu_w+th*2]);
        txyz(-l+ew*1.5, th/2-ew, -psu_w/2-ew-th)
          rcc([ew*3, th, ew+th]);
      }
      txy(psu_l/2, -psu_h/2) {
        cc([psu_l, psu_h+clearance/2, psu_w+clearance]);
      }
      txy(-l/2+th, -psu_h/2) cc([l, psu_h, psu_w+clearance]);
      txyz(ol-clearance, -psu_h, -th-clearance) {
        cc([ew+clearance, psu_h*2, psu_w+clearance]);
      }
      tx(ol) {
        ty(-psu_h/2-th/2) {
          mxz(25/2) {
            cylinder(d = screw_clearance_d(psu_screw)*1.1,
                     h = 1000, center = true);
          }
        }
      }
      txz(-l+ew*1.5, -(psu_w+th*2+ew)/2) myz(ew) {
        rx(90) {
          cylinder(d = screw_clearance_d(ex_screw)*1.1,
                   h = 1000, center = true);
        }
      }
      txyz(-l+th+2, -ew-th, -iec_socket_cut_out_w()/2+th) {
        ry(-90) cylinder(d = 8, h = th);
      }
      txyz(-l+th+2, -ew-th, -psu_w/2+th) {
        ry(-90) cylinder(d = 8, h = th);
      }
      txyz(-l+th*2, -ew-th, -psu_w/2-th+2) {
        cylinder(d = 8, h = th);
      }
    }
  }
}

module psu_mount_screws() {
  myz(150/2) {
    ty(-psu_h-th) mxy(50/2) {
      rx(-90) screw_washer_up(psu_screw, 6);
    }
    tyz(-psu_h/2-25/2-th/2, -psu_w/2-th) {
      screw_washer_up(psu_screw, 8);
    }
  }
  tx(-150/2) {
    tyz(-psu_h/2-th/2, psu_w/2+th) {
      mxz(25/2) {
        screw_washer(psu_screw, 8);
      }
    }
  }

}

module psu_mount_assembly() {
  tx(-psu_l/2) {
    explode([0, -20, 0], true) {
      psu_cover_stl();
      txyz(-psu_cover_l+ew*1.5, -ew, -(psu_w+th*2+ew)/2) myz(ew) {
        rx(90) {
          screw_and_washer(ex_screw, ex_screw_l);
          if (exploded() == 0) {
            tz(-7) rz(90) tnut(M4_tnut);
          }
        }
      }
    }
  }
  if (exploded()) {
    txyz(-(psu_l/2+ew2+80)+25, -ew, -(psu_w+th*2+ew)/2) {
      explode([-10, 0, 0], offset = [10, 0, 0]) {
        for (i = [0:3]) {
          tx(-ew*i) rx(90) tz(-7) rz(90) tnut(M4_tnut);
        }
      }
      tz(-ew) {
        explode([-10, 0, 0], offset = [10, 0, 0]) {
          for (i = [0:1]) {
            tx(-ew*i) rx(90) tz(-7) rz(90) tnut(M4_tnut);
          }
        }
      }
    }
  }
  myz(150/2) {
    explode([0, -20, 0], true) {
      psu_mount_stl();
      tyz(-ew, -psu_w/2-th-ew2/2) mxy(20/2) {
        rx(90) {
          screw_and_washer(ex_screw, ex_screw_l);
          if (exploded() == 0) {
            tz(-7) rz(90) tnut(M4_tnut);
          }
        }
      }
    }
  }
}

module duet_mount_assembly()
  pose([79.5, 0, 316.2], [4.56, -72.88, 17.90]) assembly("duet_mount") {
  tx(duet_mount_w/2-ew/2) {
    duet_mount_stl();
    tx(-duet_mount_w/2+ew/2) {
      mxz(100/2) {
        rx(180) {
          screw_and_washer(ex_screw, ex_screw_l);
          tz(-10) tnut(M4_tnut);
        }
      }
    }
    txyz(duet_clearance+duet_mount_offset, -1, ew/2+th) {
      ty(-(fd/2-ew*1.5)/2+th) {
        myz(duet_mount_pitch/2) {
          rx(-90) {
            screw_and_washer(ex_screw, ex_screw_l);
            rz(90) tz(-8) tnut(M4_tnut);
          }
        }
      }
      ty((fd/2-ew*1.5)/2-th) {
        myz(duet_mount_pitch/2) {
          explode([0, 0, -20], offset = [0, th/2, 0]) {
            rx(90) {
              screw_and_washer(ex_screw, ex_screw_l);
              rz(90) tz(-8) tnut(M4_tnut);
            }
          }
        }
      }
    }
  }
}

module duet_mount_stl() {
  stl("duet_mount");
  // TOFIX: Add tie supports for power, heat bed and hotend
  color(print_color) render() {
    difference() {
      union() {
        rcc([duet_mount_w, 125, th]);
        tx(duet_clearance) {
          txy(duet_mount_offset, -1) {
            myz(duet_mount_pitch/2) {
              ty(-(fd/2-ew*1.5)/2+th/2) {
                ty(ew/2) rcc([ew/2, ew+th, th]);
                rcc([ew/2, th, ew+th]);
              }
              ty((fd/2-ew*1.5)/2-th/2) {
                tyz(-(ew-th)/2, ew) rcc([ew/2, ew, th]);
                tz(ew/2) difference() {
                  rcc([ew/2, th, ew/2+th]);
                  hull() {
                    rx(90) cylinder(d = screw_clearance_d(ex_screw),
                                    h = th*3, center = true);
                    tz(th) {
                      rx(90) cylinder(d = screw_clearance_d(ex_screw),
                                      h = th*3, center = true);
                    }
                  }
                }
                ty(-ew+th) rcc([ew/2, th, ew+th]);
              }
            }
          }
          rz(90) duet_wifi_mount_holes() {
            cylinder(d = 6, h = th+duet_standoff_h);
          }
        }
      }
      tx(duet_clearance) {
        tx(-ew/2) cc([80,100,th*5]);
        rz(90) duet_wifi_mount_holes() {
          cylinder(d = screw_clearance_d(pcb_mount_screw),
                   h = 100, center = true);
        }
        txyz(duet_mount_offset, -1, ew/2+th) {
          myz(duet_mount_pitch/2) {
            rx(90) {
              cylinder(d = screw_clearance_d(ex_screw),
                       h = 1000, center = true);
            }
          }
        }
      }
      tx(-duet_mount_w/2+ew/2) mxz(100/2) {
        cylinder(d = screw_clearance_d(ex_screw),
                 h = 100, center = true);
      }
    }
  }
}

if ($preview) {
  //$explode = 1;
  //duet_mount_assembly()
  //duet_mount_stl();
  //psu_cover_stl();
  //psu_mount_screws();
  //psu_mount_stl();
  union() {
    txyz(-fw/2+psu_l/2+ew2+80, fd/2-th, ew2+psu_w/2+th) {
      psu_mount_assembly();
    }
    psu_subassembly();
  }
  //iec_socket_mount_stl();
  //socket_mount_assembly();
  //socket_mount_preassembly();
}
