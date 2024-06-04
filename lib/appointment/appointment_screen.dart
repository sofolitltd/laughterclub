import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  final ScrollController _scrollController = ScrollController();
  bool _isStudent = false;
  double baseFee = 500;
  double fees = 500;
  String _selectedType = 'Online';
  final List<String> _types = [
    'Online',
    'Offline(Chittagong University Campus only)'
  ];

  // New variables for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToSelectedDate());
  }

  void _scrollToSelectedDate() {
    List<DateTime> dates = _generateDates();
    int index = dates.indexOf(_selectedDate);
    if (index != -1) {
      double position = index * 68.0; // Width (60) + Margin (8)
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<DateTime> _generateDates() {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month, 1);
    final DateTime lastDate =
        DateTime(now.year, now.month + 2, 0); // End of next month
    List<DateTime> dates = [];

    for (DateTime date = firstDate;
        date.isBefore(lastDate);
        date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }

    return dates;
  }

  bool _isDateSelectable(DateTime date) {
    if (_selectedType == 'Online') {
      return date.weekday == DateTime.thursday ||
          date.weekday == DateTime.friday ||
          date.weekday == DateTime.wednesday;
    } else if (_selectedType == 'Offline(Chittagong University Campus only)') {
      return date.weekday == DateTime.sunday ||
          date.weekday == DateTime.tuesday ||
          date.weekday == DateTime.thursday;
    }
    return false;
  }

  DateTime _getFirstSelectableDate(List<DateTime> dates) {
    for (DateTime date in dates) {
      if (_isDateSelectable(date) && !date.isBefore(DateTime.now())) {
        return date;
      }
    }
    return dates.first;
  }

  List<String> _generateTimes() {
    if (_selectedType == 'Online') {
      return [
        '06:00 PM',
        '07:00 PM',
        '08:00 PM',
        '09:00 PM',
        '10:00 PM',
        '11:00 PM',
      ];
    } else {
      return [
        '09:00 AM',
        '03:00 PM',
        '04:00 PM',
      ];
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedDate != null && _selectedTime.isNotEmpty) {
      final appointment = {
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'time': _selectedTime,
        'fees': fees,
        'name': _nameController.text.trim(), // Include name
        'mobile': _mobileController.text.trim(), // Include mobile
      };

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointment);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentConfirmationScreen(
            date: _selectedDate,
            time: _selectedTime,
            fees: fees,
          ),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getBookedAppointments() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('appointments').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  void _updateFees() {
    setState(() {
      if (_isStudent) {
        fees = baseFee * 0.8; // Apply 20% discount
      } else {
        fees = baseFee; // Reset to base fees
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = _generateDates();
    List<String> times = _generateTimes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 768),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Type
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    focusColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    value: _selectedType,
                    items: _types.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedType = val!;
                        _selectedDate = DateTime.now();
                        _selectedTime = '';
                        _scrollToSelectedDate();
                      });
                    },
                  ),
                ),

                const SizedBox(height: 4),

                // Schedule
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      DateTime date = dates[index];
                      bool isSelected = date == _selectedDate;
                      bool isDisabled = !_isDateSelectable(date) ||
                          date.isBefore(DateTime.now()) ||
                          (date.day == DateTime.now().day &&
                              !_isDateSelectable(DateTime.now()));
                      return GestureDetector(
                        onTap: isDisabled
                            ? null
                            : () {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blueAccent.shade400
                                : (isDisabled
                                    ? Colors.grey.shade200
                                    : Colors.white),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEE').format(date),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDisabled
                                            ? Colors.black26
                                            : Colors.black),
                                  ),
                                ),
                                Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDisabled
                                            ? Colors.black26
                                            : Colors.black.withOpacity(.7)),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM, yy').format(date),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.white.withOpacity(.5)
                                        : (isDisabled
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black.withOpacity(.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Time
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    'Select Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getBookedAppointments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      List<Map<String, dynamic>> bookedAppointments =
                          snapshot.data!;
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio:
                              MediaQuery.of(context).size.width < 550 ? 3 : 5,
                        ),
                        itemCount: times.length,
                        itemBuilder: (context, index) {
                          String time = times[index];
                          bool isDisabled = bookedAppointments.any(
                              (appointment) =>
                                  appointment['date'] ==
                                      DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate) &&
                                  appointment['time'] == time);
                          return GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () {
                                    setState(() {
                                      _selectedTime = time;
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedTime == time
                                    ? Colors.blueAccent.shade400
                                    : (isDisabled
                                        ? Colors.grey.shade200
                                        : Colors.white),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTime == time
                                        ? Colors.white
                                        : (isDisabled
                                            ? Colors.black26
                                            : Colors.black.withOpacity(.7)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile
                TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          value: _isStudent,
                          onChanged: (value) {
                            setState(() {
                              _isStudent = value!;
                              _updateFees();
                            });
                          },
                        ),
                        const Text(
                          '20% discount for student',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Fees: '),
                        Text(
                          ' $fees BDT',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedTime.isNotEmpty || _selectedDate == null
                      ? _bookAppointment
                      : null,
                  child: const Text('Book Appointment'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentConfirmationScreen extends StatelessWidget {
  final DateTime date;
  final String time;
  final double fees;

  const AppointmentConfirmationScreen({
    super.key,
    required this.date,
    required this.time,
    required this.fees,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmation'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Appointment Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Date: ${DateFormat('EEE, MMM d, yyyy').format(date)}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Time: $time',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Fees: $fees BDT',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
