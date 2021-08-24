// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

import 'estilos.dart';
import 'models.dart';

class FilterBar extends StatefulWidget {
  static final filterBarKey = GlobalKey<NavigatorState>();
  const FilterBar({Key? filterBarKey, this.titulo}) : super(key: filterBarKey);
  final String? titulo;

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? selectedValueSingleMenu;
  String? selectedValueSingleDialog;
  String? selectedValueSingleDialogDarkMode;
  List<DropdownMenuItem> items = [];
  var data = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
  ];
  @override
  void initState() {
    for (var i = 0; i < data.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(data[i]),
        value: data[i],
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Single dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Sedes",
        searchHint: "Selecciona una",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        displayItem: (item, selected) {
          return (Row(children: [
            selected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 7),
            Expanded(
              child: item,
            ),
          ]));
        },
        searchInputDecoration: const InputDecoration(
            icon: Icon(Icons.search_rounded), border: OutlineInputBorder()),
        isExpanded: false,
        padding: 0,
        underline: Container(
          height: 0.0,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.transparent, width: 0.0),
            ),
          ),
        ),
      ),
      /* "Single menu": SearchChoices.single(
        items: items,
        value: selectedValueSingleMenu,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            selectedValueSingleMenu = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ), */
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.titulo!,
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontSize: font1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: widgets
                              .map((k, v) {
                                return (MapEntry(
                                  k,
                                  Column(
                                    children: <Widget>[
                                      v,
                                    ],
                                  ),
                                ));
                              })
                              .values
                              .toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Año lectivo',
                              style: TextStyle(
                                color: Colors.brown.shade700,
                                fontSize: font1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors
                                        .transparent, //Theme.of(context).primaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: DropdownButton<String>(
                                      value: dropdownYear,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      // elevation: 16,
                                      style: const TextStyle(
                                        color: Colors.brown,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      focusColor: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(5),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onChanged: (String? newValue) async {
                                        setState(() {
                                          periodos = anos
                                              .firstWhere((ax) =>
                                                  ax.nombre == newValue!)
                                              .periodos;
                                          dropdownPeriodo = periodos[0];
                                          dropdownYear = newValue!;
                                          print(dropdownYear);
                                        });
                                        await cargaTotal(dropdownYear);
                                        asignacionesPendientes =
                                            asignacionesPendientes;
                                        easigkey.currentState!.setState(() {
                                          pendientes.docentes =
                                              pendientes.docentes;
                                        });
                                        dxakey.currentState!.setState(() {
                                          listaPendientes = [];
                                          asignacionesPendientes =
                                              asignacionesPendientes;
                                          dxakey.currentState!
                                              .cargaAsignaciones(dropdownTipo,
                                                  dropdownPeriodo);
                                        });
                                      },
                                      items: anosLectivos
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                              height: 10,
                            ),
                            Text(
                              'Periodo',
                              style: TextStyle(
                                color: Colors.brown.shade700,
                                fontSize: font1,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors
                                        .transparent, //Theme.of(context).primaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: DropdownButton<int>(
                                      value: dropdownPeriodo,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      // elevation: 16,
                                      style: const TextStyle(
                                        color: Colors.brown,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      focusColor: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(5),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          dropdownPeriodo = newValue!;
                                          print(dropdownPeriodo);
                                          dxakey.currentState!.setState(() {
                                            listaPendientes = [];
                                            asignacionesPendientes =
                                                asignacionesPendientes;
                                            dxakey.currentState!
                                                .cargaAsignaciones(dropdownTipo,
                                                    dropdownPeriodo);
                                          });
                                        });
                                      },
                                      items: periodos
                                          .map<DropdownMenuItem<int>>(
                                              (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                              'Periodo ' + value.toString()),
                                        );
                                      }).toList(),
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
              ),
            ],
          ),
        )
      ],
    );
  }
}
