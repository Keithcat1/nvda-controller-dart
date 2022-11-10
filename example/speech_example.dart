import "package:nvda_controller_client/nvda_controller_client.dart";
import "dart:io";
void main() {
	final nvda = Nvda();
	final stuff = ["This", "is", "a", "self", "voicing", "program", "sort of"];
	for(final i in stuff) {
    sleep(const Duration(seconds: 1));
		nvda.speakText(i);
	}
}