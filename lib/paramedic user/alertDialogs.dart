import 'package:flutter/material.dart';
import 'package:medic/paramedic user/panel.dart';

class goOnline extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const goOnline({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          content:
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
            child: Text(
              'Go Online?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inria Sans',
                color: Color(0xFFA60101),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(32.0))),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Online()));
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Color.fromRGBO(123, 189,
                        99, 1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(
                        0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    width: 0,
                    thickness: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text(
                    'No',
                    style: TextStyle(color: Color.fromRGBO(227, 0,
                        42, 1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(
                        0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
  }
}