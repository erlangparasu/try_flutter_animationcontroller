import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Created by Erlang Parasu 2022

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AB Race Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AB Race Flutter'),
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
  bool _isAnimForward = false;

  late TextEditingController _textController1;
  late TextEditingController _textController2;
  late TextEditingController _textController3;

  final List<int> _durationList = [
    2465, // 2.4 detik
    4070, // 4.0 detik
    3696, // 3.6 detik
  ];

  String _hashTmp = '';

  @override
  void initState() {
    super.initState();

    _textController1 = TextEditingController(text: _durationList[0].toString());
    _textController2 = TextEditingController(text: _durationList[1].toString());
    _textController3 = TextEditingController(text: _durationList[2].toString());

    _animControllers.clear();
    _animCars.clear();

    var num1 = _textController1.value.text;
    var num2 = _textController2.value.text;
    var num3 = _textController3.value.text;

    _addAnimController(int.parse(num1));
    _addAnimController(int.parse(num2));
    _addAnimController(int.parse(num3));
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

      var num1 = _textController1.value.text;
      var num2 = _textController2.value.text;
      var num3 = _textController3.value.text;

      var hashNew = num1.toString() + num2.toString() + num3.toString();
      if (hashNew != _hashTmp) {
        _hashTmp = hashNew;

        /// Clear
        for (var c in _animControllers) {
          c.dispose();
        }

        _animControllers.clear();
        _animCars.clear();

        /// Add
        _addAnimController(int.parse(num1));
        _addAnimController(int.parse(num2));
        _addAnimController(int.parse(num3));
      }

      _isAnimForward = !_isAnimForward;
      if (_isAnimForward) {
        for (var c in _animControllers) {
          c.forward();
        }
      } else {
        for (var c in _animControllers) {
          c.reverse();
        }
      }
    });
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
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoTextField(
                controller: _textController1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoTextField(
                controller: _textController2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoTextField(
                controller: _textController3,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
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
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Builder(
          builder: (context) {
            if (!_isAnimForward) {
              return const Icon(Icons.play_arrow);
            } else {
              return const RotatedBox(
                quarterTurns: 90,
                child: Icon(Icons.play_arrow),
              );
            }
          },
        ),
      ),
    );
  }
}
