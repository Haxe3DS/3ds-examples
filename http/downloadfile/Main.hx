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

// Uninitialize this file, this will be used in the main function.
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
			// Write to a file.
			file.write(untyped __cpp__('(char*)({0})', array[0]), toInt(array[1]));

			// And just print the progress.
			Sys.println('Total: ${toInt(array[2])} / ${toInt(array[3])} (Downloaded ${toInt(array[1])} bytes.)');

			// To know what those magic "array" means, if using vscode just hover the DOWNLOAD_PENDING enum.
			// Or just see this: https://github.com/Haxe3DS/Haxe3DS/blob/main/haxe3ds/services/HTTPC.hx#L11

		case DOWNLOAD_FINISHED: // 2
			// Close the file.
			file.close();

			// Printing to say you can now exit.
			Sys.println("Everything's downloaded!");
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

	// Create a constructor for the context.
	var http:HTTPContext = new HTTPContext("https://raw.githubusercontent.com/JordanSantiagoYT/Mods-for-JS-Engine/refs/heads/main/LONGSONG/data/desert-bus/Desert-bus.json", httpHandler);

	// And construct the file too using this path.
	file = new FSFile(http.file);

	// Resize to 0 to remove any existing data.
	file.resize(0);

	// Start the request.
	Sys.println('Now downloading the file from ${http.url}, and saving it in sdmc:${http.file}.');
	http.request();

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