import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class ToastService {
  /// Show a simple error toast
  static void showError(BuildContext context, String message, {String? title}) {
    CherryToast.error(
      title: Text(
        title ?? 'Error',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,

      toastDuration: const Duration(seconds: 3),
      displayCloseButton: true,

      borderRadius: 12,
      backgroundColor: Colors.red,
    ).show(context);
  }

  /// Show a success toast
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    CherryToast.success(
      title: Text(
        title ?? 'Success',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      toastDuration: const Duration(seconds: 3),
      borderRadius: 12,
    ).show(context);
  }

  /// Show a warning toast
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
  }) {
    CherryToast.warning(
      title: Text(
        title ?? 'Warning',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      toastDuration: const Duration(seconds: 3),
      borderRadius: 12,
    ).show(context);
  }
}
