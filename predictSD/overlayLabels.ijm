paths = getArgument();
argList = split(paths, ";;");

chn = parseInt(argList[3]) + 1;

// Flatten microscopy image based on max intensity
open(argList[1]);
iLabel=getTitle();
run("Duplicate...", "duplicate channels="+chn+"");
close(iLabel)
run("Enhance Contrast", "saturated=0.35");

if(nSlices > 1) {
    run("Z Project...", "projection=[Max Intensity]");
}
pImg=getTitle();

// Flatten label image based on maximum intensity, i.e. largest label ID is drawn on top of smaller
open(argList[2]);
if(nSlices > 1) {
    run("Z Project...", "projection=[Max Intensity]");
}
pLabel=getTitle();

// Merge flattened images and set color maps
run("Merge Channels...", "c1=["+pImg+"] c2=["+pLabel+"] create");
Stack.setDisplayMode("color");
Stack.setChannel(1);
run("Grays");
Stack.setChannel(2);
// Apply color to labels
run(argList[4]);

Stack.setDisplayMode("composite");

save(argList[0]);
run("Close All");
//run("Quit");