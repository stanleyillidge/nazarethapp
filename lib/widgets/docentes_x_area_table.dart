// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'models.dart';

class DocentesxAreaTable extends StatefulWidget {
  DocentesxAreaTable({Key? key, this.periodo}) : super(key: key);
  int? periodo;

  @override
  DocentesxAreaTableState createState() => DocentesxAreaTableState();
}

class DocentesxAreaTableState extends State<DocentesxAreaTable> {
  final ScrollController _docexAreaScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final ScrollController _docexAreaScrollController2 =
      ScrollController(initialScrollOffset: 0.0);

  bool loading = true;
  bool _hasMore = true;
  bool _error = false;
  init() async {}

  @override
  void initState() {
    init();
    super.initState();
    _docexAreaScrollController2.addListener(() async {
      // print([
      //   'pixeles',
      //   _docexAreaScrollController2.position.pixels,
      //   _docexAreaScrollController2.position.maxScrollExtent
      // ]);
      if (_docexAreaScrollController2.position.pixels ==
          _docexAreaScrollController2.position.maxScrollExtent) {
        if (asignacionesPendientes.isEmpty) {
          asgPendientes = asigTotal.asignaciones;
          setState(() {
            if (!_listaTotal) {
              limiteInf = 0;
              limiteSup = 10;
            }
            limiteInf = limiteSup;
            limiteSup += 10;
            _listaTotal = true;
            _hasMore = asgPendientes.length == limiteSup;
          });
          print([
            'fin',
            limiteInf,
            limiteSup,
            _listaTotal,
            _hasMore,
          ]);
        }
        await cargaAsignaciones(dropdownTipo, dropdownPeriodo);
      }
    });
    _hasMore = true;
    _error = false;
    loading = true;
    // listaPendientes = [];
    listaPendientes = [];
    asgPendientes = [];
    limiteInf = 0;
    limiteSup = 25;
    cargaAsignaciones(dropdownTipo, dropdownPeriodo);
  }

  @override
  void dispose() {
    _docexAreaScrollController.dispose();
    _docexAreaScrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return getBody(size)!;
  }

  List<AsignacionT> asgPendientes = [];
  int limiteInf = 0;
  int limiteSup = 25;
  bool _listaTotal = true;

  Future<void> cargaAsignaciones(String tipo, int periodo) async {
    print('Entro ok');
    // print(['Pendientes', asignacionesPendientes.length]);
    asgPendientes = [];
    if (asignacionesPendientes.isEmpty) {
      if (!_listaTotal) {
        setState(() {
          limiteInf = 0;
          limiteSup = 25;
          _listaTotal = true;
        });
      }
      asgPendientes = asigTotal.asignaciones
          .where((asigx) => asigx.periodo == periodo)
          .toList();
      // print(['Pendiente 0', asgPendientes[0].toJson()]);
    } else {
      asgPendientes = asignacionesPendientes
          .where((asigx) => asigx.periodo == periodo)
          .toList();
      setState(() {
        // listaPendientes = [];
        listaPendientes = [];
        genPlanillas = [];
        limiteInf = 0;
        limiteSup = asgPendientes.length;
        _listaTotal = false;
        // homekey.currentState!.setState(() {
        //   homekey.currentState!.genPlanillas2 = false;
        // });
      });
    }
    _hasMore = (!_listaTotal) ? _listaTotal : asgPendientes.length == limiteSup;
    print([
      'inicio',
      tipo,
      'Periodo ' + periodo.toString(),
      limiteInf,
      limiteSup,
      _listaTotal,
      _hasMore,
    ]);
    setState(() {
      asgPendientes = asgPendientes;
    });
    switch (tipo) {
      case 'Area':
        xArea(asgPendientes);
        break;
      case 'Grupo':
        xGrupo(asgPendientes);
        break;
      default:
    }
  }

  Future<void> xArea(List<AsignacionT> asgPendientes) async {
    var aa = [];
    if (asgPendientes.isEmpty) {
      setState(() {
        loading = false;
      });
    }
    if (!_hasMore && asgPendientes.isNotEmpty) {
      for (var i = limiteInf; i < limiteSup; i++) {
        var gg = asigTotal.asignaciones
            .where((p) => ((p.docente == asgPendientes[i].docente) &&
                (p.area == asgPendientes[i].area) &&
                (p.periodo == dropdownPeriodo) &&
                (p.grado == asgPendientes[i].grado)))
            .map((e) => (e.grupo))
            .toList();
        // var gg2 = asigTotal.asignaciones
        //     .where((p) => ((p.docente == asgPendientes[i].docente) &&
        //         (p.area == asgPendientes[i].area) &&
        //         (p.periodo == dropdownPeriodo) &&
        //         (p.grado == asgPendientes[i].grado)))
        //     .map((e) => [e.grupo, e.completa, e.cargada])
        //     .toList();
        var sedex = sede(asgPendientes[i].grupo);
        sedex =
            (sedex == 'Instituciàn Etnoeducativa Rural Internado De Nazareth')
                ? 'principal'
                : sedex;
        // var fila = [
        //   asgPendientes[i].area, //0
        //   asgPendientes[i].docente,
        //   sedex.toString().toUpperCase() + ' - ' + asgPendientes[i].grado,
        //   sedex.toString().toUpperCase(),
        //   asgPendientes[i].grado,
        //   gg,
        //   false, //6
        //   gg2, //7
        // ];
        var filax = asgPendientes[i].area +
            ' ' +
            asgPendientes[i].docente +
            ' ' +
            asgPendientes[i].grado;
        // print([loading, 'filax', aa.indexOf(filax)]);
        DashboardCard dc = DashboardCard(
          selected: false,
          area: asgPendientes[i].area,
          docente: asgPendientes[i].docente,
          sede: sedex.toString().toUpperCase(),
          grado: asgPendientes[i].grado,
          grupos: gg,
          asignaciones: asigTotal.asignaciones
              .where((p) => ((p.docente == asgPendientes[i].docente) &&
                  (p.area == asgPendientes[i].area) &&
                  (p.periodo == dropdownPeriodo) &&
                  (p.grado == asgPendientes[i].grado)))
              .toList(),
        );
        if (!aa.contains(filax)) {
          aa.add(filax);
          // listaPendientes.add(fila);
          listaPendientes.add(dc);
          // genPlanillas.add(false);
        }
      }
    }
    aa = [];
  }

  Future<void> xGrupo(List<AsignacionT> asgPendientes) async {
    var aa = [];
    if (asgPendientes.isEmpty) {
      setState(() {
        loading = false;
      });
    }
    if (!_hasMore && asgPendientes.isNotEmpty) {
      for (var i = limiteInf; i < limiteSup; i++) {
        var sedex = sede(asgPendientes[i].grupo);
        sedex =
            (sedex == 'Instituciàn Etnoeducativa Rural Internado De Nazareth')
                ? 'principal'
                : sedex;
        var filax = asgPendientes[i].area +
            ' ' +
            asgPendientes[i].docente +
            ' ' +
            asgPendientes[i].grado;
        // print([loading, 'filax', aa.indexOf(filax)]);
        if (!aa.contains(filax)) {
          aa.add(filax);
          // listaPendientes.add(fila);
          // genPlanillas.add(false);
        }
      }
    }
    aa = [];
  }

  Widget? getBody(Size size) {
    if (listaPendientes.isEmpty) {
      if (loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              loading = true;
              _error = false;
              cargaAsignaciones(dropdownTipo, dropdownPeriodo);
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Error while loading photos, tap to try agin"),
          ),
        ));
      }
    } else {
      return Container(
        height: size.height * 0.795,
        color: Colors.transparent,
        child: SingleChildScrollView(
          controller: _docexAreaScrollController2,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height * 0.3),
            child: ListView.builder(
              controller: _docexAreaScrollController,
              shrinkWrap: true,
              itemCount: listaPendientes.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == listaPendientes.length) {
                  if (_error) {
                    return Center(
                        child: InkWell(
                      onTap: () {
                        setState(() {
                          loading = true;
                          _error = false;
                          cargaAsignaciones(dropdownTipo, dropdownPeriodo);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child:
                            Text("Error while loading photos, tap to try agin"),
                      ),
                    ));
                  } else {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ));
                  }
                }
                return DocenteCard2(
                  data: listaPendientes[index],
                  index: index,
                );
                // return DocenteCard(
                //   lista: listaPendientes[index],
                //   index: index,
                // );
              },
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

class DocenteCard2 extends StatefulWidget {
  DocenteCard2({Key? key, required this.data, required this.index})
      : super(key: key);
  DashboardCard data;
  final int index;

  @override
  _DocenteCardState2 createState() => _DocenteCardState2();
}

class _DocenteCardState2 extends State<DocenteCard2> {
  @override
  void initState() {
    // selectedx = false;
    super.initState();
  }

  // bool selectedx = false;
  @override
  Widget build(BuildContext context) {
    List<AsignacionT> flexs = [];
    flexs = widget.data.asignaciones!;
    return ListTile(
      selected: widget.data.selected,
      // tileColor: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      selectedTileColor: Colors.brown[100],
      onTap: () async {
        setState(() {
          widget.data.selected = !widget.data.selected;
          listaPendientes[widget.index].selected = widget.data.selected;
          var genp = listaPendientes.where((e) => (e.selected == true));
          print(['Genera Planillas', genp.isNotEmpty]);
          homekey.currentState!.setState(() {
            homekey.currentState!.genPlanillas2 = genp.isNotEmpty;
          });
          print(widget.data.toJson());
        });
      },
      title: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.data.area!,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // [e.grupo, e.completa, e.cargada]
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.data.docente!,
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.data.sede! +
                                      ' - ' +
                                      widget.data.grado!,
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (flexs.isNotEmpty)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[0].completa)
                                              ? Colors.green[500]
                                              : (flexs[0].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[0].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[0].completa)
                                            ? Colors.green[200]
                                            : (flexs[0].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[0].completa)
                                            ? const Text('Completa')
                                            // Text('Completa ' +
                                            //     DateFormat(
                                            //             "yyyy-MM-dd HH:mm:ss")
                                            //         .format(DateTime.now())
                                            //         .toString())
                                            : (flexs[0].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                                (flexs.length > 1)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[1].completa)
                                              ? Colors.green[500]
                                              : (flexs[1].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[1].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[1].completa)
                                            ? Colors.green[200]
                                            : (flexs[1].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[1].completa)
                                            ? const Text('Completa')
                                            : (flexs[1].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (flexs.length > 2)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[2].completa)
                                              ? Colors.green[500]
                                              : (flexs[2].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[2].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[2].completa)
                                            ? Colors.green[200]
                                            : (flexs[2].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[2].completa)
                                            ? const Text('Completa')
                                            : (flexs[2].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                                (flexs.length > 3)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[3].completa)
                                              ? Colors.green[500]
                                              : (flexs[3].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[3].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[3].completa)
                                            ? Colors.green[200]
                                            : (flexs[3].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[3].completa)
                                            ? const Text('Completa')
                                            : (flexs[3].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (flexs.length > 4)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[4].completa)
                                              ? Colors.green[500]
                                              : (flexs[4].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[4].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[4].completa)
                                            ? Colors.green[200]
                                            : (flexs[4].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[4].completa)
                                            ? const Text('Completa')
                                            : (flexs[4].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                                (flexs.length > 5)
                                    ? Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: (flexs[5].completa)
                                              ? Colors.green[500]
                                              : (flexs[5].cargada)
                                                  ? Colors.amber[500]
                                                  : Colors.red,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              flexs[5].grupo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: (flexs[5].completa)
                                            ? Colors.green[200]
                                            : (flexs[5].cargada)
                                                ? Colors.amber[100]
                                                : Colors.red[200],
                                        label: (flexs[5].completa)
                                            ? const Text('Completa')
                                            : (flexs[5].cargada)
                                                ? const Text('Incompleta')
                                                : const Text('Pendiente'),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (asignacionesPendientes.isNotEmpty)
                ? const Icon(Icons.more_vert)
                : Container(),
          ],
        ),
      ),
    );
  }
}
