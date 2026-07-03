import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RiveNative.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FileLoader loader;
  @override
  void initState() {
    super.initState();
    loader = FileLoader.fromAsset('assets/greg_the_frog.riv', riveFactory: Factory.rive);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loader.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Math App')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.red,
              child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: RiveWidgetBuilder(
                    fileLoader: loader,
                    builder: (context, state) {
                      if (state is RiveLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is RiveFailed) {
                        return Center(child: Text(state.error.toString()));
                      }

                      if (state is RiveLoaded) {
                        return RiveWidget(controller: state.controller, fit: Fit.cover);
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
