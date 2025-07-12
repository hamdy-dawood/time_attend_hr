import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';


class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final key = GlobalKey(debugLabel: 'QR');
  final scannerScaffoldKey = GlobalKey<ScaffoldState>();

  QRViewController? controller;
  bool isScanning = false;

  @override
  void initState() {
    isScanning = true;
    super.initState();
  }

  @override
  void dispose() {
    isScanning = false;
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const CustomText(
          text: "فحص الباركود",
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      key: scannerScaffoldKey,
      body: QRView(
        key: key,
        onQRViewCreated: (QRViewController controller) {
          setState(() {
            this.controller = controller;
          });
          controller.scannedDataStream.listen(
            (barcode) {
              if (barcode.code != null && isScanning) {
                Navigator.pop(context, "${barcode.code}");
                isScanning = false;
              }
            },
          );
        },
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          cutOutHeight: 300,
          cutOutWidth: 300,
          borderColor: AppColors.primary,
        ),
      ),
    );
  }
}
