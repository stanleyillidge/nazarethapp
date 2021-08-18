// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nazarethapp/icons/school_icons_icons.dart';
import 'package:nazarethapp/widgets/dashboard_card.dart';
import 'package:nazarethapp/widgets/estilos.dart';
import 'package:nazarethapp/widgets/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ScrollController? _homeController =
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
    _homeController!.dispose();
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
          controller: _homeController,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 2,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bienvenidos al Internado indigena de Nazareth',
                                        style: TextStyle(
                                          color: Colors.brown.shade700,
                                          fontSize: font1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      /* GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MyHomePage(
                                                login: false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Stanley Illidge',
                                              style: TextStyle(
                                                  fontSize: font1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                              height: 5,
                                            ),
                                            const CircleAvatar()
                                          ],
                                        ),
                                      ), */
                                      Row(
                                        children: [
                                          Text(
                                            'Año lectivo',
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
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.brown[
                                                      100], //Theme.of(context).primaryColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: DropdownButton<String>(
                                                    value: dropdownYear,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    // elevation: 16,
                                                    style: const TextStyle(
                                                      color: Colors.brown,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    focusColor:
                                                        Colors.deepPurple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    underline: Container(
                                                      height: 0,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged: (String?
                                                        newValue) async {
                                                      setState(() {
                                                        periodos = anos
                                                            .firstWhere((ax) =>
                                                                ax.nombre ==
                                                                newValue!)
                                                            .periodos;
                                                        dropdownPeriodo =
                                                            periodos[0];
                                                        dropdownYear =
                                                            newValue!;
                                                        print(dropdownYear);
                                                      });
                                                      await cargaTotal(
                                                          dropdownYear);
                                                      asignacionesPendientes =
                                                          asignacionesPendientes;
                                                      easigkey.currentState!
                                                          .setState(() {
                                                        pendientes.docentes =
                                                            pendientes.docentes;
                                                      });
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
                                                    },
                                                    items: anosLectivos.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
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
                                                width: 130,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.brown[
                                                      100], //Theme.of(context).primaryColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: DropdownButton<int>(
                                                    value: dropdownPeriodo,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    // elevation: 16,
                                                    style: const TextStyle(
                                                      color: Colors.brown,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    focusColor:
                                                        Colors.deepPurple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    underline: Container(
                                                      height: 0,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged: (int? newValue) {
                                                      setState(() {
                                                        dropdownPeriodo =
                                                            newValue!;
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
                                                    items: periodos.map<
                                                        DropdownMenuItem<
                                                            int>>((int value) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value,
                                                        child: Text('Periodo ' +
                                                            value.toString()),
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
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 45);
                      },
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) =>
                          DashBoardCard(
                        icon: data[index][0],
                        color: data[index][1],
                        titulo: data[index][2],
                        count: data[index][3],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: size.width * espacio2,
                                height: size.height * espacio3,
                                child: Container(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                            height: 10,
                          ),
                          Expanded(
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: size.width * espacio2,
                                height: size.height * espacio3,
                                child: Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: size.width * espacio2,
                                height: size.height * espacio3,
                                child: Container(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                            height: 10,
                          ),
                          Expanded(
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: size.width * espacio2,
                                height: size.height * espacio3,
                                child: Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              /* Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors
                                  .brown[100], //Theme.of(context).primaryColor,
                              // brightness: Brightness.dark,
                              // primaryColor: Colors.brown.shade400,
                              // hintColor: Colors.black,
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.brown[
                                            100], //Theme.of(context).primaryColor,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: DropdownButton<String>(
                                          value: dropdownYear,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          // elevation: 16,
                                          style: const TextStyle(
                                            color: Colors.brown,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          focusColor: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                                  .cargaAsignaciones(
                                                      dropdownTipo,
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
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.brown[
                                            100], //Theme.of(context).primaryColor,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: DropdownButton<int>(
                                          value: dropdownPeriodo,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          // elevation: 16,
                                          style: const TextStyle(
                                            color: Colors.brown,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
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
                                              dxakey.currentState!.setState(() {
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          IconButton(
                              onPressed: () {},
                              iconSize: 30,
                              icon: const Icon(Icons.notifications)),
                          const SizedBox(
                            width: 5,
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyHomePage(
                                    login: false,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Stanley\nIllidge',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                CircleAvatar()
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.015,
                    height: size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.595,
                            height: size.height * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        ((asignacionesPendientes.isNotEmpty)
                                            ? 'Asignaciones pendientes ' +
                                                asignacionesPendientes
                                                    .where((e) =>
                                                        (e.completa == false) &&
                                                        (e.periodo ==
                                                            dropdownPeriodo))
                                                    .toList()
                                                    .length
                                                    .toString()
                                            : 'Total de areas pendientes ' +
                                                asigTotal.asignaciones
                                                    .where((e) => ((e
                                                                .completa ==
                                                            false) &&
                                                        (e.periodo ==
                                                            dropdownPeriodo)))
                                                    .toList()
                                                    .length
                                                    .toString()),
                                        style: titulo,
                                      ),
                                      Row(
                                        children: [
                                          (genPlanillas2)
                                              ? ElevatedButton(
                                                  // style: style,
                                                  onPressed: () async {
                                                    setState(() {
                                                      genPlanillas3 = true;
                                                    });
                                                    for (var i = 0;
                                                        i <
                                                            listaPendientes
                                                                .length;
                                                        i++) {
                                                      if (listaPendientes[i]
                                                          .selected) {
                                                        print(listaPendientes[i]
                                                            .toJson());
                                                        await creaFile(
                                                          context,
                                                          listaPendientes[i]
                                                              .area,
                                                          listaPendientes[i]
                                                              .docente,
                                                          listaPendientes[i]
                                                              .sede,
                                                          listaPendientes[i]
                                                              .grado,
                                                          listaPendientes[i]
                                                              .grupos,
                                                          dropdownPeriodo,
                                                        );
                                                        setState(() {
                                                          listaPendientes[i]
                                                              .selected = false;
                                                        });
                                                        dxakey.currentState!
                                                            .setState(() {
                                                          listaPendientes =
                                                              listaPendientes;
                                                        });
                                                      }
                                                    }
                                                    setState(() {
                                                      genPlanillas2 = false;
                                                      genPlanillas3 = false;
                                                    });
                                                    String titulo =
                                                        'Planillas generadas';
                                                    List<Widget> body = [];
                                                    body.add(const Text(
                                                        'Las planillas fueron guardadas en la ubicación de descargas.'));
                                                    _showMyDialog(titulo, body);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      (genPlanillas3)
                                                          ? const SizedBox(
                                                              width: 15,
                                                              height: 15,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                // strokeWidth: 1.5,
                                                              ),
                                                            )
                                                          : Container(),
                                                      (genPlanillas3)
                                                          ? const SizedBox(
                                                              width: 10,
                                                              height: 10,
                                                            )
                                                          : Container(),
                                                      const Text(
                                                          'Generar planillas'),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            width: 10,
                                            height: 10,
                                          ),
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
                                              dxakey.currentState!
                                                  .cargaAsignaciones(
                                                      dropdownTipo,
                                                      dropdownPeriodo);
                                              // String titulo =
                                              //     'Documento cargado';
                                              // List<Widget> body = [];
                                              // body.add(Text(
                                              //     'La información fue cargada correctamente!'));
                                              // _showMyDialog(titulo, body);
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
                                                    : const Icon(Icons
                                                        .dashboard_customize_sharp),
                                                const SizedBox(
                                                  width: 10,
                                                  height: 10,
                                                ),
                                                const Text('Cargar planilla'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.brown[
                                              100], //Theme.of(context).primaryColor,
                                          // brightness: Brightness.dark,
                                          // primaryColor: Colors.brown.shade400,
                                          // hintColor: Colors.black,
                                        ),
                                        child: Container(
                                          height: 30,
                                          // width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.brown[
                                                100], //Theme.of(context).primaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: DropdownButton<String>(
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 30,
                                              // elevation: 16,
                                              style: const TextStyle(
                                                color: Colors.brown,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              focusColor: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              underline: Container(
                                                height: 0,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              value: dropdownTipo,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownTipo = newValue!;
                                                  print(dropdownTipo);
                                                });
                                              },
                                              items: filtroPendientes.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                                Card(
                                  // elevation: 2,
                                  // color: Colors.blueGrey[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: DocentesxAreaTable(
                                    key: dxakey,
                                    periodo: dropdownPeriodo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Placeholder(
                          //   fallbackWidth: size.width * 0.6,
                          //   fallbackHeight: size.height * 0.43,
                          // ),
                          // SizedBox(
                          //   width: size.width * 0.01,
                          //   height: size.height * 0.01,
                          // ),
                          // Placeholder(
                          //   fallbackWidth: size.width * 0.6,
                          //   fallbackHeight: size.height * 0.43,
                          // ),
                        ],
                      ),
                      Flexible(
                        child: Card(
                          elevation: 2,
                          color: Colors.blueGrey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: size.width * 0.295,
                            height: size.height * 0.865,
                            child: EstadoAsignacion(key: easigkey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ), */
            ),
          ),
        );
      },
    );
  }
}
