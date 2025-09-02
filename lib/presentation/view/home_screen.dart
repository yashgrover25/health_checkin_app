import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'calender_view.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime todayDateTime = DateTime.now();
int? _selectedIndex;

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  double anxietyProgress = 3;
  double sleepProgress = 4;

  String selectedActivity = "Good";
  List<String> selectedSymptoms = [];

  final activityOptions = ["Good", "Average", "Bad"];
  final symptoms = ["Headache", "Fever", "Cough", "Fatigue", "Nausea"];
  final moodIcons = ["😊", "😔", "😐", "😡", "🤩"];
  final moods = ["Happy", "Sad", "Neutral", "Angry", "Excited"];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green[700],
          elevation: 0,
          title: Text("Health Check-in", style: TextStyle(color: Colors.black)),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodCalendarScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                        size: 18,
                      color: Colors.black,),
                      Text(
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Mood
              Text(
                "Current Mood",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50, // enough height for chips
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        shadowColor: Colors.black,
                        backgroundColor: Colors.grey[200],
                        side: BorderSide(),
                        pressElevation: 5,
                        selectedColor: Colors.green,
                        label: Text("${moodIcons[index]} ${moods[index]}"),
                        selected: _selectedIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            _selectedIndex = selected ? index : null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Today's Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
      
              goalCard("Anxiety/Stress throughout the day", anxietyProgress, (
                val,
              ) {
                setState(() => anxietyProgress = val);
              }),
              SizedBox(height: 18),
              goalCard("Sleep Quality", sleepProgress, (val) {
                setState(() => sleepProgress = val);
              }),
      
              SizedBox(height: 20),
      
              // Sleep Section
              Text(
                "Exercise / Activity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: activityOptions.map((option) {
                  return ChoiceChip(
                    label: Text(option),
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: selectedActivity == option
                          ? Colors.white
                          : Colors.black,
                    ),
                    backgroundColor: Colors.grey[200],
                    selected: selectedActivity == option,
                    onSelected: (selected) {
                      setState(() {
                        selectedActivity = option;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
      
              // Health Condition Section
              Text(
                "Health Condition Symptoms",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: symptoms.map((symptom) {
                  return FilterChip(
                    label: Text(symptom),
                    selectedColor: Colors.green,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedSymptoms.contains(symptom)
                          ? Colors.white
                          : Colors.black,
                    ),
                    backgroundColor: Colors.grey[200],
                    selected: selectedSymptoms.contains(symptom),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSymptoms.add(symptom);
                        } else {
                          selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.settings,
          activeIcon: Icons.close,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.green,
          overlayOpacity: 00,
          spacing: 10,
          children: [
            SpeedDialChild(
              shape: CircleBorder(),
              onTap: () {
                _logout(context);
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget goalCard(String title, double value, Function(double) onChanged) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Slider(
            allowedInteraction: SliderInteraction.slideOnly
            ,
            activeColor: Colors.green,
            inactiveColor: Colors.green.shade100,
            value: value,
            min: 0,
            max: 4,
            divisions: 4,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
          Padding(
            padding: const EdgeInsets.only(left:12,right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Poor"),
                Text("Not Well"),
                Text("Okay"),
                Text("Great"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
