include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/psus.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <NopSCADlib/vitamins/swiss_clips.scad>
include <NopSCADlib/vitamins/spools.scad>
use <NopSCADlib/vitamins/rod.scad>

printed_z_motor_mount = true;

$fn = 24;
$label = 0;
eta = 0.01;
th = 5;
pw = 300;
pd = 200;
ph = 200;
e2020 = E2020;
e2040 = E2040;
PSU_S_350 = S_300_12;
sp = spool_200x60;
sp_h = spool_height(sp);

ew = extrusion_width(E2020);
ew2 = extrusion_height(E2040);
psu_w = psu_width(PSU_S_350);
psu_h = psu_height(PSU_S_350);
psu_l = psu_length(PSU_S_350);
psu_cover_l = 50;


ms = medium_microswitch;
function microswitch_l(t) = microswitch_length(t);
function microswitch_d(t) = microswitch_thickness(t);
function microswitch_h(t) = microswitch_width(t);
car_screw = M3_cap_screw;

module label(l) {
  color("black") text(text = l, size = 20, halign = "center");
}

function screw_clearance_d(t) = 2 * screw_clearance_radius(t);
function screw_d(t) = 2 * screw_radius(t);
function screw_head_d(t) = 2 * screw_head_radius(t);
function screw_head_h(t) = screw_head_height(t);
function washer_h(t) = washer_thickness(t);
function washer_od(t) = washer_diameter(t);
function ball_bearing_h(t) = bb_width(t);
function ball_bearing_od(t) = bb_diameter(t);
function ball_bearing_id(t) = bb_bore(t);
function carriage_total_h(t) = carriage_height(t);
function carriage_l(t) = carriage_length(t);
function carriage_w(t) = carriage_width(t);
function pulley_od(t) = 12.22; // TOFIX
function pulley_length(t) = 16.2; // TOFIX
function pulley_belt_center(t) = 11.5;
function nut_h(t) = nut_thickness(t);
function nut_flats_d(t) = 2 * nut_flat_radius(t);
function screw_tap_d(t) = 2 * screw_pilot_hole(t);
function carriage_screw_gap_l(t) = carriage_pitch_x(t);
function carriage_screw_gap_w(t) = carriage_pitch_y(t);

M3_tnut = 0;
M4_tnut = 1;
M5_tnut = 2;
module tnut(t) {
  rz(90) ry(180) {
    sliding_t_nut(t == M3_tnut ? M3_sliding_t_nut :
                  t == M4_tnut ? M4_sliding_t_nut :
                  M5_sliding_t_nut);
  }
}
function screw_for(l) = (l <= 8 ? 8 :
                         (l <= 10 ? 10:
                          (l <= 12 ? 12 :
                           (l <= 14 ? 14 :
                            (l <= 16 ? 16 :
                             ceil(l / 5) * 5)))));

module screw_washer(t, l) {
  screw_and_washer(t, screw_for(l+washer_h(screw_washer(t))));
}

module screw_washer_nut(t, l) {
  n = screw_nut(t);
  w = screw_washer(t);
  tl = l + washer_h(w) + nut_h(n);
  sl = screw_for(tl);
  screw_and_washer(t, sl);
  explode([0, 0, -10]) tz(-l-nut_h(n)) nut(n);
}

module screw_washer_nut_up(t, l) {
  mirror([0, 0, 1]) {
    screw_washer_nut(t, l);
  }
}

module screw_washer_washer_nut(t, l) {
  n = screw_nut(t);
  w = screw_washer(t);
  tl = l + washer_h(w) * 2 + nut_h(n);
  sl = screw_for(tl);
  screw_and_washer(t, sl);
  tz(-l) nut_washer_up(n);
}

module screw_washer_washer_nut_up(t, l) {
  mirror([0, 0, 1]) {
    screw_washer_washer_nut(t, l);
  }
}

module screw_up(t, l) ry(180) screw(t, screw_for(l));
module screw_washer_up(t, l) ry(180) screw_washer(t, l);

module nut_washer_up(t) {
  mirror([0, 0, 1]) {
    nut_washer(t);
  }
}

module nut_washer(t) {
  tz(exploded() ? -4 : 0) {
    nut_and_washer(t);
  }
}

module NEMA_hole_positions(t, n) NEMA_screw_positions(t, n) children();

module inside_hidden_corner_bracket() {
  extrusion_inner_corner_bracket(E20_inner_corner_bracket);
}

module carriage_for_rail(t) {
  carriage(rail_carriage(t), t);
}

module iec_socket() {
  rz(90) iec(IEC_320_C14_switched_fused_inlet);
}

function iec_socket_screw_gap() = iec_pitch(IEC_320_C14_switched_fused_inlet);
function iec_socket_cut_out_h() = iec_body_w(IEC_320_C14_switched_fused_inlet);
function iec_socket_cut_out_w() = iec_body_h(IEC_320_C14_switched_fused_inlet);
function iec_socket_back_clearance_d() = 25;
module duet_wifi() pcb(DuetE);
module duet_wifi_mount_holes() pcb_hole_positions(DuetE) children();
duet_th = pcb_thickness(DuetE);
duet_w = pcb_width(DuetE);
duet_h = pcb_length(DuetE);
duet_clearance = 20;
duet_standoff_h = 2;
duet_mount_w = duet_w+th*2+ew+duet_clearance;
duet_mount_pitch = 60;
duet_mount_offset = 10;

print_color = [0.7, 0.2, 0.7];
flex_print_color = [0.7, 0.2, 0.2];
aluminium_color = grey(50);
screw_color = grey(80);
black_aluminium_color = [0.2, 0.2, 0.2];
black_delrin_color = [0.2, 0.2, 0.2];
bed_color = "#dedede7f";
bottom_belt_color = [0.6,0.6,0.2];
top_belt_color = [0.7,0.2,0.2];

M12_toothed_washer =
  ["M12 Toothed Washer", 12, undef, 1, false, 21.5, undef, undef, undef];
M12_probe_nut_depth = 4;
M12_probe_nut = ["M12 Probe nut", 12, 17, 4, undef, M12_toothed_washer,
  M12_probe_nut_depth, 0];
probe_offset = [25, 0, 3]; // Z is position not sensing offset obviously
include <vitamins/probe.scad>
probe = LJ12a3_probe;
hotend_mount_screw = M3_cap_screw;
hotend_offset = -2;
idler_screw = M3_cap_screw;
motor_screw = M3_cap_screw;
pcb_mount_screw = M3_cap_screw;
ex_screw = M4_cap_screw;
ex_screw_l = 10;
nema_plate_screw = M5_low_profile_screw;
ex_print_screw = M4_flanged_screw;
ex_tap_screw = M5_flanged_screw;
bed_level_screw = M5_cap_screw;
microswitch_screw = M3_cap_screw; // Tap the microswitch
foot_screw = ex_tap_screw;
psu_screw = M4_cap_screw;
psu_low_screw = M4_flanged_screw;
opulley = GT2x20ob_pulley; // TOFIX: GT2x20_ooznest_pulley;

z_rail = MGN15;
z_car = rail_carriage(z_rail);
z_car_l = carriage_l(z_car);
z_car_w = carriage_w(z_car);
z_car_h = carriage_total_h(z_car);
y_rail = MGN15;
y_car = rail_carriage(y_rail);
y_car_l = carriage_l(y_car);
y_car_w = carriage_w(y_car);
y_car_h = carriage_total_h(y_car);
x_rail = MGN12H;
x_car = rail_carriage(x_rail);
x_car_l = carriage_l(x_car);
x_car_h = ew+carriage_total_h(x_car)+(screw_clearance_d(car_screw)+th)*2+th/2;
pulley_d = pulley_od(opulley);
belt_width = 1.38;
belt_h = 6;
cl = 0.2;
BB623 = ["623", 3, 10, 4, "red", 1.0, 1.0];
BBF623 = BB623; // TOFIX: flange
idler_h = ball_bearing_h(BBF623)*2+washer_h(M3_washer)*3;
acme_nut_w = 12;

// offset from fd/2 to z shaft
z_shaft_offset = ew+z_car_h+th+ew+acme_nut_w/2;

fw = pw+252;
fd = pd+194;
fh = ph+230;

//pos = [cos(360*$t)*pw/2, sin(360*$t)*pd/2, sin(720*$t)*ph/2+100];
pos = [pw/4, pd/2, 100];
y_rail_l = 300;
y_rail_offset = 22;

y_bar_h = fh-ew*2-10; // top of y bar 2040 extrusion == bottom of y rail
x_bar_l = fw-ew*4-22;
x_rail_l = x_bar_l - 50;
x_bar_h = y_bar_h-ew/2;
y_bar_w = fw/2-ew*2;
z_bar_l = y_bar_h-ew*3;
z_rail_l = ph+100;
z_offset = 44;

hotend_mount_h = carriage_total_h(x_car)+ew+screw_clearance_d(car_screw)+th*1.5;
motor_offset = sqrt(2*NEMA_width(NEMA17)*NEMA_width(NEMA17)) / 2;
motor_hole_offset = sqrt(2*NEMA_hole_pitch(NEMA17)*NEMA_hole_pitch(NEMA17)) / 2;

bottom_belt_h = th-8-pulley_belt_center(opulley);
top_belt_h = th-5.5-(pulley_length(opulley)-pulley_belt_center(opulley));

motor_x = y_bar_w-motor_hole_offset+ew/2;
motor_y = -fd/2+motor_offset+ew/2;
motor_z =  y_bar_h+th;

bbr = (ball_bearing_od(BBF623)+belt_width)/2;
pbr = (pulley_od(opulley)+belt_width)/2;
idler_offset = motor_hole_offset-pbr+bbr;
