// ignore_for_file: avoid_print, duplicate_ignore

import 'package:flutter/material.dart';
import 'models.dart';
import 'excel_admin.dart';

class ALectivosList extends StatefulWidget {
  const ALectivosList({Key? key, this.nombre, this.lista, this.modelo})
      : super(key: key);
  final List<Ano>? lista;
  final String? nombre;
  final ModelType? modelo;
  @override
  _ALectivosListState createState() => _ALectivosListState();
}

class _ALectivosListState extends State<ALectivosList> {
  init() async {
    // await openYears();
    // setState(() {
    //   anos = anos;
    //   anosLectivos = anosLectivos;
    // });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackbar);
    }
  }

  List<TextEditingController> nombres = [];
  final TextEditingController _anosController = TextEditingController();
  bool? edit = false;
  bool _validateName = true;
  int? gindex = 0;
  double width = 350;
  String? borrado = '';
  String? editado = '';
  bool loadingAll = false;
  final ScrollController? _anosScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final ScrollController? _anosLv1ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _anosScrollController,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            (widget.nombre != null) ? widget.nombre! : 'Lista',
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Card(
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: _anosController,
                            decoration: InputDecoration(
                              hintText: 'Crea un año lectivo',
                              errorText: !_validateName
                                  ? 'No puede estar vacio'
                                  : null,
                              prefixIcon: Icon(
                                Icons.bookmark,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (a) {},
                            onSubmitted: (a) async {
                              if (_anosController.text.isEmpty) {
                                setState(() {
                                  _validateName = false;
                                });
                                return;
                              }
                              // print(['Modelo', widget.modelo]);
                              // print(['Año', _anosController.text]);
                              _anosController.clear();
                              Ano ax = Ano(nombre: a, periodos: [1]);
                              setState(() {
                                if (!edit!) {
                                  print('Esta creando');
                                  // nombres.add(TextEditingController());
                                  // anos.add(ax);
                                  widget.lista!.add(ax);
                                } else {
                                  print('Esta editando');
                                  widget.lista![gindex!] = ax;
                                }
                              });
                              var listaA = [];
                              anosLectivos = [];
                              for (var e in widget.lista!) {
                                anosLectivos.add(e.nombre);
                                listaA.add(e.toJson());
                              }
                              print([
                                'Año a ser guardados1',
                                widget.lista!.length,
                                listaA
                              ]);
                              await anosLectivosStorage.put('anos', listaA);
                              setState(() {
                                anos = anos;
                                anosLectivos = anosLectivos;
                              });
                              // configuracionkey.currentState!.setState(() {
                              //   anos = anos;
                              //   anosLectivos = anosLectivos;
                              // });
                            },
                            onTap: () {
                              print(['onTap']);
                            },
                            onEditingComplete: () {
                              print(['onEditingComplete']);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.lista!.isNotEmpty
                    ? Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            controller: _anosLv1ScrollController,
                            shrinkWrap: true,
                            itemCount: widget.lista!.length,
                            itemBuilder: (context, i) {
                              return Card(
                                child: ExpansionTile(
                                  title: Text(widget.lista![i].nombre),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 13.0, right: 13.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /* ElevatedButton(
                                            style: TextButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                            onPressed: () {
                                              edit = true;
                                              gindex = i;
                                              editado = widget.lista![i].nombre;
                                              _anosController.text =
                                                  widget.lista![i].nombre;
                                              print([
                                                'Editar',
                                                widget.lista![i].nombre
                                              ]);
                                            },
                                            child: const Text(
                                                'Editar año lectivo'),
                                          ), */
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              // textStyle:
                                              //     TextStyle(fontSize: 18),
                                              primary: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                loadingAll = true;
                                              });
                                              await openFile(context);
                                              setState(() {
                                                estudiantes = estudiantes;
                                                asigTotal.asignaciones =
                                                    asigTotal.asignaciones;
                                                grados = grados;
                                                areas = areas;
                                                loadingAll = false;
                                              });
                                              await acPendientes();
                                              gxakey.currentState!.setState(() {
                                                grados = grados;
                                              });
                                              axakey.currentState!.setState(() {
                                                areas = areas;
                                              });
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                (loadingAll)
                                                    ? const SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          // strokeWidth: 1.5,
                                                        ),
                                                      )
                                                    : Container(),
                                                const SizedBox(
                                                  width: 5,
                                                  height: 5,
                                                ),
                                                const Text('Cargar datos'),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                            onPressed: () async {
                                              setState(() {
                                                widget.lista!.removeAt(i);
                                              });
                                              anos = [];
                                              var listaA = [];
                                              anosLectivos = [];
                                              for (var e in widget.lista!) {
                                                anos.add(e);
                                                anosLectivos.add(e.nombre);
                                                listaA.add(e.toJson());
                                              }
                                              print([
                                                'Año a ser guardados2',
                                                widget.lista!.length,
                                                listaA
                                              ]);
                                              await anosLectivosStorage.put(
                                                  'anos', listaA);
                                              setState(() {
                                                anos = anos;
                                                anosLectivos = anosLectivos;
                                              });
                                            },
                                            child: const Text(
                                                'Eliminar año lectivo'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PeriodosList(
                                      nombre: widget.lista![i].nombre,
                                      lista: widget.lista![i].periodos,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PeriodosList extends StatefulWidget {
  const PeriodosList({Key? key, this.nombre, this.lista}) : super(key: key);
  final List<int>? lista;
  final String? nombre;
  @override
  _PeriodosListState createState() => _PeriodosListState();
}

class _PeriodosListState extends State<PeriodosList> {
  @override
  void initState() {
    // init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackbar);
    }
  }

  final ScrollController? _anosLv2ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final TextEditingController _anosController2 = TextEditingController();
  bool? edit = false;
  int? gindex = 0;
  double width = 350;
  String? borrado = '';
  String? editado = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: _anosController2,
                  decoration: InputDecoration(
                    hintText: 'Añadir un periodo a ' + widget.nombre!,
                    prefixIcon: Icon(
                      Icons.bookmark_border,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (a) {},
                  onSubmitted: (a) async {
                    print(['Añadir periodo a año', widget.nombre, anos.length]);
                    _anosController2.clear();
                    setState(() {
                      if (!edit!) {
                        widget.lista!.add(int.parse(a));
                      } else {
                        edit = false;
                        widget.lista![gindex!] = int.parse(a);
                        // showSnack(editado! + ' fue modificado a ' + a);
                      }
                    });
                    var lista = [];
                    List<int> _g = [];
                    for (var e in widget.lista!) {
                      _g.add(e);
                      lista.add(e);
                    }
                    // print(['Grupo a ser guardados en', widget.nombre!, lista]);
                    // await anosLectivosStorage.put(widget.nombre!, lista);
                    for (var a in anos) {
                      if (a.nombre == widget.nombre) {
                        setState(() {
                          a.periodos = _g;
                        });
                      }
                    }
                    var listaA = [];
                    anosLectivos = [];
                    for (var e in anos) {
                      anosLectivos.add(e.nombre);
                      listaA.add(e.toJson());
                    }
                    print(['Año a ser guardados3', anos.length, listaA]);
                    await anosLectivosStorage.put('anos', listaA);
                    setState(() {
                      anos = anos;
                      anosLectivos = anosLectivos;
                    });
                    print([
                      'onSubmitted',
                      'Grupo Guardado como',
                      widget.nombre!,
                      a,
                      widget.lista
                    ]);
                  },
                  onTap: () {
                    print(['onTap']);
                  },
                  onEditingComplete: () {
                    // ignore: avoid_print
                    print(['onEditingComplete']);
                  },
                ),
              ),
            ],
          ),
        ),
        widget.lista!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller: _anosLv2ScrollController,
                  shrinkWrap: true,
                  itemCount: widget.lista!.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Periodo ' + widget.lista![i].toString()),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                /* ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 18),
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      loadingAll = true;
                                    });
                                    await openFile(context);
                                    setState(() {
                                      estudiantes = estudiantes;
                                      asigTotal.asignaciones =
                                          asigTotal.asignaciones;
                                      grados = grados;
                                      areas = areas;
                                      loadingAll = false;
                                    });
                                    await acPendientes();
                                    String titulo = 'Documento cargado';
                                    List<Widget> body = [];
                                    body.add(Text(
                                        'La información fue cargada correctamente!'));
                                    _showMyDialog(titulo, body);
                                  },
                                  child: Container(
                                    // width: 210,
                                    height: 30,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (loadingAll)
                                            ? SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  // strokeWidth: 1.5,
                                                ),
                                              )
                                            : Icon(Icons.dashboard_customize_sharp),
                                        SizedBox(
                                          width: 10,
                                          height: 10,
                                        ),
                                        Text('Cargar documento'),
                                      ],
                                    ),
                                  ),
                                ), */
                                PopupMenuItem(
                                  child: const Text('Editar'),
                                  onTap: () {
                                    edit = true;
                                    gindex = i;
                                    editado = widget.lista![i].toString();
                                    _anosController2.text =
                                        widget.lista![i].toString();
                                    print(['Editar', widget.lista![i]]);
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Eliminar'),
                                  onTap: () async {
                                    setState(() {
                                      borrado = widget.lista![i].toString();
                                      widget.lista!.removeAt(i);
                                    });
                                    var lista = [];
                                    for (var e in widget.lista!) {
                                      lista.add(e);
                                    }
                                    // await anosLectivosStorage.put(widget.nombre!, lista);
                                    showSnack(borrado! + ' fue borrado');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // margin: const EdgeInsets.all(0.0),
                    );
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
