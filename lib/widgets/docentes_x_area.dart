// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'models.dart';

class DocentesxArea extends StatefulWidget {
  const DocentesxArea({Key? key, this.nombre, this.lista}) : super(key: key);
  final List<Area>? lista;
  final String? nombre;
  @override
  _DocentesxAreaState createState() => _DocentesxAreaState();
}

class _DocentesxAreaState extends State<DocentesxArea> {
  init() async {
    areas = [];
    var path = Directory.current.path;
    Hive.init(path);
    DateTime now = DateTime.now();
    storage = await Hive.openBox(now.year.toString());
    await carga(widget.nombre!);
    print(['Grados', grados.length]);
    for (var i = 0; i < grados.length; i++) {
      items.add(MultiSelectDialogItem(i + 1, grados[i].nombre!));
    }
  }

  carga(a) async {
    List? g = await storage.get(a);
    if (g != null) {
      widget.lista!.clear();
      for (var i = 0; i < g.length; i++) {
        setState(() {
          // print(['Area cargada', g[i]]);
          areas.add(Area.fromJson(g[i]));
          widget.lista!.add(Area.fromJson(g[i]));
        });
      }
    }
    // print(['Lista ' + widget.nombre! + ' guardada', g]);
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

  void _showMultiSelect(BuildContext context) async {
    // final items = <MultiSelectDialogItem<int>>[
    //   MultiSelectDialogItem(1, 'Dog'),
    //   MultiSelectDialogItem(2, 'Cat'),
    //   MultiSelectDialogItem(3, 'Mouse'),
    // ];
    _grados = [];
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: null, //[].toSet(),
        );
      },
    );
    var l = selectedValues!.toList();
    for (var i in l) {
      _grados.add(grados[i - 1]);
    }
    setState(() {
      if (_grados.isNotEmpty) {
        // gradost = true;
        areat = true;
      } else {
        // gradost = false;
        areat = false;
      }
    });
    print(['selectedValues', selectedValues]);
  }

  List<Grado> _grados = [];
  List<MultiSelectDialogItem<int>> items = [];
  List<TextEditingController> nombres = [];
  TextEditingController nombre = TextEditingController();
  TextEditingController ih = TextEditingController();
  bool? edit = false;
  bool? gradost = false;
  bool? areat = false;
  bool? iht = false;
  bool _validateName = true;
  bool _validateIh = true;
  int? gindex = 0;
  double width = 400;
  String? borrado = '';
  String? editado = '';
  final ScrollController? _docentesScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final ScrollController? _docentesLv1ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _docentesScrollController,
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
                        Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.58,
                                  child: Card(
                                    child: TextField(
                                      textInputAction: TextInputAction.done,
                                      controller: nombre,
                                      decoration: InputDecoration(
                                        hintText: 'Crea un area',
                                        errorText: !_validateName
                                            ? 'No puede estar vacio'
                                            : null,
                                        prefixIcon: Icon(
                                          Icons.class_,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      onChanged: (a) {
                                        setState(() {
                                          if (a != '') {
                                            gradost = true;
                                            // areat = true;
                                          } else {
                                            gradost = false;
                                            // areat = false;
                                          }
                                        });
                                      },
                                      onSubmitted: (a) async {},
                                      onTap: () {
                                        print(['onTap']);
                                      },
                                      onEditingComplete: () {
                                        print(['onEditingComplete']);
                                      },
                                    ),
                                  ),
                                ),
                                if (gradost!)
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                      primary:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    onPressed: () {
                                      _showMultiSelect(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0,
                                          bottom: 12.0,
                                          right: 0,
                                          left: 0),
                                      child: Icon(
                                        Icons.bookmark,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                if (areat!)
                                  SizedBox(
                                    width: width * 0.225,
                                    child: Card(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(2),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        textInputAction: TextInputAction.done,
                                        controller: ih,
                                        decoration: InputDecoration(
                                          hintText: 'I.h',
                                          errorText: !_validateIh
                                              ? 'No puede estar vacio'
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.av_timer),
                                        ),
                                        onChanged: (a) {},
                                        onSubmitted: (a) async {
                                          if (nombre.text.isEmpty) {
                                            setState(() {
                                              _validateName = false;
                                            });
                                            return;
                                          }
                                          if (ih.text.isEmpty) {
                                            setState(() {
                                              _validateIh = false;
                                            });
                                            return;
                                          }
                                          setState(() {
                                            if (!edit!) {
                                              nombres
                                                  .add(TextEditingController());
                                              widget.lista!.add(Area(
                                                nombre: nombre.text,
                                                ih: int.parse(a),
                                                porcentaje: 0,
                                                grados: _grados,
                                                activo: false,
                                              ));
                                              print([
                                                'Area añadida',
                                                Area(
                                                  nombre: nombre.text,
                                                  ih: int.parse(a),
                                                  porcentaje: 0,
                                                  grados: _grados,
                                                  activo: false,
                                                ).toJson()
                                              ]);
                                            } else {
                                              print('Esta editando');
                                              widget.lista![gindex!].ih =
                                                  int.parse(ih.text);
                                              widget.lista![gindex!].nombre =
                                                  nombre.text;
                                              widget.lista![gindex!].grados =
                                                  _grados;
                                            }
                                          });
                                          areas = [];
                                          var lista = [];
                                          for (var e in widget.lista!) {
                                            areas.add(e);
                                            lista.add(e.toJson());
                                          }
                                          print(
                                              ['Lista a ser guardada', lista]);
                                          await storage.put('Areas', lista);
                                          if (edit!) {
                                            List? g =
                                                await storage.get(editado);
                                            if (g != null) {
                                              for (var i = 0;
                                                  i < g.length;
                                                  i++) {
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
                                          setState(() {
                                            areat = false;
                                            gradost = false;
                                            _grados = [];
                                            ih.clear();
                                            nombre.clear();
                                          });
                                        },
                                        onTap: () {
                                          print(['onTap']);
                                        },
                                        onEditingComplete: () {
                                          print(['onEditingComplete']);
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
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
                            controller: _docentesLv1ScrollController,
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
                                              nombre.text =
                                                  widget.lista![i].nombre!;
                                              print([
                                                'Editar',
                                                widget.lista![i].nombre
                                              ]);
                                            },
                                            child: const Text('Editar area'),
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
                                              areas = [];
                                              var lista = [];
                                              for (var e in widget.lista!) {
                                                areas.add(e);
                                                lista.add(e.toJson());
                                              }
                                              await storage.put('Areas', lista);
                                            },
                                            child: const Text('Eliminar area'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AsignaturasList(
                                      nombre: widget.lista![i].nombre,
                                      lista: widget.lista![i].asignaturas ?? [],
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

class AsignaturasList extends StatefulWidget {
  const AsignaturasList({Key? key, this.nombre, this.lista, this.modelo})
      : super(key: key);
  final List<Asignatura>? lista;
  final String? nombre;
  final ModelType? modelo;
  @override
  _AsignaturasListState createState() => _AsignaturasListState();
}

class _AsignaturasListState extends State<AsignaturasList> {
  init() async {
    var path = Directory.current.path;
    Hive.init(path);
    DateTime now = DateTime.now();
    storage = await Hive.openBox(now.year.toString());
    List? g = await storage.get(widget.nombre!);
    if (g != null) {
      widget.lista!.clear();
      for (var i = 0; i < g.length; i++) {
        setState(() {
          widget.lista!.add(Asignatura.fromJson(g[i]));
        });
      }
    }
    print(['Lista ' + widget.nombre! + ' guardada', g]);
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

  checkPorc() {
    double porc = 0;
    for (var e in widget.lista!) {
      porc += e.porcentaje!;
    }
    setState(() {
      enable = true;
    });
    if (porc == 100 && !edit!) {
      setState(() {
        enable = false;
      });
    }
  }

  final ScrollController? _docentesLv2ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  List<TextEditingController> nombres = [];
  List<TextEditingController> porcentajes = [];
  TextEditingController nombre = TextEditingController();
  TextEditingController porcentaje = TextEditingController();
  bool? edit = false;
  bool? asigt = false;
  bool enable = true;
  bool _validateName = true;
  bool _validatePorc = true;
  String errorValidatePorc = '';
  int? gindex = 0;
  double width = 400;
  String? borrado = '';
  String? editado = '';
  @override
  Widget build(BuildContext context) {
    checkPorc();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.67,
                child: Card(
                  child: TextField(
                    enabled: enable,
                    textInputAction: TextInputAction.done,
                    controller: nombre,
                    decoration: InputDecoration(
                      hintText: widget.nombre,
                      errorText: !_validateName ? 'No puede estar vacio' : null,
                      prefixIcon: Icon(
                        Icons.class_,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (a) {
                      setState(() {
                        if (a != '') {
                          asigt = true;
                        } else {
                          asigt = false;
                        }
                      });
                    },
                    onSubmitted: (a) async {},
                    onTap: () {
                      print(['onTap']);
                    },
                    onEditingComplete: () {
                      print(['onEditingComplete']);
                    },
                  ),
                ),
              ),
              if (asigt!)
                SizedBox(
                  width: width * 0.225,
                  child: Card(
                    child: TextField(
                      enabled: enable,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(2),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.done,
                      controller: porcentaje,
                      decoration: InputDecoration(
                        hintText: 'I.h',
                        errorText: !_validatePorc ? errorValidatePorc : null,
                        prefixIcon: const Icon(Icons.av_timer),
                        // errorText: _validate ? 'No puede estar vacio' : null,
                      ),
                      onChanged: (a) {},
                      onSubmitted: (a) async {
                        if (nombre.text.isEmpty) {
                          setState(() {
                            _validateName = false;
                          });
                          return;
                        }
                        if (porcentaje.text.isEmpty) {
                          setState(() {
                            errorValidatePorc = 'No vacio';
                            _validatePorc = false;
                          });
                          return;
                        }
                        double porc = 0;
                        for (var e in widget.lista!) {
                          porc += e.porcentaje!;
                        }
                        // if (porc == 100) {}
                        porc += double.parse(porcentaje.text);
                        if (edit!) {
                          porc -= widget.lista![gindex!].porcentaje!;
                        }
                        if (porc > 100) {
                          setState(() {
                            errorValidatePorc = 'Muy grande';
                            _validatePorc = false;
                          });
                          return;
                        }
                        for (var a in areas) {
                          if (a.nombre == widget.nombre) {
                            setState(() {
                              a.porcentaje = porc;
                            });
                          }
                        }
                        var listaA = [];
                        for (var e in areas) {
                          listaA.add(e.toJson());
                        }
                        print(['Areas a ser guardadas', listaA]);
                        await storage.put('Areas', listaA);
                        setState(() {
                          _validatePorc = true;
                          if (!edit!) {
                            nombres.add(TextEditingController());
                            widget.lista!.add(Asignatura(
                              nombre: nombre.text,
                              porcentaje: double.parse(a),
                              activo: false,
                            ));
                          } else {
                            print('Esta editando');
                            widget.lista![gindex!].porcentaje =
                                double.parse(porcentaje.text);
                            widget.lista![gindex!].nombre = nombre.text;
                          }
                        });
                        asignaturas = [];
                        var lista = [];
                        for (var e in widget.lista!) {
                          asignaturas.add(e);
                          lista.add(e.toJson());
                        }
                        print(['Asignaturas a ser guardadas', lista]);
                        await storage.put(widget.nombre, lista);
                        if (porc == 100) {
                          setState(() {
                            enable = false;
                          });
                        }
                        setState(() {
                          edit = false;
                          asigt = false;
                          porcentaje.clear();
                          nombre.clear();
                        });
                      },
                      onTap: () {
                        print(['onTap']);
                      },
                      onEditingComplete: () {
                        print(['onEditingComplete']);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        widget.lista!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(7.0),
                child: ListView.builder(
                  controller: _docentesLv2ScrollController,
                  shrinkWrap: true,
                  itemCount: widget.lista!.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.lista![i].nombre!),
                                  Text(
                                    '% ' +
                                        widget.lista![i].porcentaje!.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: const Text('Editar'),
                                  onTap: () {
                                    setState(() {
                                      edit = true;
                                      asigt = true;
                                      enable = true;
                                      gindex = i;
                                      editado = widget.lista![i].nombre!;
                                      nombre.text = widget.lista![i].nombre!;
                                      porcentaje.text = widget
                                          .lista![i].porcentaje!
                                          .toString();
                                    });
                                    print([
                                      'Editar',
                                      nombre.text,
                                      porcentaje.text
                                    ]);
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
                                    checkPorc();
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

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  const MultiSelectDialog({Key? key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>>? items;
  final Set<V>? initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = <V>{};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  final ScrollController? _docentesxArea0ScrollController =
      ScrollController(initialScrollOffset: 0.0);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Grados'),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        controller: _docentesxArea0ScrollController,
        child: ListTileTheme(
          contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items!.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked!),
    );
  }
}
