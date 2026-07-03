import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FileLoader fileLoader;
  RiveWidgetController? _controller;
  TriggerInput? _triggerSuccess;
  TriggerInput? _triggerFailed;
  TriggerInput? _triggerThinking;

  @override
  void initState() {
    super.initState();
    fileLoader = FileLoader.fromAsset('assets/greg_the_frog.riv', riveFactory: Factory.rive);
  }

  @override
  void dispose() {
    super.dispose();
    fileLoader.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Froggy Math'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: RiveWidgetBuilder(
                fileLoader: fileLoader,
                builder: (context, state) => switch (state) {
                  RiveLoading() => Center(child: CircularProgressIndicator()),
                  RiveFailed() => Center(child: Text(state.error.toString())),
                  RiveLoaded() => Builder(
                    builder: (context) {
                      if (_controller != state.controller) {
                        _controller = state.controller;
                        _triggerSuccess = state.controller.stateMachine.trigger('Hi');

                        _triggerFailed = state.controller.stateMachine.trigger('Annoyed');
                        _triggerThinking = state.controller.stateMachine.trigger('Curious');
                      }
                      return RiveWidget(controller: state.controller, fit: Fit.cover);
                    },
                  ),
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _triggerSuccess?.fire();
            },
            child: Icon(Icons.back_hand),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {
              _triggerFailed?.fire();
            },
            child: Icon(Icons.error),
          ),
          SizedBox(height: 12),

          FloatingActionButton(
            onPressed: () {
              _triggerThinking?.fire();
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
