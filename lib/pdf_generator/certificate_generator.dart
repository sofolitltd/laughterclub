import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PdfGenerator {
  static Future<void> createCertificate(String name, String background,
      double position, String trainingTitle) async {
    // Create a PDF document.
    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 0;
    document.pageSettings = PdfPageSettings(
      PdfPageSize.a4,
      PdfPageOrientation.landscape,
    );

    // Add page to the PDF
    final PdfPage page = document.pages.add();

    // Get the page size
    final Size pageSize = page.getClientSize();

    // Draw image from the internet
    final Uint8List imageData = await _fetchImageData(background);
    page.graphics.drawImage(PdfBitmap(imageData),
        Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

    // Create font
    final PdfFont nameFont =
        await _loadCustomFont('assets/fonts/PinyonScript-Regular.ttf', 50);

    // Calculate the X position for the name text
    double x = _calculateXPosition(name, nameFont, pageSize.width);
    page.graphics.drawString(name, nameFont,
        bounds: Rect.fromLTWH(x, position, 0, 0),
        brush: PdfSolidBrush(PdfColor(20, 58, 86)));

    // Save and launch the document
    final List<int> bytes = await document.save();
    // Dispose the document
    document.dispose();

    // Save and launch file
    await _saveAndLaunchFile(bytes, '$name ($trainingTitle).pdf');
  }

  static Future<PdfTrueTypeFont> _loadCustomFont(
      String path, double size) async {
    // Load the font from assets
    final ByteData fontData = await rootBundle.load(path);
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    return PdfTrueTypeFont(fontBytes, size);
  }

  static double _calculateXPosition(
      String text, PdfFont font, double pageWidth) {
    final Size textSize =
        font.measureString(text, layoutArea: Size(pageWidth, 0));
    return (pageWidth - textSize.width) / 2;
  }

  static Future<Uint8List> _fetchImageData(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  /// To save the pdf file in the device
  static Future<void> _saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    final base64data = base64.encode(bytes);
    final url = 'data:application/octet-stream;base64,$base64data';

    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
  }
}
