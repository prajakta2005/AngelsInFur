import 'package:flutter/material.dart';

class VetConnectScreen extends StatefulWidget {
  const VetConnectScreen({super.key});

  @override
  State<VetConnectScreen> createState() => _VetConnectScreenState();
}

class _VetConnectScreenState extends State<VetConnectScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _vetClinics = [
    'City Pet Hospital - Pune',
    'Care & Cure Clinic - Wakad',
    'Aarogya Vet Center - Kothrud',
  ];

  String? _selectedClinic;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Function to show the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800, // Primary color for date picker
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to show the Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function to handle the booking submission
  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Appointment Confirmed! 🎉'),
            content: Text(
              'You have successfully booked an appointment with $_selectedClinic '
              'on ${MaterialLocalizations.of(context).formatShortDate(_selectedDate!)} '
              'at ${_selectedTime!.format(context)}.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reset state for a new booking
                  setState(() {
                    _selectedClinic = null;
                    _selectedDate = null;
                    _selectedTime = null;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Helper to format TimeOfDay to String
  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  // Helper to format DateTime to String
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return MaterialLocalizations.of(context).formatShortDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Connect - Pune 💉'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book an Appointment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Text(
                'Find the best veterinary care for your Angel in Pune.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Clinic Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Clinic',
                  prefixIcon: Icon(Icons.location_city, color: Colors.blue.shade800),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                value: _selectedClinic,
                items: _vetClinics.map((String clinic) {
                  return DropdownMenuItem<String>(
                    value: clinic,
                    child: Text(clinic),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClinic = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a clinic' : null,
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: Text(
                  _formatDate(_selectedDate),
                  style: TextStyle(fontSize: 16, color: _selectedDate == null ? Colors.grey.shade600 : Colors.black),
                ),
                leading: Icon(Icons.calendar_today, color: Colors.blue.shade800),
                trailing: const Icon(Icons.arrow_drop_down),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Time Picker
              ListTile(
                title: Text(
                  _formatTimeOfDay(_selectedTime),
                  style: TextStyle(fontSize: 16, color: _selectedTime == null ? Colors.grey.shade600 : Colors.black),
                ),
                leading: Icon(Icons.schedule, color: Colors.blue.shade800),
                trailing: const Icon(Icons.arrow_drop_down),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: (_selectedDate != null && _selectedTime != null && _selectedClinic != null)
                      ? _submitBooking
                      : null, // Disable button until selections are made
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Book Appointment', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}