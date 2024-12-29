import 'package:coc_calculater/provider/provider.dart';
import 'package:coc_calculater/responsive/desktop_body.dart';
import 'package:coc_calculater/responsive/mobile_body.dart';
import 'package:coc_calculater/responsive/tablet_body.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final damagesModelAsyncValue = ref.watch(damagesProvider);

    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBody(),
        tabletBody: TabletBody(),
        desktopBody: DesktopBody(),
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return mobileBody;
    } else if (width < 1200) {
      return tabletBody;
    } else {
      return desktopBody;
    }
  }
}
