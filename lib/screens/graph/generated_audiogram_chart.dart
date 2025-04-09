import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/screens/graph/audiogram_chart.dart';

class GeneratedAudiogramChart extends StatelessWidget {
  const GeneratedAudiogramChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audiogram')),
      body: Center(
        child: AudiogramChart(),
      ),
    );
  }
}
