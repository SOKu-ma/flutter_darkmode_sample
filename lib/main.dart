import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ダークモード判定用プロバイダー
final isDarkModeProvider = StateProvider((ref) => false);

// カウントアップ用プロバイダー
final counterProvider = StateProvider((ref) => 0);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ダークモード切替を監視
    final _isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      // テーマをダークモード時かどうかで切り替える
      theme: _isDarkMode
          ? ThemeData.dark()
          : ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter DarkMode Demo'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // カウントアップを監視
    final _counter = ref.watch(counterProvider);
    final _counterNotifier = ref.watch(counterProvider.notifier);

    // ダークモード切替を監視
    final _isDarkMode = ref.watch(isDarkModeProvider);
    final _isDarkModeNotifier = ref.watch(isDarkModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
            Switch(
              value: _isDarkMode,
              activeColor: _isDarkMode ? Colors.pink : Colors.blue,
              onChanged: (value) {
                _isDarkModeNotifier.update((state) => !state);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counterNotifier.update((state) => state + 1);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: _isDarkMode ? Colors.pink : Colors.blue,
      ),
    );
  }
}

///ダークモードかどうか
///true:dark, false:light
bool isDarkMode(BuildContext context) {
// Brightness platformBrightnessOf(BuildContext context) {
  final Brightness brightness = MediaQuery.platformBrightnessOf(context);
  // MediaQuery.maybeOf(context)?.platformBrightness ?? Brightness.light;
  // return MediaQuery.maybeOf(context)?.platformBrightness ?? Brightness.light;
  return brightness == Brightness.dark;
}
