// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'estilos.dart';
import 'models.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key, this.titulo}) : super(key: key);
  final String? titulo;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
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
