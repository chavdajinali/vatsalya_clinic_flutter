import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(Uint8List pngBytes) async {
  final pdf = pw.Document();
  final image = pw.MemoryImage(pngBytes);
  pdf.addPage(pw.Page(
    build: (_) => pw.Center(child: pw.Image(image)),
  ));
  return pdf.save();
}
