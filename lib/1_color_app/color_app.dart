import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType { red, blue, green, pink }

extension CardTypeExtension on CardType {
  Color get color {
    switch (this) {
      case CardType.red:
        return Colors.red;
      case CardType.blue:
        return Colors.blue;
      case CardType.green:
        return Colors.green;
      case CardType.pink:
        return Colors.pink;
    }
  }

  // Capitalises the enum name → "Red", "Blue", "Green", etc.
  String get label => name[0].toUpperCase() + name.substring(1);
}

final ColorService colorService = ColorService();

class ColorService extends ChangeNotifier {
  final Map<CardType, int> _counts = {
    for (final type in CardType.values) type: 0,
  };

  Map<CardType, int> get counts => Map.unmodifiable(_counts);

  int countFor(CardType type) => _counts[type] ?? 0;

  void increment(CardType type) {
    _counts[type] = (_counts[type] ?? 0) + 1;
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? const ColorTapsScreen()
          : const StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

// ─── ColorTapsScreen ──────────────────────────────────────────────────────────
// Q1: No parameters — accesses global colorService directly.
// Q2: Iterates CardType.values so new colors appear automatically.
class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Taps')),
      body: Column(
        children: [
          for (final type in CardType.values)
            ListenableBuilder(
              listenable: colorService,
              builder: (context, child) {
                return ColorTap(
                  type: type,
                  tapCount: colorService.countFor(type),
                  onTap: () => colorService.increment(type),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;
  final int tapCount;
  final VoidCallback onTap;

  const ColorTap({
    super.key,
    required this.type,
    required this.tapCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListenableBuilder(
        listenable: colorService,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final entry in colorService.counts.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      '${entry.key.label} Taps: ${entry.value}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
