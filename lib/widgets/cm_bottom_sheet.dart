import 'package:flutter/material.dart';
import 'package:green_guard_app/widgets/base_cm_bottom_sheet.dart';

class CmBottomSheet<T> extends BaseCmBottomSheet<T> {
  const CmBottomSheet({
    super.title,
    this.contentBuilder,
    super.crossAxisAlignment,
    super.message,
    super.includePlatformBottomPadding,
  });

  final Widget Function(BuildContext context)? contentBuilder;

  @override
  Widget buildBottomSheet(BuildContext context) {
    double viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) buildTitle(context),
        if (message != null) buildMessage(context),
        if (contentBuilder != null)
          Flexible(child: Wrap(children: [contentBuilder!(context)])),
        if (includePlatformBottomPadding)
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        SizedBox(height: viewInsetsBottom)
      ],
    );
  }
}
