// Import all class needed.
import haxe3ds.Console;
import haxe3ds.services.APT;
import haxe3ds.services.FS;
import haxe3ds.services.GFX;
import haxe3ds.services.HID;
import haxe3ds.services.HTTPC;
import haxe3ds.services.HTTPC.HTTPCInfo;
import haxe3ds.services.HTTPC.HTTPContext;
import cxx.VoidPtr;

// Declare this file, this will be used in the main function.
var file:FSFile;

// Use a built in feature from haxe that converts a pointer to integer
function toInt(ptr:VoidPtr):Int {
	return cast(ptr, Int);
}

// Function that handles downloaded data from HTTP.
function httpHandler(info:HTTPCInfo, array:Array<VoidPtr>) {
	// There's multiple in HTTPCInfo, so let's just use a switch.
	switch (info) {
		case DOWNLOAD_PENDING: // 1
			// Write to a file using void.
			file.writeVoid(array[0], toInt(array[1]));

			// And just print the progress.
			Sys.println('Total: ${toInt(array[2])} / ${toInt(array[3])} (Downloaded ${toInt(array[1])} bytes.)');

		case DOWNLOAD_FINISHED: // 2
			// Close the file.
			file.close();

			// Printing to say you can now exit.
			Sys.println('${ConsoleColor.textGreen}Everything\'s downloaded!${ConsoleColor.textWhite}');
			Sys.println("Press [START] to exit.");
	}
}

// Main function.
function main() {
	// Initialize GFX, FS, HTTPC and Console.
	GFX.initDefault();
	FS.init();
	HTTPC.init();
	Console.init(GFX_TOP);

	// Create an instance for the context.
	// We will use a url from devkitPro for this. It's only content size is 230,400 bytes.
	var http:HTTPContext = new HTTPContext("http://devkitpro.org/misc/httpexample_rawimg.rgb", httpHandler);

	// Set the download speed to any amount, for buffer safety use a less number for this!
	// its default is 0x4000 (16384) but you can also use 0x8000 (32768)
	http.downloadSpeed = 0x8000; // 32768

	// And construct the file too using this path.
	file = new FSFile(http.file);

	// Resize to 0 to remove any existing data.
	file.resize(0);

	// Start the request.
	Sys.println('Now downloading the file from ${http.url}, and saving it in sdmc:${http.file}.');
	http.request();

	// Print the response that we've gotten.
	Sys.println('Result: ${http.reason} (${http.result})');

	// Main Loop
	while (APT.mainLoop()) {
		if (HID.keyPressed(Key.START)) {
			break;
		}
	}

	HTTPC.exit();
	FS.exit();
	GFX.exit();
}
