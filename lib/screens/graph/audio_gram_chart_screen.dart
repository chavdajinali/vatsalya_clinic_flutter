import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:vatsalya_clinic/main.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/report_name_add_model.dart';
import 'package:vatsalya_clinic/utils/app_utils.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';
import 'package:vatsalya_clinic/utils/ReusableCheckbox.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';

import '../../utils/audio_gram_pdf_generator.dart';

class AudioGramChartScreen extends StatefulWidget {
  final AppointmentModel appointmentModel;

  const AudioGramChartScreen({super.key, required this.appointmentModel});

  @override
  State<AudioGramChartScreen> createState() => _AudioGramChartScreenState();
}

class _AudioGramChartScreenState extends State<AudioGramChartScreen> {
  String? selectedReport;
  List<ReportNameAddModel> reportNames = [];

  final dropDownKey = GlobalKey<DropdownSearchState>();
  final GlobalKey _chartKey = GlobalKey();
  final List<List<TextEditingController>> _controllers = List.generate(
    14,
    (i) => List.generate(8, (j) => TextEditingController()),
  );

  // final List<double> hzValue = [125, 250, 500, 1000, 2000, 4000, 8000];
  final List<LineChartBarData> chartData = [];

  bool isLoading = false;
  final double _cellHeight = 30.0;
  final double _fontSize = 10.0;

  bool isGood = false;
  bool isFair = false;
  bool isPoor = false;

  bool isInventis = false;
  bool isInteracoustic = false;
  bool isENTConsultation = false;
  bool isCaresOfEars = false;
  bool isHAT = false;
  bool isFollowUp = false;

  final TextEditingController rightEarController = TextEditingController();
  final TextEditingController leftEarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReportNameOptions();
  }

  @override
  void dispose() {
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _loadReportNameOptions() async {
    try {
      final fetched = await getNamesOfReportFromFirestore();
      setState(() => reportNames = fetched);
    } catch (_) {
      setState(() => reportNames = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Gram Chart Generator',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        child: SafeArea(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 16),
              _buildDataTable(),
              const SizedBox(height: 32),

              _buildChart(),
              const SizedBox(height: 16),

              _buildSubmitButton(),

              const SizedBox(height: 16),
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphOtherData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Reliability : ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ReusableCheckbox(
              value: isGood,
              onChanged: (value) {
                setState(() {
                  isGood = value ?? false;
                });
              },
              label: "Good",
            ),
            ReusableCheckbox(
              value: isFair,
              onChanged: (value) {
                setState(() {
                  isFair = value ?? false;
                });
              },
              label: "Fair",
            ),
            ReusableCheckbox(
              value: isPoor,
              onChanged: (value) {
                setState(() {
                  isPoor = value ?? false;
                });
              },
              label: "Poor",
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              "Audiometer Used : ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ReusableCheckbox(
              value: isInventis,
              onChanged: (value) {
                setState(() {
                  isInventis = value ?? false;
                });
              },
              label: "Inventis",
            ),
            ReusableCheckbox(
              value: isInteracoustic,
              onChanged: (value) {
                setState(() {
                  isInteracoustic = value ?? false;
                });
              },
              label: "Interacoustic",
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "Audiological Interpreration :",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Right Ear :",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
            Expanded(
                child: TextFormField(
              decoration: InputDecoration(border: UnderlineInputBorder()),
              controller: rightEarController,
            ))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Left Ear :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                )),
            Expanded(
                child: TextFormField(
              decoration: InputDecoration(border: UnderlineInputBorder()),
              controller: leftEarController,
            ))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Recommendation : ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ReusableCheckbox(
              value: isENTConsultation,
              onChanged: (value) {
                setState(() {
                  isENTConsultation = value ?? false;
                });
              },
              label: "ENT Consultation",
            ),
            ReusableCheckbox(
              value: isCaresOfEars,
              onChanged: (value) {
                setState(() {
                  isCaresOfEars = value ?? false;
                });
              },
              label: "Care of Ears",
            ),
            ReusableCheckbox(
              value: isHAT,
              onChanged: (value) {
                setState(() {
                  isHAT = value ?? false;
                });
              },
              label: "HAT",
            ),
            ReusableCheckbox(
              value: isFollowUp,
              onChanged: (value) {
                setState(() {
                  isFollowUp = value ?? false;
                });
              },
              label: "Follow Up",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: Colors.grey[400]!),
              columnWidths: {
                0: FixedColumnWidth(110),
                1: FixedColumnWidth(200),
                for (int i = 2; i <= 8; i++) i: FixedColumnWidth(60),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _buildHeaderRow(),
                ...List.generate(14, (i) => _buildLabelRow(i)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[200]),
      children: [
        _headerCell(''),
        _headerCell(''),
        ...[125, 250, 500, 1000, 2000, 4000, 8000]
            .map((hz) => _headerCell('${hz}hz')),
      ],
    );
  }

  TableRow _buildLabelRow(int index) {
    const labels = [
      'LEFT AC',
      'RIGHT AC',
      'LEFT BC',
      'RIGHT BC',
      'MASKING LEFT AC',
      'MASKING RIGHT AC',
      'MASKING LEFT BC',
      'MASKING RIGHT BC',
      'NO RESPONSE RIGHT AC',
      'NO RESPONSE LEFT AC',
      'NO RESPONSE RIGHT BC',
      'NO RESPONSE LEFT BC',
      'NO RESPONSE RIGHT AC MASKING',
      'NO RESPONSE LEFT AC MASKING',
    ];
    const mainLabels = [
      'AC',
      '',
      'BC',
      '',
      'AC MASKING',
      '',
      'BC MASKING',
      '',
      'AC (N.R.)',
      '',
      'BC (N.R.)',
      '',
      'AC MASKING (N.R.)',
      '',
    ];

    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        _fixedHeightCell(Text(mainLabels[index],
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize))),
        _fixedHeightCell(
            Text(labels[index], style: TextStyle(fontSize: _fontSize))),
        ...List.generate(7, (col) => _textField(index, col)),
      ],
    );
  }

  Widget _headerCell(String text) => _fixedHeightCell(Text(text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)));

  Widget _fixedHeightCell(Widget child) => SizedBox(
      height: _cellHeight,
      child: Center(
          child: Padding(padding: const EdgeInsets.all(8), child: child)));

  Widget _textField(int row, int col) => SizedBox(
        height: _cellHeight,
        child: TextField(
          controller: _controllers[row][col],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), isDense: true),
          keyboardType: TextInputType.number,
          onChanged: (_) => onDataChanged(),
        ),
      );

  Widget _buildChart() {
    return RepaintBoundary(
      key: _chartKey,
      child: SizedBox(
        width: 700,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 600,
                      height: 600,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Hearing Threshold Level in (dB)",
                                style: TextStyle(fontSize: 12),
                              ),
                              axisNameSize: 40,
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10,
                                getTitlesWidget: (value, _) => Text(
                                  '${120 - value.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            topTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Test Frequencies in (Hz)",
                                style: TextStyle(fontSize: 12),
                              ),
                              axisNameSize: 30,
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, _) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return Text('0',
                                          style: TextStyle(fontSize: 10));
                                    case 1:
                                      return Text('250Hz',
                                          style: TextStyle(fontSize: 10));
                                    case 2:
                                      return Text('500Hz',
                                          style: TextStyle(fontSize: 10));
                                    case 3:
                                      return Text('1KHz',
                                          style: TextStyle(fontSize: 10));
                                    case 4:
                                      return Text('2KHz',
                                          style: TextStyle(fontSize: 10));
                                    case 5:
                                      return Text('4KHz',
                                          style: TextStyle(fontSize: 10));
                                    case 6:
                                      return Text('8KHz',
                                          style: TextStyle(fontSize: 10));
                                    default:
                                      return SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                              axisNameSize: 30,
                              axisNameWidget: Text(
                                "Test Frequencies in (Hz)",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          lineBarsData: chartData,
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: 6,
                          minY: -10,
                          maxY: 130,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGraphOtherData()
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() => GradientButton(
        padding: const EdgeInsets.all(12),
        text: 'Submit Audiogram',
        fontsize: 14,
        isLoading: isLoading,
        onPressed: () => _exportOrSubmitAudioGram(true),
      );

  Widget _buildDownloadButton() => GradientButton(
        padding: const EdgeInsets.all(12),
        text: 'Download Audiogram',
        fontsize: 14,
        isLoading: isLoading,
        onPressed: () => _exportOrSubmitAudioGram(false),
      );

  void onDataChanged() {
    final rowConfigs = [
      {'color': Colors.blue, 'symbol': 'X', 'line': 1},
      // 0 - Left AC
      {'color': Colors.red, 'symbol': 'O', 'line': 1},
      // 1 - Right AC
      {'color': Colors.blue, 'symbol': '>', 'line': 2},
      // 2 - Left BC
      {'color': Colors.red, 'symbol': '<', 'line': 2},
      // 3 - Right BC
      {'color': Colors.blue, 'symbol': '□', 'line': 1},
      // 4 - Left AC Masked
      {'color': Colors.red, 'symbol': '△', 'line': 1},
      // 5 - Right AC Masked
      {'color': Colors.blue, 'symbol': ']', 'line': 2},
      // 6 - Left BC Masked
      {'color': Colors.red, 'symbol': '[', 'line': 2},
      // 7 - Right BC Masked
      {'color': Colors.red, 'symbol': 'O↓', 'line': 0},
      // 8 - Right AC N.R
      {'color': Colors.blue, 'symbol': 'X↓', 'line': 0},
      // 9 - Left AC N.R
      {'color': Colors.red, 'symbol': '[↓]', 'line': 0},
      // 10 - Right BC N.R
      {'color': Colors.blue, 'symbol': ']↓', 'line': 0},
      // 11 - Left BC N.R
      {'color': Colors.red, 'symbol': '△↓', 'line': 0},
      // 12 - Right AC Masked N.R.
      {'color': Colors.blue, 'symbol': '□↓', 'line': 0},
      // 13 - Left AC Masked N.R.
    ];

    chartData.clear();

    for (var row = 0; row < _controllers.length; row++) {
      List<FlSpot> spots = [];

      for (var col = 0; col < _controllers[row].length; col++) {
        final text = _controllers[row][col].text.trim();
        if (text.isNotEmpty) {
          spots.add(FlSpot(col.toDouble(), 120 - double.parse(text)));
        }
      }

      if (spots.isNotEmpty && row < rowConfigs.length) {
        chartData.add(_buildLineData(
          spots,
          rowConfigs[row],
        ));
      }
    }

    setState(() {});
  }

  LineChartBarData _buildLineData(List<FlSpot> spots, Map config) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: config["line"] == 0 ? Colors.transparent : config["color"],
      barWidth: 2,
      dashArray: config["line"] == 2 ? [5] : null,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlTextPainter(
              symbol: config["symbol"], color: config["color"]);
        },
        checkToShowDot: (spot, barData) => true,
      ),
      showingIndicators: List.generate(spots.length, (i) => i),
    );
  }

  Future<void> _exportOrSubmitAudioGram(bool isSubmit) async {
    try {
      _showLoadingOverlay(context); // Use overlay instead of setState

      // Let the overlay render
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        showSnackBar("Failed to capture chart!", context);
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      if (isSubmit) {
        Navigator.pop(context, base64Encode(pngBytes));
        return;
      }
      final pdfBytes = await compute(generatePdf, pngBytes);

      await Printing.sharePdf(
          bytes: pdfBytes,
          filename:
              '${widget.appointmentModel.patientName.toLowerCase().replaceAll(" ", "")}_audiogram.pdf');
    } catch (e) {
      showSnackBar("Error exporting PDF: $e", context);
    } finally {
      _hideLoadingOverlay(); // Remove the overlay
    }
  }

  late OverlayEntry _overlayEntry;

  void _showLoadingOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black45,
            child: Center(
              child: Text(
                "Processing, Please wait...",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry);
  }

  void _hideLoadingOverlay() {
    _overlayEntry.remove();
  }
}

class FlTextPainter extends FlDotPainter {
  final String symbol;
  final Color color;
  final double fontSize;

  FlTextPainter(
      {required this.symbol, this.color = Colors.black, this.fontSize = 16});

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    final tp = TextPainter(
      text: TextSpan(
          text: symbol,
          style: TextStyle(
              backgroundColor: Colors.transparent,
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = offsetInCanvas - Offset(tp.width / 2, tp.height / 2);
    tp.paint(canvas, offset);
  }

  @override
  Size getSize(FlSpot spot) => Size(fontSize, fontSize);

  @override
  Color get mainColor => color;

  @override
  bool hitTest(
      FlSpot spot, Offset touched, Offset center, double extraThreshold) {
    return (touched - center).distance < fontSize + extraThreshold;
  }

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => this;

  @override
  List<Object?> get props => [symbol, color, fontSize];
}
