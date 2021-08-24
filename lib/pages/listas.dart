// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nazarethapp/icons/school_icons_icons.dart';
import 'package:nazarethapp/widgets/filter_bar.dart';
import 'package:nazarethapp/widgets/models.dart';
import 'package:nazarethapp/widgets/top_bar.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({Key? key}) : super(key: key);

  @override
  _ListasPageState createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final ScrollController? _listasController =
      ScrollController(initialScrollOffset: 0.0);
  TextEditingController ano = TextEditingController();

  /* Future<void> _showMyDialog(String titulo, List<Widget> body) async {
    ScrollController? _dialogScrollController;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(
            controller: _dialogScrollController,
            child: ListBody(
              children: body,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */

  init() async {
    setState(() {
      if (!anosLectivos.contains(dropdownYear)) {
        dropdownYear = anos[0].nombre;
      }
      anos = anos;
      anosLectivos = anosLectivos;
      periodos = periodos;
      areas = areas;
      grados = grados;
      estudiantes = estudiantes;
      docentes = docentes;
      asigTotal = asigTotal;
      pendientes = pendientes;
    });
  }

  @override
  void initState() {
    init();
    dropdownTipo = 'Area';
    porcentajeAvance = 0;
    super.initState();
    /* WidgetsBinding.instance!.addPostFrameCallback(
      (_) => dxakey.currentState!.setState(
        () {
          listaPendientes = [];
          dxakey.currentState!.limiteInf = 0;
          dxakey.currentState!.limiteSup = 25;
          dxakey.currentState!.cargaAsignaciones(dropdownTipo, dropdownPeriodo);
        },
      ),
    ); */
  }

  @override
  void dispose() {
    _listasController!.dispose();
    super.dispose();
  }

  double espacio2 = 0.44;
  double espacio3 = 0.35;
  dynamic data = [
    [School_icons.school, Colors.orange, 'Sedes', 6],
    [School_icons.teacher0, Colors.purple, 'Docentes', 69],
    [School_icons.students0, Colors.yellow, 'Estudiantes', 1690],
    [School_icons.family0, Colors.green, 'Reportes', 876]
  ];
  bool genPlanillas2 = false;
  bool genPlanillas3 = false;
  bool loadingAll = false;
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _listasController,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Column(
                children: const [
                  TopBar(
                    titulo: 'Listas',
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  FilterBar(
                    titulo: 'Listas',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
