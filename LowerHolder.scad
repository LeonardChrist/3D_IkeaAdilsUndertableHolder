include <BOSL2/std.scad>


$fn = 64;



legOuterDiameter = 40;
legInnerDiameter = 35;

legLowerScrewHeight = 5;
legLowerScrewDiameter = 6;


holderWidth = legOuterDiameter * 1.1;
holderDepth = 20;
holderHeight = holderWidth;


lowerHolderHeight = holderWidth * 0.2;
lowerHolderDepth = holderDepth * 3;

lowerHolderYOffset = (lowerHolderDepth - holderDepth) / 2;


mountingScrewHoleDiameter = 4;

mountingScrewTranslates = 
[
    [holderWidth / 2, -lowerHolderYOffset / 2, 0],
    [holderWidth / 4, holderDepth + lowerHolderYOffset / 2, 0],
    [holderWidth / 4 * 3, holderDepth + lowerHolderYOffset / 2, 0]
];


difference()
{
    union()
    {
        difference()
        {
            union()
            {
                // main holder
                cube([holderWidth, holderDepth, holderHeight + lowerHolderHeight]);
            
                // lower holder
                fwd(lowerHolderYOffset)
                    cube([holderWidth, lowerHolderDepth, lowerHolderHeight]);
            }
            
            // leg cutout
            translate([holderWidth / 2, legLowerScrewHeight, holderHeight / 2 + lowerHolderHeight])
                xrot(-90)
                    cylinder(d = legOuterDiameter, h = holderDepth);

            // leg slide-in cutout
            translate([(holderWidth - legOuterDiameter) / 2,legLowerScrewHeight, lowerHolderHeight + holderHeight / 2])
                cube([legOuterDiameter, holderDepth, holderHeight]);
        }

    }
    
    // leg screw cutout
    translate([holderWidth / 2, 0, holderHeight / 2 + lowerHolderHeight])
        xrot(-90)
            cylinder(d = legLowerScrewDiameter, h = holderDepth);

    translate([holderWidth / 2 - legLowerScrewDiameter / 2, 0, holderHeight / 2 + lowerHolderHeight])
        cube([legLowerScrewDiameter, holderDepth, holderHeight]);


    // mounting screw cutouts
    for(screwTranslate = mountingScrewTranslates)
        translate(screwTranslate)
            cylinder(d = mountingScrewHoleDiameter, h = holderHeight);
}

