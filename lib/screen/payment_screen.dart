import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Check'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('training').snapshots(),
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
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
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
                  'Mobile(bKash)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Transaction ID',
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
            child: Text(itemData['payment']['mobile']),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemData['payment']['transactionID']),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemData['payment']['amount']),
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
          child: DeletePayment(itemId: itemData.id),
        ),
      ],
    );
  }
}

class RowItem extends StatefulWidget {
  final QueryDocumentSnapshot itemData;

  const RowItem({Key? key, required this.itemData}) : super(key: key);

  @override
  _RowItemState createState() => _RowItemState();
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
      await FirebaseFirestore.instance
          .collection('training')
          .doc(widget.itemData.id)
          .update({'payment.status': newStatus});
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
  final String itemId;

  const DeletePayment({super.key, required this.itemId});

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
                .collection('training')
                .doc(itemId)
                .delete();
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
