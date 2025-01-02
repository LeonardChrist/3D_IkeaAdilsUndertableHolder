include <BOSL2/std.scad>
$fn = 64;

//// parameters

// can generate multiple holders in one, putting them next to each other
// set this to how many legs you want to hold with one holder
numberOfLegs = 4;

// if this variable is set to true, the generate holder holds the upper part of a leg
// if set to false, it generates the holder for the lower part
generateUpperHolder = true;





//// measured
// these should only be adjusted when there an issue with the fit
// the first number is always the measured one, the second factor is adjusting for a tighter or looser tolerance on that value

legOuterDiameter = 40.23 * 1.03;

legInnerDiameter = 38.5 * 0.95;

legUpperScrewDiameter = 8 * 1.1;
legUpperIndentation = 6.16;

legFeetScrewDiameter = 7.6 * 1.2;
legFeetScrewOpening = 10;

legFeetDomeDiameter = 18.9 * 1.1;
legFeetDomeHeight = 2.86 * 1.1;

mountingScrewHoleDiameter = 4 * 1.2;






//// computed
// these should only be adjusted when changes to design are made

holderColumnWidth = legOuterDiameter * 1.15;
holderColumnDepth = 18;
holderColumnHeight = holderColumnWidth;
holderColumnDimensions = [holderColumnWidth, holderColumnDepth, holderColumnHeight];

holderBaseWidth = holderColumnWidth;
holderBaseDepth = holderColumnDepth * 2;
holderBaseHeight = holderColumnHeight * 0.1;
holderBaseDimensions = [holderBaseWidth, holderBaseDepth, holderBaseHeight];

holderColumnYOffset = (holderBaseDepth - holderColumnDepth) / 2;

mountingScrewPadding = (holderBaseDepth - holderColumnDepth) / 4;

mountingScrewTranslates = 
[
    [mountingScrewPadding, mountingScrewPadding, 0],
    [holderBaseWidth - mountingScrewPadding, mountingScrewPadding, 0],
    [mountingScrewPadding, holderBaseDepth - mountingScrewPadding, 0],
    [holderBaseWidth - mountingScrewPadding, holderBaseDepth - mountingScrewPadding, 0]
];







//// actual 3d code
xcopies(n = numberOfLegs, spacing = holderBaseWidth)
{
    difference()
    {
        // holder base
        cube(holderBaseDimensions);

        // mounting screw cutouts
        for(screwTranslate = mountingScrewTranslates)
            translate(screwTranslate)
                cylinder(d = mountingScrewHoleDiameter, h = holderBaseHeight);
        
    }

    difference()
    {
        // holder column
        translate([0, holderColumnYOffset, holderBaseHeight])
            cube(holderColumnDimensions);

        if(generateUpperHolder)
        {
            // cutout for leg
            translate([holderColumnWidth / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                xrot(-90)
                    difference()
                    {
                        cylinder(d = legOuterDiameter, h = legUpperIndentation);

                        cylinder(d = legInnerDiameter, h = legUpperIndentation);
                    }

            // cutout for leg screw
            translate([holderColumnWidth / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                xrot(-90) 
                    cylinder(d = legUpperScrewDiameter, h = holderColumnDepth);
            
        }
        else
        {
            // cutout for leg
            translate([holderColumnWidth / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                xrot(-90) 
                    cylinder(d = legOuterDiameter, h = holderColumnDepth - legFeetScrewOpening);
            
            translate([(holderColumnWidth - legOuterDiameter) / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                cube([legOuterDiameter, holderColumnDepth - legFeetScrewOpening, holderColumnHeight]);


            // cutout for feet screw
            translate([holderColumnWidth / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                xrot(-90) 
                    cylinder(d = legFeetScrewDiameter, h = holderColumnDepth);
            
            translate([(holderColumnWidth - legFeetScrewDiameter) / 2, holderColumnYOffset, holderBaseHeight + holderColumnHeight / 2])
                cube([legFeetScrewDiameter, holderColumnDepth, holderColumnHeight]);


            // cutout for leg dome
            translate([holderColumnWidth / 2, holderColumnYOffset + holderColumnDepth - legFeetDomeHeight, holderBaseHeight + holderColumnHeight / 2])
                xrot(-90) 
                    cylinder(d = legFeetDomeDiameter, h = legFeetDomeHeight);
        }
    }
}