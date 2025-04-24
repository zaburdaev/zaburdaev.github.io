import 'package:flutter/material.dart';
import 'dart:async';
import 'l10n.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int pomodoroMinutes = 25;
  int secondsLeft = pomodoroMinutes * 60;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (timer != null) return;
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        t.cancel();
        timer = null;
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      secondsLeft = pomodoroMinutes * 60;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loc.get('pomodoro_timer'),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            '$minutes:${seconds}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isRunning ? null : startTimer,
                child: Text(loc.get('start')),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: isRunning ? stopTimer : null,
                child: Text(loc.get('stop')),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text(loc.get('reset')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}