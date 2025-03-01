import 'package:eventvista/flavors/flavor_config.dart';

const CONNECT_TIMEOUT = 60 * 1000;
const RECEIVE_TIMEOUT = 60 * 1000;

class IPAddress {
  /// DEV
  static const String DEV = 'jsonplaceholder.typicode.com/';

  /// STAGING
  static const String STG = 'jsonplaceholder.typicode.com/';

  /// PRE_PRODUCTION
  static const String PRE_PROD = 'jsonplaceholder.typicode.com/';

  /// PRODUCTION
  static const String PROD = 'jsonplaceholder.typicode.com/';
}

class ServerProtocol {
  static const String DEV = 'https://';
  static const String STG = 'https://';
  static const String PRE_PROD = 'https://';
  static const String PROD = 'https://';
}

class NetworkConfig {
  static String getNetworkUrl() {
    String url = _getProtocol() + _getBaseURL();
    return url;
  }

  static String _getProtocol() {
    if (FlavorConfig.isDevelopment()) {
      return ServerProtocol.DEV;
    } else if (FlavorConfig.isStaging()) {
      return ServerProtocol.STG;
    } else if (FlavorConfig.isPreProduction()) {
      return ServerProtocol.PRE_PROD;
    } else {
      return ServerProtocol.PROD;
    }
  }

  static String _getBaseURL() {
    if (FlavorConfig.isDevelopment()) {
      return IPAddress.DEV;
    } else if (FlavorConfig.isStaging()) {
      return IPAddress.STG;
    } else if (FlavorConfig.isPreProduction()) {
      return IPAddress.PRE_PROD;
    } else {
      return IPAddress.PROD;
    }
  }
}
