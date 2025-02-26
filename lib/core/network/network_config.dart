import 'package:eventvista/flavors/flavor_config.dart';

const CONNECT_TIMEOUT = 60 * 1000;
const RECEIVE_TIMEOUT = 60 * 1000;

class IPAddress {
  /// DEV
  static const String DEV = 'dev-api-refresh.shopease.co/v1/';

  /// STAGING
  static const String STG = 'qa-api-refresh.shopease.co/v1/';

  /// PRE_PRODUCTION
  static const String PRE_PROD = 'api-pre-prod-refresh.shopease.co/v1/';

  /// PRODUCTION
  static const String PROD = 'qa-api-refresh.shopease.co/v1/';
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
