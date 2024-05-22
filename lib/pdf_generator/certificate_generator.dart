// import 'dart:convert';
// import 'dart:html';
//
// import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
//
// //
// class PdfGenerator {
//   //
//   static Future<void> createCertificate(String name) async {
//     //Create a PDF document.
//     final PdfDocument document = PdfDocument();
//     document.pageSettings.margins.all = 0;
//     document.pageSettings = PdfPageSettings(
//       PdfPageSize.a4,
//       PdfPageOrientation.landscape,
//     );
//
//     //Add page to the PDF
//     final PdfPage page = document.pages.add();
//
//     //Get the page size
//     final Size pageSize = page.getClientSize();
//
//     //Draw image
//     page.graphics.drawImage(
//         PdfBitmap(await _readImageData('basic_counseling.png')),
//         Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
//
//     //Create font
//     final PdfFont nameFont =
//         await _loadCustomFont('assets/fonts/PinyonScript-Regular.ttf', 48);
//     // final PdfFont controlFont = PdfStandardFont(PdfFontFamily.helvetica, 19);
//     // final PdfFont dateFont = PdfStandardFont(PdfFontFamily.helvetica, 16);
//
//     //
//     double x = _calculateXPosition(name, nameFont, pageSize.width);
//     page.graphics.drawString(name, nameFont,
//         bounds: Rect.fromLTWH(x, 190, 0, 0),
//         brush: PdfSolidBrush(PdfColor(20, 58, 86)));
//
//     //Save and launch the document
//     final List<int> bytes = await document.save();
//     //Dispose the document.
//     document.dispose();
//
//     //Save and launch file.
//     await _saveAndLaunchFile(bytes, '$name.pdf');
//   }
//
//   static Future<PdfTrueTypeFont> _loadCustomFont(
//       String path, double size) async {
//     // Load the font from assets
//     final ByteData fontData = await rootBundle.load(path);
//     final Uint8List fontBytes = fontData.buffer.asUint8List();
//     return PdfTrueTypeFont(fontBytes, size);
//   }
//
// //
//   static double _calculateXPosition(
//       String text, PdfFont font, double pageWidth) {
//     final Size textSize =
//         font.measureString(text, layoutArea: Size(pageWidth, 0));
//     return (pageWidth - textSize.width) / 2;
//   }
//
// //
//   static Future<List<int>> _readImageData(String name) async {
//     final ByteData data = await rootBundle.load('assets/$name');
//     return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   }
//
//   ///To save the pdf file in the device
//   static Future<void> _saveAndLaunchFile(
//       List<int> bytes, String fileName) async {
//     AnchorElement(
//         href:
//             'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
//       ..setAttribute('download', fileName)
//       ..click();
//   }
// }
