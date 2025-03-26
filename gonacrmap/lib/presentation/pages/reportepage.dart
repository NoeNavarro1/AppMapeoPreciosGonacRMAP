import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gonacrmap/presentation/widgets/reporte_formulario.dart';
import 'package:gonacrmap/presentation/pages/scanner.dart'; // Nombre corregido

class ReportePage extends StatefulWidget {
  const ReportePage({super.key});

  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  final TextEditingController _marcaProductoController = TextEditingController();
  final ReporteFormulario _reporteFormulario = ReporteFormulario();
  bool _isGonac = true;

  void _abrirEscaner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scanner(
          onCodeScanned: (String scannedCode) {
            setState(() {
              _marcaProductoController.text = scannedCode;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Reporte'),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Switch Cliente Gonac o Externo
                Row(
                  children: [
                    const Text('Cliente Gonac', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Switch(
                      value: _isGonac,
                      onChanged: (value) => setState(() => _isGonac = value),
                    ),
                    const Text('Cliente Externo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 20),

                // Campos generales
                _reporteFormulario.buildTextField(
                  label: _isGonac ? 'Nombre de Empresa' : 'Nombre del Cliente',
                  name: 'nombre_cliente',
                ),
                const SizedBox(height: 15),

                _reporteFormulario.buildTextField(
                  label: _isGonac ? 'Contacto' : 'Número del Cliente',
                  name: 'contacto_cliente',
                ),
                const SizedBox(height: 15),

                // Campos extra para Cliente Externo
                if (!_isGonac) ...[
                  _reporteFormulario.buildTextField(label: 'Zona', name: 'zona'),
                  const SizedBox(height: 15),
                  _reporteFormulario.buildTextField(label: 'Región', name: 'region'),
                  const SizedBox(height: 15),
                  _reporteFormulario.buildTextField(label: 'Asesor', name: 'asesor'),
                  const SizedBox(height: 15),
                  _reporteFormulario.buildTextField(label: 'Contacto Asesor', name: 'contacto_asesor'),
                  const SizedBox(height: 15),
                ],

                // Datos del promotor
                _reporteFormulario.buildTextField(label: 'Nombre del Promotor', name: 'nombre_promotor'),
                const SizedBox(height: 15),
                _reporteFormulario.buildTextField(label: 'Contacto del Promotor', name: 'contacto_promotor'),
                const SizedBox(height: 15),

                // Escáner de código de barras
                _reporteFormulario.buildIconButton(
                  icon: Icons.camera_alt,
                  label: 'Escanear Código de Barras',
                  onPressed: _abrirEscaner,
                ),
                const SizedBox(height: 15),

                // Marca del producto
                _reporteFormulario.buildTextField(
                  label: 'Marca del Producto',
                  name: 'marca_producto',
                  controller: _marcaProductoController,
                ),
                const SizedBox(height: 15),

                // Otros campos del producto
                _reporteFormulario.buildTextField(label: 'Tamaño del Producto', name: 'tamano_producto'),
                const SizedBox(height: 15),
                _reporteFormulario.buildTextField(label: 'Nombre del Producto', name: 'nombre_producto'),
                const SizedBox(height: 15),
                _reporteFormulario.buildTextField(label: 'Lote de la Bobina', name: 'lote_bobina'),
                const SizedBox(height: 15),
                _reporteFormulario.buildDatePicker(label: 'Caducidad de la Bobina', name: 'caducidad_bobina'),
                const SizedBox(height: 15),
                _reporteFormulario.buildTextField(label: 'Cantidad Reportada', name: 'cantidad_reportada'),
                const SizedBox(height: 15),

                // Unidad de medida
                _reporteFormulario.buildDropdown(
                  label: 'Seleccionar Unidad',
                  name: 'unidad',
                  items: ['Unidad 1', 'Unidad 2', 'Unidad 3'],
                ),
                const SizedBox(height: 15),

                // Descripción
                _reporteFormulario.buildTextField(label: 'Descripción', name: 'descripcion'),
                const SizedBox(height: 15),

                // Botón para tomar foto del producto
                _reporteFormulario.buildIconButton(
                  icon: Icons.camera,
                  label: 'Tomar Foto del Producto',
                  onPressed: () {
                    // Acción para tomar foto del producto
                  },
                ),
                const SizedBox(height: 30),

                // Botón de enviar formulario
                _reporteFormulario.buildSubmitButton(onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
