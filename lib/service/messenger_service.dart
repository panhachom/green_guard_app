import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MessengerService {
  final BuildContext context;

  MessengerService._({
    required this.context,
  });

  static MessengerService of(BuildContext context) {
    return MessengerService._(context: context);
  }

  ScaffoldMessengerState? get state {
    return ScaffoldMessenger.maybeOf(context);
  }

  void clearSnackBars() {
    return state?.clearSnackBars();
  }

  void hideCurrentMaterialBanner() {
    return state?.hideCurrentMaterialBanner();
  }

  Future<T?> showLoading<T>({
    required Future<T?> Function() future,
    required String? debugSource,
    String Function(T?)? debugResult,
    Widget Function(BuildContext context, Widget child)? builder,
    bool rootNavigator = false,
    bool barrierDismissible = true,
  }) async {
    if (debugSource != null) debugPrint('LOADING $debugSource');
    bool popped = false;

    final Completer<T?> completer = Completer();
    future.call()
      ..then((value) => completer.complete(value))
      ..catchError((error, stackTrace) {
        completer.completeError(error, stackTrace);
        return null;
      });

    T? result = await showAdaptiveDialog<T?>(
      context: context,
      useRootNavigator: rootNavigator,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return FutureBuilder<T?>(
          future: completer.future,
          builder: (context, snapshot) {
            if (completer.isCompleted && !popped) {
              popped = true;
              Navigator.maybePop(context, snapshot.data);
            }

            final child = AlertDialog(
              alignment: Alignment.center,
              content: Lottie.asset(
                'assets/images/loading.json',
                width: 85,
                height: 85,
              ),
            );

            if (builder != null) return builder(context, child);
            return child;
          },
        );
      },
    );

    if (debugResult != null) {
      debugPrint('LOADED $debugSource with result: ${debugResult(result)}');
    } else if (debugSource != null) {
      debugPrint('LOADED $debugSource with result: ${result.runtimeType}');
    }

    return result;
  }
}
