import 'package:flutter/material.dart';

abstract class BaseCmBottomSheet<T> {
  const BaseCmBottomSheet({
    this.title,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.message,
    this.includePlatformBottomPadding = true,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final String? title;
  final String? message;
  final bool includePlatformBottomPadding;

  Future<T?> show(
    BuildContext context, {
    bool useRootNavigator = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      enableDrag: false,
      showDragHandle: Theme.of(context).bottomSheetTheme.showDragHandle,
      constraints: const BoxConstraints(maxWidth: 560), // default: 640
      elevation: Theme.of(context).bottomSheetTheme.elevation,
      builder: (context) {
        return buildBottomSheet(context);
      },
    );
  }

  Widget buildBottomSheet(BuildContext context);

  Widget buildMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: textAlignment,
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0),
      child: Text(
        message!,
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0)
          .copyWith(bottom: message != null ? 8.0 : 16.0),
      alignment: textAlignment,
      child: Text(
        title!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Alignment get textAlignment {
    Alignment alignment;
    switch (crossAxisAlignment) {
      case CrossAxisAlignment.start:
        alignment = Alignment.centerLeft;
        break;
      case CrossAxisAlignment.end:
        alignment = Alignment.centerRight;
        break;
      case CrossAxisAlignment.center:
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        alignment = Alignment.center;
        break;
    }
    return alignment;
  }
}
