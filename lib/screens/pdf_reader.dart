import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    final file = args != null ? args['file'] as String : null;
    if (file == null) return Scaffold(body: Center(child: Text('Aucun fichier')));
    final isNetwork = file.startsWith('http');
    return Scaffold(
      appBar: AppBar(title: Text('Lecture')),
      body: isNetwork ? SfPdfViewer.network(file) : SfPdfViewer.asset(file),
    );
  }
}￼Enter
