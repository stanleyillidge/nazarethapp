// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'models.dart';

class GradosList extends StatefulWidget {
  const GradosList({Key? key, this.nombre, this.lista, this.modelo})
      : super(key: key);
  final List<Grado>? lista;
  final String? nombre;
  final ModelType? modelo;
  @override
  GradosListState createState() => GradosListState();
}

class GradosListState extends State<GradosList> {
  // init() async {
  //   grados = [];
  //   var path = Directory.current.path;
  //   Hive.init(path);
  //   DateTime now = new DateTime.now();
  //   storage = await Hive.openBox(now.year.toString());
  //   carga(widget.nombre!, widget.modelo);
  // }

  // carga(a, modelo) async {
  //   List? g = await storage.get(a);
  //   if (g != null) {
  //     widget.lista!.clear();
  //     for (var i = 0; i < g.length; i++) {
  //       setState(() {
  //         // print(['Grado cargado', g[i]]);
  //         grados.add(Grado.fromJson(g[i]));
  //         widget.lista!.add(Grado.fromJson(g[i]));
  //       });
  //     }
  //   }
  //   // print(['Lista ' + widget.nombre! + ' guardada', g]);
  // }

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

  List<TextEditingController> nombres = [];
  TextEditingController controller = TextEditingController();
  bool? edit = false;
  bool _validateName = true;
  int? gindex = 0;
  double width = 350;
  String? borrado = '';
  String? editado = '';
  final ScrollController? _gradosScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final ScrollController? _gradosLv1ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _gradosScrollController,
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
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Crea un grado',
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
                              if (controller.text.isEmpty) {
                                setState(() {
                                  _validateName = false;
                                });
                                return;
                              }
                              print(['Modelo', widget.modelo]);
                              controller.clear();
                              setState(() {
                                if (!edit!) {
                                  nombres.add(TextEditingController());
                                  widget.lista!
                                      .add(Grado(nombre: a, activo: false));
                                } else {
                                  print('Esta editando');
                                  widget.lista![gindex!] =
                                      Grado(activo: false, nombre: a);
                                }
                              });
                              grados = [];
                              var lista = [];
                              for (var e in widget.lista!) {
                                grados.add(e);
                                lista.add(e.toJson());
                              }
                              print(['Lista a ser guardada', lista]);
                              await storage.put('Grados', lista);
                              if (edit!) {
                                List? g = await storage.get(editado);
                                if (g != null) {
                                  for (var i = 0; i < g.length; i++) {
                                    await storage.put(a, g);
                                    print([
                                      'Editado ' +
                                          editado! +
                                          ' por ' +
                                          a +
                                          ' y fue guardado',
                                      g
                                    ]);
                                  }
                                }
                                setState(() {
                                  edit = false;
                                });
                              }
                              print([
                                'onSubmitted',
                                'Guardado como',
                                widget.nombre!,
                                a,
                                widget.lista
                              ]);
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
                            controller: _gradosLv1ScrollController,
                            shrinkWrap: true,
                            itemCount: widget.lista!.length,
                            itemBuilder: (context, i) {
                              return Card(
                                child: ExpansionTile(
                                  title: Text(widget.lista![i].nombre!),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 13.0, right: 13.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
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
                                              editado =
                                                  widget.lista![i].nombre!;
                                              controller.text =
                                                  widget.lista![i].nombre!;
                                              print([
                                                'Editar',
                                                widget.lista![i].nombre
                                              ]);
                                            },
                                            child: const Text('Editar grado'),
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
                                              grados = [];
                                              var lista = [];
                                              for (var e in widget.lista!) {
                                                grados.add(e);
                                                lista.add(e.toJson());
                                              }
                                              print([
                                                'Lista a ser guardada',
                                                lista
                                              ]);
                                              await storage.put(
                                                  'Grados', lista);
                                            },
                                            child: const Text('Eliminar grado'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GruposList(
                                      nombre: widget.lista![i].nombre,
                                      lista: widget.lista![i].grupos ?? [],
                                      modelo: ModelType.grupo,
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

class GruposList extends StatefulWidget {
  const GruposList({Key? key, this.nombre, this.lista, this.modelo})
      : super(key: key);
  final List? lista;
  final String? nombre;
  final ModelType? modelo;
  @override
  _GruposListState createState() => _GruposListState();
}

class _GruposListState extends State<GruposList> {
  // init() async {
  //   var path = Directory.current.path;
  //   Hive.init(path);
  //   DateTime now = new DateTime.now();
  //   storage = await Hive.openBox(now.year.toString());
  //   List? g = await storage.get(widget.nombre!);
  //   if (g != null) {
  //     widget.lista!.clear();
  //     for (var i = 0; i < g.length; i++) {
  //       setState(() {
  //         widget.lista!
  //             .add(Grupo(activo: g[i]['activo'], nombre: g[i]['nombre']));
  //       });
  //     }
  //   }
  //   print(['Lista ' + widget.nombre! + ' guardada', g]);
  // }

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

  final ScrollController? _gradosLv2ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  TextEditingController controller = TextEditingController();
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
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Añadir un grupo a ' + widget.nombre!,
                    prefixIcon: Icon(
                      Icons.bookmark_border,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (a) {},
                  onSubmitted: (a) async {
                    controller.clear();
                    setState(() {
                      if (!edit!) {
                        widget.lista!.add(Grupo(activo: false, nombre: a));
                      } else {
                        edit = false;
                        widget.lista![gindex!] =
                            Grupo(activo: false, nombre: a);
                        // showSnack(editado! + ' fue modificado a ' + a);
                      }
                    });
                    var lista = [];
                    List<Grupo> _g = [];
                    for (var e in widget.lista!) {
                      _g.add(e);
                      lista.add(e.toJson());
                    }
                    print(['Grupos a ser guardados en', widget.nombre!, lista]);
                    await storage.put(widget.nombre!, lista);
                    for (var a in grados) {
                      if (a.nombre == widget.nombre) {
                        setState(() {
                          a.grupos = _g;
                        });
                      }
                    }
                    var listaG = [];
                    for (var e in grados) {
                      listaG.add(e.toJson());
                    }
                    print(['Grados a ser guardados', listaG]);
                    await storage.put('Grados', listaG);
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
                  controller: _gradosLv2ScrollController,
                  shrinkWrap: true,
                  itemCount: widget.lista!.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.lista![i].nombre!),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: const Text('Editar'),
                                  onTap: () {
                                    edit = true;
                                    gindex = i;
                                    editado = widget.lista![i].nombre!;
                                    controller.text = widget.lista![i].nombre!;
                                    print(['Editar', widget.lista![i].nombre]);
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Eliminar'),
                                  onTap: () async {
                                    setState(() {
                                      borrado = widget.lista![i].nombre;
                                      widget.lista!.removeAt(i);
                                    });
                                    var lista = [];
                                    for (var e in widget.lista!) {
                                      lista.add(e.toJson());
                                    }
                                    await storage.put(widget.nombre!, lista);
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
