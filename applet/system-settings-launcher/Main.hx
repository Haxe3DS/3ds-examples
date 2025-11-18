import haxe3ds.applet.Error;
import haxe3ds.services.APT;  // Needed for APT.jumpToSystemSettingsWithFlag
import haxe3ds.services.CFGU; // Needed to initialize region to use for APT.jumpToSystemSettingsWithFlag
import haxe3ds.services.GFX;  // So that we can use the console.
import haxe3ds.services.HID;  // For button inputs, duh.
import haxe3ds.Console;       // For debugging purposes.

/**
 * This is a list of flags that can be used for the system settings, for more info see enum APTSystemSettingsFlag
 */
final listsOfFlags:Array<APTSystemSettingsFlag> = [
	NORMAL,
	SETUP,
	INTERNET_SETTINGS_CONFIGURATION_PAGE,
	INTERNET_SETTINGS_OTHER_SETTINGS,
	INTERNET_SETTINGS,
	PARENTAL_CONTROLS,
	DATA_MANAGEMENT,
	SOFTWARE_MANAGEMENT_SOFTWARES,
	SOFTWARE_MANAGEMENT_EXTRA_DATA,
	NINTENDO_DSI_SOFTWARES,
	STREETPASS_DATA_MANAGEMENT,
	OTHER_SETTINGS_PAGE_4,
	OTHER_SETTINGS_TOUCH_CALIBRATION,
	OTHER_SETTINGS_CIRCLE_PAD,
	OTHER_SETTINGS_SYSTEM_UPDATE,
	OTHER_SETTINGS_FORMAT_SYSTEM
];

/**
 * the index that we will choose for the list of flags up above.
 */
var index:Int = 0;

function print(add:Int) {
	Console.clear(); // clear the screen to avoid going out of bounds

	// add and clamp the index so that we are in bounds of listsOfFlags
	index += add;
	index = index < 0 ? 0 : index >= listsOfFlags.length ? listsOfFlags.length - 1 : index;

	// a lot of printings.
	Sys.println("0:  NORMAL");
	Sys.println("1:  SETUP");
	Sys.println("2:  INTERNET_SETTINGS_CONFIGURATION_PAGE");
	Sys.println("3:  INTERNET_SETTINGS_OTHER_SETTINGS");
	Sys.println("4:  INTERNET_SETTINGS");
	Sys.println("5:  PARENTAL_CONTROLS");
	Sys.println("6:  DATA_MANAGEMENT");
	Sys.println("7:  SOFTWARE_MANAGEMENT_SOFTWARES");
	Sys.println("8:  SOFTWARE_MANAGEMENT_EXTRA_DATA");
	Sys.println("9:  NINTENDO_DSI_SOFTWARES");
	Sys.println("10: STREETPASS_DATA_MANAGEMENT");
	Sys.println("11: OTHER_SETTINGS_PAGE_4 (real hw freezes)");
	Sys.println("12: OTHER_SETTINGS_TOUCH_CALIBRATION");
	Sys.println("13: OTHER_SETTINGS_CIRCLE_PAD");
	Sys.println("14: OTHER_SETTINGS_SYSTEM_UPDATE");
	Sys.println("15: OTHER_SETTINGS_FORMAT_SYSTEM");
	Sys.print('\nYour Index: $index\n\n[A]: Launch\n[START]: Exit\n[DPAD LEFT/RIGHT]: Change Index\n\n');
}

/**
 * This is where your code will be ran when game is compiled.
 */
function main() {
	// initialize gfx and cfgu, enable console too.
	GFX.initDefault();
	CFGU.init();
	Console.init(GFX_TOP);
	
	print(0); // setup by printing it.

	// main loop
	while (APT.mainLoop()) {
		if (HID.keyPressed(Key.START)) {
			break; // if we pressed the key START, exit this program.
		} else if (HID.keyPressed(Key.A)) {
			Sys.println(APT.jumpToSystemSettingsWithFlag(listsOfFlags[index]).toString()); // if we pressed the key A, call this function with the index from listofflags
			Sys.println("Goodbye!"); // goodbye indeed, we are jumping to system setings
		}

		// some dpad handler for index.
		if (HID.keyPressed(Key.DLEFT)) {
			print(-1);
		} else if (HID.keyPressed(Key.DRIGHT)) {
			print(1);
		}
	}

	// exit cfgu and gfx, we don't need it anymore.
	CFGU.exit();
	GFX.exit();
}