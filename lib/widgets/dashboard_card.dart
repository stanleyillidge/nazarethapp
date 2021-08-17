import 'package:flutter/material.dart';

class DashBoardCard extends StatefulWidget {
  const DashBoardCard(
      {Key? key, this.icon, this.color, this.titulo, this.count})
      : super(key: key);
  final IconData? icon;
  final Color? color;
  final String? titulo;
  final int? count;

  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: size.width * 0.205,
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
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: (size.width * 0.205) - 15,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: widget.color,
                    size: 40,
                  ),
                  VerticalDivider(
                    color: widget.color,
                    thickness: 2.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.titulo!),
                      Text(
                        widget.count!.toString(),
                        style: TextStyle(
                          color: widget.color,
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
    );
  }
}
