import 'package:flutter/material.dart';

mixin AuthFormMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  void showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> runAuthRequest(Future<void> Function() action) async {
    setState(() {
      isLoading = true;
    });
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
