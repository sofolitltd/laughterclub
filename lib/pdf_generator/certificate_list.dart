import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CertificateList extends StatelessWidget {
  const CertificateList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('trainings')
                  .orderBy('dateOpen', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No names added yet.');
                }
                final docs = snapshot.data!.docs;

                //
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final id = docs[index].id;
                    final title = docs[index].get('title');
                    final batch = docs[index].get('batch');
                    final image = docs[index].get('image');
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/certificates/generate',
                              arguments: id);
                        },
                        leading: Image.network(image),
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Batch $batch'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
