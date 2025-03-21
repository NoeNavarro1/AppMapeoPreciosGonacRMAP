import 'package:flutter/material.dart';

class ReportePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Reporte')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Producto')),
            TextField(decoration: InputDecoration(labelText: 'Cantidad')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Enviar Reporte')),
          ],
        ),
      ),
    );
  }
}
