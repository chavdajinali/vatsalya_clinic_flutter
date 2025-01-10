import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class AppointmentInfo extends StatelessWidget {
  final AppointmentModel appointmentData;

  const AppointmentInfo({super.key, required this.appointmentData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Appointment Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Chief Complaint",
              value: appointmentData.appointmentChiefComplain ?? 'N/A'),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Reference",
              value: appointmentData.appointmentReferenceBy ?? 'N/A'),
          const SizedBox(
            height: 8,
          ),
          appointmentData.paymentAmount.isEmpty
              ? const AppLabelValue(label: "Payment", value: "Pending")
              : Column(
                  children: [
                    AppLabelValue(
                        label: "Payment Type",
                        value: appointmentData.paymentType ?? "N/A"),
                    const SizedBox(
                      height: 8,
                    ),
                    AppLabelValue(
                        label: "Payment Amount",
                        value: appointmentData.paymentAmount ?? "N/A"),
                  ],
                ),

          const SizedBox(height: 16),
          // Display the image
          const Text(
            "Reports",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 8),
          appointmentData.reports.isEmpty
              ? const Text("No reports found.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: appointmentData.reports
                      .asMap()
                      .entries
                      .map<Widget>((entry) {
                    int index = entry.key;
                    var report = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Text(
                                report.reportName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Stack(
                                            fit: StackFit.loose,
                                            children: [
                                              Image.network(
                                                report.reportImage,
                                                // fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              (loadingProgress
                                                                      .expectedTotalBytes ??
                                                                  1)
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return const Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey);
                                                },
                                              ),
                                              Positioned(
                                                // right: 16,
                                                top: 16, right: 1,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          downloadImage(report
                                                              .reportImage);
                                                        },
                                                        icon: const Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Image.network(
                                  report.reportImage,
                                  width: 120,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return const Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        if (index != appointmentData.reports.length - 1)
                          const Divider(
                            height: 1,
                            thickness: 0.5,
                          ),
                      ],
                    );
                  }).toList(),
                )
        ],
      ),
    );
  }

  Future<void> downloadImage(String url) async {
    try {
      // Fetch the image data
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Convert image data to a byte array
        Uint8List bytes = response.bodyBytes;

        // Create a blob and download it
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg'
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        throw "Failed to download image. Status code: ${response.statusCode}";
      }
    } catch (e) {
      print("Error downloading image: $e");
    }
  }
}
