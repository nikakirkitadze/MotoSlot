import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/design_system.dart';

class AppLoading extends StatelessWidget {
  final String? message;

  const AppLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return const AppLoadingIndicator();
  }
}
