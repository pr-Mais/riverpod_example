import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. Create a provider
/// 2. Consume/read a provider
/// 3. Combine/transform providers [Computed]
/// 4. Use multiple providers of the same type
void main() {
  runApp(
    ProviderScope(
      child: CounterApp(),
    ),
  );
}

final _counter1Provider = StateProvider((_) => 0);
final _counter2Provider = StateProvider((_) => 0);

class Counter {
  static get multiply => Computed((watch) {
        final counter1 = watch(_counter1Provider).state;
        final counter2 = watch(_counter2Provider).state;

        return counter1 * counter2;
      });
  static get sub => Computed((watch) {
        final counter1 = watch(_counter1Provider).state;
        final counter2 = watch(_counter2Provider).state;

        return counter1 - counter2;
      });
}

class CounterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterText(provider: _counter1Provider),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () => _counter1Provider.read(context).state++,
            ),
            SizedBox(height: 50),
            CounterText(provider: _counter2Provider),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () => _counter2Provider.read(context).state++,
            ),
            SizedBox(height: 50),
            Consumer((context, watch) {
              final m = watch(Counter.multiply);
              final s = watch(Counter.sub);

              return Column(
                children: [
                  Text(
                    "Multiplication: $m",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    "Substraction: $s",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({
    Key key,
    this.provider,
  }) : super(key: key);

  final provider;

  @override
  Widget build(BuildContext context) {
    return Consumer((context, watch) {
      final counter = watch(provider).state;
      return Text(
        "$counter",
        style: Theme.of(context).textTheme.headline3,
      );
    });
  }
}
