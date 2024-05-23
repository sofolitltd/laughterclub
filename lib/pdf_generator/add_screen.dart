// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'certificate_generator.dart';
//
// class AddScreen extends StatefulWidget {
//   const AddScreen({super.key});
//
//   @override
//   State<AddScreen> createState() => _AddScreenState();
// }
//
// class _AddScreenState extends State<AddScreen> {
//   bool _isLoading = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final List<String> _names = [];
//   String? _currentFileName;
//   final FocusNode _nameFocusNode = FocusNode();
//
//   final List<Map<String, dynamic>> _certificateTypes = [
//     {
//       'name': 'Basic Counseling',
//       'url':
//           'https://firebasestorage.googleapis.com/v0/b/campusassistantbd.appspot.com/o/basic_counseling.png?alt=media&token=44aeec92-f2ff-4408-80ab-66f82aa971b4',
//       'position': 195
//     },
//     {
//       'name': 'Advanced Counseling',
//       'url': 'https://fire'
//           'basestorage.googleapis.com/v0/b/campusassistantbd.appspot.com/o/advanced_counseling.png?alt=media&token=exampletoken2',
//       'position': 205
//     },
//     {
//       'name': 'Psychological First Aid',
//       'url':
//           'https://firebasestorage.googleapis.com/v0/b/campusassistantbd.appspot.com/o/psychological_first_aid.png?alt=media&token=exampletoken3',
//       'position': 225
//     },
//   ];
//
//   String _selectedCertificateType = 'Basic Counseling';
//
//   @override
//   void dispose() {
//     _nameFocusNode.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _generateCertificates() async {
//     if (_names.isEmpty || _isLoading) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final selectedCertificate = _certificateTypes.firstWhere(
//       (element) => element['name'] == _selectedCertificateType,
//     );
//     final imageUrl = selectedCertificate['url']!;
//     final position = selectedCertificate['position']!;
//     final type = selectedCertificate['name']!;
//
//     for (var i = 0; i < _names.length; i++) {
//       final fileName = _names[i];
//       setState(() {
//         _currentFileName = fileName;
//       });
//
//       await _generateCertificateInBackground(
//           fileName, imageUrl, position, type);
//     }
//
//     setState(() {
//       _isLoading = false;
//       _currentFileName = null;
//     });
//   }
//
//   static Future<void> _generateCertificateInBackground(
//       String fileName, String imageUrl, double position, String type) async {
//     return await compute(_generateCertificate, {
//       'fileName': fileName,
//       'imageUrl': imageUrl,
//       'position': position,
//       'type': type
//     });
//   }
//
//   static Future<void> _generateCertificate(Map<String, dynamic> params) async {
//     final fileName = params['fileName']!;
//     final imageUrl = params['imageUrl']!;
//     final position = params['position']!;
//     final type = params['type']!;
//     await PdfGenerator.createCertificate(fileName, imageUrl, position, type);
//   }
//
//   void _addName(String name) {
//     setState(() {
//       _names.add(_capitalizeEachWord(name));
//       _nameController.clear();
//       _nameFocusNode.requestFocus();
//     });
//   }
//
//   String _capitalizeEachWord(String input) {
//     if (input.isEmpty) return input;
//     return input.trim().split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
//
//   void _deleteName(int index) {
//     setState(() {
//       _names.removeAt(index);
//     });
//   }
//
//   void _clearAllNames() {
//     setState(() {
//       _names.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Certificate Generator',
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 720),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Card(
//                 elevation: 0,
//                 margin: EdgeInsets.zero,
//                 color: Colors.white,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Card(
//                             margin: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
//                               height: 32,
//                               child: DropdownButton<String>(
//                                 focusColor: Colors.transparent,
//                                 value: _selectedCertificateType,
//                                 underline: Container(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     _selectedCertificateType = newValue!;
//                                   });
//                                 },
//                                 items: _certificateTypes
//                                     .map<DropdownMenuItem<String>>(
//                                         (Map<String, dynamic> type) {
//                                   return DropdownMenuItem<String>(
//                                     value: type['name'],
//                                     child: Text(type['name']!),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: const Size(175, 40),
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(24)),
//                                 ),
//                                 onPressed:
//                                     _isLoading ? null : _generateCertificates,
//                                 child: _isLoading
//                                     ? const Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           SizedBox(
//                                             height: 24,
//                                             width: 24,
//                                             child: CircularProgressIndicator(),
//                                           ),
//                                           SizedBox(width: 16),
//                                           Text('Generating...'),
//                                         ],
//                                       )
//                                     : const Text('Generate Certificates'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       Form(
//                         key: _formKey,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 autofocus: true,
//                                 focusNode: _nameFocusNode,
//                                 controller: _nameController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Enter Full Name',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                                 textCapitalization: TextCapitalization.words,
//                                 validator: (value) {
//                                   if (value!.trim().isEmpty) {
//                                     return 'Please enter a name';
//                                   }
//                                   return null;
//                                 },
//                                 onFieldSubmitted: (value) {
//                                   if (_formKey.currentState!.validate()) {
//                                     _addName(value);
//                                   }
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             GestureDetector(
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _addName(_nameController.text.trim());
//                                 }
//                               },
//                               child: Card(
//                                 margin: EdgeInsets.zero,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                         color: Colors.black45, width: 2),
//                                   ),
//                                   padding: const EdgeInsets.all(12),
//                                   child: const Text(
//                                     'Add Name',
//                                     style: TextStyle(
//                                       color: Colors.black87,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (_names.isNotEmpty)
//                 Expanded(
//                   child: Card(
//                     color: Colors.white,
//                     margin: EdgeInsets.zero,
//                     elevation: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                           child: Row(
//                             children: [
//                               ElevatedButton.icon(
//                                 style: ElevatedButton.styleFrom(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(12, 8, 16, 8),
//                                 ),
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.people_alt_outlined),
//                                 label: Text('Total (${_names.length})'),
//                               ),
//                               const SizedBox(width: 16),
//                               ElevatedButton.icon(
//                                 style: ElevatedButton.styleFrom(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(8, 8, 16, 8),
//                                 ),
//                                 onPressed: _clearAllNames,
//                                 icon: const Icon(Icons.refresh),
//                                 label: const Text('Reset'),
//                               ),
//                               const SizedBox(width: 16),
//                               if (_isLoading && _currentFileName != null)
//                                 Expanded(
//                                   child: Text(
//                                     '✔ $_currentFileName',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(color: Colors.green),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.separated(
//                             shrinkWrap: true,
//                             separatorBuilder: (context, index) =>
//                                 const SizedBox(height: 10),
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                             itemCount: _names.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               final sortedNames = _names.toList()..sort();
//                               final name = sortedNames[index];
//                               return Card(
//                                 elevation: 0,
//                                 margin: EdgeInsets.zero,
//                                 child: ListTile(
//                                   title: Text(name),
//                                   trailing: IconButton(
//                                     icon: const Icon(Icons.delete),
//                                     onPressed: () {
//                                       _deleteName(index);
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'certificate_generator.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool _isLoading = false;
  String _activePdfName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _generateCertificates() async {
    final firestore = FirebaseFirestore.instance;

    final namesSnapshot = await firestore
        .collection('training/ME49ryDAn4ExrNmXAtBZ/members')
        .get();

    final names = namesSnapshot.docs.map((doc) => doc['name']).toList();

    if (names.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _activePdfName = '';
    });

    try {
      final doc = await firestore
          .collection('training')
          .doc('ME49ryDAn4ExrNmXAtBZ')
          .get();
      final certificateType = doc.get('certificateType');
      final name = certificateType['name'];
      final imageUrl = certificateType['url'];
      final position = certificateType['position'];

      for (var fileName in names) {
        setState(() {
          _activePdfName = fileName;
        });
        await _generateCertificateInBackground(
            fileName, imageUrl, position, name);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _activePdfName = '';
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All certificates have been generated!')),
    );
  }

  Future<void> _generateSingleCertificate(String fileName) async {
    final firestore = FirebaseFirestore.instance;
    final doc = await firestore
        .collection('training')
        .doc('ME49ryDAn4ExrNmXAtBZ')
        .get();

    final certificateType = doc.get('certificateType');
    final name = certificateType['name'];
    final imageUrl = certificateType['url'];
    final position = certificateType['position'];

    await _generateCertificateInBackground(fileName, imageUrl, position, name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$fileName certificate has been generated!')),
    );
  }

  static Future<void> _generateCertificateInBackground(
      String fileName, String imageUrl, double position, String type) async {
    return await compute(_generateCertificate, {
      'fileName': fileName,
      'imageUrl': imageUrl,
      'position': position,
      'type': type
    });
  }

  static Future<void> _generateCertificate(Map<String, dynamic> params) async {
    final fileName = params['fileName']!;
    final imageUrl = params['imageUrl']!;
    final position = params['position']!;
    final type = params['type']!;
    await PdfGenerator.createCertificate(fileName, imageUrl, position, type);
  }

  Future<void> _addName(String name) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('training/ME49ryDAn4ExrNmXAtBZ/members').add({
      'name': _capitalizeEachWord(name),
    });
    _nameController.clear();
    _nameFocusNode.requestFocus();
  }

  String _capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificate Generator',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(180, 40),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed:
                                _isLoading ? null : _generateCertificates,
                            child: _isLoading
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                      SizedBox(width: 16),
                                      Text('Generating...'),
                                    ],
                                  )
                                : const Text('Generate Certificates'),
                          ),
                          const SizedBox(width: 8),
                          if (_activePdfName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  Text(
                                    ' $_activePdfName',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                autofocus: true,
                                focusNode: _nameFocusNode,
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Full Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (_formKey.currentState!.validate()) {
                                    _addName(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _addName(_nameController.text.trim());
                                }
                              },
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.black45, width: 2),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Text(
                                    'Add Name',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!_isLoading)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('training/ME49ryDAn4ExrNmXAtBZ/members')
                      .orderBy('name')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No names added yet.');
                    }
                    final names =
                        snapshot.data!.docs.map((doc) => doc['name']).toList();

                    //
                    return Expanded(
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //total
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 40),
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 16, 8),
                                ),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.people_alt_outlined,
                                  size: 20,
                                ),
                                label: Text('Total (${names.length})'),
                              ),
                            ),

                            // names
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                itemCount: names.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final name = names[index];
                                  return Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    child: ListTile(
                                      title: Text(name),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.picture_as_pdf),
                                            onPressed: () {
                                              _generateSingleCertificate(name);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              final doc =
                                                  snapshot.data!.docs[index];
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      'training/ME49ryDAn4ExrNmXAtBZ/members')
                                                  .doc(doc.id)
                                                  .delete();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
