// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:path/path.dart';
// import 'package:excel/excel.dart';
// import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
// import 'package:hive/hive.dart';
import 'models.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsx;

Directory? rootPath;
String? filePath;
String? dirPath;

Future<void> _ErrorDialog(
    BuildContext context, String titulo, List<Widget> body) async {
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
}

Future<void> openFile(BuildContext context) async {
  final _file = OpenFilePicker()
    ..filterSpecification = {
      'Excel (*.xlsx)': '*.xlsx',
      // 'Word Document (*.doc)': '*.doc',
      // 'Wordx Document (*.docx)': '*.docx',
      // 'Web Page (*.htm; *.html)': '*.htm;*.html',
      // 'Text Document (*.txt)': '*.txt',
      // 'All Files': '*.*'
    }
    ..defaultFilterIndex = 1
    ..defaultExtension = 'xlsx'
    ..title = 'Select a document';

  final result = _file.getFile();
  if (result != null) {
    print(result.path);
    String path = result.path;
    String ext = result.path.substring(result.path.indexOf('.'));
    print(['_file.defaultExtension', ext]);
    if (ext == '.txt') {
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text(contents)));
    } else if (ext == '.xlsx') {
      print(['_excelFile', path]);
      await excelFile(context, path);
    }
    // setState(() {
    filePath = path;
    // });
  }
}

excelFile(BuildContext context, String path) async {
  try {} catch (e) {
    print(['Error2', e, path]);
    _ErrorDialog(context, 'Error2', [Text(e.toString())]);
  }
  // try {
  var bytes = File(path).readAsBytesSync();
  var libro = SpreadsheetDecoder.decodeBytes(bytes, update: true);
  for (var hoja in libro.tables.keys) {
    if (hoja == 'Planilla') {
      try {
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        // var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        var sede = rows[1][1].toString();
        var docente = rows[2][1].toString();
        var area = rows[3][1].toString();
        var grupo = rows[4][1].toString();
        var logro1 = rows[1][3].toString();
        var logro2 = rows[2][3].toString();
        var logro3 = rows[3][3].toString();
        var periodo = int.parse(rows[4][3].toString());
        var codGrado =
            (grupo.length >= 2) ? grupo.substring(0, 1) : grupo.substring(0);
        var lista = estudiantes
            .where((e) =>
                ((e.sede!.toUpperCase() == sede.toString().toUpperCase()) &&
                    (e.grupo == grupo)))
            .toList();
        lista.sort((a, b) {
          return a.apellidos!
              .toLowerCase()
              .compareTo(b.apellidos!.toLowerCase());
        });
        // print([
        //   grupo.length,
        //   grupo,
        //   codGrado,
        //   grupo.substring(0, 1),
        //   grupo.substring(0),
        //   'lista',
        //   lista.length
        // ]);
        var logrosfile =
            'data/flutter_assets/assets/logros.xlsx'; //'assets/logros.xlsx';
        var logrosbytes = File(logrosfile).readAsBytesSync();
        var logrosDB =
            SpreadsheetDecoder.decodeBytes(logrosbytes, update: false);
        var lsheet = logrosDB.tables['LOGROS'];
        // var lcount = lsheet!.rows.length;
        var clogros = lsheet!.rows
            .where((l) =>
                ((area.toUpperCase().contains(l[3].toString().toUpperCase())) &&
                    (l[2].toString() == codGrado)))
            .toList();
        // print(['clogros', logro1, logro2, logro3, clogros]);
        logros = [];
        for (var j = clogros.length - 1; j >= 0; j--) {
          // libro.updateCell('Logros', 0, j, clogros[j][1].toString());
          logros.add(Logro(
            logro: clogros[j][1].toString(),
            codGrado: clogros[j][2].toString(),
            area: clogros[j][3].toString(),
            periodo: clogros[j][4].toString(),
            sede: clogros[j][5].toString(),
            dflogro: clogros[j][9].toString(),
          ));
        }
        bool estado = true;
        for (var i = 0; i < lista.length; i++) {
          var n0 = rows[i + 7][1]; // nombre en la hoja de calculo
          var n1 =
              lista[i].apellidos! + ' ' + lista[i].nombres!; // nombre en la BD
          List<Nota> notas = [];
          notas.add((rows[i + 7][3] != '')
              ? Nota(nota: rows[i + 7][3] + 0.0, criterio: esfuerzo)
              : Nota(nota: 0, criterio: esfuerzo));
          notas.add((rows[i + 7][4] != '')
              ? Nota(nota: rows[i + 7][4] + 0.0, criterio: actitud)
              : Nota(nota: 0, criterio: actitud));
          notas.add((rows[i + 7][5] != '')
              ? Nota(nota: rows[i + 7][5] + 0.0, criterio: creatividad)
              : Nota(nota: 0, criterio: creatividad));
          var notat = (notas[0].nota! != 0) &&
              (notas[1].nota! != 0) &&
              (notas[2].nota! != 0);
          estado =
              ((notat) && (n0 == n1)) ? (estado && true) : (estado && false);
          // var index = estudiantes.indexOf(lista[i]);
          // print(['estado', n1, estado]);
          for (var j = 0; j < notas.length; j++) {
            if (n0 == n1) {
              List<String> logrosf = [];
              for (var j = 0; j < logros.length; j++) {
                if (await logroNota(j, logro1, notas[j].nota!) != null) {
                  logrosf.add(await logroNota(j, logro1, notas[j].nota!));
                } else if (await logroNota(j, logro2, notas[j].nota!) != null) {
                  logrosf.add(await logroNota(j, logro2, notas[j].nota!));
                } else if (await logroNota(j, logro3, notas[j].nota!) != null) {
                  logrosf.add(await logroNota(j, logro3, notas[j].nota!));
                }
              }
              var ie = estudiantes.indexOf(lista[i]);
              var rta = calificaciones
                  .where((c) =>
                      (c.estudianteId == estudiantes[ie].userId!) &&
                      (c.docente == docente) &&
                      (c.grupo == grupo) &&
                      (c.codGrado == codGrado) &&
                      (c.area == area) &&
                      (c.periodo == periodo) &&
                      (c.criterio.nombre == notas[j].criterio!.nombre))
                  .toList();
              // la calificaci??n existe?
              actualizaCalificacion(
                docente,
                estudiantes[ie].userId!,
                docente,
                grupo,
                codGrado,
                area,
                notas[j].criterio!,
                notas[j].nota!,
                logrosf,
                periodo,
                rta,
                'c',
              );
              // consulto todas las calificaciones
              var cals = calificaciones
                  .where((c) =>
                      (c.estudianteId == estudiantes[ie].userId!) &&
                      (c.docente == docente) &&
                      (c.grupo == grupo) &&
                      (c.codGrado == codGrado) &&
                      (c.area == area) &&
                      (c.periodo == periodo))
                  .toList();
              // creo la calificacion final y la a??ado!
              double notafinal = notaFinal(cals);
              rta = calificacionesFinales
                  .where((c) =>
                      (c.estudianteId == estudiantes[ie].userId!) &&
                      (c.docente == docente) &&
                      (c.grupo == grupo) &&
                      (c.codGrado == codGrado) &&
                      (c.area == area) &&
                      (c.periodo == periodo))
                  .toList();
              actualizaCalificacion(
                docente,
                estudiantes[ie].userId!,
                docente,
                grupo,
                codGrado,
                area,
                nFinal,
                notafinal,
                logrosf,
                periodo,
                rta,
                'f',
              );
            }
          }
        }
        var listaC = [];
        for (var cx in calificaciones) {
          listaC.add(cx.toJson());
        }
        await calificacionesStorage.put('Calificaciones', listaC);
        // print('Calificaciones guardadas',listaC);
        var listaCf = [];
        for (var cx in calificacionesFinales) {
          listaCf.add(cx.toJson());
        }
        await storage.put('Calificaciones', listaCf);
        // print('Calificaciones finales guardadas',listaCf);
        asigTotal.asignaciones =
            await actualizarPendientes(sede, area, docente, grupo, estado);
        var listaAsig = [];
        for (var asg in asigTotal.asignaciones) {
          listaAsig.add(asg.toJson());
        }
        await storage.put('Asignaciones', listaAsig);
        // print('Asignaciones guardadas');
      } catch (e) {
        print(['Error en Planillas', e, path]);
        _ErrorDialog(context, 'Error en Planillas', [Text(e.toString())]);
      }
    }
    if (hoja == 'LOGROS') {
      try {
        // logros = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        for (var i = 1; i < count; i++) {
          try {
            var logroC =
                logros.indexWhere((g) => g.logro == rows[i][1].toString());
            // print(['logroC', logroC, logros.length]);
            Logro logro = Logro(
              logro: rows[i][1].toString(),
              codGrado: rows[i][2].toString(),
              area: rows[i][3].toString(),
              periodo: rows[i][4].toString(),
              sede: rows[i][5].toString(),
              dflogro: rows[i][9].toString(),
            );
            if (logroC == -1) {
              //value not exists
              // print(['logro no existe', logro.toJson()]);
              logros.add(logro);
            } else {
              //value exists
              // print(['logro existe', logroC, logros.length]);
              logros[logroC] = logro;
            }
          } catch (e) {
            print(['Error en LOGROS - ForIn', e, rows[i], path]);
            // _ErrorDialog(context, 'LOGROS - ForIn',
            //     [Text(e.toString()), Text(rows[i].toString())]);
          }
        }
        var listaS = [];
        for (var gg in logros) {
          listaS.add(gg.toJson());
        }
        // print(['Lista a ser guardada', lista]);
        await storage.put('Logros', listaS);
      } catch (e) {
        print(['Error en LOGROS', e, path]);
        // _ErrorDialog(context, 'Error en LOGROS', [Text(e.toString())]);
      }
    }
    if (hoja == 'SEDES') {
      try {
        sedes = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        for (var i = 1; i < count; i++) {
          var sedeC = sedes.where((g) => g.nombre == rows[i][0]).toList();
          var codGrupos = rows[i][2].toString().split(',').toList();
          // print(['sedeC', sedeC]);
          Sede sede = Sede(
            nombre: rows[i][0].toString(),
            refSimat: rows[i][1].toString(),
            codGrupo: codGrupos,
            encargado: rows[i][3].toString(),
            telefono: rows[i][4].toString(),
            email: rows[i][5].toString(),
            referencia: rows[i][6].toString(),
          );
          if (sedeC.isEmpty) {
            //value not exists
            sedes.add(sede);
            print(['sede no existe', sede]);
          } else {
            //value exists
            var indexG = sedes.indexOf(sedeC[0]);
            sedes[indexG] = sede;
          }
          var listaS = [];
          for (var gg in sedes) {
            listaS.add(gg.toJson());
          }
          // print(['Lista a ser guardada', lista]);
          await storage.put('Sedes', listaS);
        }
      } catch (e) {
        print(['Error en SEDES', e, path]);
        _ErrorDialog(context, 'Error en SEDES', [Text(e.toString())]);
      }
    }
    if (hoja == 'GRADOS') {
      try {
        grados = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        for (var i = 1; i < count; i++) {
          var gradoC = grados.where((g) => g.nombre == rows[i][0]).toList();
          // print(['GradoC', gradoC]);
          Grado grado;
          if (gradoC.isEmpty) {
            //value not exists
            grado = Grado(
              nombre: rows[i][0].toString().toUpperCase(),
              codigo: rows[i][1].toInt(),
              grupos: [],
              activo: false,
            );
            grados.add(grado);
            print(['Grado no existe', grado]);
          } else {
            //value exists
            var indexG = grados.indexOf(gradoC[0]);
            grados[indexG].codigo = rows[i][1].toInt();
          }
          var listaG = [];
          for (var gg in grados) {
            listaG.add(gg.toJson());
          }
          // print(['Lista a ser guardada', lista]);
          await storage.put('Grados', listaG);
        }
      } catch (e) {
        print(['Error en GRADOS', e, path]);
        _ErrorDialog(context, 'Error en GRADOS', [Text(e.toString())]);
      }
    }
    if (hoja == 'AREAS') {
      try {
        areas = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var listaG = [];
        for (var gg in grados) {
          listaG.add(gg.toJson());
        }
        // print(['Grados', listaG]);
        // print(['areas', areas]);
        // for (var row in libro.tables[hoja]!.rows) {
        //   print('$row');
        // }
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        for (var i = 2; i < count; i++) {
          // print(['fila', rows[i], rows[i][0]]);
          var areaIt = areas.where((a) => a.nombre == rows[i][0]).toList();
          Area area;
          var indexA = 0;
          // print(['area', areaIt]);
          if (areaIt.isEmpty) {
            area = Area(
              activo: false,
              nombre: rows[i][0],
              porcentaje: 100,
              grados: [],
              asignaturas: [],
              planEstudio: [],
              ih: 0,
            );
            areas.add(area);
            // print(['indexG', indexG]);
          } else {
            area = areaIt[0];
            area.planEstudio ??= [];
          }
          indexA = areas.indexOf(area);
          for (var n = 1; n < rows[i].length; n++) {
            if (rows[i][n] != null) {
              var gradoC = grados
                  .where((g) => g.nombre == rows[0][n].toString().toUpperCase())
                  .toList();
              Grado grado;
              if (gradoC.isEmpty) {
                //value not exists
                grado = Grado(
                  nombre: rows[0][n].toString().toUpperCase(),
                  grupos: [],
                  activo: false,
                );
                grados.add(grado);
                print(['Grado A??adido', grado.toJson()]);
              } else {
                //value exists
                grado = gradoC[0];
                // var indexG = grados.indexOf(grado);
                // print(['indexG', indexG]);
                // print(['gradoC', gradoC]);
              }
              // print(['grado', grado.toJson()]);
              var ih = rows[i][n].toInt();
              var asig = AsigPlanEstudio(grado: grado, ih: ih);
              areas[indexA].planEstudio!.add(asig);
            }
          }
          // print(['area', area.toJson()]);
        }
        var listaA = [];
        listaG = [];
        for (var e in areas) {
          listaA.add(e.toJson());
        }
        for (var gg in grados) {
          listaG.add(gg.toJson());
        }
        // print(['Lista a ser guardada', lista]);
        await storage.put('Areas', listaA);
        await storage.put('Grados', listaG);
      } catch (e) {
        print(['Error en AREAS', e, path]);
        _ErrorDialog(context, 'Error en AREAS', [Text(e.toString())]);
      }
    }
    if (hoja == 'SIMAT') {
      try {
        estudiantes = [];
        grupos = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        for (var i = 2; i < count; i++) {
          Estudiante est = Estudiante.fromSIMAT(rows[i]);
          // est.gradoCod
          Grado gradoC = grados.firstWhere((grd) => grd.codigo == est.gradoCod);
          int gcIndex = grados.indexOf(gradoC);
          int gpcIndex = -1;
          var n = est.grupo;
          var grupoC = grupos
              .where((grp) => grp.nombre == est.grupo.toString().toUpperCase())
              .toList();
          try {
            if (grupos.isNotEmpty) {
              gpcIndex = (grupoC.isNotEmpty) ? grupos.indexOf(grupoC[0]) : -1;
            }
            if (est.grupo!.contains('ROS')) {
              n = 'J';
            } else if (est.grupo!.contains('SIP')) {
              n = 'I';
            } else if (est.grupo!.contains('GRPA')) {
              n = 'E';
            } else if (est.grupo!.contains('IYWO')) {
              n = 'H';
            } else if (est.grupo!.contains('JASA')) {
              n = 'K';
            } else if (est.grupo!.contains('MTRY')) {
              n = 'D';
            } else if (est.grupo!.contains('SCRZ')) {
              n = 'G';
            } else if (est.grupo!.contains('SMTR')) {
              n = 'C';
            } else if (est.grupo!.contains('TRMN')) {
              n = 'F';
            }
            if (n!.length == 1) {
              n = est.gradoCod.toString() + n;
            }
            var cc = grados[gcIndex].grupos!.where((grp) => grp.nombre == n);
            var ss = (est.sede == 'principal')
                ? 'Instituci??n Etnoeducativa Rural Internado De Nazareth'
                : est.sede;
            Sede se = sedes.firstWhere((s) => s.nombre == ss);
            Grupo gr = Grupo(
              nombre: n.toString().toUpperCase(),
              activo: false,
              sede: se,
            );
            // print(['Sede del grupo', n, se.nombre]);
            if (cc.isEmpty) {
              grados[gcIndex].grupos!.add(gr);
            }
            // print([i, 'gpcIndex', n, gpcIndex, gr.toJson()]);
            est.grupo = n.toString().toUpperCase();
            estudiantes.add(est);
            if (gpcIndex == -1) {
              grupos.add(gr);
            }
            // print(['Estudiante', est.toJson()]);
          } catch (e) {
            // print(['Error en SIMAT - ForIn', e, i, gpcIndex, grupoC]);
            // est.toJson()
            _ErrorDialog(
                context, 'Error en SIMAT - ForIn', [Text(e.toString())]);
          }
        }
        var listaE = [];
        for (var gg in estudiantes) {
          listaE.add(gg.toJson());
        }
        var listaG = [];
        for (var gg in grados) {
          listaG.add(gg.toJson());
        }
        var listaGp = [];
        for (var gp in grupos) {
          listaGp.add(gp.toJson());
        }
        await storage.put('Grados', listaG);
        await storage.put('Grupos', listaGp);
        await storage.put('Estudiantes', listaE);
        print(['Estudiantes', listaE.length]);
        print(['Grupos', listaGp.length]);
        // print(['Estudiante', Estudiante.fromSIMAT(rows[20]).toJson()]);
      } catch (e) {
        print(['Error en SIMAT', e, path]);
        _ErrorDialog(context, 'Error en SIMAT', [Text(e.toString())]);
      }
    }
    // Asignaciones academicas
    if (hoja == 'BACHILLERATO') {
      try {
        // docentes = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        var nombre;
        int finGrupos = rows[0].indexOf('HORAS X AREA');
        print(['finGrupos', finGrupos]);
        for (var i = 2; i < count; i++) {
          try {
            if (rows[i][2] != null) {
              nombre = rows[i][2];
            }
            Asignacion asign = Asignacion();
            asign.asigAreas = <AsigxArea>[];
            // asign.asigAreas!.asGrupos = <AsigxGrupo>[];
            var area;
            Docente docente = Docente();
            Grado? grado;
            var grupo;
            if (rows[i][4] != null) {
              asign.dirGrupo = rows[i][4];
            }
            if (rows[i][3] != null) {
              area = rows[i][3];
            }
            for (var j = 5; j < finGrupos; j++) {
              AsigxGrupo asiG = AsigxGrupo();
              // if (i == 2) {
              //   print(['Fila de', area, rows[i][j], rows[0][j], rows[1][j]]);
              // }
              try {
                if (rows[0][j] != null) {
                  grado = grados.firstWhere(
                      (g) => g.nombre == rows[0][j].toString().toUpperCase());
                  grupo = grado.grupos!
                      .firstWhere((grp) => grp.nombre!.contains(rows[1][j]))
                      .nombre;
                }
                if ((rows[i][j] != null) && (rows[i][3] != null)) {
                  grupo = grupo.substring(0, grupo.length - 1);
                  grupo = grupo + rows[1][j];
                  // if (i == 2) {
                  //   print(['Grupo ', grupo]);
                  // }
                  asiG.grupo = grupo;
                  asiG.ih = rows[i][j].toInt();
                  var ano = anos.firstWhere((ax) => ax.nombre == dropdownYear);
                  print(['Periodos', ano.periodos]);
                  for (var per in ano.periodos) {
                    var asigp = AsignacionT(
                      area: area,
                      docente: nombre,
                      grupo: grupo,
                      grado: grado!.nombre!,
                      periodo: per,
                      ih: rows[i][j].toInt(),
                      completa: false,
                      cargada: false,
                    );
                    var contain = asigTotal.asignaciones.where((at) =>
                        ((at.area == area) &&
                            (at.periodo == per) &&
                            (at.docente == nombre) &&
                            (at.grupo == grupo) &&
                            (at.grado == grado!.nombre!) &&
                            (at.ih == rows[i][j].toInt())));
                    if (contain.isEmpty) {
                      asigTotal.asignaciones.add(asigp);
                    }

                    var dc = docentes.where((d) => d.nombre == nombre).toList();
                    if (dc.isEmpty) {
                      Asignaciones aParcial =
                          Asignaciones(asignaciones: [asigp]);
                      asign.asigAreas!
                          .add(AsigxArea(area: area, asGrupos: [asiG]));
                      // asign.asigAreas!.area = area;
                      // asign.asigAreas!.asGrupos!.add(asiG);
                      docente = Docente(
                        nombre: nombre,
                        sede: 'principal',
                        apellidos: null,
                        nombres: null,
                        cedula: null,
                        asignacion: asign,
                        asignaciones: aParcial,
                      );
                      docentes.add(docente);
                      // if (i == 2) {
                      //   print(['Docente nuevo', docente.toJson()]);
                      // }
                      // print(['Docente nuevo', docente.toJson()]);
                    } else {
                      docente = dc[0];
                      int dcIndex = docentes.indexOf(docente);
                      docentes[dcIndex].sede = 'principal';
                      docentes[dcIndex].asignaciones!.asignaciones.add(asigp);
                      var ac = docentes[dcIndex]
                          .asignacion!
                          .asigAreas!
                          .where((a) => a.area == area)
                          .toList();
                      if (ac.isEmpty) {
                        docentes[dcIndex]
                            .asignacion!
                            .asigAreas!
                            .add(AsigxArea(area: area, asGrupos: [asiG]));
                      } else {
                        var aIndex = docentes[dcIndex]
                            .asignacion!
                            .asigAreas!
                            .indexOf(ac[0]);
                        var ag = docentes[dcIndex]
                            .asignacion!
                            .asigAreas![aIndex]
                            .asGrupos!
                            .where((_g) => _g.grupo == grupo)
                            .toList();
                        if (ag.isEmpty) {
                          docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos!
                              .add(asiG);
                        } else {
                          var gIndex = docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos!
                              .indexOf(ag[0]);
                          docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos![gIndex]
                              .ih = rows[i][j].toInt();
                        }
                      }
                      // if (i == 2) {
                      //   print(
                      //       ['Docente actualizado', docentes[dcIndex].toJson()]);
                      // }
                      // print(['Docente actualizado', docentes[dcIndex].toJson()]);
                    }
                  }
                }
              } catch (e) {
                print([
                  'Error1',
                  e,
                  'en Asig a grupo',
                  nombre,
                  area,
                  grado!.nombre,
                  grupo,
                  rows[i][j],
                  rows[0][j],
                  rows[1][j],
                  docente.toJson(),
                ]);
              }
            }
          } catch (e) {
            print([
              'Error0',
              e,
              'en Fila',
              rows[i],
              rows[i][2],
              rows[i][3],
              rows[i][4]
            ]);
          }
        }
        var listaD = [];
        for (var dd in docentes) {
          listaD.add(dd.toJson());
        }
        await storage.put('Docentes', listaD);
        var listaAsig = [];
        for (var asg in asigTotal.asignaciones) {
          listaAsig.add(asg.toJson());
        }
        await storage.put('Asignaciones', listaAsig);
        print(['Asignaciones', listaAsig.length]);
      } catch (e) {
        print(['Error en BACHILLERATO', e, path]);
        _ErrorDialog(context, 'Error en BACHILLERATO', [Text(e.toString())]);
      }
    }
    if ((hoja == 'SIERRA MAESTRA') ||
        (hoja == 'MONTERREY') ||
        (hoja == 'GUARERPA') ||
        (hoja == 'TOROMANA') ||
        (hoja == 'SANTA CRUZ') ||
        (hoja == 'IYULIWOU') ||
        (hoja == 'SIPANAO') ||
        (hoja == 'SANTA ROSA') ||
        (hoja == 'JASARIRU') ||
        (hoja == 'PRINCIPAL')) {
      try {
        // docentes = [];
        print(['Hoja', hoja]);
        // print(['maxCols', libro.tables[hoja]!.maxCols]);
        // print(['maxRows', libro.tables[hoja]!.maxRows]);
        var count = libro.tables[hoja]!.rows.length;
        var rows = libro.tables[hoja]!.rows;
        var nombre;
        int finGrupos = rows[0].indexOf('TOTAL HORAS POR DOCENTE');
        print(['finGrupos', finGrupos]);
        for (var i = 2; i < count; i++) {
          try {
            if (rows[i][2] != null) {
              nombre = rows[i][2];
            }
            Asignacion asign = Asignacion();
            asign.asigAreas = <AsigxArea>[];
            // asign.asigAreas!.asGrupos = <AsigxGrupo>[];
            var area;
            Grado? grado;
            var grupo;
            // if (rows[i][4] != null) {
            //   asign.dirGrupo = rows[i][4];
            // }
            if (rows[i][3] != null) {
              area = rows[i][3];
            }
            for (var j = 4; j < finGrupos; j++) {
              AsigxGrupo asiG = AsigxGrupo();
              /* if (i == 19) {
                print([
                  'Fila de',
                  i,
                  j,
                  area,
                  rows[i][j],
                  rows[0][j],
                  rows[1][j]
                ]);
              } */
              try {
                if (rows[i][j] != null) {
                  grado = grados.firstWhere((g) => g.codigo == rows[0][j]);
                  grupo = grado.grupos!
                      .firstWhere((grp) => grp.nombre!.contains(rows[1][j]))
                      .nombre;
                  grupo = grupo.substring(0, grupo.length - 1);
                  grupo = grupo + rows[1][j];
                  /* if (i == 19) {
                    print(['Grupo ', grupo]);
                  } */
                  asiG.grupo = grupo;
                  asiG.ih = rows[i][j].toInt();
                  var ano = anos.firstWhere((ax) => ax.nombre == dropdownYear);
                  print(['Periodos', ano.periodos]);
                  for (var per in ano.periodos) {
                    var asigp = AsignacionT(
                      area: area,
                      docente: nombre,
                      grupo: grupo,
                      grado: grado.nombre!,
                      periodo: per,
                      ih: rows[i][j].toInt(),
                      completa: false,
                      cargada: false,
                    );
                    var contain = asigTotal.asignaciones.where((at) =>
                        ((at.area == area) &&
                            (at.periodo == per) &&
                            (at.docente == nombre) &&
                            (at.grupo == grupo) &&
                            (at.grado == grado!.nombre!) &&
                            (at.ih == rows[i][j].toInt())));
                    if (contain.isEmpty) {
                      asigTotal.asignaciones.add(asigp);
                    }
                    var dc = docentes.where((d) => d.nombre == nombre).toList();
                    Docente docente;
                    if (dc.isEmpty) {
                      Asignaciones aParcial =
                          Asignaciones(asignaciones: [asigp]);
                      asign.asigAreas!
                          .add(AsigxArea(area: area, asGrupos: [asiG]));
                      // asign.asigAreas!.area = area;
                      // asign.asigAreas!.asGrupos!.add(asiG);
                      docente = Docente(
                        nombre: nombre,
                        apellidos: null,
                        nombres: null,
                        cedula: null,
                        sede: hoja.toLowerCase(),
                        asignacion: asign,
                        asignaciones: aParcial,
                      );
                      docentes.add(docente);
                      /* if (i == 19) {
                      print(['Docente nuevo', docente.toJson()]);
                    } */
                      // print(['Docente nuevo', docente.toJson()]);
                    } else {
                      docente = dc[0];
                      int dcIndex = docentes.indexOf(docente);
                      docentes[dcIndex].sede = hoja.toLowerCase();
                      docentes[dcIndex].asignaciones!.asignaciones.add(asigp);
                      var ac = docentes[dcIndex]
                          .asignacion!
                          .asigAreas!
                          .where((a) => a.area == area)
                          .toList();
                      if (ac.isEmpty) {
                        docentes[dcIndex]
                            .asignacion!
                            .asigAreas!
                            .add(AsigxArea(area: area, asGrupos: [asiG]));
                      } else {
                        var aIndex = docentes[dcIndex]
                            .asignacion!
                            .asigAreas!
                            .indexOf(ac[0]);
                        var ag = docentes[dcIndex]
                            .asignacion!
                            .asigAreas![aIndex]
                            .asGrupos!
                            .where((_g) => _g.grupo == grupo)
                            .toList();
                        if (ag.isEmpty) {
                          docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos!
                              .add(asiG);
                        } else {
                          var gIndex = docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos!
                              .indexOf(ag[0]);
                          docentes[dcIndex]
                              .asignacion!
                              .asigAreas![aIndex]
                              .asGrupos![gIndex]
                              .ih = rows[i][j].toInt();
                        }
                      }
                      /* if (i == 19) {
                      print(
                          ['Docente actualizado', docentes[dcIndex].toJson()]);
                    } */
                      // print(['Docente actualizado', docentes[dcIndex].toJson()]);
                    }
                  }
                }
              } catch (e) {
                print([
                  'Error en Asig a grupo',
                  e,
                  'en Asig a grupo',
                  i,
                  j,
                  nombre,
                  area,
                  grupo,
                  rows[i][j],
                  rows[0][j],
                  rows[1][j],
                ]);
              }
            }
          } catch (e) {
            print([
              'Error en Fila de Asignacion',
              e,
              'en Fila',
              i,
              rows[i],
              rows[i][2],
              rows[i][3],
              rows[i][4]
            ]);
          }
        }
        var listaD = [];
        for (var dd in docentes) {
          listaD.add(dd.toJson());
        }
        await storage.put('Docentes', listaD);
        var listaAsig = [];
        for (var asg in asigTotal.asignaciones) {
          listaAsig.add(asg.toJson());
        }
        await storage.put('Asignaciones', listaAsig);
        print(['Asignaciones', listaAsig.length]);
        // print(['Docentes', listaD.length, listaD[10]]);
      } catch (e) {
        print(['Error en ' + hoja, e, path]);
        _ErrorDialog(context, 'Error en ' + hoja, [Text(e.toString())]);
      }
    }
  }
  await acPendientes();
  // } catch (e) {
  //   print(['Error0', e, path]);
  //   _ErrorDialog(context, 'Error0', [Text(e.toString())]);
  // }
}

Future logroNota(int i, String logro, double nota) async {
  if (logros[i].logro == logro) {
    if (nota >= 3) {
      return logros[i].logro;
    } else {
      return logros[i].dflogro;
    }
  }
}

Future creaFile(BuildContext context,
    [String? area,
    String? docente,
    String? sede,
    String? grado,
    List? grupos,
    int? periodo,
    String? path]) async {
  try {
    var file = path ?? 'data/flutter_assets/assets/Template1.xlsx';
    var bytes = File(file).readAsBytesSync();
    var libro = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for (var i = 0; i < grupos!.length; i++) {
      String sheet = 'Planilla';
      print(['Filas', libro.tables[sheet]!.maxRows]);
      libro.updateCell(sheet, 1, 1, sede!);
      libro.updateCell(sheet, 1, 2, docente!);
      libro.updateCell(sheet, 1, 3, area!);
      libro.updateCell(sheet, 1, 4, grupos[i]);
      libro.updateCell(sheet, 3, 4, periodo);
      var codGrado = (grupos[i].length > 2)
          ? grupos[i].substring(0, 2)
          : grupos[i].substring(0, 1);
      print([
        'codGrado',
        grupos[i].length,
        grupos[i].substring(0, 1),
        grupos[i].substring(0),
        codGrado
      ]);
      var logrosfile =
          'data/flutter_assets/assets/logros.xlsx'; //'assets/logros.xlsx'; // data\flutter_assets\assets
      var logrosbytes = File(logrosfile).readAsBytesSync();
      var logrosDB = SpreadsheetDecoder.decodeBytes(logrosbytes, update: false);
      var lsheet = logrosDB.tables['LOGROS'];
      var lcount = lsheet!.rows.length;
      var clogros = lsheet.rows
          .where((l) =>
              ((area.toUpperCase().contains(l[3].toString().toUpperCase())) &&
                  (l[2].toString() == codGrado)))
          .toList();
      print([lcount, codGrado, 'clogros', clogros.length]);
      for (var j = clogros.length - 1; j >= 0; j--) {
        libro.updateCell('Logros', 0, j, clogros[j][1].toString());
        /* logros.add(Logro(
          logro: lsheet.rows[i][1].toString(),
          codGrado: lsheet.rows[i][2].toString(),
          area: lsheet.rows[i][3].toString(),
          periodo: lsheet.rows[i][4].toString(),
          sede: lsheet.rows[i][5].toString(),
          dflogro: lsheet.rows[i][9].toString(),
        )); */
      }
      var lista = estudiantes.where((e) => e.grupo == grupos[i]).toList();
      lista.sort((a, b) {
        return a.apellidos!.toLowerCase().compareTo(b.apellidos!.toLowerCase());
      });
      if (lista.isNotEmpty) {
        for (var i = 0; i < lista.length; i++) {
          var n =
              lista[i].apellidos.toString() + ' ' + lista[i].nombres.toString();
          // print(n);
          libro.updateCell(sheet, 1, i + 7, n);
        }
      }
      Uint8List data = Uint8List.fromList(libro.encode());
      MimeType type = MimeType.MICROSOFTEXCEL;
      // String? val = await FileSaver.instance.saveFile(
      //   docente +
      //       ' - ' +
      //       'Periodo ' +
      //       dropdownPeriodo.toString() +
      //       ' - ' +
      //       area +
      //       ' - ' +
      //       grupos[i],
      //   data,
      //   "xlsx",
      //   mimeType: type,
      // );
      // print(val);
      String fileName = docente +
          ' - ' +
          dropdownYear +
          ' - ' +
          'Periodo ' +
          dropdownPeriodo.toString() +
          ' - ' +
          area +
          ' - ' +
          grupos[i];
      String ruta = 'Planillas exportadas/' +
          dropdownYear +
          '/Periodo ' +
          dropdownPeriodo.toString();
      File(join(ruta + '/${basename('assets/' + fileName + '.xlsx')}'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
      String? val = await FileSaver.instance.saveFile(
        join(ruta + '/${basename('assets/' + fileName)}'),
        data,
        "xlsx",
        mimeType: type,
      );
      print(val);
    }
    // File(join('test/out/${basename('assets/Template1.xlsx')}'))
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(libro.encode());
  } catch (e) {
    print(['Error creaFile', e, path]);
    _ErrorDialog(context, 'Error creaFile', [Text(e.toString())]);
  }
}

Future reporteFaltantes(BuildContext context) async {
  try {
    var file = 'data/flutter_assets/assets/Template2.xlsx';
    var bytes = File(file).readAsBytesSync();
    var libro = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    var datos = pendientes.docentes!;
    int deTotal = 0;
    for (var i = 0; i < datos.length; i++) {
      String general = 'General';
      String detallado = 'Detallado';
      var sedex = sede(datos[i].asignacion![0].grupo);
      sedex = (sedex == 'Instituci??n Etnoeducativa Rural Internado De Nazareth')
          ? 'principal'
          : sedex;
      libro.updateCell(general, 0, 2 + i, datos[i].nombre);
      libro.updateCell(
          general,
          1,
          2 + i,
          datos[i]
              .asignacion!
              .where((a) => (a.periodo == dropdownPeriodo))
              .length);
      // libro.updateCell(general, 2, 2 + i, datos[i].grupos!.toSet());
      libro.updateCell(general, 3, 2 + i, sedex);
      for (var j = 0; j < datos[i].asignacion!.length; j++) {
        if (datos[i].asignacion![j].periodo == dropdownPeriodo) {
          var sedex = sede(datos[i].asignacion![j].grupo);
          sedex =
              (sedex == 'Instituci??n Etnoeducativa Rural Internado De Nazareth')
                  ? 'principal'
                  : sedex;
          libro.updateCell(
              detallado, 0, 2 + deTotal, datos[i].asignacion![j].docente);
          libro.updateCell(detallado, 1, 2 + deTotal, sedex);
          libro.updateCell(
              detallado, 2, 2 + deTotal, datos[i].asignacion![j].area);
          libro.updateCell(
              detallado, 3, 2 + deTotal, datos[i].asignacion![j].grado);
          libro.updateCell(
              detallado, 4, 2 + deTotal, datos[i].asignacion![j].grupo);
          deTotal += 1;
        }
      }
      Uint8List data = Uint8List.fromList(libro.encode());
      MimeType type = MimeType.MICROSOFTEXCEL;
      String fileName = 'Reporte de asignaciones pendientes - ' +
          dropdownYear +
          ' - ' +
          'Periodo ' +
          dropdownPeriodo.toString() +
          ' - ' +
          DateTime.now().day.toString() +
          ' de ' +
          DateTime.now().month.toString();
      String ruta = 'Reportes exportados/' +
          dropdownYear +
          '/Periodo ' +
          dropdownPeriodo.toString();
      File(join(ruta + '/${basename('assets/' + fileName + '.xlsx')}'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
      String? val = await FileSaver.instance.saveFile(
        join(ruta + '/${basename('assets/' + fileName)}'),
        data,
        "xlsx",
        mimeType: type,
      );
      print(val);
    }
    // File(join('test/out/${basename('assets/Template1.xlsx')}'))
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(libro.encode());
  } catch (e) {
    // print(['Error creaFile', e, path]);
    _ErrorDialog(context, 'Error reporteFaltantes', [Text(e.toString())]);
  }
}
