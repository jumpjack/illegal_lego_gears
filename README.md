# Illegal Lego Gears

This fork allow creating gears compatible with lego because they use standard hole diameters and standard holes distance, but you can customize your gears to have less holes, and/or round hole at center (free-wheel gears) in place of standard cross axle.

## Standard gear
lego_gear(4);

<img width="601" height="393" alt="image" src="https://github.com/user-attachments/assets/5c4519ae-00f4-4835-9244-69c29747c2ea" />


##  Standard gear, round hole
lego_gear(4, flat_surface=true, cross_hole= false);

<img width="569" height="398" alt="image" src="https://github.com/user-attachments/assets/38a00e83-e92c-4a81-b429-50ac210a0655" />


## Gear with reduced number of holes and center round hole
lego_gear(4, flat_surface=true, cross_hole= false, stud_radius_target=2);

<img width="571" height="382" alt="image" src="https://github.com/user-attachments/assets/281e9704-4044-48c5-9aa0-3c360dd08eba" />


## Gear with reduced number of holes but standard center cross hole
lego_gear(4, flat_surface=true, cross_hole= true, stud_radius_target=2);

<img width="581" height="388" alt="image" src="https://github.com/user-attachments/assets/a4cf701a-1c52-44ef-9b1a-7283bcff05ea" />


## Testing

You can  test the library in this two online OpenScad pages:
- https://ochafik.com/openscad2/
- https://printpal.io/cad-agent

Both toolw do not support uploading custom libraries, so you will need to embed this whole lego-gears library, and its dependency "[gears](https://github.com/chrisspen/gears)" library, right above your OpenScad code:

    code of gears.scad
    code of illegal_lego_gears.scad
    your code

  

------------

# Original readme.md

# lego_gears
OpenSCAD lib to create lego compatible gears.

I just got 3d printer kit and I need something to test it on. Gears are always useful... Requires gears library - https://github.com/chrisspen/gears which does the heavy lifting.


lego_gear(s, flat_surface=true, central_axle=true, solid=false, stud_hole_tolerance=0.00, axle_hole_tolerance=0.05)

parameters:
  - s - size in lego brick length. Spurs count is s*16.
standard sizes are 0.5 (8 spurs), 1 (16 spurs), 1.5 (24 spurs), 2.5 (40 spurs). Other down to 0.0625 (1 spur) are possible. There is no restriction on that parameter. Be wise. 8 spur gear is the minimum for the axle hole to make sense. Smaller are possible - not sure if usable though.
  - flat surface - if set to true will create big flat space on both sides of the gear so it prints better - there will be less support required.
  - central axle - create a hole for the central axle. If set to false there will be none so you can create a custom one - to interface with non-lego stuff
  - solid - if set to true - create no additional spur or axle holes off the center. Implies "flat_surface".
  - stud_hole_tolerance - offset from 4.8/6.2mm standard. Positive values give bigger holes.
  - axle_hole_tolerance - offset from 4.8mm standard. Default is 0.05 (4.85mm). Positive values give bigger holes.


lego_axle(m=1, hole=false, tolerance=0.05)

  - m - size in lego bricks (8mm) total length will be m*8-0.15mm
  - hole - make the axle to be used to make holes in other objects with it. Basically tolerance make the axle bigger if set to true. If set to flase the tolerance makes the axle smaller
  - tolerance - offset to apply to cross section dimension. Default is 0.05 giving 4.75 mm axles and 4.85mm holes


non-lego:

rounded_square(size, r=0.2)

  - size - like for the square module
  - r - radius of the rounding circle


example:

`for (s = [0.5:1:2.5]) translate([s*s*8,0,0]) rotate([0,0,22.5*(s-0.5)]) lego_gear(s);
for (s = [1:1:2]) translate([-s*s*8-2,0,0]) rotate([0,0,22.5*s/2]) lego_gear(s, flat_surface=false);`

![Example](/example.png)

