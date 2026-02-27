import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo app',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Demo app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _centerKey = GlobalKey();
  late String message;

  @override
  void initState() {
    super.initState();
    message =
        'Flutter popup card demo app. Click the account icon in the top right.';
  }

  Future<void> _accountClicked() async {
    final result = await showPopupCard<String>(
      context: context,
      builder: (context) {
        return PopupCard(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: const PopupCardDetails(),
        );
      },
      offset: const Offset(-8, 60),
      alignment: Alignment.topRight,
      useSafeArea: true,
      dimBackground: true,
    );
    if (result == null) return;
    setState(() {
      message = result;
    });
  }

  Future<void> _centerClicked() async {
    final result = await showPopupCard<String>(
      context: context,
      builder: (context) {
        return PopupCard(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: const PopupCardDetails(),
        );
      },
      anchorKey: _centerKey,
      alignment: Alignment.bottomCenter,
      useSafeArea: true,
      dimBackground: true,
    );
    if (result == null) return;
    setState(() {
      message = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _accountClicked,
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              TextButton(
                key: _centerKey,
                onPressed: () {
                  _centerClicked();
                },
                child: Text('Open card here'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            message = 'Reset.';
          });
        },
        child: const Icon(Icons.restore),
      ),
    );
  }
}

class PopupCardDetails extends StatelessWidget {
  const PopupCardDetails({super.key});

  void _logoutPressed(BuildContext context) {
    Navigator.of(context).pop('Logout pressed');
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(450, MediaQuery.sizeOf(context).width - 16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24.0),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            radius: 36,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Text(
              'AB',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Able Bradley',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'able.bradley@gmail.com',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8.0),
          const Divider(),
          TextButton(
            onPressed: () => _logoutPressed(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
