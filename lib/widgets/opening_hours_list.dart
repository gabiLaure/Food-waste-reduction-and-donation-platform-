import 'package:flutter/material.dart';

class OpeningHoursList extends StatefulWidget {
  final List<Map<String, dynamic>> openingHours;
  final void Function(List<Map<String, dynamic>>) onOpeningHoursChanged;

  OpeningHoursList(
      {Key? key,
      required this.openingHours,
      required this.onOpeningHoursChanged})
      : super(key: key);

  @override
  _OpeningHoursListState createState() => _OpeningHoursListState();
}

class _OpeningHoursListState extends State<OpeningHoursList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.openingHours.length,
      itemBuilder: (context, index) {
        final dayData = widget.openingHours[index];
        return _buildOpeningHourTile(
          day: dayData['day'],
          open: dayData['open'],
          close: dayData['close'],
          onOpenTimeChanged: (newTime) {
            setState(() {
              widget.openingHours[index]['open'] = newTime;
              widget.onOpeningHoursChanged(widget.openingHours);
            });
          },
          onCloseTimeChanged: (newTime) {
            setState(() {
              widget.openingHours[index]['close'] = newTime;
              widget.onOpeningHoursChanged(widget.openingHours);
            });
          },
        );
      },
    );
  }

  /// Méthode pour construire un widget d'élément pour chaque jour
  Widget _buildOpeningHourTile({
    required String day,
    required TimeOfDay open,
    required TimeOfDay close,
    required void Function(TimeOfDay) onOpenTimeChanged,
    required void Function(TimeOfDay) onCloseTimeChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(day),
        subtitle: Text(
          "Ouverture: ${open.format(context)} - Fermeture: ${close.format(context)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: open,
                );
                if (pickedTime != null) {
                  onOpenTimeChanged(pickedTime);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.access_time_filled),
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: close,
                );
                if (pickedTime != null) {
                  onCloseTimeChanged(pickedTime);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
