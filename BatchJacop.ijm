#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".czi") suffix

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

function processFile(input, output, file) {
	run("Bio-Formats Importer", "open=["+input + File.separator + file+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	title=getTitle();
	run("BIOP JACoP", "channel_a=1 channel_b=3 threshold_for_channel_a=Huang threshold_for_channel_b=Default manual_threshold_a=0 manual_threshold_b=0 set_auto_thresholds_on_stack_histogram get_manders costes_block_size=5 costes_number_of_shuffling=100");
	saveAs("tiff", output+ File.separator +title+"_composite.tif");
	selectWindow("Results");
	saveAs("Results", output+ File.separator +title+"_Results.csv");
	run("Close");
	close("*");
	
}

