import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(TimeRecorderApp());
}

class TimeRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Office Time Recorder',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TimeRecorderScreen(),
    );
  }
}

class TimeRecorderScreen extends StatefulWidget {
  @override
  _TimeRecorderScreenState createState() => _TimeRecorderScreenState();
}

class _TimeRecorderScreenState extends State<TimeRecorderScreen> {
  String? inTime;
  String? outTime;
  String userName = "";
  String userId ="";
  String displayText = "";
  List<Map<String, String>> records = [];

  bool inTimeRecorded = false;
  bool outTimeRecorded = false;

  String get currentDate {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  void recordInTime() {
    if (!inTimeRecorded) {
      setState(() {
        inTime = _formatCurrentTime();
        inTimeRecorded = true;
        updateDisplayText();
      });
    }
  }

  void recordOutTime() {
    if (!outTimeRecorded && inTimeRecorded) {
      setState(() {
        outTime = _formatCurrentTime();
        outTimeRecorded = true;
        _saveRecord();
        updateDisplayText();
      });
    }
  }

  void _saveRecord() {
    records.add({
      'date': currentDate,
      'inTime': inTime!,
      'outTime': outTime!,
      'name': userName,
      'id' : userId,
    });
  }

  void updateDisplayText() {
    setState(() {
      displayText = "Name: $userName\nTrainee Id: $userId\n Date: $currentDate\nIn Time: $inTime\nOut Time: $outTime";
    });
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: displayText));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to Clipboard")));
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";
  }

  // Stream<String> _clockStream() async* {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     final now = DateTime.now();
  //     yield "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  //   }
  // }
  DateTime _currentTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[500],
      appBar: AppBar(
        title: const Text(
          'Office Time Recorder',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[800],
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[200]!, Colors.teal[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child:CustomPaint(
          size: Size(300, 300),
           painter: ClockPainter(_currentTime),
           
        ),
                    
                  ),
                 Padding(
  padding: const EdgeInsets.all(20.0),
  child: Column(
    children: [
      TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black87,  // Dark background color
          labelText: 'Enter Name',
          labelStyle: const TextStyle(color: Colors.white),  // White label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),  // White border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),  // Accent color on focus
          ),
        ),
        style: const TextStyle(color: Colors.white),  // White text color
        onChanged: (value) {
          setState(() {
            userName = value;
          });
        }, 
      ),

       const SizedBox(height: 16.0), // Adds a gap of 16 pixels between the text fields

       TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black87,  // Dark background color
          labelText: 'Enter Trainee Id',
          labelStyle: const TextStyle(color: Colors.white),  // White label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),  // White border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),  // Accent color on focus
          ),
        ),
        style: const TextStyle(color: Colors.white),  // White text color
        onChanged: (value) {
          setState(() {
            userId = value;
          });
        },
      ),
    ],
  ),
  
),

                  Card(
                    color: Colors.teal[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Date: $currentDate',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Time: ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.teal[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'In Time: ${inTime ?? "--:--:--"}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: inTimeRecorded ? null : recordInTime,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Record In Time',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Out Time: ${outTime ?? "--:--:--"}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: outTimeRecorded ? null : recordOutTime,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Record Out Time',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (records.isNotEmpty) ...[
                    const Text(
                      'Recorded Times',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal[800],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.teal[900]!),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.teal[900]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Trainee ID',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'In Time',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Out Time',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            ...records.map((record) => TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        record['name']!,
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        record['id']!,
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        record['date']!,
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        record['inTime']!,
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        record['outTime']!,
                                        style: const TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  const SizedBox(height: 20),
                  Text(displayText, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: copyToClipboard,
                    child: const Text('Copy to Clipboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Draw clock face
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Draw ticks for hours, minutes, and seconds
    drawTicks(canvas, centerX, centerY, radius);

    // Draw numbers on the clock
    drawNumbers(canvas, centerX, centerY, radius);

    // Draw hour hand
    double hourAngle = (time.hour % 12) * 30 + (time.minute / 2); // 30 degrees per hour + extra for minutes
    double hourX = centerX + (radius - 40) * cos((hourAngle - 90) * pi / 180);
    double hourY = centerY + (radius - 40) * sin((hourAngle - 90) * pi / 180);
    paint.strokeWidth = 6;
    canvas.drawLine(Offset(centerX, centerY), Offset(hourX, hourY), paint);

    // Draw minute hand
    double minuteAngle = time.minute * 6; // 6 degrees per minute
    double minuteX = centerX + (radius - 20) * cos((minuteAngle - 90) * pi / 180);
    double minuteY = centerY + (radius - 20) * sin((minuteAngle - 90) * pi / 180);
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(centerX, centerY), Offset(minuteX, minuteY), paint);

    // Draw second hand
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    double secondAngle = time.second * 6; // 6 degrees per second
    double secondX = centerX + (radius - 10) * cos((secondAngle - 90) * pi / 180);
    double secondY = centerY + (radius - 10) * sin((secondAngle - 90) * pi / 180);
    canvas.drawLine(Offset(centerX, centerY), Offset(secondX, secondY), paint);
  }

  void drawTicks(Canvas canvas, double centerX, double centerY, double radius) {
    Paint tickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Hour ticks
    for (int i = 0; i < 12; i++) {
      double angle = (i * 30 - 90) * pi / 180; // 30 degrees for each hour
      double startX = centerX + (radius - 15) * cos(angle);
      double startY = centerY + (radius - 15) * sin(angle);
      double endX = centerX + (radius - 25) * cos(angle);
      double endY = centerY + (radius - 25) * sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
    }

    // Minute ticks
    for (int i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        double angle = (i * 6 - 90) * pi / 180; // 6 degrees for each minute
        double startX = centerX + (radius - 10) * cos(angle);
        double startY = centerY + (radius - 10) * sin(angle);
        double endX = centerX + (radius - 15) * cos(angle);
        double endY = centerY + (radius - 15) * sin(angle);
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
      }
    }
  }

  void drawNumbers(Canvas canvas, double centerX, double centerY, double radius) {
    Paint textPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    TextSpan textSpan;
    TextPainter textPainter;

    for (int i = 1; i <= 12; i++) {
      double angle = (i * 30 - 90) * pi / 180; // 30 degrees for each hour
      double x = centerX + (radius - 40) * cos(angle);
      double y = centerY + (radius - 40) * sin(angle);

      textSpan = TextSpan(
        text: i.toString(),
        style: textStyle,
      );

      textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
