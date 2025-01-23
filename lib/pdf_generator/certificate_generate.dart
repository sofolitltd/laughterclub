import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pdf_generator.dart';

class CertificateGenerate extends StatefulWidget {
  const CertificateGenerate({super.key});

  @override
  State<CertificateGenerate> createState() => _CertificateGenerateState();
}

class _CertificateGenerateState extends State<CertificateGenerate> {
  bool _isLoading = false;
  String _activePdfName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  // var trainingID = "Pm52xAxZYyFrIpFyM1Mc";
  String trainingID = "";

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

// single pdf
  Future<void> _generateSingleCertificate(String fileName) async {
    final firestore = FirebaseFirestore.instance;
    final doc = await firestore.collection('trainings').doc(trainingID).get();

    final trainingTitle = doc.get('title');
    final background = doc.get('certificate')['background'];
    final position = doc.get('certificate')['position'];

    await _generateCertificateInBackground(
        fileName, background, position, trainingTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$fileName certificate has been generated!')),
    );
  }

  // multi pdf 1 by 1
  Future<void> _generateCertificates() async {
    final ref = FirebaseFirestore.instance.collection('trainings');
    final namesSnapshot = await ref.doc(trainingID).collection('members').get();
    final names = namesSnapshot.docs.map((doc) => doc['name']).toList();
    if (names.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _activePdfName = '';
    });

    try {
      final doc = await ref.doc(trainingID).get();

      //
      final trainingTitle = doc.get('title');
      final background = doc.get('certificate')['background'];
      final position = doc.get('certificate')['position'];

      for (var memberName in names) {
        setState(() {
          _activePdfName = memberName;
        });
        await _generateCertificateInBackground(
            memberName, background, position, trainingTitle);
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

  // all in one
  Future<void> _generateAllInOnePdf() async {
    final firestore = FirebaseFirestore.instance;
    final doc = await firestore.collection('trainings').doc(trainingID).get();

    final trainingTitle = doc.get('title');
    final background = doc.get('certificate')['background'];
    final position = doc.get('certificate')['position'];

    final namesSnapshot = await firestore
        .collection('trainings')
        .doc(trainingID)
        .collection('members')
        .get();
    final List names = namesSnapshot.docs.map((doc) => doc['name']).toList();

    if (names.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _activePdfName = '';
    });

    try {
      await PdfGenerator.createAllCertificates(
        names,
        List.filled(names.length, background), // Fill background list
        List.filled(names.length, position), // Fill position list
        List.filled(names.length, trainingTitle), // Fill trainingTitle list
      );
    } finally {
      setState(() {
        _isLoading = false;
        _activePdfName = '';
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('All certificates have been generated in a single PDF!')),
    );
  }

  // background task
  static Future<void> _generateCertificateInBackground(String memberName,
      String background, double position, String trainingTitle) async {
    return await compute(_generateCertificate, {
      'memberName': memberName,
      'background': background,
      'position': position,
      'trainingTitle': trainingTitle
    });
  }

  static Future<void> _generateCertificate(Map<String, dynamic> params) async {
    final memberName = params['memberName']!;
    final background = params['background']!;
    final position = params['position']!;
    final trainingTitle = params['trainingTitle']!;

    //
    await PdfGenerator.createCertificate(
        memberName, background, position, trainingTitle);
  }

  // add name
  Future<void> _addName(String name) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('trainings')
        .doc(trainingID)
        .collection('members')
        .add({
      'name': _capitalizeEachWord(name),
    });
    _nameController.clear();
    _nameFocusNode.requestFocus();
  }

  // capitalize
  String _capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    trainingID = ModalRoute.of(context)!.settings.arguments as String;

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
                      // generate 1 by 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // minimumSize: const Size(180, 40),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed:
                                _isLoading ? null : _generateCertificates,
                            child: const Text('1 by 1'),
                          ),

                          const SizedBox(width: 10),
                          // New button for generating all in one PDF
                          ElevatedButton(
                            onPressed: _isLoading ? null : _generateAllInOnePdf,
                            child: const Text('All'),
                          ),

                          //
                          if (_isLoading) ...[
                            const SizedBox(width: 8),
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ],

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

                      // all in one

                      //
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
                      .collection('trainings')
                      .doc(trainingID)
                      .collection('members')
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
                                                  .collection('trainings')
                                                  .doc(trainingID)
                                                  .collection('members')
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
