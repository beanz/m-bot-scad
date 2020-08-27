include <conf.scad>
include <lazy.scad>
include <shapes.scad>

module top_belt() {
  /* thr = th/2+belt_thickness(GT2x6); */
  /* bt = belt_thickness(GT2x6); */
  /* path = */
  /*   [[pos[0]-x_car_l/2,        pos[1]+y_rail_offset-20.5+bbr-th, 0], // carriage */
  /*    [pos[0]-x_car_l/2+th*2,   pos[1]+y_rail_offset-20.5+bbr-th, 0], // carriage */
  /*    [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr, bt/2], // carriage */
  /*    [-motor_x+pbr+bbr, pos[1]+y_rail_offset-20.5, -bbr-bt/2], // left */
  /*    [-motor_x, -fd/2+motor_offset+ew/2, pbr+bt/2], // front left */
  /*    [-(motor_x+pbr-bbr), fd/2-ew/2, bbr+bt/2], // rear left */
  /*    [motor_x+pbr-bbr, fd/2-ew/2, bbr+bt/2], // rear right */
  /*    [motor_x+pbr-bbr, pos[1]+y_rail_offset+20.5, bbr+bt/2], // right */
  /*    [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr, bt/2], // carriage */
  /*    [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr+th, 0], // front */
  /*    [pos[0]+th, pos[1]+y_rail_offset+20.5-bbr+th, 0], // middle */
  /* ]; */

  /* belt(GT2x6, path, gap = 100, gap_pt = [pos[0], pos[1]+y_rail_offset], */
  /*      belt_colour = top_belt_color); */

  mbelt(GT2x6,
        [[pos[0]-x_car_l/2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
         [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
         [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset-20.5+bbr], // carriage
         [-(motor_x-pbr), pos[1]+y_rail_offset-20.5+bbr], // left
         [-(motor_x-pbr), -fd/2+motor_offset+ew/2-pbr], // front left
         [-(motor_x+pbr), -fd/2+motor_offset+ew/2-pbr],
         [-(motor_x+pbr), fd/2-ew/2+bbr], // rear left
         [motor_x+pbr, fd/2-ew/2+bbr], // rear right
         [motor_x+pbr, pos[1]+y_rail_offset+20.5-bbr], // right
         [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr], // carriage
         [pos[0]+x_car_l/2-th, pos[1]+y_rail_offset+20.5-bbr+th], // front
         [pos[0]+x_car_l/2, pos[1]+y_rail_offset+20.5-bbr+th], // middle
        ],
        bcolor = top_belt_color);
}

module bottom_belt() {
  mbelt(GT2x6,
        [
          [pos[0]+x_car_l/2, pos[1]+y_rail_offset-20.5+bbr-th], // carriage
          [pos[0]+x_car_l/2-th*2, pos[1]+y_rail_offset-20.5+bbr-th], // front
          [pos[0]+x_car_l/2-th*2, pos[1]+y_rail_offset-20.5+bbr], // rear
          [motor_x-pbr, pos[1]+y_rail_offset-20.5+bbr], // right
          [motor_x-pbr, -fd/2+motor_offset+ew/2-pbr], // front right
          [motor_x+pbr, -fd/2+motor_offset+ew/2-pbr],
          [motor_x+pbr, fd/2-ew/2+bbr], // rear right
          [-(motor_x+pbr), fd/2-ew/2+bbr], // rear left
          [-(motor_x+pbr), pos[1]+y_rail_offset+20.5-bbr], // left
          [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset+20.5-bbr], // carriage rear
          [pos[0]-x_car_l/2+th*2, pos[1]+y_rail_offset+20.5-bbr+th], // front
          [pos[0]-th, pos[1]+y_rail_offset+20.5-bbr+th], // middle
        ],
        bcolor = bottom_belt_color);
}

function dist(p1, p2) = sqrt((p1[0]-p2[0])*(p1[0]-p2[0])+
                             (p1[1]-p2[1])*(p1[1]-p2[1]));
function pdist(p, i = 0, a = 0) =
  len(p) > i+1 ? pdist(p, i+1, a+dist(p[i], p[i+1])) : a;

module mbelt(type, path, bcolor = top_belt_color) {
  th = belt_thickness(type);
  h = belt_width(type);
  vitamin(str("BELT: GT2 ", pdist(path)));
  color(bcolor) {
    for (i = [0:len(path)-2]) {
      hull() {
        txy(path[i][0], path[i][1]) cylinder(d = th, h = h, center = true);
        txy(path[i+1][0], path[i+1][1]) cylinder(d = th, h = h, center = true);
      }
    }
  }
}
