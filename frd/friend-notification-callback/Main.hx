// Import all class needed.
import haxe3ds.Console;
import haxe3ds.services.APT;
import haxe3ds.services.FRD;
import haxe3ds.services.GFX;
import haxe3ds.services.HID;

// The whole callback.
function friendCallback(profile:FRDFriendDetail, type:FRDNotifTypes) {
	Sys.println('\nGot NEW callback! (${Std.string(type)})');
	Sys.print("\t- ");

	// Using a switch so that you'll know what this means.
	switch (type) {
		case SELF_ONLINE: // 1
			Sys.println("You're online!");
		case SELF_OFFLINE: // 2
			Sys.println("You're offline!");
		case FRIEND_ONLINE: // 3
			Sys.println("Friend is online!");
		case FRIEND_PRESENCE_CHANGED: // 4
			Sys.println("Friend's presence changed!");
		case FRIEND_MII_CHANGED: // 5
			Sys.println("Mii is changed!");
		case FRIEND_PROFILE_CHANGED: // 6
			Sys.println("Friend's profile changed!");
		case FRIEND_OFFLINE: // 7
			Sys.println("Friend is offline!");
		case FRIEND_REGISTERED: // 8
			Sys.println("Friend registered you!");
		case FRIEND_GOT_INVITED: // 9
			Sys.println("You got invited!");
	}

	// Avoid if it's console related.
	if (type != SELF_ONLINE && type != SELF_OFFLINE) {
		Sys.println('Comment:   ${profile.comment}');
		Sys.println('Fav Game:  ${profile.favoriteGameTID}');
		Sys.println('Male:      ${profile.male}');
		Sys.println('Name:      ${profile.displayName}');
		Sys.println('PID:       ${profile.principalID}');
		Sys.println('Relation:  ${profile.relationship}');
		Sys.println('Timestamp: ${profile.addedTimestamp}');
	}
}

// Main function.
function main() {
	// Initializes services and console.
	GFX.initDefault();
	FRD.init();
	Console.init(GFX_TOP);

	// Set callback to a function.
	FRD.notifCallback = friendCallback;

	Sys.println("Callback Initialized!");
	Sys.println("Press [START] to exit thread and deinit callbacks.");
	Sys.println("Note that if you want this to happen quick, just use an emulator or just get a lot of friends!");

	// Main Loop
	while (APT.mainLoop()) {
		if (HID.keyPressed(Key.START)) {
			break;
		}
	}

	// Exit Services
	FRD.exit();
	GFX.exit();
}