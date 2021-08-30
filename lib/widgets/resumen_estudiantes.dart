import 'package:flutter/material.dart';

import 'pie_chart.dart';

class ResumenEstudiantes extends StatefulWidget {
  const ResumenEstudiantes({Key? key}) : super(key: key);

  @override
  _ResumenEstudiantesState createState() => _ResumenEstudiantesState();
}

class _ResumenEstudiantesState extends State<ResumenEstudiantes> {
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
                  GrupoPieChart(
                    aprobados: 30,
                    reprobados: 0,
                    pendientes: 5,
                    convenciones: false,
                    centerSpaceRadius: 12,
                    sectionRadius: 10,
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
