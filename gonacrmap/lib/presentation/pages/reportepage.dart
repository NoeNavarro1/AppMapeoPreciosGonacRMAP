import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReportePage extends StatefulWidget {
  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Reporte'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Switch(
              value: _value,
              activeColor: Colors.orange,
              inactiveThumbColor: Colors.orange,
              dragStartBehavior: DragStartBehavior.down,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  print('Switch is ON');
                });
              }
            ),
          ),
          ...(_value == true
              ? [Text('Cliente Externo')]
              : [Text('Cliente Gonac')]),
        ],
      ),
    );
  }
}
