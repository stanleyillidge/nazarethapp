import 'package:flutter/material.dart';

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
    // cargaTotal();
    // paginas.add(HomePage(key: homekey));
    // paginas.add(BoletinesPage());
    // paginas.add(ConfiguracionPage(key: configuracionkey));
    // paginas.add(OtroPage());
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
                              /* Future.delayed(const Duration(milliseconds: 1000),
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
                              }); */
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

/* class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
} */
