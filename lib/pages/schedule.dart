import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Schedule')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Calendar widget
              TableCalendar(
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: DateTime.now(),
                // Customize other properties as needed
              ),
              SizedBox(height: 16), // Add spacing
              // List of scheduled programs (cards)
              SingleChildScrollView(
                child: Column(
                  children: List.generate(5, (index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        title: Text('Programme $index'),
                        subtitle: Text('10:00 - 11:00'),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
