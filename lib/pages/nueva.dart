import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/estilos.dart';
import 'package:nazarethapp/widgets/models.dart';
import 'package:provider/provider.dart';

class NuevaPage extends StatefulWidget {
  const NuevaPage({Key? key, this.index, this.body}) : super(key: key);
  final int? index;
  final Widget? body;

  @override
  _NuevaPageState createState() => _NuevaPageState();
}

class _NuevaPageState extends State<NuevaPage> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> width;
  late Animation<double> padding;
  late Animation<double> menu;
  late Animation<double> menuOpen;
  late Animation<double> menu2;

  @override
  void initState() {
    for (var e in menus) {
      setState(() {
        e.activo = false;
      });
    }
    menus[widget.index!].activo = true;
    controller = AnimationController(
        duration: const Duration(milliseconds: 0), vsync: this);
    width = Tween<double>(
      begin: 0.92,
      end: 0.833,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    padding = Tween<double>(
      begin: 0,
      end: 160,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    menu = Tween<double>(
      begin: 75,
      end: 210,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    menuOpen = Tween<double>(
      begin: 0,
      end: 150,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    menu2 = Tween<double>(
      begin: 0,
      end: 0.025,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    setState(() {
      w = (act) ? 0.7 : 0.8;
      if (act) {
        controller.forward();
      }
      controller.duration = const Duration(milliseconds: 500);
      // print([widget.index, 'initState', act, w]);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  openMenu() {
    setState(() {
      act = !act;
      w = (act) ? 0.7 : 0.8;
      p = (act) ? 160 : 0;
      // print(['onHorizontalDragEnd', act, w, p]);
    });
    (act) ? controller.forward() : controller.reverse();
  }

  double p = 0.0;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.brown,
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 11, top: 0),
              child: SizedBox(
                width: menu.value,
                height: size.height * 0.98,
                child: GestureDetector(
                  onHorizontalDragEnd: (a) {
                    openMenu();
                  },
                  child: Column(
                    children: [
                      GestureDetector(
                        onHorizontalDragEnd: (a) {
                          openMenu();
                        },
                        child: const SizedBox(
                          width: 60,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: menus.length,
                          itemBuilder: (context, index) {
                            // final item = menus[index];
                            return MouseRegion(
                              cursor: SystemMouseCursors.none,
                              child: GestureDetector(
                                onHorizontalDragEnd: (a) {
                                  openMenu();
                                },
                                onTap: () {
                                  setState(() {
                                    for (var e in menus) {
                                      e.activo = false;
                                    }
                                  });
                                  menus[index].activo = true;
                                  if (index != widget.index) {
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return ListenableProvider(
                                            create: (context) => animation,
                                            child: NuevaPage(
                                              index: index,
                                              body: paginas[index],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  /* Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              menus[index].ruta!),
                                    ); */
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (menus[index].activo!)
                                        ? Colors.brown.shade400
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: (menus[index].activo!)
                                            ? Colors.white
                                            : Colors.transparent),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        22.5, 0, 5, 0),
                                    // visualDensity: VisualDensity.comfortable,
                                    horizontalTitleGap: 5,
                                    leading: menus[index].icono,
                                    title: (menuOpen.value != 0)
                                        ? Text(
                                            menus[index].titulo!,
                                            style: TextStyle(
                                              fontSize: (menuOpen.value * 0.1),
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 0),
              child: Container(
                width: (MediaQuery.of(context).size.width * width.value),
                height: MediaQuery.of(context).size.height * h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1.25,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: widget.body,
              ),
            ),
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            (!act) ? controller.stop() : controller.reverse();
            w = 0.8;
          });
          // _showMyDialog();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(
                login: false,
              ),
            ),
          );
        },
        label: Text('Navigate Back'),
      ), */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    /* MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tema,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: 
    ); */
  }

  /* Future<void> _showMyDialog() async {
    ScrollController? _dialogScrollController;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            controller: _dialogScrollController,
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

/* LayoutBuilder(
  builder: (BuildContext context, BoxConstraints viewportConstraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Areas pendientes',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  },
); */
