import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionAnalysis extends StatelessWidget {
  const QuestionAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    var quesRef = FirebaseFirestore.instance.collection('questions');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var ref = FirebaseFirestore.instance.collection('questions');

          //
          var data = QuestionData(
              chapter: '2', no: '1', subPoint: 'b', text: '', mark: '1');
          ref
              .doc('G7MjeVTIx3c1oWBWwTWq')
              .collection('years')
              .doc('2022')
              .collection('questions')
              .add(data.toJson());
        },
        child: Text('Add'),
      ),
      appBar: AppBar(
        title: const Text('Question Analysis Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              // final Uint8List pdfBytes = await generatePdf();
              // Download PDF
              // _download(pdfBytes);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot>(
              stream: quesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('No data!');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                var docs = snapshot.data!.docs;

                String course = '';
                var docID = '';
                var chapterNo = '';

                //
                for (var doc in docs) {
                  course = doc.get('code') + ' ' + doc.get('course');
                  docID = doc.id;
                }

                // col
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //course
                    Text(course,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),

                    // years
                    StreamBuilder<QuerySnapshot>(
                        stream:
                            quesRef.doc(docID).collection('years').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('No data!');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          var docs = snapshot.data!.docs;

                          //
                          return Row(
                            children: docs.map((years) {
                              return Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(years.get('year'))),
                                ),
                              );
                            }).toList(),
                          );
                        }),

                    //
                    StreamBuilder<QuerySnapshot>(
                        stream: quesRef
                            .doc(docID)
                            .collection('chapters')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('No data!');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          var docs = snapshot.data!.docs;
                          for (var doc in docs) {
                            chapterNo = doc.get('chapter');
                          }

                          //
                          return Column(
                            children: docs.map((chapter) {
                              //
                              return Column(
                                children: [
                                  //
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(),
                                        right: BorderSide(),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Center(
                                        child: Text(chapter.get('title'))),
                                  ),

                                  //
                                  StreamBuilder<QuerySnapshot>(
                                      stream: quesRef
                                          .doc(docID)
                                          .collection('years')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Text('No data!');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text("Loading");
                                        }

                                        var docs = snapshot.data!.docs;

                                        return Row(
                                          children: [
                                            for (var doc in docs)
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: doc.reference
                                                            .collection(
                                                                'questions')
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return const Text(
                                                                'No data!');
                                                          }
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Text(
                                                                "Loading");
                                                          }

                                                          var docs = snapshot
                                                              .data!.docs;

                                                          //
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                docs.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int i) {
                                                              var chapter =
                                                                  docs[i].get(
                                                                      'chapter');
                                                              var no = docs[i]
                                                                  .get('no');
                                                              var subPoint =
                                                                  docs[i].get(
                                                                      'subPoint');
                                                              var text = docs[i]
                                                                  .get('text');
                                                              var mark = docs[i]
                                                                  .get('mark');

                                                              if (chapter ==
                                                                  chapterNo) {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              '$no. ($subPoint) $text',
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            mark,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    if (i <
                                                                            docs.length -
                                                                                1 &&
                                                                        docs[i + 1].get('chapter') ==
                                                                            chapter)
                                                                      const Divider(),
                                                                    // Add a divider if next question has different number and same chapter
                                                                  ],
                                                                );
                                                              } else {
                                                                return const SizedBox
                                                                    .shrink(); // Return an empty widget if chapter does not match
                                                              }
                                                            },
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }),

                                  //
                                ],
                              );
                            }).toList(),
                          );
                        }),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

// Future<Uint8List> _loadFont(String path) async {
//   final ByteData fontData = await rootBundle.load(path);
//   return fontData.buffer.asUint8List();
// }
//
// Future<Uint8List> generatePdf() async {
//   final pdf = pw.Document();
//
//   // Load fonts
//   final Uint8List regularFontData =
//       await _loadFont('assets/fonts/Montserrat-Regular.ttf');
//   final Uint8List boldFontData =
//       await _loadFont('assets/fonts/Montserrat-Bold.ttf');
//
//   // Set up fonts
//   final pw.Font regularFont = pw.Font.ttf(regularFontData.buffer.asByteData());
//   final pw.Font boldFont = pw.Font.ttf(boldFontData.buffer.asByteData());
//
//   // Set page size to A4 with horizontal orientation and 40 pixel margin
//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4.landscape.copyWith(
//         marginTop: 20,
//         marginLeft: 24,
//         marginRight: 24,
//         marginBottom: 10,
//       ),
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Center(
//               child: pw.Text(
//                 'Psy 501 - Physiological Psychology',
//                 style: pw.TextStyle(
//                   font: boldFont,
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 textAlign: pw.TextAlign.center,
//               ),
//             ),
//             pw.SizedBox(height: 20),
//
//             // Year row
//             pw.Row(
//               children: [
//                 for (var data in questionList)
//                   pw.Expanded(
//                     child: pw.Container(
//                       decoration: pw.BoxDecoration(
//                         border: pw.Border.all(),
//                       ),
//                       padding: const pw.EdgeInsets.all(8.0),
//                       child: pw.Center(
//                           child: pw.Text(data.year,
//                               style: pw.TextStyle(font: boldFont))),
//                     ),
//                   ),
//               ],
//             ),
//
//             // Chapters and questions
//             for (var chapter in chapterList)
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Container(
//                     decoration: const pw.BoxDecoration(
//                       border: pw.Border(
//                         left: pw.BorderSide(),
//                         right: pw.BorderSide(),
//                       ),
//                     ),
//                     padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
//                     child: pw.Center(
//                         child: pw.Text(chapter.title,
//                             style: pw.TextStyle(font: regularFont))),
//                   ),
//                   pw.Row(
//                     children: [
//                       for (var data in questionList)
//                         pw.Expanded(
//                           child: pw.Container(
//                             decoration: pw.BoxDecoration(
//                               border: pw.Border.all(),
//                             ),
//                             child: pw.Column(
//                               crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//                               children: [
//                                 for (var i = 0;
//                                     i < data.questions.length;
//                                     i++) ...[
//                                   if (data.questions[i].chapter ==
//                                       chapter.chapter) ...[
//                                     pw.Padding(
//                                       padding: const pw.EdgeInsets.symmetric(
//                                           horizontal: 8, vertical: 4),
//                                       child: pw.Row(
//                                         mainAxisAlignment:
//                                             pw.MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             pw.CrossAxisAlignment.end,
//                                         children: [
//                                           pw.Expanded(
//                                             child: pw.Text(
//                                               '${data.questions[i].no}. (${data.questions[i].subPoint}) ${data.questions[i].text}',
//                                               style: pw.TextStyle(
//                                                   font: regularFont),
//                                             ),
//                                           ),
//                                           pw.SizedBox(
//                                             width: 8,
//                                           ),
//                                           pw.Text(
//                                             data.questions[i].mark,
//                                             style: pw.TextStyle(
//                                               font: boldFont,
//                                               fontWeight: pw.FontWeight.bold,
//                                               fontSize: 10,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (i < data.questions.length - 1 &&
//                                         data.questions[i].no !=
//                                             data.questions[i + 1].no &&
//                                         data.questions[i].chapter ==
//                                             data.questions[i + 1].chapter)
//                                       pw.Divider(height: 8),
//                                   ]
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Save the PDF as bytes
//   return await pdf.save();
// }
//
// void _download(Uint8List pdfBytes) {
//   final blob = html.Blob([pdfBytes]);
//   final url = html.Url.createObjectUrlFromBlob(blob);
//   html.AnchorElement(href: url)
//     ..setAttribute("download", "question_analysis.pdf")
//     ..click();
//   html.Url.revokeObjectUrl(url);
// }

class YearData {
  final String year;
  final List<QuestionData> questions;

  YearData({
    required this.year,
    required this.questions,
  });
}

class ChapterData {
  final String chapter;
  final String title;

  ChapterData({
    required this.chapter,
    required this.title,
  });
}

class QuestionData {
  final String chapter;
  final String no;
  final String subPoint;
  final String text;
  final String mark;

  QuestionData({
    required this.chapter,
    required this.no,
    required this.subPoint,
    required this.text,
    required this.mark,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      chapter: json['chapter'],
      no: json['no'],
      subPoint: json['subPoint'],
      text: json['text'],
      mark: json['mark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'no': no,
      'subPoint': subPoint,
      'text': text,
      'mark': mark,
    };
  }
}
