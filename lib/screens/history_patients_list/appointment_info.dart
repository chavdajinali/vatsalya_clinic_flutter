import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:vatsalya_clinic/utils/app_utils.dart';

class AppointmentInfo extends StatefulWidget {
  final AppointmentModel appointmentData;

  const AppointmentInfo({super.key, required this.appointmentData});

  @override
  State<AppointmentInfo> createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
/*    // Check if the device is desktop
    bool isDesktop =
        MediaQuery.of(context).size.width >= 600; // Adjust threshold as needed

    // If not desktop, show as a dialog
    if (!isDesktop) {
      return Dialog(
        child: _buildContent(context),
      );
    }*/

    // If desktop, show as a regular widget
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    // Get the screen width to adjust padding and font sizes
    double screenWidth = MediaQuery.of(context).size.width;
    double padding =
        screenWidth < 600 ? 8.0 : 16.0; // Adjust padding for mobile
    double fontSize =
        screenWidth < 600 ? 14.0 : 16.0; // Adjust font size for mobile

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Appointment Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AppLabelValue(
              label: "Chief Complaint",
              value: widget.appointmentData.appointmentChiefComplain ?? 'N/A'),
          const SizedBox(height: 8),
          AppLabelValue(
              label: "Reference",
              value: widget.appointmentData.appointmentReferenceBy ?? 'N/A'),
          const SizedBox(height: 8),
          widget.appointmentData.paymentAmount.isEmpty
              ? const AppLabelValue(label: "Payment", value: "Pending")
              : Column(
                  children: [
                    AppLabelValue(
                        label: "Payment Type",
                        value: widget.appointmentData.paymentType ?? "N/A"),
                    const SizedBox(height: 8),
                    AppLabelValue(
                        label: "Payment Amount",
                        value: widget.appointmentData.paymentAmount ?? "N/A"),
                  ],
                ),
          const SizedBox(height: 16),
          const Text(
            "Reports",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          widget.appointmentData.reports.isEmpty
              ? const Text("No reports found.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.appointmentData.reports
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
                              Expanded(
                                child: Text(
                                  report.reportName,
                                  style: TextStyle(fontSize: fontSize),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  _showReportDialog(context, report);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                ),
                              )
                            ],
                          ),
                        ),
                        if (index != widget.appointmentData.reports.length - 1)
                          const Divider(height: 1, thickness: 0.5),
                      ],
                    );
                  }).toList(),
                )
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, var report) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            fit: StackFit.loose,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  report.reportImage,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey);
                  },
                ),
              ),
              Positioned(
                top: 16,
                right: 1,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        /*  if (Platform.isAndroid) {
                          PermissionStatus status = await Permission.storage.request();
                          return status.isGranted;
                        }*/
                        if (Platform.isAndroid) {
                          downloadInAndroid(report.reportImage);
                        } else {
                          downloadInWeb(report.reportImage);
                        }
                      },
                      icon: const Icon(Icons.download, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> downloadInWeb(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
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

  Future<void> downloadInAndroid(String fileUrl) async {
    setState(() => isDownloading = true);

    try {
      Directory? downloadsDir = await getApplicationDocumentsDirectory();

      String savePath = "${downloadsDir.path}/sample.png";

      await Dio().download(fileUrl, savePath);

      setState(() => isDownloading = false);

      Navigator.pop(context);

      showSnackBar("Downloaded to: $savePath", context);
    } catch (e) {
      setState(() => isDownloading = false);
      showSnackBar("Error: ${e.toString()}", context);
    }
  }
}
