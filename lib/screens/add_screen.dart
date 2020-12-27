import 'package:flutter/material.dart';

class AddReservationScreen extends StatelessWidget {
  final String _title;

  static const routeName = '/add';
  AddReservationScreen({Key key, String title})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue[700].withOpacity(0.2),
              ),
              child: Icon(
                Icons.hotel,
                size: 170,
                color: Colors.blue[900],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                _title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
