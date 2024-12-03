#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Boolean (label = "Save image result") checkbox

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file){
	setBatchMode(true);
	open(input + File.separator + file);
	title=getTitle();
	makeRectangle(0, 0, 428, 684);
	run("Duplicate...", "title=Ch1 duplicate");
	selectWindow(title);
	makeRectangle(428, 0, 428, 684);
	run("Duplicate...", "title=Ch2 duplicate");
	run("Merge Channels...", "c2=Ch1 c6=Ch2 create keep");
	close("\\Others");
	run("Detect Particles", "calculate max=2 rois=Ovals add=Nothing summary=Reset ch1i ch1a=1 ch1s=10 ch2i ch2a=1 ch2s=3");
	selectWindow("Summary");
	saveAs("Results", output+ File.separator +title+"_Summary.csv");
	run("Close");
	selectWindow("Results");
	saveAs("Results", output+ File.separator +title+"_Results.csv");
	run("Close");
	selectWindow("Composite");
	if (checkbox) {
		saveAs("Tiff", output+ File.separator +title+"_Detections.tif");
	}
	close("*");
	setBatchMode(false);
}