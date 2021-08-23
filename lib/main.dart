import 'package:flutter/material.dart';
import 'package:nazarethapp/pages/boletines.dart';
import 'package:nazarethapp/pages/configuracion.dart';
import 'package:nazarethapp/pages/listas.dart';
import 'package:nazarethapp/pages/nueva.dart';
import 'package:nazarethapp/pages/otro.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
import 'widgets/estilos.dart';
import 'widgets/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: tema,
      home: MyHomePage(
        login: false,
      ),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.login}) : super(key: key);
  bool login;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    cargaTotal();
    paginas.add(HomePage(key: homekey));
    paginas.add(const ListasPage());
    paginas.add(const BoletinesPage());
    paginas.add(ConfiguracionPage(key: configuracionkey));
    paginas.add(const OtroPage());
    super.initState();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    // onPrimary: Colors.black87,
    // primary: Colors.grey[300],
    // minimumSize: Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedContainer(
        color: (!widget.login) ? Colors.white : Colors.brown,
        width: size.width,
        height: size.height,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
        child: Padding(
          padding: const EdgeInsets.only(left: 65, top: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: (!widget.login)
                    ? MediaQuery.of(context).size.width * 0.68
                    : 0,
                height: MediaQuery.of(context).size.height * h,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.25,
                      blurRadius: 5,
                      offset: const Offset(4, 4), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/login0.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(),
              ),
              AnimatedContainer(
                width: (!widget.login)
                    ? MediaQuery.of(context).size.width * 0.248
                    : widthT * w * 1.16,
                height: MediaQuery.of(context).size.height * h,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.25,
                      blurRadius: 5,
                      offset: const Offset(4, 4), // changes position of shadow
                    ),
                  ],
                  borderRadius: (!widget.login)
                      ? const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))
                      : BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      (!widget.login)
                          ? Colors.amber.shade100
                          : Colors.amber.shade50,
                      (!widget.login)
                          ? Colors.amber.shade400
                          : Colors.amber.shade50,
                      (!widget.login) ? Colors.amber : Colors.amber.shade50,
                      (!widget.login) ? Colors.amber.shade700 : Colors.white,
                      (!widget.login) ? Colors.amber.shade800 : Colors.white,
                    ],
                    stops: const [0.0, 0.3, 0.7, 0.9, 1],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomCenter,
                  ),
                  // color: (!widget.login) ? null : Colors.amber,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (!widget.login)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.brown),
                              decoration: const InputDecoration(
                                // fillColor: Colors.brown,
                                // enabledBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.orange),
                                // ),
                                border: UnderlineInputBorder(
                                    // borderSide: BorderSide(color: Colors.orange),
                                    ),
                                // focusedBorder: UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.orange),
                                // ),
                                labelText: 'Enter your username',
                                suffixIcon: Icon(Icons.email),
                                // focusColor: Colors.brown,
                                // prefixIcon: Icon(Icons.email),
                                // icon: Icon(Icons.email),
                              ),
                            ),
                          )
                        : Container(),
                    (!widget.login)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: Icon(Icons.remove_red_eye),
                                // icon: Icon(Icons.remove_red_eye),
                                // prefixIcon: Icon(Icons.remove_red_eye),
                              ),
                            ),
                          )
                        : Container(),
                    (!widget.login)
                        ? ElevatedButton(
                            style: raisedButtonStyle,
                            onPressed: () async {
                              setState(() {
                                widthT = MediaQuery.of(context).size.width;
                                heightT = MediaQuery.of(context).size.height;
                                widget.login = !widget.login;
                              });
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return ListenableProvider(
                                        create: (context) => animation,
                                        child: NuevaPage(
                                          index: 0,
                                          body: paginas[0],
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 3000),
                                  ),
                                );
                              });
                            },
                            child: const Text('Entrar'),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
