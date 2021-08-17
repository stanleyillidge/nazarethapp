import 'package:flutter/material.dart';
import 'package:nazarethapp/icons/school_icons_icons.dart';

class DashBoardCard extends StatefulWidget {
  const DashBoardCard({Key? key}) : super(key: key);

  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  final ScrollController? _dcardController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: _dcardController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100),
            child: Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 280,
                height: 100,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 265,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            School_icons.school,
                            color: Colors.orange,
                            size: 40,
                          ),
                          const VerticalDivider(
                            color: Colors.orange,
                            thickness: 2.5,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Sedes'),
                              Text(
                                '6',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
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
            ),
          ),
        );
      },
    );
  }
}
