import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GrupoPieChart extends StatefulWidget {
  GrupoPieChart({
    Key? key,
    this.aprobados,
    this.reprobados,
    this.pendientes,
    this.convenciones,
    this.centerSpaceRadius,
    this.sectionRadius,
  }) : super(key: key);
  final double? aprobados;
  final double? reprobados;
  final double? pendientes;
  final double? centerSpaceRadius;
  final double? sectionRadius;
  bool? convenciones = false;

  @override
  _GrupoPieChartState createState() => _GrupoPieChartState();
}

class _GrupoPieChartState extends State<GrupoPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: widget.centerSpaceRadius! * .15,
                    startDegreeOffset: 0,
                    centerSpaceRadius: widget.centerSpaceRadius,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            (widget.convenciones!)
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Indicator(
                        color: Colors.lightGreen,
                        text: 'Aprobados',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Indicator(
                        color: Color(0xfff8b250),
                        text: 'Pendientes',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Reprobados',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      // Indicator(
                      //   color: Color(0xff13d38e),
                      //   text: 'Fourth',
                      //   isSquare: true,
                      // ),
                      SizedBox(
                        height: 9,
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize =
          isTouched ? widget.sectionRadius! * .40 : widget.sectionRadius! * .25;
      final radius =
          isTouched ? widget.sectionRadius : (widget.sectionRadius! * .8);
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.lightGreen,
            value: widget.aprobados,
            title: widget.aprobados!.toInt().toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: widget.reprobados,
            title: widget.reprobados!.toInt().toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.pendientes,
            title: widget.pendientes!.toInt().toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        /* case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          ); */
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 14,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 10.3, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
