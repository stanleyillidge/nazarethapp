// ignore_for_file: avoid_print, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/models.dart';
// import 'package:nazarethapp/widgets/excel_admin.dart';
import 'package:nazarethapp/widgets/pdf_admin.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BoletinesPage extends StatefulWidget {
  const BoletinesPage({Key? key}) : super(key: key);

  @override
  _BoletinesPageState createState() => _BoletinesPageState();
}

List<Resumen> resGrupos = [];
bool genBoletin = false;

class _BoletinesPageState extends State<BoletinesPage> {
  init() {
    for (var grupo in pendientes.grupos!) {
      var p0 = grupo.asignacion!
          .where((ag) => (ag.completa == false))
          .toList()
          .length;
      var p1 = (asigTotal.asignaciones
          .where((a) => (a.grupo == grupo.nombre!))
          .toList()
          .length);
      var por = 1 - (p0 / p1);
      // ignore: avoid_print
      print([grupo.nombre!, p0, p1, por]);
    }
  }

  @override
  void initState() {
    // init();
    resGrupos = pendientes.grupos!;
    super.initState();
  }

  Widget grupoCard(Size size, int index) {
    // ListTile(
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grupo ' + pendientes.grupos![index].nombre!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: Text(
                    sede(pendientes.grupos![index].nombre!),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.0325,
            height: size.height * 0.065,
            child: CircularPercentIndicator(
              radius: size.width * 0.035,
              animation: true,
              animationDuration: 1200,
              lineWidth: 7.0,
              percent: (1 -
                  ((pendientes.grupos![index].asignacion!
                          .where((ag) => (ag.completa == false))
                          .toList()
                          .length) /
                      (asigTotal.asignaciones
                          .where((a) =>
                              (a.grupo == pendientes.grupos![index].nombre!))
                          .toList()
                          .length))),
              center: Text(
                ((1 -
                                ((pendientes.grupos![index].asignacion!
                                        .where((ag) => (ag.completa == false))
                                        .toList()
                                        .length) /
                                    (asigTotal.asignaciones
                                        .where((a) => (a.grupo ==
                                            pendientes.grupos![index].nombre!))
                                        .toList()
                                        .length))) *
                            100)
                        .toStringAsFixed(1) +
                    "%",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 10.0),
              ),
              // footer:Text(
              //   "Asignaciones calificadas",
              //   style:TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 15.0),
              // ),
              progressColor: Colors.brown,
              backgroundColor: Colors.red.shade300,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget grupoCard2(Size size, int index) {
    bool selected = false;
    return ListTile(
      selected: selected,
      // horizontalTitleGap: 5,
      // minVerticalPadding: 5,
      // minLeadingWidth: 5,
      visualDensity: VisualDensity.compact,
      onTap: () {
        setState(() {
          selected = !selected;
        });
        // ignore: avoid_print
        print(index);
      },
      title: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grupo ' + resGrupos[index].nombre!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        sede(resGrupos[index].nombre!).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: size.width * 0.0325,
                  height: size.height * 0.065,
                  child: CircularPercentIndicator(
                    radius: size.width * 0.035,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 7.0,
                    percent: (1 -
                        ((resGrupos[index]
                                .asignacion!
                                .where((ag) => (ag.completa == false))
                                .toList()
                                .length) /
                            (asigTotal.asignaciones
                                .where((a) =>
                                    (a.grupo == resGrupos[index].nombre!))
                                .toList()
                                .length))),
                    center: Text(
                      ((1 -
                                      ((resGrupos[index]
                                              .asignacion!
                                              .where((ag) =>
                                                  (ag.completa == false))
                                              .toList()
                                              .length) /
                                          (asigTotal.asignaciones
                                              .where((a) => (a.grupo ==
                                                  resGrupos[index].nombre!))
                                              .toList()
                                              .length))) *
                                  100)
                              .toStringAsFixed(1) +
                          "%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0),
                    ),
                    // footer:Text(
                    //   "Asignaciones calificadas",
                    //   style:TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15.0),
                    // ),
                    progressColor: Colors.brown,
                    backgroundColor: Colors.red.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: (selected) ? Colors.amberAccent : Colors.amber,
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

// GlobalKey<_GrupoCardState> gckey = GlobalKey();
  final ScrollController? _boletinesScrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final ButtonStyle style =
    //     ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20));
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * 0.35,
                    height: size.height * 0.1,
                    child: TextFormField(
                      onChanged: (v) {
                        setState(() {
                          List<Resumen> resGrupost = pendientes.grupos!
                              .where(
                                (g) => ((g.nombre!
                                        .substring(0)
                                        .contains(v.toUpperCase())) ||
                                    (sede(g.nombre!)
                                        .toUpperCase()
                                        //  == v.toUpperCase()
                                        .contains(v.toUpperCase()))),
                              )
                              .toList();
                          resGrupos =
                              (v != '') ? resGrupost : pendientes.grupos!;
                        });
                        // print([v.toUpperCase(), resGrupost.length]);
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    height: 10,
                  ),
                  ElevatedButton(
                    // style: style,
                    onPressed: () async {
                      setState(() {
                        genBoletin = true;
                      });
                      for (var i = 0; i < resGrupos.length; i++) {
                        if (resGrupos[i].selected!) {
                          // print(resGrupos[i].toJson());
                          await generateBoletin3(resGrupos[i]);
                          setState(() {
                            resGrupos[i].selected = false;
                          });
                          // print(['Boletin', i, resGrupos[i].toJson()]);
                        }
                      }
                      setState(() {
                        genBoletin = false;
                      });
                      List<Widget> body = [];
                      body.add(const Text(
                          'Las Boletines fueron guardadas en la ubicación de descargas.'));
                      // _showMyDialog(titulo, body);
                    },
                    child: Row(
                      children: [
                        (genBoletin)
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  // strokeWidth: 1.5,
                                ),
                              )
                            : Container(),
                        (genBoletin)
                            ? const SizedBox(
                                width: 10,
                                height: 10,
                              )
                            : Container(),
                        const Text('Generar Boletines'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.85,
              child: GridView.builder(
                  shrinkWrap: true,
                  controller: _boletinesScrollController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    // mainAxisExtent: 100,
                    childAspectRatio: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: resGrupos.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GrupoCard(index: index);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GrupoCard extends StatefulWidget {
  GrupoCard({Key? key, required this.index}) : super(key: key);
  int index;

  @override
  _GrupoCardState createState() => _GrupoCardState();
}

class _GrupoCardState extends State<GrupoCard> {
  @override
  void initState() {
    // init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListTile(
      selected: resGrupos[widget.index].selected!,
      // horizontalTitleGap: 5,
      // minVerticalPadding: 5,
      // minLeadingWidth: 5,
      visualDensity: VisualDensity.compact,
      onTap: () {
        setState(() {
          resGrupos[widget.index].selected = !resGrupos[widget.index].selected!;
        });
        print(widget.index);
        List<Estudiante> lista = estudiantes
            .where((e) => (e.grupo == resGrupos[widget.index].nombre))
            .toList();
        lista.sort((a, b) {
          return a.calificaciones!
              .notaFinal()
              .compareTo(b.calificaciones!.notaFinal());
        });
        // print(lista[0].toJson());
      },
      title: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grupo ' + resGrupos[widget.index].nombre!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        sede(resGrupos[widget.index].nombre!).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: size.width * 0.035,
                  height: size.height * 0.075,
                  child: CircularPercentIndicator(
                    radius: size.width * 0.0385,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 6.0,
                    percent: (1 -
                        ((resGrupos[widget.index]
                                .asignacion!
                                .where((ag) => ((ag.completa == false) &&
                                    (ag.periodo == dropdownPeriodo)))
                                .toList()
                                .length) /
                            (asigTotal.asignaciones
                                .where((a) => ((a.grupo ==
                                        resGrupos[widget.index].nombre!) &&
                                    (a.periodo == dropdownPeriodo)))
                                .toList()
                                .length))),
                    center: Text(
                      ((1 -
                                      ((resGrupos[widget.index]
                                              .asignacion!
                                              .where((ag) =>
                                                  ((ag.completa == false) &&
                                                      (ag.periodo ==
                                                          dropdownPeriodo)))
                                              .toList()
                                              .length) /
                                          (asigTotal.asignaciones
                                              .where((a) => ((a.grupo ==
                                                      resGrupos[widget.index]
                                                          .nombre!) &&
                                                  (a.periodo ==
                                                      dropdownPeriodo)))
                                              .toList()
                                              .length))) *
                                  100)
                              .toStringAsFixed(1) +
                          "%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0),
                    ),
                    // footer:Text(
                    //   "Asignaciones calificadas",
                    //   style:TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15.0),
                    // ),
                    progressColor: Colors.brown.shade700,
                    backgroundColor: Colors.red.shade200,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: (resGrupos[widget.index].selected!)
              ? Colors.lime[100]
              : ((resGrupos[widget.index]
                          .asignacion!
                          .where((ag) => ((ag.completa == true) &&
                              (ag.periodo == dropdownPeriodo)))
                          .toList()
                          .length) ==
                      (asigTotal.asignaciones
                          .where((a) =>
                              ((a.grupo == resGrupos[widget.index].nombre!) &&
                                  (a.periodo == dropdownPeriodo)))
                          .toList()
                          .length))
                  ? Colors.limeAccent[700]
                  : Colors.yellow,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
