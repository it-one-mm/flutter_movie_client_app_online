import 'dart:io';

class InternetHandler {
  static const String host = 'example.com';

  static Future<void> checkConnection(
      {Function onSuccess, Function onError}) async {
    try {
      final result = await InternetAddress.lookup(host);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connected to the Internet
        if (onSuccess != null) onSuccess();
      }
    } on SocketException {
      // No Internet
      if (onError != null) onError();
    }
  }
}
