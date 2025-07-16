import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ExplorerRouterScreen extends StatelessWidget {
  const ExplorerRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}
