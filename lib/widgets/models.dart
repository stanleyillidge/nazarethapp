// ignore_for_file: avoid_print

import 'dart:io';

import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// ignore: prefer_typing_uninitialized_variables
var storage;
// ignore: prefer_typing_uninitialized_variables
var anosLectivosStorage;
bool act = false;
String dropdownTipo = 'Area';
String dropdownYear = '2020';
bool newall = false;
int dropdownPeriodo = 1;
List<bool> genPlanillas = [];
List<Widget> paginas = [];
List<Sede> sedes = [];
List<Area> areas = [];
List<Asignatura> asignaturas = [];
List<Grupo> grupos = [];
List<Widget> gruposWidgets = [];
List<Grado> grados = [];
List<Estudiante> estudiantes = [];
List<Docente> docentes = [];
List<AsignacionT> asignacionesPendientes = [];
List<Logro> logros = [];
// List listaPendientes = [];
List<DashboardCard> listaPendientes = [];
ResumenAsignacionT pendientes = ResumenAsignacionT(
  docentes: [],
  areas: [],
  grados: [],
  grupos: [],
);
List<String> filtroPendientes = ['Area', 'Grado', 'Grupo', 'Docente'];
List<String> anosLectivos = [DateTime.now().year.toString()];
List<Ano> anos = [];
List<int> periodos = [1];
Asignaciones asigTotal = Asignaciones(asignaciones: []);
double porcentajeAvance = 0;
enum ModelType { grado, grupo, area, asignatura, estudiante, docente, ano }
// GlobalKey<DocentesxAreaTableState> dxakey = GlobalKey();
// GlobalKey<EstadoAsignacionState> easigkey = GlobalKey();
// GlobalKey<GradosListState> gxakey = GlobalKey();
// GlobalKey<AreasListState> axakey = GlobalKey();
// GlobalKey<HomePageState> homekey = GlobalKey();
// GlobalKey<HomePageState> configuracionkey = GlobalKey();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

ThemeData tema = ThemeData(
  primarySwatch: Colors.brown,
  brightness: Brightness.light,
  primaryColor: Colors.brown,
  /* colorScheme: ColorScheme(
    onPrimary: Colors.orangeAccent,
    primary: Colors.brown,
    surface: Colors.greenAccent,
    onSurface: Colors.green,
    background: Colors.white,
    primaryVariant: Colors.orange,
    error: Colors.red,
    secondaryVariant: Colors.orange,
    onBackground: Colors.white,
    brightness: Brightness.light,
    onError: Colors.red,
    onSecondary: Colors.orange,
    secondary: Colors.orange,
  ), */
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);

Future openYears() async {
  // asignacionesPendientes = [];
  // areas = [];
  // grados = [];
  // estudiantes = [];
  // docentes = [];
  // asigTotal.asignaciones = [];
  // var path = Directory.current.path;
  // Hive.init(path);
  anos = [];
  anosLectivos = [];
  anosLectivosStorage = await Hive.openBox('anosLectivos');
  var ax = await anosLectivosStorage.get('anos');
  if ((ax == null)) {
    newall = true;
    DateTime now = DateTime.now();
    dropdownYear = now.year.toString();
    periodos = [1, 2];
    ax = [
      {'nombre': dropdownYear, 'periodos': periodos}
    ];
    print('No tiene años guardados');
    print(['Nuevo Año a ser guardado', ax]);
    await anosLectivosStorage.put('anos', ax);
  }
  ax.forEach((e) {
    print(['Año', e]);
    Ano x = Ano.fromJson(e);
    anos.add(x);
    anosLectivos.add(x.nombre);
  });
  dropdownYear = anosLectivos[0];
  periodos = anos[0].periodos;
  dropdownPeriodo = periodos[0];
  print(['Años lectivos', anos.length, anosLectivos]);
}

Future cargaTotal([String? year]) async {
  asignacionesPendientes = [];
  areas = [];
  grados = [];
  estudiantes = [];
  docentes = [];
  asigTotal.asignaciones = [];
  var path = Directory.current.path;
  Hive.init(path);
  if (year == null) {
    await openYears();
  } else {
    dropdownYear = year;
  }
  storage = await Hive.openBox(dropdownYear);
  await carga('Logros');
  await carga('Sedes');
  await carga('Areas');
  await carga('Grados');
  await carga('Estudiantes');
  await carga('Docentes');
  await carga('Asignaciones');
  // await storage.close();
  print(['Sedes', sedes.length, if (sedes.isNotEmpty) sedes[0].toJson()]);
  print(['Grados', grados.length, if (grados.isNotEmpty) grados[0].toJson()]);
  print(['Areas', areas.length, if (areas.isNotEmpty) areas[0].toJson()]);
  print([
    'Estudiantes',
    estudiantes.length,
    if (estudiantes.isNotEmpty) estudiantes[0].toJson()
  ]);
  print([
    'Docentes',
    docentes.length,
    if (docentes.isNotEmpty) docentes[0].toJson()
  ]);
  print([
    'Asignaciones',
    asigTotal.asignaciones.length,
    if (asigTotal.asignaciones.isNotEmpty) asigTotal.asignaciones[0].toJson()
  ]);
  await acPendientes();
}

Future carga(a) async {
  List? g = await storage.get(a);
  if (g != null) {
    for (var i = 0; i < g.length; i++) {
      // setState(() {
      // print([a, 'cargada', g[i]]);
      // if (a == 'Logros') logros.add(Logro.fromJson(g[i]));
      if (a == 'Sedes') sedes.add(Sede.fromJson(g[i]));
      if (a == 'Areas') areas.add(Area.fromJson(g[i]));
      if (a == 'Grados') grados.add(Grado.fromJson(g[i]));
      if (a == 'Estudiantes') estudiantes.add(Estudiante.fromJson(g[i]));
      if (a == 'Docentes') docentes.add(Docente.fromJson(g[i]));
      if (a == 'Asignaciones') {
        asigTotal.asignaciones.add(AsignacionT.fromJson(g[i]));
      }
    }
  }
}

Future acPendientes() async {
  pendientes = await asigTotal.resumen();
  pendientes.docentes!.sort((a, b) {
    return a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase());
  });
  pendientes.areas!.sort((a, b) {
    return a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase());
  });
  pendientes.grados!.sort((a, b) {
    return a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase());
  });
  pendientes.grupos!.sort((a, b) {
    return a.nombre!.toLowerCase().compareTo(b.nombre!.toLowerCase());
  });
}

Future actualizarPendientes(
    String sede, String area, String docente, String grupo, bool estado) async {
  // var _asg = asigTotal.asignaciones.firstWhere((a) =>
  //     ((a.docente == docente) && (a.area == area) && (a.grupo == grupo)));
  // var _index = asigTotal.asignaciones.indexOf(_asg);
  var _index = asigTotal.asignaciones.indexWhere((a) =>
      ((a.docente == docente) &&
          (a.periodo == dropdownPeriodo) &&
          (a.area == area) &&
          (a.grupo == grupo)));
  if (_index != -1) {
    asigTotal.asignaciones[_index].completa = estado;
    asigTotal.asignaciones[_index].cargada = true;
    print(['actualizarPendientes', asigTotal.asignaciones[_index].toJson()]);
  } else {
    var ss = asigTotal.asignaciones
        .where((a) => ((a.docente == docente) &&
            (a.periodo == dropdownPeriodo) &&
            (a.grupo == grupo)))
        .toList();
    for (var e in ss) {
      print([e.toJson()]);
    }
    print(['No existe', sede, area, docente, grupo, estado]);
  }
  return asigTotal.asignaciones;
}

String sede(String grupo) {
  String codigo = grupo.substring(grupo.length - 1);
  String codigo0 = grupo.substring(0, grupo.length - 1);
  String ss = 'No tiene';
  for (var i = 0; i < sedes.length; i++) {
    // print(['Codigo sede', codigo, sedes[i]]);
    for (var j = 0; j < sedes[i].codGrupo!.length; j++) {
      // print(['Codigo sede', codigo, sedes[i].codGrupo![j]]);
      if (sedes[i].codGrupo![j] == codigo) {
        if ((int.parse(codigo0) > 5) || (codigo == 'A') || (codigo == 'B')) {
          ss = 'principal';
        } else {
          ss = sedes[i].nombre!;
        }
      }
    }
  }
  return ss;
}

class Ano {
  late String nombre;
  late List<int> periodos;

  Ano({
    required this.nombre,
    required this.periodos,
  });

  Ano.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] ?? 'No tiene';
    periodos = json['periodos'] ?? [1];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['nombre'] = nombre;
    data['periodos'] = periodos;
    return data;
  }
}

class Logro {
  late String logro;
  late String dflogro;
  late String codGrado;
  late String area;
  late String periodo;
  late String sede;

  Logro({
    required this.logro,
    required this.dflogro,
    required this.codGrado,
    required this.area,
    required this.periodo,
    required this.sede,
  });

  Logro.fromJson(Map<dynamic, dynamic> json) {
    logro = json['logro'] ?? 'No tiene';
    dflogro = json['dflogro'] ?? 'No tiene';
    codGrado = json['codGrado'] ?? 'No tiene';
    area = json['area'] ?? 'No tiene';
    periodo = json['periodo'] ?? 'No tiene';
    sede = json['sede'] ?? 'No tiene';
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['logro'] = logro;
    data['dflogro'] = dflogro;
    data['codGrado'] = codGrado;
    data['area'] = area;
    data['periodo'] = periodo;
    data['sede'] = sede;
    return data;
  }
}

class Fila {
  String? nombre;
  bool? activo;

  Fila({
    this.nombre,
    this.activo,
  });

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

class Grupo {
  String? nombre;
  bool? activo;

  Grupo({
    this.nombre,
    this.activo,
  });

  Grupo.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] ?? 'No tiene';
    activo = json['activo'] ?? false;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

class Grado {
  String? nombre;
  int? codigo;
  List<Grupo>? grupos;
  bool? activo;

  Grado({
    this.nombre,
    this.codigo,
    this.grupos,
    this.activo,
  });

  Grado.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] ?? 'No tiene';
    activo = json['activo'] ?? false;
    codigo = json['codigo'] ?? -1;
    if (json['grupos'] != null) {
      List g = json['grupos'];
      grupos = [];
      for (var i = 0; i < g.length; i++) {
        grupos!.add(Grupo.fromJson(g[i]));
      }
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (codigo != null) {
      data['codigo'] = codigo;
    }
    if (grupos != null) {
      List<Grupo> g = grupos!;
      data['grupos'] = [];
      for (var i = 0; i < g.length; i++) {
        data['grupos'].add(g[i].toJson());
      }
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

class Asignatura {
  String? nombre;
  double? porcentaje;
  bool? activo;

  Asignatura({
    this.nombre,
    this.porcentaje,
    this.activo,
  });

  Asignatura.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] ?? 'No tiene';
    porcentaje = json['porcentaje'] ?? 0;
    activo = json['activo'] ?? false;
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (porcentaje != null) {
      data['porcentaje'] = porcentaje;
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

class AsigPlanEstudio {
  Area? area;
  Grupo? grupo;
  Grado? grado;
  int? ih;

  AsigPlanEstudio({
    this.area,
    this.grupo,
    this.grado,
    this.ih,
  });

  AsigPlanEstudio.fromJson(Map<dynamic, dynamic> json) {
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    grupo = json['grupo'] != null ? Grupo.fromJson(json['grupo']) : null;
    grado = json['grado'] != null ? Grado.fromJson(json['grado']) : null;
    ih = json['ih'] ?? 0;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (area != null) {
      Area g = area!;
      data['area'] = g.toJson();
    }
    if (grupo != null) {
      Grupo g = grupo!;
      data['grupo'] = g.toJson();
    }
    if (grado != null) {
      Grado g = grado!;
      data['grado'] = g.toJson();
    }
    if (ih != null) {
      data['ih'] = ih;
    }
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Area {
  String? nombre;
  int? ih;
  List<Asignatura>? asignaturas;
  double? porcentaje;
  List<Grado>? grados;
  List<AsigPlanEstudio>? planEstudio;
  bool? activo;

  Area({
    this.nombre,
    this.ih,
    this.porcentaje,
    this.asignaturas,
    this.grados,
    this.activo,
    this.planEstudio,
  });

  adds(Asignatura asig) {
    double p = porcentaje! + asig.porcentaje!;
    if ((p) <= 100) {
      porcentaje = porcentaje! + asig.porcentaje!;
      asignaturas ??= [];
      asignaturas!.add(asig);
      return 'ok';
    } else {
      return 'porcentaje superado';
    }
  }

  Area.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] ?? 'No tiene';
    ih = json['ih'] ?? 0;
    porcentaje = json['porcentaje'] ?? 0;
    activo = json['activo'] ?? false;
    if (json['asignaturas'] != null) {
      List a = json['asignaturas'];
      asignaturas = [];
      for (var i = 0; i < a.length; i++) {
        asignaturas!.add(Asignatura.fromJson(a[i]));
      }
    } else {
      asignaturas = [];
    }
    if (json['grados'] != null) {
      List g = json['grados'];
      grados = [];
      for (var i = 0; i < g.length; i++) {
        grados!.add(Grado.fromJson(g[i]));
      }
    } else {
      grados = [];
    }
    if (json['planEstudio'] != null) {
      List g = json['planEstudio'];
      planEstudio = [];
      for (var i = 0; i < g.length; i++) {
        planEstudio!.add(AsigPlanEstudio.fromJson(g[i]));
      }
    } else {
      planEstudio = [];
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (ih != null) {
      data['ih'] = ih;
    }
    if (porcentaje != null) {
      data['porcentaje'] = porcentaje;
    }
    if (asignaturas != null) {
      data['asignaturas'] = [];
      for (var e in asignaturas!) {
        data['asignaturas'].add(e.toJson());
      }
    }
    if (grados != null) {
      data['grados'] = [];
      for (var e in grados!) {
        data['grados'].add(e.toJson());
      }
    }
    if (planEstudio != null) {
      data['planEstudio'] = [];
      for (var e in planEstudio!) {
        data['planEstudio'].add(e.toJson());
      }
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

class AsigxGrupo {
  String? grupo;
  int? ih;

  AsigxGrupo({
    this.grupo,
    this.ih,
  });

  AsigxGrupo.fromJson(Map<dynamic, dynamic> json) {
    grupo = (json['grupo'] != null) ? json['grupo'] : '';
    ih = (json['ih'] != null) ? json['ih'] : 0;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (grupo != null) {
      data['grupo'] = grupo;
    }
    if (ih != null) {
      data['ih'] = ih;
    }
    return data;
  }
}

class AsigxArea {
  String? area;
  List<AsigxGrupo>? asGrupos;

  AsigxArea({
    this.area,
    this.asGrupos,
  });

  AsigxArea.fromJson(Map<dynamic, dynamic> json) {
    area = (json['area'] != null) ? json['area'] : '';
    if (json['asGrupos'] != null) {
      List a = json['asGrupos'];
      asGrupos = [];
      for (var i = 0; i < a.length; i++) {
        asGrupos!.add(AsigxGrupo.fromJson(a[i]));
      }
    } else {
      asGrupos = [];
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (area != null) {
      data['area'] = area;
    }
    if (asGrupos != null) {
      data['asGrupos'] = [];
      for (var e in asGrupos!) {
        data['asGrupos'].add(e.toJson());
      }
    }
    return data;
  }
}

class Asignacion {
  String? dirGrupo;
  List<AsigxArea>? asigAreas;

  Asignacion({
    this.asigAreas,
    this.dirGrupo,
  });

  getHrToales([Area? area, Grado? grado, Grupo? grupo]) {
    // asignaciones;
    return;
  }

  /* Asignacion.fromSheet(List<dynamic> cells) {
    if (cells[5] != null) {
      dirGrupo = cells[5];
    }
    var area;
    if (cells[4] != null) {
      area = cells[4];
    }
    var asig;
    if (cells[4] != null) {
      area = cells[4];
    }
    asig = AsigxArea(area: area);
  } */

  Asignacion.fromJson(Map<dynamic, dynamic> json) {
    dirGrupo = json['dirGrupo'];
    if (json['asigAreas'] != null) {
      List a = json['asigAreas'];
      asigAreas = [];
      for (var i = 0; i < a.length; i++) {
        asigAreas!.add(AsigxArea.fromJson(a[i]));
      }
    } else {
      asigAreas = [];
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (dirGrupo != null) {
      data['dirGrupo'] = dirGrupo;
    }
    // if (this.asigAreas != null) {
    //   AsigxArea g = this.asigAreas!;
    //   data['asigAreas'] = g.toJson();
    // }
    if (asigAreas != null) {
      data['asigAreas'] = [];
      for (var e in asigAreas!) {
        data['asigAreas'].add(e.toJson());
      }
    }
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class AsignacionT {
  late String docente;
  late String area;
  late String grado;
  late String grupo;
  late int periodo;
  late int ih;
  late bool cargada;
  late bool completa;

  AsignacionT({
    required this.docente,
    required this.area,
    required this.grado,
    required this.grupo,
    required this.periodo,
    required this.ih,
    required this.completa,
    required this.cargada,
  });

  AsignacionT.fromJson(Map<dynamic, dynamic> json) {
    docente = json['docente'];
    area = json['area'];
    grado = json['grado'];
    grupo = json['grupo'];
    periodo = json['periodo'];
    ih = json['ih'];
    completa = json['completa'];
    cargada = json['cargada'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['docente'] = docente;
    data['area'] = area;
    data['grado'] = grado;
    data['grupo'] = grupo;
    data['periodo'] = periodo;
    data['ih'] = ih;
    data['completa'] = completa;
    data['cargada'] = cargada;
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Resumen {
  String? nombre;
  List<AsignacionT>? asignacion;
  bool? selected;

  Resumen({
    this.nombre,
    this.asignacion,
    this.selected,
  });

  Resumen.fromJson(Map<String, dynamic> json) {
    nombre = (json['nombre'] != null) ? json['nombre'] : null;
    if (json['asignacion'] != null) {
      asignacion = <AsignacionT>[];
      json['asignacion'].forEach((v) {
        asignacion!.add(AsignacionT.fromJson(v));
      });
    }
    selected = (json['selected'] != null) ? json['selected'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    if (asignacion != null) {
      data['asignacion'] = asignacion!.map((v) => v.toJson()).toList();
    }
    data['selected'] = selected;
    return data;
  }
}

class ResumenAsignacionT {
  List<Resumen>? docentes;
  List<Resumen>? areas;
  List<Resumen>? grados;
  List<Resumen>? grupos;

  ResumenAsignacionT({
    this.docentes,
    this.areas,
    this.grados,
    this.grupos,
  });

  ResumenAsignacionT.fromJson(Map<dynamic, dynamic> json) {
    if (json['docentes'] != null) {
      docentes = <Resumen>[];
      json['docentes'].forEach((v) {
        docentes!.add(Resumen.fromJson(v));
      });
    }
    if (json['areas'] != null) {
      areas = <Resumen>[];
      json['areas'].forEach((v) {
        areas!.add(Resumen.fromJson(v));
      });
    }
    if (json['grados'] != null) {
      grados = <Resumen>[];
      json['grados'].forEach((v) {
        grados!.add(Resumen.fromJson(v));
      });
    }
    if (json['grupos'] != null) {
      grupos = <Resumen>[];
      json['grupos'].forEach((v) {
        grupos!.add(Resumen.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (docentes != null) {
      data['docentes'] = docentes!.map((v) => v.toJson()).toList();
    }
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    if (grados != null) {
      data['grados'] = grados!.map((v) => v.toJson()).toList();
    }
    if (grupos != null) {
      data['grupos'] = grupos!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Resumen> get(String propertyName) {
    var _mapRep = toJson();
    List<Resumen> rta = <Resumen>[];
    if (_mapRep.containsKey(propertyName)) {
      if (_mapRep[propertyName] != null) {
        _mapRep[propertyName].forEach((v) {
          rta.add(Resumen.fromJson(v));
        });
      }
      return rta;
      // return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Asignaciones {
  late List<AsignacionT> asignaciones;

  Asignaciones({
    required this.asignaciones,
  });

  Asignaciones.fromJson(Map<dynamic, dynamic> json) {
    if (json['asignaciones'] != null) {
      var a = json['asignaciones'];
      asignaciones = [];
      for (var i = 0; i < a.length; i++) {
        asignaciones.add(AsignacionT.fromJson(a[i]));
      }
    } else {
      asignaciones = [];
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['asignaciones'] = [];
    for (var e in asignaciones) {
      data['asignaciones'].add(e.toJson());
    }
    return data;
  }

  Future<ResumenAsignacionT> resumen() async {
    pendientes = ResumenAsignacionT(
      docentes: [],
      areas: [],
      grados: [],
      grupos: [],
    );
    for (var i = 0; i < grados.length; i++) {
      var estudGrado =
          estudiantes.where((e) => (e.grado == grados[i].nombre)).toList();
      for (var j = 0; j < grados[i].grupos!.length; j++) {
        var estudGrupo = estudGrado
            .where((e) => (e.grupo == grados[i].grupos![j].nombre))
            .toList();
        if (estudGrupo.isNotEmpty) {
          // var asgTemp = [];
          // for (var asignacion in asigGrupo) {
          //   var index = asignaciones.indexOf(asignacion);
          //   asgTemp.add([index, asignacion.area, true]);
          // }
          /* for (var estudiante in estudGrupo) {
            if (estudiante.calificaciones != null) {
              for (var asignacion in asigGrupo) {
                var cal = estudiante.calificaciones!.xArea(asignacion.area);
                // var ctemp = (cal != 'propery not found') ? true : false;
                // if (ctemp) {
                //   print(temp);
                // }
                // temp[2] = ctemp && temp[2];
                var index = asignaciones.indexOf(asignacion);
                var ctemp = (cal != 'propery not found') ? true : false;
                asignaciones[index].completa =
                    ctemp && asignaciones[index].completa;
              }
            }
          } */
          // print([
          //   'Completa',
          //   asgTemp.where((a) => (a[2] == true)).toList().length
          // ]);
          // for (var temp in asgTemp) {
          //   asignaciones[temp[0]].completa = temp[2];
          // }
        }
      }
    }
    for (var asignacion in asignaciones) {
      // if (!asignacion.completa) {
      await addResumen(asignacion, 'docentes');
      await addResumen(asignacion, 'areas');
      await addResumen(asignacion, 'grados');
      await addResumen(asignacion, 'grupos');
      // }
    }
    print([
      'pendientes.docentes',
      pendientes.docentes!.length,
      'pendientes.areas',
      pendientes.areas!.length,
      'pendientes.grados',
      pendientes.grados!.length,
      'pendientes.grupos',
      pendientes.grupos!.length,
      // pendientes.toJson(),
    ]);
    return pendientes;
  }

  addResumen(AsignacionT asignacion, String campo) async {
    String campo2 = campo.substring(0, campo.length - 1);
    switch (campo) {
      case 'docentes':
        var consulta = pendientes.docentes!
            .where((d) => (d.nombre == asignacion.get(campo2)))
            .toList();
        if (consulta.isNotEmpty) {
          for (var m = 0; m < pendientes.docentes!.length; m++) {
            if (pendientes.docentes![m].nombre == asignacion.get(campo2)) {
              if (!pendientes.docentes![m].asignacion!.contains(asignacion)) {
                pendientes.docentes![m].asignacion!.add(asignacion);
              }
            }
          }
        } else {
          pendientes.docentes!.add(Resumen(
            nombre: asignacion.get(campo2),
            asignacion: [asignacion],
            selected: false,
          ));
        }
        // print(['ojo docentes', consulta.length, pendientes.docentes!.length]);
        break;
      case 'areas':
        var consulta = pendientes.areas!
            .where((d) => (d.nombre == asignacion.get(campo2)))
            .toList();
        if (consulta.isNotEmpty) {
          for (var m = 0; m < pendientes.areas!.length; m++) {
            if (pendientes.areas![m].nombre == asignacion.get(campo2)) {
              if (!pendientes.areas![m].asignacion!.contains(asignacion)) {
                pendientes.areas![m].asignacion!.add(asignacion);
              }
            }
          }
        } else {
          pendientes.areas!.add(Resumen(
            nombre: asignacion.get(campo2),
            asignacion: [asignacion],
            selected: false,
          ));
        }
        // print(['ojo areas', consulta.length, pendientes.areas!.length]);
        break;
      case 'grados':
        var consulta = pendientes.grados!
            .where((d) => (d.nombre == asignacion.get(campo2)))
            .toList();
        if (consulta.isNotEmpty) {
          for (var m = 0; m < pendientes.grados!.length; m++) {
            if (pendientes.grados![m].nombre == asignacion.get(campo2)) {
              if (!pendientes.grados![m].asignacion!.contains(asignacion)) {
                pendientes.grados![m].asignacion!.add(asignacion);
              }
            }
          }
        } else {
          pendientes.grados!.add(Resumen(
            nombre: asignacion.get(campo2),
            asignacion: [asignacion],
            selected: false,
          ));
        }
        // print(['ojo grados', consulta.length, pendientes.grados!.length]);
        break;
      case 'grupos':
        var consulta = pendientes.grupos!
            .where((d) => (d.nombre == asignacion.get(campo2)))
            .toList();
        if (consulta.isNotEmpty) {
          for (var m = 0; m < pendientes.grupos!.length; m++) {
            if (pendientes.grupos![m].nombre == asignacion.get(campo2)) {
              if (!pendientes.grupos![m].asignacion!.contains(asignacion)) {
                pendientes.grupos![m].asignacion!.add(asignacion);
              }
            }
          }
        } else {
          pendientes.grupos!.add(Resumen(
            nombre: asignacion.get(campo2),
            asignacion: [asignacion],
            selected: false,
          ));
        }
        // print(['ojo grupos', consulta.length, pendientes.grupos!.length]);
        break;
      default:
    }
  }

  /* Future<ResumenAsignacionT> areasPendientes() async {
    for (var i = 0; i < asignaciones.length; i++) {
      var lista =
          estudiantes.where((e) => (e.grupo == asignaciones[i].grupo)).toList();
      if (lista.isNotEmpty) {
        for (var estudiante in lista) {
          if (_resumen.areas!.contains(asignaciones[i])) break;
          if (estudiante.calificaciones != null) {
            var cal = estudiante.calificaciones!.xArea(asignaciones[i].area);
            if (cal == 'propery not found') {
              resumen.areas!.add(asignaciones[i]);
            }
          } else {
            resumen.areas!.add(asignaciones[i]);
          }
        }
      }
    }
    return _resumen;
  } */

  /* Future<List<AsignacionT>> docentesPendientes() async {
    List<AsignacionT> pendientes = [];
    for (var i = 0; i < asignaciones.length; i++) {
      var grupo = asignaciones[i].grupo;
      var area = asignaciones[i].area;
      var docente = asignaciones[i].docente;
      var lista = estudiantes.where((e) => (e.grupo == grupo)).toList();
      if (lista.isNotEmpty) {
        for (var estudiante in lista) {
          if (pendientes.contains(asignaciones[i])) break;
          if (estudiante.calificaciones != null) {
            var cal = estudiante.calificaciones!.xArea(area);
            if (cal == 'propery not found') {
              pendientes.add(asignaciones[i]);
            }
          } else {
            pendientes.add(asignaciones[i]);
          }
        }
      }
    }
    return pendientes;
  } */

  List<AsigxArea> getAreas() {
    List<String> areas = [];
    List<AsigxArea> asigAreas = [];
    if (asignaciones.isNotEmpty) {
      for (var i = 0; i < asignaciones.length; i++) {
        var area = asignaciones[i].area;
        var aa = asigAreas.where((a) => (a.area == area)).toList();
        if (!areas.contains(area)) {
          areas.add(area);
          asigAreas.add(AsigxArea(
            area: asignaciones[i].area,
            asGrupos: [
              AsigxGrupo(
                grupo: asignaciones[i].grupo,
                ih: asignaciones[i].ih,
              )
            ],
          ));
        } else if (aa.isNotEmpty) {
          var indexA = asigAreas.indexOf(aa[0]);
          asigAreas[indexA].asGrupos!.add(AsigxGrupo(
                grupo: asignaciones[i].grupo,
                ih: asignaciones[i].ih,
              ));
        }
      }
    }
    return asigAreas;
  }

  dynamic getArea(String area) {
    if (asignaciones.isNotEmpty) {
      for (var i = 0; i < asignaciones.length; i++) {
        if (asignaciones[i].area.contains(area)) {
          return asignaciones[i];
        }
      }
    }
    throw ArgumentError('propery not found');
  }
}

class Docente {
  String? nombres;
  String? apellidos;
  String? nombre;
  String? sede;
  int? cedula;
  Asignacion? asignacion;
  Asignaciones? asignaciones;

  Docente({
    this.nombres,
    this.apellidos,
    this.nombre,
    this.sede,
    this.cedula,
    this.asignacion,
    this.asignaciones,
  });

  Docente.fromJson(Map<dynamic, dynamic> json) {
    nombre = (json['nombre'] != null)
        ? json['nombre']
        : (json['nombres'] != null)
            ? (json['apellidos'] != null)
                ? (json['nombres'] + ' ' + json['apellidos'])
                : json['nombres']
            : 'No tiene';
    nombres = (json['nombres'] != null) ? json['nombres'] : 'No tiene';
    apellidos = (json['apellidos'] != null) ? json['apellidos'] : 'No tiene';
    sede = (json['sede'] != null) ? json['sede'] : 'No tiene';
    cedula = (json['cedula'] != null) ? json['cedula'] : 0;
    asignacion = (json['asignacion'] != null)
        ? Asignacion.fromJson(json['asignacion'])
        : null;
    asignaciones = (json['asignaciones'] != null)
        ? Asignaciones.fromJson(json['asignaciones'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (nombres != null) {
      data['nombres'] = nombres;
    }
    if (apellidos != null) {
      data['apellidos'] = apellidos;
    }
    if (sede != null) {
      data['sede'] = sede;
    }
    if (cedula != null) {
      data['cedula'] = cedula;
    }
    if (asignacion != null) {
      Asignacion? a = asignacion;
      data['asignacion'] = a!.toJson();
    }
    if (asignaciones != null) {
      Asignaciones? a = asignaciones;
      data['asignaciones'] = a!.toJson();
    }
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Calificacion {
  late String docente;
  late String area;
  late DateTime fecha;
  late double nota;
  int? periodo;
  String? actividad;
  List<String>? logros;

  Calificacion({
    required this.docente,
    required this.area,
    required this.fecha,
    required this.nota,
    this.periodo,
    this.actividad,
    this.logros,
  });

  Calificacion.fromJson(Map<dynamic, dynamic> json) {
    try {
      docente = (json['docente'] != null) ? json['docente'] : 'No tiene';
      area = (json['area'] != null) ? json['area'] : 'No tiene';
      nota = (json['nota'] != null) ? json['nota'].toDouble() : 0;
      fecha = (json['fecha'] != null)
          ? DateTime.parse(json['fecha'])
          : DateTime.now();
      actividad = (json['actividad'] != null) ? json['actividad'] : 'No tiene';
      periodo = (json['periodo'] != null) ? json['periodo'] : 1;
      logros = (json['logros'] != null) ? json['logros'] : ['No tiene'];
    } catch (e) {
      print(['Error en modelo Calificacion', e, json]);
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['docente'] = docente;
    data['area'] = area;
    data['fecha'] = fecha.toIso8601String();
    data['nota'] = nota;
    if (periodo != null) {
      data['periodo'] = periodo;
    }
    if (actividad != null) {
      data['actividad'] = actividad;
    }
    if (logros != null) {
      data['logros'] = logros;
    }
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Calificaciones {
  List<Calificacion>? lista;
  Calificaciones({
    this.lista,
  });

  Calificaciones.fromJson(Map<dynamic, dynamic> json) {
    try {
      // calificacion =
      //     (json['calificacion'] != null) ? json['calificacion'] : null;
      if (json['lista'] != null) {
        var a = json['lista'];
        lista = <Calificacion>[];
        for (var i = 0; i < a.length; i++) {
          lista!.add(Calificacion.fromJson(a[i]));
        }
      } else {
        lista = <Calificacion>[];
      }
    } catch (e) {
      print(['Error en modelo Calificaciones', e, json]);
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (lista != null) {
      data['lista'] = [];
      for (var c in lista!) {
        data['lista'].add(c.toJson());
      }
    }
    return data;
  }

  dynamic notaFinal() {
    double notaFinal = 0;
    double p = 0;
    if (lista!.isNotEmpty) {
      for (var i = 0; i < lista!.length; i++) {
        notaFinal += lista![i].nota;
      }
      p = notaFinal / lista!.length;
    }
    return p;
  }

  notasByProperty(String propiedad,
      [String? docente,
      String? area,
      DateTime? fecha,
      double? nota,
      int? periodo,
      String? actividad]) {
    if (lista != null) {
      if (lista!.isNotEmpty) {
        for (var i = 0; i < lista!.length; i++) {
          bool test = false;
          switch (propiedad) {
            case 'docente':
              test = lista![i].docente.contains(docente!);
              break;
            case 'area':
              test = lista![i].area.contains(area!);
              break;
            case 'fecha':
              test = lista![i].fecha == fecha!;
              break;
            case 'nota':
              test = lista![i].nota == nota!;
              break;
            case 'periodo':
              test =
                  lista![i].periodo!.toString().contains(periodo!.toString());
              break;
            case 'actividad':
              test = lista![i].actividad!.contains(actividad!);
              break;
            default:
          }
          if (test) {
            return lista![i];
          }
        }
      }
    }
    return 'propery not found';
  }

  xArea(String area) {
    if (lista != null) {
      if (lista!.isNotEmpty) {
        for (var i = 0; i < lista!.length; i++) {
          if (lista![i].area.contains(area)) {
            return lista![i];
          }
        }
      }
    }
    return 'propery not found';
  }

  Calificacion xDocente(String docente) {
    List<Calificacion> c = [];
    if (lista!.isNotEmpty) {
      for (var i = 0; i < lista!.length; i++) {
        if (lista![i].docente.contains(docente)) {
          c.add(lista![i]);
        }
      }
    }
    throw ArgumentError('propery not found');
  }
}

class Estudiante {
  String? nombre;
  String? nombre1;
  String? apellido1;
  String? nombre2;
  String? apellido2;
  String? nombres;
  String? apellidos;
  String? doc;
  String? tipodoc;
  String? userId;
  String? email;
  String? photo;
  String? sede;
  String? jornada;
  String? grupo;
  String? grado;
  int? gradoCod;
  String? courseId;
  // Profile? profile;
  int? index;
  bool? selected;
  bool? editado;
  // List?<Clase> cursos;
  Calificaciones? calificaciones;

  Estudiante({
    this.nombre,
    this.nombres,
    this.nombre1,
    this.nombre2,
    this.apellidos,
    this.apellido1,
    this.apellido2,
    this.doc,
    this.tipodoc,
    this.sede,
    this.jornada,
    this.grupo,
    this.grado,
    this.gradoCod,
    this.email,
    this.userId,
    this.photo,
    this.index,
    this.selected,
    this.editado,
    this.courseId,
    // this.cursos,
    // this.profile,
    this.calificaciones,
  });

  // verifica todas sus calificaciones
  Future<int> allCalifications() async {
    int ok = 0;
    var planE =
        asigTotal.asignaciones.where((a) => (a.grupo == grupo)).toList();
    for (var a in planE) {
      var notas =
          calificaciones!.lista!.where((c) => (c.area == a.area)).toList();
      if (notas.isNotEmpty) {
        ok += 1;
      }
    }
    return ok;
  }
  //

  Estudiante.fromJson(Map<dynamic, dynamic> json) {
    try {
      apellido1 = (json['apellido1'] != null) ? json['apellido1'] : 'No tiene';
      apellido2 = (json['apellido2'] != null) ? json['apellido2'] : 'No tiene';
      nombre1 = (json['nombre1'] != null) ? json['nombre1'] : 'No tiene';
      nombre2 = (json['nombre2'] != null) ? json['nombre2'] : 'No tiene';
      nombres = (json['nombres'] != null) ? json['nombres'] : 'No tiene';
      apellidos = (json['apellidos'] != null) ? json['apellidos'] : 'No tiene';
      doc = (json['doc'] != null) ? json['doc'] : 'No tiene';
      tipodoc = (json['tipodoc'] != null) ? json['tipodoc'] : 'No tiene';
      sede = (json['sede'] != null) ? json['sede'] : 'No tiene';
      jornada = (json['jornada'] != null) ? json['jornada'] : 'No tiene';
      grupo = (json['grupo'] != null) ? json['grupo'] : 'No tiene';
      gradoCod = (json['gradoCod'] != null) ? json['gradoCod'].toInt() : -1;
      grado = (json['gradoCod'] != null)
          ? grados
              .firstWhere((g) => g.codigo == json['gradoCod'].toInt())
              .nombre
          : 'No tiene';
      email = (json['email'] != null) ? json['email'] : 'No tiene';
      index = (json['index'] != null) ? json['index'] : 0;
      selected = (json['selected'] != null) ? json['selected'] : false;
      editado = (json['editado'] != null) ? json['editado'] : false;
      calificaciones = (json['calificaciones'] != null)
          ? Calificaciones.fromJson(json['calificaciones'])
          : null;
    } catch (e) {
      print(['Error en modelo Estudiante', e, json]);
    }
  }

  Estudiante.fromSIMAT(List<dynamic> json) {
    String sedet = '';
    switch (json[8]) {
      case 'INSTITUCIÀN ETNOEDUCATIVA RURAL INTERNADO DE NAZARETH':
        sedet = 'principal';
        break;
      case 'ESC DE SANTA ROSA':
        sedet = 'Esc De Santa Rosa';
        break;
      case 'GUARERPA':
        sedet = 'Guarerpa';
        break;
      case 'ESC. DE SIPANAO':
        sedet = 'Esc. De Sipanao';
        break;
      case 'TOROMANA':
        sedet = 'Toromana';
        break;
      case 'SIERRA MAESTRA':
        sedet = 'Sierra Maestra';
        break;
      case 'JASARIRU':
        sedet = 'Jasariru';
        break;
      case 'SANTA CRUZ':
        sedet = 'Santa cruz';
        break;
      case 'IYULIWOU':
        sedet = 'Iyuliwou';
        break;
      case 'MONTERREY':
        sedet = 'Monterrey';
        break;
      default:
        break;
    }
    try {
      apellido1 = (json[25] != null) ? json[25] : 'No tiene';
      apellido2 = (json[26] != null) ? json[26] : 'No tiene';
      nombre1 = (json[27] != null) ? json[27] : 'No tiene';
      nombre2 = (json[28] != null) ? json[28] : 'No tiene';
      nombres = (json[27] != null)
          ? (json[28] != null)
              ? json[27] + ' ' + json[28]
              : json[27]
          : 'No tiene';
      apellidos = (json[25] != null)
          ? (json[26] != null)
              ? json[25] + ' ' + json[26]
              : json[25]
          : 'No tiene';
      doc = (json[23] != null) ? json[23].toString() : 'No tiene';
      tipodoc = (json[24] != null)
          ? json[24].toString().substring(
              json[24].toString().indexOf(':') + 1, json[24].toString().length)
          : 'No tiene';
      sede = sedet;
      jornada = (json[12] != null) ? json[12] : 'No tiene';
      grupo = (json[14] != null) ? json[14] : 'No tiene';
      gradoCod = (json[13] != null) ? json[13].toInt() : -1;
      grado = (json[13] != null)
          ? grados.firstWhere((g) => g.codigo == json[13].toInt()).nombre
          : 'No tiene';
      email = (json[42] != null) ? json[42] : 'No tiene';
      index = 0;
      selected = false;
      editado = false;
    } catch (e) {
      // print(['Error en modelo Estudiante.fromSIMAT', e, json.toList()]);
      print([
        'Error en modelo Estudiante.fromSIMAT',
        e,
        json[7 + 1],
        json[11 + 1],
        json[12 + 1],
        json[13 + 1],
        json[22 + 1],
        json[23 + 1],
        json[24 + 1],
        json[25 + 1],
        json[26 + 1],
        json[27 + 1],
        json[41 + 1],
      ]);
    }
  }

  Estudiante.fromClassroom(Map<dynamic, dynamic> json) {
    try {
      nombre = json["profile"]["name"]["fullName"];
      nombres = json["profile"]["name"]["givenName"];
      apellidos = json["profile"]["name"]["familyName"];
      email = json["profile"]['emailAddress'];
      photo = json["profile"]['photoUrl'];
      courseId = json['courseId'];
      userId = json['userId'];
      //=profile: Profile.fromClassroom(json['profile']);
      index = 0;
      selected = false;
      editado = false;
    } catch (e) {
      print(['Error en modelo', e, json]);
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (nombre != null) {
      data['nombre'] = nombre;
    }
    if (nombres != null) {
      data['nombres'] = nombres;
    }
    if (nombre1 != null) {
      data['nombre1'] = nombre1;
    }
    if (nombre2 != null) {
      data['nombre2'] = nombre2;
    }
    if (apellidos != null) {
      data['apellidos'] = apellidos;
    }
    if (apellido1 != null) {
      data['apellido1'] = apellido1;
    }
    if (apellido2 != null) {
      data['apellido2'] = apellido2;
    }
    if (doc != null) {
      data['doc'] = doc;
    }
    if (tipodoc != null) {
      data['tipodoc'] = tipodoc;
    }
    if (sede != null) {
      data['sede'] = sede;
    }
    if (jornada != null) {
      data['jornada'] = jornada;
    }
    if (grupo != null) {
      data['grupo'] = grupo;
    }
    if (grado != null) {
      data['grado'] = grado;
    }
    if (gradoCod != null) {
      data['gradoCod'] = gradoCod;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (userId != null) {
      data['userId'] = userId;
    }
    if (photo != null) {
      data['photo'] = photo;
    }
    if (index != null) {
      data['index'] = index;
    }
    if (selected != null) {
      data['selected'] = selected;
    }
    if (editado != null) {
      data['editado'] = editado;
    }
    if (courseId != null) {
      data['courseId'] = courseId;
    }
    if (calificaciones != null) {
      Calificaciones c = calificaciones!;
      data['calificaciones'] = c.toJson();
    }
    return data;
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class Sede {
  String? nombre;
  String? refSimat;
  List<String>? codGrupo;
  String? encargado;
  String? telefono;
  String? email;
  String? referencia;

  Sede({
    this.nombre,
    this.refSimat,
    this.codGrupo,
    this.encargado,
    this.telefono,
    this.email,
    this.referencia,
  });

  Sede.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'];
    refSimat = json['refSimat'];
    codGrupo = json['codGrupo'];
    encargado = json['encargado'];
    telefono = json['telefono'];
    email = json['email'];
    referencia = json['referencia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['refSimat'] = refSimat;
    data['codGrupo'] = codGrupo;
    data['encargado'] = encargado;
    data['telefono'] = telefono;
    data['email'] = email;
    data['referencia'] = referencia;
    return data;
  }
}

class DashboardCard {
  String? area;
  String? docente;
  String? sede;
  String? grado;
  List<String>? grupos;
  List<AsignacionT>? asignaciones;
  late bool selected;

  DashboardCard({
    this.area,
    this.docente,
    this.sede,
    this.grado,
    this.grupos,
    this.asignaciones,
    required this.selected,
  });

  DashboardCard.fromJson(Map<dynamic, dynamic> json) {
    area = (json['area'] != null) ? json['area'] : 'No tiene';
    docente = (json['docente'] != null) ? json['docente'] : 'No tiene';
    sede = (json['sede'] != null) ? json['sede'] : 'No tiene';
    grado = (json['grado'] != null) ? json['grado'] : 'No tiene';
    grupos = (json['grupos'] != null) ? json['grupos'] : 'No tiene';
    asignaciones =
        (json['asignaciones'] != null) ? json['asignaciones'] : 'No tiene';
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (area != null) {
      data['area'] = area;
    }
    if (docente != null) {
      data['docente'] = docente;
    }
    if (sede != null) {
      data['sede'] = sede;
    }
    if (grado != null) {
      data['grado'] = grado;
    }
    if (grupos != null) {
      data['grupos'] = grupos;
    }
    if (asignaciones != null) {
      data['asignaciones'] = [];
      for (var e in asignaciones!) {
        data['asignaciones'].add(e.toJson());
      }
    }
    return data;
  }
}

class MenuElement {
  String? titulo;
  Icon? icono;
  bool? activo;

  MenuElement({
    this.titulo,
    this.icono,
    this.activo,
  });

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    if (titulo != null) {
      data['titulo'] = titulo;
    }
    if (icono != null) {
      data['icono'] = icono;
    }
    if (activo != null) {
      data['activo'] = activo;
    }
    return data;
  }
}

List<MenuElement> menus = [
  MenuElement(
    icono: const Icon(
      Icons.assessment,
      color: Colors.white,
      size: 30,
    ),
    titulo: 'Home',
    activo: false,
  ),
  MenuElement(
    icono: const Icon(
      Icons.library_books,
      color: Colors.white,
      size: 30,
    ),
    titulo: 'Boletines',
    activo: false,
  ),
  MenuElement(
    icono: const Icon(
      Icons.addchart,
      color: Colors.white,
      size: 30,
    ),
    titulo: 'Configuración',
    activo: false,
  ),
  MenuElement(
    icono: const Icon(
      Icons.chrome_reader_mode,
      color: Colors.white,
      size: 30,
    ),
    titulo: 'One-line with leading widget',
    activo: false,
  ),
];
