import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResumenEstudiantes extends StatefulWidget {
  const ResumenEstudiantes({Key? key}) : super(key: key);

  @override
  _ResumenEstudiantesState createState() => _ResumenEstudiantesState();
}

class _ResumenEstudiantesState extends State<ResumenEstudiantes> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResumenRow(),
    );
  }
}

class ResumenRow extends StatefulWidget {
  const ResumenRow({Key? key}) : super(key: key);

  @override
  _ResumenRowState createState() => _ResumenRowState();
}

class _ResumenRowState extends State<ResumenRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleAvatar(
                    radius: 20,
                  ),
                  Text('Nombres y apellidos'),
                ],
              ),
            ),
            const Text('Fecha'),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 5.0,
                    animation: true,
                    animationDuration: 3000,
                    percent: 0.7,
                    animateFromLastPercent: true,
                    center: const Text(
                      "10",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.lightGreen,
                    backgroundColor: Colors.red,
                  ),
                  Icon(
                    Icons.emoji_events,
                    color: Colors.yellow[700],
                    size: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
