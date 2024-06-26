import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminPayment extends StatelessWidget {
  const AdminPayment({super.key});

  @override
  Widget build(BuildContext context) {
    var trainingId = 'basic-counseling-2';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Check'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('route', isEqualTo: trainingId)
            // .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1920),
              padding: const EdgeInsets.all(16),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    primary: true,
                    scrollDirection: Axis.horizontal,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: MyTable(data: data),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyTable extends StatelessWidget {
  final List<QueryDocumentSnapshot> data;

  const MyTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(),
      children: [
        const TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Method',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Reference',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Action',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        ...data.asMap().entries.map((entry) {
          int index = entry.key + 1;
          QueryDocumentSnapshot itemData = entry.value;
          return buildTableRow(context, index, itemData);
        }),
      ],
    );
  }

  TableRow buildTableRow(
      BuildContext context, int index, QueryDocumentSnapshot itemData) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(index.toString()),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: itemData['name']));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name copied to clipboard')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(itemData['name']),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemData['payment']['method']),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemData['payment']['reference']),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemData['payment']['fee']),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RowItem(itemData: itemData),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: DeletePayment(itemData: itemData),
        ),
      ],
    );
  }
}

//
class RowItem extends StatefulWidget {
  final QueryDocumentSnapshot itemData;

  const RowItem({super.key, required this.itemData});

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.itemData['payment']['status'];
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      selectedStatus = newStatus;
    });

    try {
      //
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.itemData.id)
          .update({'payment.status': newStatus});

      //
      var userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.itemData.get('uid'));

      if (selectedStatus == 'Completed') {
        await userRef.update({
          'trainings': FieldValue.arrayUnion([widget.itemData.get('route')]),
        });
      } else {
        //
        await userRef.update({
          'trainings': FieldValue.arrayRemove([widget.itemData.get('route')]),
        });
      }
    } catch (e) {
      print("Failed to update status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: DropdownButton<String>(
        padding: EdgeInsets.zero,
        isExpanded: true,
        value: selectedStatus,
        focusColor: Colors.transparent,
        items: <String>['Pending', 'Completed', 'Failed']
            .map<DropdownMenuItem<String>>((String value) {
          Color? itemColor;
          if (value == 'Pending') {
            itemColor = Colors.amber; // Change color based on status
          } else if (value == 'Completed') {
            itemColor = Colors.green; // Change color based on status
          } else if (value == 'Failed') {
            itemColor = Colors.red; // Change color based on status
          }
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: itemColor), // Apply color to text
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            _updateStatus(newValue);
          }
        },
        underline: Container(), // Remove underline
      ),
    );
  }
}

//
class DeletePayment extends StatelessWidget {
  final QueryDocumentSnapshot itemData;

  const DeletePayment({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (confirmDelete) {
          try {
            await FirebaseFirestore.instance
                .collection('payments')
                .doc(itemData.id)
                .delete();
            //
            var userRef = FirebaseFirestore.instance
                .collection('users')
                .doc(itemData.get('uid'));
            await userRef.update({
              'trainings': FieldValue.arrayRemove([itemData.get('route')]),
            });

            //
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item deleted successfully')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete item: $e')),
            );
          }
        }
      },
    );
  }
}
