import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormDialog extends StatefulWidget {
  final Dio dio;
  const FormDialog({Key? key, required this.dio}) : super(key: key);

  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Controladores de texto
  final TextEditingController _establecimientoController =
      TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _productImage;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchProductos(String query) async {
    try {
      final response = await widget.dio.get(
        "http://10.11.20.61:8000/api/ProductosCompetencia/",
        queryParameters: {"search": query},
      );

      List<Map<String, dynamic>> productos =
          List<Map<String, dynamic>>.from(response.data);
      return productos.where((producto) {
        return producto['nombre_producto']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      debugPrint("Error al obtener productos: $e");
      return [];
    }
  }

  Future<String> _getMarcaNombre(String marcaId) async {
    try {
      final response =
          await widget.dio.get("http://10.11.20.61:8000/api/Marcas/$marcaId/");
      return response.data['nombre'] ?? '';
    } catch (e) {
      debugPrint("Error al obtener Marcas $e");
      return '';
    }
  }

  Future _getCategoriaName(String categoriaId) async {
    try {
      final response = await widget.dio
          .get('http://10.11.20.61:8000/api/Categorias/$categoriaId/');
      return response.data['nombre'] ?? '';
    } catch (e) {
      debugPrint("Error al obtener categorias: $e");
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchEstablecimientos(
      String query) async {
    try {
      final response = await widget.dio.get(
        "http://10.11.20.61:8000/api/ClientesLista/",
        queryParameters: {"search": query},
      );

      List<Map<String, dynamic>> establecimientos =
          List<Map<String, dynamic>>.from(response.data);
      return establecimientos.where((establishment) {
        return establishment['nombre_cliente']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      debugPrint("Error al obtener establecimientos: $e");
      return [];
    }
  }

  Future<String> _getZonaName(String zonaId) async {
    try {
      final response =
          await widget.dio.get("http://10.11.20.61:8000/api/Zona/$zonaId/");
      return response.data['nombre'] ?? '';
    } catch (e) {
      debugPrint("Error al obtener zona: $e");
      return '';
    }
  }

  Future<String> _getRegionName(String regionId) async {
    try {
      final response =
          await widget.dio.get("http://10.11.20.61:8000/api/Region/$regionId/");
      return response.data['nombre'] ?? '';
    } catch (e) {
      debugPrint("Error al obtener región: $e");
      return '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      try {
        final response = await widget.dio.post(
          'http://10.11.20.61:8000/api/guardarFormulario/',
          data: formData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Formulario enviado con éxito')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar formulario')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Formulario de Registro'),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<Map<String, dynamic>>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') {
                    return [];
                  } else {
                    return await _fetchProductos(textEditingValue.text);
                  }
                },
                displayStringForOption: (Map<String, dynamic> option) {
                  return option['nombre_producto'];
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        labelText: 'Nombre del producto',
                        suffixIcon: Icon(Icons.local_grocery_store_outlined)),
                  );
                },
                onSelected: (Map<String, dynamic> selection) {
                  _productoController.text = selection['nombre_producto'];
                  _getMarcaNombre(selection['marca']?.toString() ?? '')
                      .then((marcaName) {
                    if (marcaName.isNotEmpty) {
                      setState(() {
                        _marcaController.text = marcaName;
                      });
                    }
                  });

                  _getCategoriaName(selection['categoria']?.toString() ?? '')
                      .then((categoriaName) {
                    if(categoriaName.isNotEmpty){
                      setState(() {
                        _categoriaController.text = categoriaName;
                      });
                    }
                  });
                },
              ),
              FormBuilderTextField(
                name: 'marca',
                controller: _marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
                enabled: false,
              ),
              FormBuilderTextField(
                name: 'categoria',
                controller: _categoriaController,
                decoration: InputDecoration(labelText: 'Categoría'),
                enabled: false,
              ),
              Autocomplete<Map<String, dynamic>>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') {
                    return [];
                  } else {
                    return await _fetchEstablecimientos(textEditingValue.text);
                  }
                },
                displayStringForOption: (Map<String, dynamic> option) {
                  return option['nombre_cliente'];
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Establecimiento',
                      suffixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  );
                },
                onSelected: (Map<String, dynamic> selection) {
                  _establecimientoController.text = selection['nombre_cliente'];
                  _getZonaName(selection['zona']?.toString() ?? '')
                      .then((zonaName) {
                    if(zonaName.isNotEmpty){
                      setState(() {
                        _zonaController.text = zonaName;
                      });
                    }
                  });
                  _getRegionName(selection['region']?.toString() ?? '')
                      .then((regionName) {
                    if(regionName.isNotEmpty){
                      setState(() {
                        _regionController.text = regionName;
                      });
                    }
                  });
                },
              ),
              FormBuilderTextField(
                name: 'zona',
                controller: _zonaController,
                decoration: InputDecoration(labelText: 'Zona'),
                enabled: false,
              ),
              FormBuilderTextField(
                name: 'region',
                controller: _regionController,
                decoration: InputDecoration(labelText: 'Región'),
                enabled: false,
              ),
              FormBuilderDropdown(
                name: 'unidad_medida',
                decoration: InputDecoration(
                    labelText: 'Unidad de medida',
                    suffixIcon: Icon(Icons.scale_outlined)),
                items: ['CAJA', 'BOLSA', 'UNIDAD']
                    .map((unidad) =>
                        DropdownMenuItem(value: unidad, child: Text(unidad)))
                    .toList(),
                validator: FormBuilderValidators.required(
                    errorText: 'Selecciona la unidad'),
              ),
              FormBuilderTextField(
                name: 'gramaje',
                decoration: InputDecoration(
                  labelText: 'Gramaje',
                  suffixIcon: Icon(Icons.balance),
                ),
              ),
              FormBuilderTextField(
                name: 'precio',
                controller: _precioController,
                decoration: InputDecoration(
                    labelText: 'Precio',
                    suffixIcon: Icon(Icons.monetization_on_outlined)),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))
                ],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'El precio es obligatorio'),
                  FormBuilderValidators.numeric(
                      errorText: 'Solo se permite números'),
                  FormBuilderValidators.min(0,
                      errorText: 'El precio debe ser mayor a 0 '),
                ]),
              ),
              FormBuilderDateTimePicker(
                name: 'fecha',
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                decoration: InputDecoration(
                  labelText: 'Fecha de registro',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                initialValue: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now(),
                validator: FormBuilderValidators.required(
                    errorText: 'La fecha es obligatoria'),
                enabled: false,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra los elementos en el Row
                children: [
                  // Si ya se ha tomado una foto, mostramos la imagen
                  if (_productImage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Image.file(
                        _productImage!, // Muestra la foto tomada
                        height: 100, // Tamaño de la imagen
                        width: 100, // Tamaño de la imagen
                        fit: BoxFit.cover, // Ajuste de la imagen
                      ),
                    ),
                  // Si no hay foto, mostramos el ícono para tomar la foto
                  if (_productImage ==
                      null) // Solo mostrar el ícono si no hay imagen
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding: const EdgeInsets.all(
                            15), // Espaciado alrededor del ícono
                        decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // Hace que el fondo sea circular
                          color: Colors.orange[
                              200], // Fondo gris claro para resaltar el ícono
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 40, // Aumenta el tamaño del ícono
                          ),
                          onPressed:
                              _pickImage, // Llama al método _pickImage para tomar la foto
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(onPressed: _submitForm, child: Text('Enviar')),
      ],
    );
  }
}
