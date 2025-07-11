import 'dart:io';
import 'package:injectable/injectable.dart';

/// Abstract interface for checking network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo that checks internet connectivity
@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => _hasNetworkConnection();

  Future<bool> _hasNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
