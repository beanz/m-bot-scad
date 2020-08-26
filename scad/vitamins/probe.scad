LJ12a3_probe =
  ["LJ12a3: Inductive Probe", 12, 58, 10.5, 6, [0.0, 0.6, 0.6], 4,
   M12_probe_nut, M12_toothed_washer];

function probe_name(t) = t[0];
function probe_d(t) = t[1];
function probe_h(t) = t[2];
function probe_sensor_d(t) = t[3];
function probe_sensor_h(t) = t[4];
function probe_sensor_color(t) = t[5];
function probe_sensing_h(t) = t[6];
function probe_nut(t) = t[7];
function probe_washer(t) = t[8];
function probe_washer_d(t) = star_washer_diameter(probe_washer(t));

module probe(t, bottom_offset = 15, top_offset = 25) {
  vitamin(str(probe_name(t)));
  w = probe_washer(t);
  n = probe_nut(t);
  explode([0, 0, probe_h(t)]) {
    color(screw_color) render() {
      tz(probe_sensor_h(t)) {
        cylinder(d = probe_d(t), probe_h(t)-probe_sensor_h(t));
      }
    }
    color(probe_sensor_color(t)) render() {
      cylinder(d = probe_sensor_d(t), h = probe_sensor_h(t)+eta);
    }
    tz(top_offset+washer_h(w)*0.5) {
      star_washer(w);
      tz(washer_h(w)+0.5) nut(n);
    }
  }
  explode([0,0,-20]) tz(bottom_offset - washer_h(w)*1.5) {
    star_washer(w);
    tz(-nut_h(n)-0.5) nut(n);
  }
}
