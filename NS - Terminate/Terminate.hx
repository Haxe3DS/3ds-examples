// Import all class needed.
import haxe3ds.Console;
import haxe3ds.services.APT;
import haxe3ds.services.GFX;
import haxe3ds.services.HID;
import haxe3ds.services.NS;
import haxe3ds.util.Env;

// Main Function
function main() {
    // Initializes all libraries
	GFX.initDefault();
	NS.init();
	Console.init(GFX_TOP);

    // Printing
	Sys.println("Haxe3DS Terminate Title Test");
	Sys.println("A     - Calls NS.terminate()");
	Sys.println('Start - Exits ${Env.is3DSX ? "3DSX" : "Application"}');

    // Main Loop.
	while (APT.mainLoop()) {
        // Scan and check if Key [A] is pressed.
		HID.scanInput();
		if (HID.keyPressed(Key.A)) {
			NS.terminate(); // Terminate!
		}

        // Checks if key [START] is pressed.
		if (HID.keyPressed(Key.START)) {
			break; // Break loop.
		}
	}

    // Exits Services and exits application/3dsx.
	NS.exit();
	GFX.exit();
}