import 'package:flutter/material.dart';
import 'package:min_absen/templates/text_style_template.dart';

class AlertDialogTemplate {

  void showTheDialog({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyleTemplate.mediumGray(size: 18),
        ),
        content: Text(
          content,
          style: TextStyleTemplate.regularGray(size: 16),
        ),
        actions: actions,
      ),
    );
  }
}
