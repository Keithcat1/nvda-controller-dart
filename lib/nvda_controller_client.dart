import "package:ffi/ffi.dart";
import "nvda_controller_client_bindings.dart";
import "dart:ffi";
import "dart:io";
// NVDA controller doesn't appear to provide any info on an error
class NvdaException extends Error {}

// the DLL is loaded lazily when one of the static functions here is called
class Nvda {
  // the name of the dll
  late final NvdaControllerApi _dll;
  static const dllName = "nvdaControllerClient64";
  String _getPath(String? pathToDll) {
    pathToDll ??= dllName;
    return pathToDll;
  }

  Nvda({String? pathToDll } ) {
		_dll = NvdaControllerApi(DynamicLibrary.open(_getPath(pathToDll)));
	}

	bool get testIfRunning => _dll.nvdaController_testIfRunning() == 0;

  void speakText(String text) {
    final ctext = text.toNativeUtf16(allocator: calloc).cast<Uint16>();
    final result = _dll.nvdaController_speakText(ctext);
    try {
      if(result != 0) {
        throw NvdaException();
      }
    } finally {
      calloc.free(ctext);
    }
  }



  void brailleText(String text) {
    final ctext = text.toNativeUtf16(allocator: calloc).cast<Uint16>();
    final result = _dll.nvdaController_brailleMessage(ctext);
    try {
      if(result != 0) {
        throw NvdaException();
      }
    } finally {
      calloc.free(ctext);
    }
  }

  void cancelSpeech() {
    if(_dll.nvdaController_cancelSpeech() != 0) {
      throw NvdaException();
    }
  }
  // like calling both brailleText(text) and speakText(text), but more efficient since it uses the same C string for both calls
  void outputText(String text) {
    final ctext = text.toNativeUtf16(allocator: calloc).cast<Uint16>();
    try {
      final result = _dll.nvdaController_speakText(ctext);
      if(result != 0) {
        throw NvdaException();
      }
      final result2 = _dll.nvdaController_brailleMessage(ctext);
      if(result2 != 0) {
        throw NvdaException();
      }
    } finally {
      calloc.free(ctext);
    }
  }




}