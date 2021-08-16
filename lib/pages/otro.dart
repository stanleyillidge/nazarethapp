import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/excel_admin.dart';
import 'package:nazarethapp/widgets/models.dart';
import 'package:nazarethapp/widgets/pdf_admin.dart';

class OtroPage extends StatefulWidget {
  const OtroPage({Key? key}) : super(key: key);

  @override
  _OtroPageState createState() => _OtroPageState();
}

class _OtroPageState extends State<OtroPage> {
  /* init() async {
    areas = [];
    grados = [];
    estudiantes = [];
    docentes = [];
    asigTotal.asignaciones = [];
    var path = Directory.current.path;
    Hive.init(path);
    DateTime now = DateTime.now();
    storage = await Hive.openBox(now.year.toString());
    await carga('Areas');
    await carga('Grados');
    await carga('Estudiantes');
    await carga('Docentes');
    await carga('Asignaciones');
    var listaA = [];
    areas.forEach((e) {
      listaA.add(e.toJson());
    });
    var listaG = [];
    grados.forEach((gg) {
      listaG.add(gg.toJson());
    });
    var listaE = [];
    estudiantes.forEach((gg) {
      listaE.add(gg.toJson());
    });
    var listaD = [];
    docentes.forEach((d) {
      listaD.add(d.toJson());
    });
    var listaAsig = [];
    asigTotal.asignaciones.forEach((asg) {
      listaAsig.add(asg.toJson());
    });
    print(['Grados', listaG.length]);
    print(['Areas', listaA.length]);
    print(['Estudiantes', listaE.length]);
    print(['Docentes', listaD.length]);
    print(['Asignaciones', listaAsig.length]);
  }

  carga(a) async {
    List? g = await storage.get(a);
    if (g != null) {
      for (var i = 0; i < g.length; i++) {
        setState(() {
          // print([a, 'cargada', g[i]]);
          if (a == 'Areas') areas.add(Area.fromJson(g[i]));
          if (a == 'Grados') grados.add(Grado.fromJson(g[i]));
          if (a == 'Estudiantes') estudiantes.add(Estudiante.fromJson(g[i]));
          if (a == 'Docentes') docentes.add(Docente.fromJson(g[i]));
          if (a == 'Asignaciones')
            asigTotal.asignaciones.add(AsignacionT.fromJson(g[i]));
        });
      }
    }
  } */

  @override
  void initState() {
    cargaTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ButtonStyle style =
    //     ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20));
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              // style: style,
              onPressed: () async {
                await generateBoletin();
              },
              child: const Text('Crea PDF'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              // style: style,
              onPressed: () async {
                await openFile(context);
                setState(() {
                  estudiantes = estudiantes;
                  asigTotal.asignaciones = asigTotal.asignaciones;
                });
              },
              child: const Text('Carga xlsx'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              // style: style,
              onPressed: () {
                creaFile(context);
                // _creaFile2();
                // _creaFile3();
                // generateExcel();
              },
              child: const Text('Crea xlsx'),
            ),
          ],
        ),
      ),
    );
  }
}
