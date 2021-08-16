// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/estilos.dart';
import 'models.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'excel_admin.dart';

class EstadoAsignacion extends StatefulWidget {
  const EstadoAsignacion({Key? key}) : super(key: key);

  @override
  EstadoAsignacionState createState() => EstadoAsignacionState();
}

class EstadoAsignacionState extends State<EstadoAsignacion> {
  final ScrollController _estaAsigScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final ScrollController _estaAsigScrollController2 =
      ScrollController(initialScrollOffset: 0.0);

  bool loading = false;
  bool loadingRep = false;
  Future init() async {
    /* var listaAp = [];
    pendientes.docentes!.forEach((e) {
      listaAp.add([
        e.nombre,
        e.asignacion!.where((x) => (x.completa != false)).toList().length
      ]);
    });
    var listaA = [];
    docentes.forEach((e) {
      listaA.add([
        e.nombre,
        e.asignaciones!.asignaciones
            .where((x) => (x.completa != false))
            .toList()
            .length
      ]);
    });
    print([
      'EstadoAsignacion docentes Pendientes',
      pendientes.docentes!.length,
      docentes.length,
      'Area pendientes',
      listaAp,
      'Area Totales',
      listaA,
    ]); */
    setState(() {
      if (pendientes.docentes!.isNotEmpty) {
        var p = asigTotal.asignaciones
                .where((x) =>
                    ((x.completa != false) && (x.periodo == dropdownPeriodo)))
                .toList()
                .length /
            asigTotal.asignaciones.length;
        print(['Avance', p, double.parse(p.toStringAsFixed(4))]);
        porcentajeAvance = p;
        // 1 - (pendientes.docentes!.length / docentes.length);
        // porcentajeAvance = porcentajeAvance
      }
      loading = true;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _estaAsigScrollController.dispose();
    _estaAsigScrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      porcentajeAvance = 0;
      if (pendientes.docentes!.isNotEmpty) {
        var p = asigTotal.asignaciones
                .where((x) =>
                    ((x.completa != false) && (x.periodo == dropdownPeriodo)))
                .toList()
                .length /
            asigTotal.asignaciones.length;
        print(['Avance', p, double.parse(p.toStringAsFixed(4))]);
        porcentajeAvance = p;
        // 1 - (pendientes.docentes!.length / docentes.length);
        // porcentajeAvance = porcentajeAvance
      }
      loading = true;
    });
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Docentes pendientes ' + pendientes.docentes!.length.toString(),
            style: titulo,
          ),
          (!loading)
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.3,
                  child: const Center(child: CircularProgressIndicator()))
              : SizedBox(
                  // color: Colors.grey[50],
                  width: size.width,
                  height: size.height * 0.3,
                  child: SingleChildScrollView(
                    controller: _estaAsigScrollController2,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: size.height * 0.35),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            controller: _estaAsigScrollController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(4),
                            itemCount: pendientes.docentes!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: (index == 0)
                                    ? const EdgeInsets.only(top: 0.0)
                                    : const EdgeInsets.only(top: 15.0),
                                child: AsignacionCard(
                                  resumen: pendientes.docentes![index],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso general',
                style: titulo,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    loadingRep = true;
                  });
                  await reporteFaltantes(context);
                  setState(() {
                    loadingRep = false;
                  });
                },
                child: SizedBox(
                  // width: 210,
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (loadingRep)
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                // strokeWidth: 1.5,
                              ),
                            )
                          : const Icon(Icons.dashboard_customize_sharp),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      const Text('Exportar'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          (!loading)
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.3,
                  child: const Center(child: CircularProgressIndicator()))
              : SizedBox(
                  width: size.width,
                  height: size.height * 0.3,
                  child: CircularPercentIndicator(
                    radius: size.width * 0.125,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 30.0,
                    percent: porcentajeAvance,
                    center: Text(
                      (porcentajeAvance * 100).toStringAsFixed(1) + "%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    footer: const Text(
                      "Asignaciones calificadas",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    progressColor: Colors.brown,
                    backgroundColor: Colors.red.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
        ],
      ),
    );
  }
}

class AsignacionCard extends StatefulWidget {
  const AsignacionCard({Key? key, required this.resumen}) : super(key: key);
  final Resumen resumen;

  @override
  _AsignacionCardState createState() => _AsignacionCardState();
}

class _AsignacionCardState extends State<AsignacionCard> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /* print([
      'Tamaño de fila',
      size.width,
      size.width * 0.195,
      size.height,
      size.height * 0.06,
    ]); */
    return ListTile(
      selected: selected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      selectedTileColor: Colors.amber[50],
      onTap: () async {
        setState(() {
          selected = !selected;
          // widget.resumen.asignacion!.sort((AsignacionT m, AsignacionT b) {
          //   return m.area.toLowerCase().compareTo(b.area.toLowerCase());
          // });
          if (selected) {
            for (var asig in widget.resumen.asignacion!) {
              asignacionesPendientes.add(asig);
            }
          } else {
            for (var asig in widget.resumen.asignacion!) {
              asignacionesPendientes.remove(asig);
            }
            // asignacionesPendientes.remove(widget.resumen);
          }
          print(['asignacionesPendientes', asignacionesPendientes.length]);
          dxakey.currentState!.setState(() {
            listaPendientes = [];
            asignacionesPendientes = asignacionesPendientes;
            dxakey.currentState!
                .cargaAsignaciones(dropdownTipo, dropdownPeriodo);
          });
          homekey.currentState!.setState(() {
            asigTotal.asignaciones = asigTotal.asignaciones;
            asignacionesPendientes = asignacionesPendientes;
          });
        });
      },
      title: SizedBox(
        width: size.width * 0.195,
        height: size.height * 0.06,
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.local_library),
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.resumen.nombre!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Text('Asignaciones pendientes ' +
                            widget.resumen.asignacion!
                                .where((x) => ((x.completa == false) &&
                                    (x.periodo == dropdownPeriodo)))
                                .toList()
                                .length
                                .toString()
                        // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
