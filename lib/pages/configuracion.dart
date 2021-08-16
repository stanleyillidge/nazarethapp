import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/anos.dart';
import 'package:nazarethapp/widgets/areas.dart';
// import 'package:nazarethapp/widgets/excel_admin.dart';
import 'package:nazarethapp/widgets/grados.dart';
import 'package:nazarethapp/widgets/models.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  _ConfiguracionPageState createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 15),
    primary: Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  bool loading = false;

  @override
  void initState() {
    if (grados.isEmpty) {
      loading = false;
    } else {
      loading = true;
    }
    porcentajeAvance = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            height: size.height * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ALectivosList(
                  nombre: 'Años lectivos',
                  lista: anos,
                  modelo: ModelType.ano,
                ),
                GradosList(
                  key: gxakey,
                  nombre: 'Grados',
                  lista: grados,
                  modelo: ModelType.grado,
                ),
                AreasList(
                  key: axakey,
                  nombre: 'Areas',
                  lista: areas,
                ),
                // ToDoList(nombre: 'Asignaturas', lista: asignaturas),
                // ToDoList(
                //   nombre: 'Docentes',
                //   lista: docentes,
                //   modelo: ModelType.docente,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
