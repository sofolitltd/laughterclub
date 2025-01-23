import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

//
// class CertificateBuilder extends StatefulWidget {
//   @override
//   _CertificateBuilderState createState() => _CertificateBuilderState();
// }
//
// class _CertificateBuilderState extends State<CertificateBuilder> {
//   Uint8List? backgroundImage;
//   final List<_DraggableItem> draggableItems = [];
//   final double canvasWidth = 595.28; // A4 width in points
//   final double canvasHeight = 841.89; // A4 height in points
//   _DraggableItem? selectedItem;
//
//   Future<void> pickBackgroundImage() async {
//     final pickedFile =
//         await FilePicker.platform.pickFiles(type: FileType.image);
//     if (pickedFile != null && pickedFile.files.single.bytes != null) {
//       setState(() {
//         backgroundImage = pickedFile.files.single.bytes;
//       });
//     }
//   }
//
//   Future<void> createPDF() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) {
//           return pw.Stack(
//             children: [
//               if (backgroundImage != null)
//                 pw.Positioned(
//                   left: 0,
//                   top: 0,
//                   child: pw.Image(
//                     pw.MemoryImage(backgroundImage!),
//                     fit: pw.BoxFit.cover,
//                     width: PdfPageFormat.a4.height,
//                     height: PdfPageFormat.a4.width,
//                   ),
//                 ),
//               ...draggableItems.map((item) {
//                 if (item.isImage) {
//                   return pw.Positioned(
//                     left: item.position.dx,
//                     top: item.position.dy,
//                     child: pw.Image(
//                       pw.MemoryImage(item.image!),
//                       width: 100,
//                       height: 50,
//                     ),
//                   );
//                 } else {
//                   return pw.Positioned(
//                     left: item.position.dx,
//                     top: item.position.dy,
//                     child: pw.Text(
//                       item.text!,
//                       style: pw.TextStyle(
//                         fontSize: item.fontSize,
//                         //       font: pw.Font.ttf(
//                         //           await rootBundle.load(
//                         //       GoogleFonts.getFont(item.fontFamily).fontLoader!
//                         //           .fontUrl!),
//                         // ),
//                         color: PdfColors.black,
//                       ),
//                     ),
//                   );
//                 }
//               }),
//             ],
//           );
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }
//
//   void _addTextItem() {
//     setState(() {
//       draggableItems.add(
//         _DraggableItem(
//           isImage: false,
//           text: "Placeholder Text",
//           position: const Offset(50, 50),
//           fontSize: 16,
//         ),
//       );
//     });
//   }
//
//   void _addSignatureImage() async {
//     final pickedFile =
//         await FilePicker.platform.pickFiles(type: FileType.image);
//     if (pickedFile != null && pickedFile.files.single.bytes != null) {
//       setState(() {
//         draggableItems.add(
//           _DraggableItem(
//             isImage: true,
//             image: pickedFile.files.single.bytes,
//             position: const Offset(50, 100),
//           ),
//         );
//       });
//     }
//   }
//
//   void _updateSelectedItem(void Function(_DraggableItem) update) {
//     if (selectedItem != null) {
//       setState(() {
//         update(selectedItem!);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Certificate Generator'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: AspectRatio(
//                   aspectRatio: canvasHeight / canvasWidth,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2),
//                       color: Colors.white,
//                     ),
//                     child: Stack(
//                       children: [
//                         if (backgroundImage != null)
//                           Image.memory(
//                             backgroundImage!,
//                             width: double.infinity,
//                             height: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ...draggableItems.map((item) {
//                           final isSelected = selectedItem == item;
//                           return Positioned(
//                             left: item.position.dx,
//                             top: item.position.dy,
//                             child: GestureDetector(
//                               onPanUpdate: (details) {
//                                 setState(() {
//                                   item.position += Offset(
//                                     details.delta.dx,
//                                     details.delta.dy,
//                                   );
//                                 });
//                               },
//                               onTap: () {
//                                 setState(() {
//                                   selectedItem = isSelected ? null : item;
//                                 });
//                               },
//                               child: Container(
//                                 decoration: isSelected
//                                     ? BoxDecoration(
//                                         border: Border.all(
//                                           color: Colors.blue,
//                                           width: 2,
//                                         ),
//                                       )
//                                     : null,
//                                 child: item.isImage
//                                     ? Image.memory(
//                                         item.image!,
//                                         width: 100,
//                                         height: 50,
//                                       )
//                                     : Text(
//                                         item.text!,
//                                         style: GoogleFonts.getFont(
//                                           item.fontFamily,
//                                           fontSize: item.fontSize,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (selectedItem != null && !selectedItem!.isImage)
//             Container(
//               padding: const EdgeInsets.all(8),
//               margin: const EdgeInsets.all(8),
//               color: Colors.grey[200],
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   DropdownButton<String>(
//                     value: selectedItem!.fontFamily,
//                     items: GoogleFonts.asMap().keys.map((font) {
//                       return DropdownMenuItem(
//                         value: font,
//                         child: Text(font, style: GoogleFonts.getFont(font)),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _updateSelectedItem((item) {
//                           item.fontFamily = value;
//                         });
//                       }
//                     },
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           _updateSelectedItem((item) => item.fontSize -= 2);
//                         },
//                         icon: const Icon(Icons.remove),
//                       ),
//                       Text("${selectedItem!.fontSize.toInt()}"),
//                       IconButton(
//                         onPressed: () {
//                           _updateSelectedItem((item) => item.fontSize += 2);
//                         },
//                         icon: const Icon(Icons.add),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black12),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               spacing: 24,
//               children: [
//                 IconButton(
//                   onPressed: pickBackgroundImage,
//                   icon: const Icon(Icons.image),
//                 ),
//                 IconButton(
//                   onPressed: _addTextItem,
//                   icon: const Icon(Icons.text_fields),
//                 ),
//                 IconButton(
//                   onPressed: _addSignatureImage,
//                   icon: const Icon(Icons.edit_location_alt_outlined),
//                 ),
//                 IconButton(
//                   onPressed: createPDF,
//                   icon: const Icon(Icons.picture_as_pdf_outlined),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _DraggableItem {
//   bool isImage;
//   Uint8List? image;
//   String? text;
//   Offset position;
//   double fontSize;
//   String fontFamily;
//
//   _DraggableItem({
//     required this.isImage,
//     this.image,
//     this.text,
//     required this.position,
//     this.fontSize = 16,
//     String? fontFamily,
//   }) : fontFamily = fontFamily ?? 'Roboto';
// }

class CertificateBuilder extends StatefulWidget {
  @override
  _CertificateBuilderState createState() => _CertificateBuilderState();
}

class _CertificateBuilderState extends State<CertificateBuilder> {
  Uint8List? backgroundImage;
  Offset titlePosition = Offset(100, 100);
  String title = "Sample Title";
  double titleFontSize = 24;
  String selectedFont = "Roboto";

  Future<void> pickBackgroundImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        backgroundImage = result.files.first.bytes;
      });
    }
  }

  Future<void> generatePdf() async {
    if (backgroundImage != null) {
      await PdfGenerator.createCertificate(
        title: title,
        titlePosition: titlePosition,
        titleFontSize: titleFontSize,
        fontFamily: selectedFont,
        backgroundImageData: backgroundImage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Certificate Builder")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.414, // A4 size (landscape).
                child: Container(
                  color: Colors.grey[200],
                  child: Stack(
                    children: [
                      if (backgroundImage != null)
                        Image.memory(
                          backgroundImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      Positioned(
                        left: titlePosition.dx,
                        top: titlePosition.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              titlePosition += details.delta;
                            });
                          },
                          child: Text(
                            title,
                            style: GoogleFonts.getFont(
                              selectedFont,
                              fontSize: titleFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickBackgroundImage,
                child: Text("Pick Background"),
              ),
              ElevatedButton(
                onPressed: generatePdf,
                child: Text("Generate PDF"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PdfGenerator {
  static Future<void> createCertificate({
    required String title,
    required Offset titlePosition,
    required double titleFontSize,
    required String fontFamily,
    required Uint8List backgroundImageData,
  }) async {
    // Create a PDF document.
    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 0;
    document.pageSettings = PdfPageSettings(
      PdfPageSize.a4,
      PdfPageOrientation.landscape,
    );

    // Add a page to the PDF.
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Draw the background image.
    page.graphics.drawImage(
      PdfBitmap(backgroundImageData),
      Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    );

    // Load the custom font.
    final PdfFont titleFont = await _loadCustomFont(
        'assets/fonts/PinyonScript-Regular.ttf', titleFontSize);

    // Draw the title.
    page.graphics.drawString(
      title,
      titleFont,
      bounds: Rect.fromLTWH(
        titlePosition.dx,
        titlePosition.dy,
        0,
        0,
      ),
      brush: PdfSolidBrush(PdfColor(20, 58, 86)), // Customize text color.
    );

    // Save and download the document.
    final List<int> bytes = await document.save();
    document.dispose();
    await _saveAndLaunchFile(bytes, '$title Certificate.pdf');
  }

  static Future<PdfTrueTypeFont> _loadCustomFont(
      String path, double size) async {
    final ByteData fontData = await rootBundle.load(path);
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    return PdfTrueTypeFont(fontBytes, size);
  }

  static Future<void> _saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    final base64data = base64.encode(bytes);
    final url = 'data:application/octet-stream;base64,$base64data';

    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
  }
}
