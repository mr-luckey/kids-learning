import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Single connectivity signal for ads. Not a guarantee of internet.
///
/// If the native plugin is missing (common after hot reload when a package
/// was just added), treat connectivity as unknown/online so gameplay and
/// ads are not hard-blocked. Do a full stop + rebuild to register plugins.
class NetworkGuard {
  NetworkGuard({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _online = true;
  bool _pluginAvailable = true;
  VoidCallback? _onOnline;
  Timer? _debounce;

  bool get isOnline => _online;
  bool get pluginAvailable => _pluginAvailable;

  Future<void> start({VoidCallback? onOnline}) async {
    _onOnline = onOnline;
    try {
      _online = _usable(await _connectivity.checkConnectivity());
      _pluginAvailable = true;
    } on MissingPluginException catch (error) {
      debugPrint(
        'NetworkGuard: connectivity plugin missing ($error). '
        'Stop the app and do a full rebuild — hot reload cannot register new plugins.',
      );
      _pluginAvailable = false;
      _online = true;
      return;
    } catch (error) {
      debugPrint('NetworkGuard check failed: $error');
      _online = true;
    }

    try {
      await _subscription?.cancel();
      _subscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          final bool next = _usable(results);
          if (next == _online) return;
          _online = next;
          if (!next) return;
          _debounce?.cancel();
          _debounce = Timer(const Duration(seconds: 2), () {
            if (_online) _onOnline?.call();
          });
        },
        onError: (Object error) {
          debugPrint('NetworkGuard stream error: $error');
          if (error is MissingPluginException) {
            _pluginAvailable = false;
            _online = true;
          }
        },
        cancelOnError: false,
      );
    } on MissingPluginException catch (error) {
      debugPrint('NetworkGuard listen missing plugin: $error');
      _pluginAvailable = false;
      _online = true;
    } catch (error) {
      debugPrint('NetworkGuard listen failed: $error');
    }
  }

  Future<void> dispose() async {
    _debounce?.cancel();
    await _subscription?.cancel();
    _subscription = null;
  }

  static bool _usable(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((ConnectivityResult r) => r != ConnectivityResult.none);
  }
}
