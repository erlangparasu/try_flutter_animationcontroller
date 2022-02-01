import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Created by Erlang Parasu 2022

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AnimationController',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter AnimationController'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;

  final List<AnimationController> _animControllers = [];
  final List<Animation<double>> _animCars = [];
  bool _isAnimForward = true;

  final List<int> _durationList = [
    2465, // 2.4 detik
    4070, // 4.0 detik
    3696, // 3.6 detik
  ];

  @override
  void initState() {
    super.initState();

    _animControllers.clear();
    _animCars.clear();
    for (var dur in _durationList) {
      _addAnimController(dur);
    }
  }

  // @override
  // void didUpdateWidget(Foo oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _controller.duration = widget.duration;
  // }

  @override
  void dispose() {
    for (var c in _animControllers) {
      c.dispose();
    }
    _animControllers.clear();
    _animCars.clear();

    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      if (_isAnimForward) {
        for (var c in _animControllers) {
          c.forward();
        }
      } else {
        for (var c in _animControllers) {
          c.reverse();
        }
      }

      _isAnimForward = !_isAnimForward;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _generateOneRoad(_animCars[0]),
                  _generateOneRoad(_animCars[1]),
                  _generateOneRoad(_animCars[2]),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addAnimController(int durationMilis) {
    var animController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: durationMilis),
    );

    CurvedAnimation curved1 = CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOut,
    );

    _animControllers.add(animController);
    _animCars.add(curved1);
  }

  AnimatedBuilder _generateOneRoad(Animation<double> anim) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, w) {
        return Row(
          children: [
            Expanded(
              child: CupertinoSlider(
                value: anim.value,
                onChanged: (value) {},
              ),
            )
          ],
        );
      },
    );
  }
}
