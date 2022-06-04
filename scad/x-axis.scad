include <conf.scad>
include <lazy.scad>
include <shapes.scad>
use <x-carriage.scad>

module x_rail_assembly() assembly("x_rail") {
  rail(x_rail, x_rail_l);
  nut = M3_sliding_t_nut;
  sheet = 3;
  rail_screws(x_rail, x_rail_l, sheet + nut_thickness(nut));
  rail_hole_positions(x_rail, x_rail_l, 0)
    tz(-sheet) vflip() sliding_t_nut(nut);
  tx(pos[0]) explode([x_rail_l/2-pos[0]+20, 0, 0]) carriage(x_car);
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
  x_carriage_mount_subassembly();
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

if ($preview) {
  $explode = 1;
  //x_rail_assembly();
  //x_rail_extrusion_assembly();
  x_rail_carriage_assembly();
  //x_axis_assembly();
  //x_carriage_assembly();
  //x_carriage_front_assembly();
  //x_carriage_front_stl();
  //x_carriage_base_stl();
  //x_carriage_rear_assembly();
  //x_carriage_rear_stl();
  //union() { tx(-5) belt_clamp_stl(); tx(5) belt_clamp_cut_stl(); }
}
