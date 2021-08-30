// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nazarethapp/icons/school_icons_icons.dart';
import 'package:nazarethapp/widgets/estilos.dart';
import 'package:nazarethapp/widgets/filter_bar.dart';
// import 'package:nazarethapp/widgets/lista_estudiantes.dart';
import 'package:nazarethapp/widgets/models.dart';
import 'package:nazarethapp/widgets/pie_chart.dart';
import 'package:nazarethapp/widgets/resumen_estudiantes.dart';
import 'package:nazarethapp/widgets/top_bar.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({Key? key}) : super(key: key);

  @override
  _ListasPageState createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage>
    with SingleTickerProviderStateMixin {
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

  TabController? _controller;
  @override
  void initState() {
    init();
    dropdownTipo = 'Area';
    porcentajeAvance = 0;
    super.initState();
    _controller = TabController(length: 2, vsync: this);
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
    var size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _listasController,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 18, right: 18),
              child: Column(
                children: [
                  const TopBar(
                    titulo: 'Listas',
                  ),
                  // const SizedBox(
                  //   width: 5,
                  //   height: 5,
                  // ),
                  const FilterBar(
                    titulo: 'Filtros',
                  ),
                  const SizedBox(
                    width: 5,
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 6),
                    child: Row(children: [
                      Column(
                        children: [
                          Container(
                            width: size.width * 0.18,
                            height: size.height * 0.82,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.2,
                                  height: 250,
                                  child: GrupoPieChart(
                                    aprobados: 40,
                                    reprobados: 30,
                                    pendientes: 30,
                                    centerSpaceRadius: 45,
                                    sectionRadius: 50,
                                    convenciones: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SizedBox(
                                    width: size.width * 0.2,
                                    // height: 200,
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          const CircleAvatar(
                                            radius: 17,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                            height: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Nombres y apellidos #1',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Text(
                                                '1° Puesto',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        const SizedBox(
                                          width: 15,
                                          height: 15,
                                        ),
                                        Row(children: [
                                          const CircleAvatar(
                                            radius: 17,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                            height: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Nombres y apellidos #1',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Text(
                                                '1° Puesto',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        const SizedBox(
                                          width: 15,
                                          height: 15,
                                        ),
                                        Row(children: [
                                          const CircleAvatar(
                                            radius: 17,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                            height: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Nombres y apellidos #1',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Text(
                                                '1° Puesto',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Asignatura',
                                        style: TextStyle(
                                          color: Colors.brown.shade700,
                                          fontSize: font1,
                                          fontWeight: FontWeight.bold,
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
                                            // width: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors
                                                  .transparent, //Theme.of(context).primaryColor,
                                            ),
                                            child: DropdownButton<int>(
                                              value: dropdownPeriodo,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 30,
                                              // elevation: 16,
                                              style: const TextStyle(
                                                color: Colors.brown,
                                                fontSize: 18,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              focusColor: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (int? newValue) {
                                                setState(() {
                                                  dropdownPeriodo = newValue!;
                                                  print(dropdownPeriodo);
                                                  dxakey.currentState!
                                                      .setState(() {
                                                    listaPendientes = [];
                                                    asignacionesPendientes =
                                                        asignacionesPendientes;
                                                    dxakey.currentState!
                                                        .cargaAsignaciones(
                                                            dropdownTipo,
                                                            dropdownPeriodo);
                                                  });
                                                });
                                              },
                                              items: periodos
                                                  .map<DropdownMenuItem<int>>(
                                                      (int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text('Periodo ' +
                                                      value.toString()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.75,
                              height: size.height * 0.82,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 105,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                              right: 20,
                                              bottom: 30,
                                            ),
                                            child: Row(
                                              children: const [
                                                ResumenGrado(
                                                  color: Colors.lightGreen,
                                                  cifra: 25,
                                                  text: 'Aprobados',
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                ResumenGrado(
                                                  color: Color(0xfff8b250),
                                                  cifra: 5,
                                                  text: 'Pendientes',
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                ResumenGrado(
                                                  color: Colors.red,
                                                  cifra: 5,
                                                  text: 'Reprobados',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            PreferredSize(
                                              preferredSize: const Size(40, 40),
                                              child: SizedBox(
                                                height: 40,
                                                width: 260,
                                                child: TabBar(
                                                  controller: _controller,
                                                  indicator:
                                                      const UnderlineTabIndicator(
                                                    borderSide:
                                                        BorderSide(width: 2.0),
                                                    insets:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0),
                                                  ),
                                                  tabs: [
                                                    Tab(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.home,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'General',
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Tab(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.my_location,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Detallado',
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70, //size.height * .6,
                                    child: TabBarView(
                                      controller: _controller,
                                      children: <Widget>[
                                        /* const Card(
                                          child: ListTile(
                                            leading: Icon(Icons.home),
                                            title: TextField(
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Search for address...'),
                                            ),
                                          ),
                                        ), */
                                        // const ListaEstudiantes(),
                                        const ResumenEstudiantes(),
                                        Card(
                                          child: ListTile(
                                            leading:
                                                const Icon(Icons.location_on),
                                            title: const Text(
                                                'Latitude: 48.09342\nLongitude: 11.23403'),
                                            trailing: IconButton(
                                                icon: const Icon(
                                                    Icons.my_location),
                                                onPressed: () {}),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
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

class ResumenGrado extends StatelessWidget {
  final Color color;
  final String text;
  final int cifra;
  final double size;
  final Color textColor;

  const ResumenGrado({
    Key? key,
    required this.color,
    required this.text,
    required this.cifra,
    this.size = 14,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          cifra.toString(),
          style: TextStyle(
            height: 1.1,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Container(
          width: 45,
          height: 5,
          decoration: BoxDecoration(
            color: color.withAlpha(120),
          ),
        ),
        Text(
          text.toString().toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            height: 1.7,
            // fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
