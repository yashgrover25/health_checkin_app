import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendarScreen extends StatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  MoodCalendarScreenState createState() => MoodCalendarScreenState();
}

class MoodCalendarScreenState extends State<MoodCalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, String> moods = {};

  final moodIcons = {
    "Happy": "😊",
    "Sad": "😔",
    "Neutral": "😐",
    "Angry": "😡",
    "Excited": "🤩",
  };

  void _selectMood(DateTime day) async {
    String? selectedMood = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Select Mood"),
        children: moodIcons.entries.map((entry) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, entry.key),
            child: Row(
              children: [
                Text(entry.value, style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Text(entry.key),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (selectedMood != null) {
      setState(() {
        moods[DateTime(day.year, day.month, day.day)] = selectedMood;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mood Tracker"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              weekendDays: [DateTime.saturday, DateTime.sunday],
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              startingDayOfWeek: StartingDayOfWeek.monday,

              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _selectMood(selectedDay); // open mood selector
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final mood = moods[DateTime(day.year, day.month, day.day)];
                  if (mood != null) {
                    return Center(
                      child: Text(
                        moodIcons[mood]!,
                        style: TextStyle(fontSize: 22),
                      ),
                    );
                  }
                  return Center(child: Text("${day.day}"));
                },
                todayBuilder: (context, day, focusedDay) {
                  final mood = moods[DateTime(day.year, day.month, day.day)];
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        mood != null ? moodIcons[mood]! : "${day.day}",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly Mood Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 12,
                    children: moodIcons.entries.map((entry) {
                      int count = moods.values
                          .where((m) => m == entry.key)
                          .length;
                      return Chip(
                        label: Text("${entry.value} ${entry.key} : $count"),
                        backgroundColor: Colors.green.shade100,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
