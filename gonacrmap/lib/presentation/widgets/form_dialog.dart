import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gonacrmap/domain/entities/producto.dart';
import 'package:gonacrmap/presentation/providers/mapeo_precios_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class MapeoPrecio {
  final String nombreProducto;
  final double precio;
  final String marca;
  final String categoria;
  final String establecimiento;
  final String zona;
  final String region;
  final String unidadMedida;
  final DateTime fecha;

  MapeoPrecio({
    required this.nombreProducto,
    required this.precio,
    required this.marca,
    required this.categoria,
    required this.establecimiento,
    required this.zona,
    required this.region,
    required this.unidadMedida,
    required this.fecha,
  });
}

class FormDialog extends StatefulWidget {
  final Dio dio;
  const FormDialog({Key? key, required this.dio}) : super(key: key);

  @override
  _FormDialogState createState() => _FormDialogState();
}

final ip = '192.168.1.72';

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

  String? _marcaId;
  String? _categoriaId;
  String? _zonaId;
  String? _regionId;

  final ImagePicker _picker = ImagePicker();
  File? _productImage;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchProductos(String query) async {
    try {
      final response = await widget.dio.get(
        "http://$ip:8000/api/ProductosCompetencia/",
        queryParameters: {"search": query},
      );
      print(
          "Respuesta de productos: ${response.data}"); // Para ver la respuesta
      List<Map<String, dynamic>> productos =
          List<Map<String, dynamic>>.from(response.data);
      return productos.where((producto) {
        return producto['nombre_producto']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print("Error al obtener productos: $e");
      debugPrint("Error al obtener productos: $e");
      return [];
    }
  }

  Future<String> _getMarcaNombre(String marcaId) async {
    try {
      final response =
          await widget.dio.get("http://$ip:8000/api/Marcas/$marcaId/");
      print("Respuesta de marca: ${response.data}"); // Para ver la respuesta
      return response.data['nombre'] ?? '';
    } catch (e) {
      print("Error al obtener Marcas $e");
      debugPrint("Error al obtener Marcas $e");
      return '';
    }
  }

  Future<String> _getCategoriaName(String categoriaId) async {
    try {
      final response =
          await widget.dio.get('http://$ip:8000/api/Categorias/$categoriaId/');
      print(
          "Respuesta de categoria: ${response.data}"); // Para ver la respuesta
      return response.data['nombre'] ?? '';
    } catch (e) {
      print("Error al obtener categorias: $e");
      debugPrint("Error al obtener categorias: $e");
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchEstablecimientos(
      String query) async {
    try {
      final response = await widget.dio.get(
        "http://$ip:8000/api/ClientesLista/",
        queryParameters: {"search": query},
      );
      print(
          "Respuesta de establecimientos: ${response.data}"); // Para ver la respuesta
      List<Map<String, dynamic>> establecimientos =
          List<Map<String, dynamic>>.from(response.data);
      return establecimientos.where((establishment) {
        return establishment['nombre_cliente']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print("Error al obtener establecimientos: $e");
      debugPrint("Error al obtener establecimientos: $e");
      return [];
    }
  }

  Future<String> _getZonaName(String zonaId) async {
    try {
      final response =
          await widget.dio.get("http://$ip:8000/api/Zona/$zonaId/");
      print("Respuesta de zona: ${response.data}"); // Para ver la respuesta
      return response.data['nombre'] ?? '';
    } catch (e) {
      print("Error al obtener zona: $e");
      debugPrint("Error al obtener zona: $e");
      return '';
    }
  }

  Future<String> _getRegionName(String regionId) async {
    try {
      final response =
          await widget.dio.get("http://$ip:8000/api/Region/$regionId/");
      print("Respuesta de región: ${response.data}"); // Para ver la respuesta
      return response.data['nombre'] ?? '';
    } catch (e) {
      print("Error al obtener región: $e");
      debugPrint("Error al obtener región: $e");
      return '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);

      // Validar que nombreProducto y unidadMedida no sean vacíos
      final nombreProducto =
          (formData['nombre_producto']?.toString() ?? "").trim().isEmpty
              ? "Nombre no disponible"
              : formData['nombre_producto'].toString();

      final unidadMedida =
          (formData['unidad_medida']?.toString() ?? "").trim().isEmpty
              ? "Unidad no especificada"
              : formData['unidad_medida'].toString();

      final precio =
          double.tryParse(formData['precio']?.toString() ?? "0.0") ?? 0.0;
      final marca = formData['marca']?.toString() ?? "";
      final categoria = formData['categoria']?.toString() ?? "";
      final establecimiento = formData['establecimiento']?.toString() ?? "";
      final zona = formData['zona']?.toString() ?? "";
      final region = formData['region']?.toString() ?? "";

      DateTime fecha = DateTime.now();
      if (formData['fecha'] != null) {
        DateTime fecha = formData['fecha'] is String
            ? DateFormat('yyyy-MM-dd').parse(formData['fecha'])
            : formData['fecha'];
        formData['fecha'] = DateFormat('yyyy-MM-dd').format(fecha);
      }

      final producto = Producto(
        nombreProducto: nombreProducto,
        precio: precio,
        marca: marca,
        categoria: categoria,
        establecimiento: establecimiento,
        zona: zona,
        region: region,
        unidadMedida: unidadMedida,
        fecha: fecha,
        
      );

      // Agregar el producto al provider
      Provider.of<MapeoPreciosProvider>(context, listen: false)
          .addProducto(producto);

      // Debug: Imprimir valores para verificar que se asignaron correctamente
      print("Producto agregado: $producto");

      // Debug: Ver los datos que se van a enviar
      print("Datos antes de enviar al backend: $formData");

      formData['marca'] = _marcaId; // Enviar el ID, no el nombre
      formData['categoria'] = _categoriaId;
      formData['zona'] = _zonaId;
      formData['region'] = _regionId;

      // Debug: Ver cómo se ven los datos de relaciones
      print("Marca (ID): ${formData['marca']}");
      print("Categoría (ID): ${formData['categoria']}");
      print("Zona (ID): ${formData['zona']}");
      print("Región (ID): ${formData['region']}");

      // Convertir precio a número
      formData['precio'] =
          double.tryParse(formData['precio'].toString()) ?? 0.0;

      // Debug: Ver el precio
      print("Precio: ${formData['precio']}");

      // Preparar datos de la imagen si existe
      FormData requestData = FormData.fromMap(formData);
      if (_productImage != null) {
        requestData.files.add(
          MapEntry(
            "foto", // Asegúrate de que esta clave sea la correcta en tu backend
            await MultipartFile.fromFile(
              _productImage!.path,
              filename: "producto.jpg",
            ),
          ),
        );
        // Debug: Ver la imagen que se adjunta
        print("Imagen añadida: ${_productImage?.path}");
      }

      try {
        // Enviar la solicitud al backend Django
        final response = await widget.dio.post(
          'http://$ip:8000/api/Productos/',
          data: requestData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        );

        // Debug: Ver la respuesta del servidor
        print("Respuesta del servidor: ${response.statusCode}");

        if (response.statusCode == 201 || response.statusCode == 200) {
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
        if (e is DioException) {
          // Manejo más específico de errores de Dio
          debugPrint("Error de conexión: ${e.response?.data ?? e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error de conexión: ${e.response?.data ?? e.message}')),
          );
        } else {
          debugPrint("Error desconocido: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error desconocido: $e')),
          );
        }
      }
    } else {
      print("Formulario no válido");
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
      print(
          "Imagen seleccionada: ${_productImage?.path}"); // Ver la imagen seleccionada
    } else {
      print("No se seleccionó ninguna imagen");
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
                  return FormBuilderTextField(
                    name: 'nombre_producto',
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        labelText: 'Nombre del producto',
                        suffixIcon: Icon(Icons.local_grocery_store_outlined)),
                    validator: FormBuilderValidators.required(
                        errorText: 'El producto es requerido'),
                  );
                },
                onSelected: (Map<String, dynamic> selection) {
                  _productoController.text = selection['nombre_producto'];

                  setState(() {
                    _marcaId =
                        selection['marca']?.toString(); // Guarda el ID real
                    _categoriaId = selection['categoria']?.toString();
                  });

                  _getMarcaNombre(selection['marca']?.toString() ?? '')
                      .then((marcaName) {
                    if (marcaName.isNotEmpty) {
                      setState(() {
                        _marcaController.text =
                            marcaName; // Muestra el nombre pero usa el ID
                      });
                    }
                  });

                  _getCategoriaName(selection['categoria']?.toString() ?? '')
                      .then((categoriaName) {
                    if (categoriaName.isNotEmpty) {
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
                  return FormBuilderTextField(
                    name: 'establecimiento',
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Establecimiento',
                      suffixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: FormBuilderValidators.required(
                        errorText: 'El establecimiento es requerido'),
                  );
                },
                onSelected: (Map<String, dynamic> selection) {
                  _establecimientoController.text =
                      selection['nombre_cliente'] ?? '';

                  setState(() {
                    _zonaId = selection['zona']?.toString();
                    _regionId = selection['region']?.toString();
                  });

                  _getZonaName(selection['zona']?.toString() ?? '')
                      .then((zonaName) {
                    if (zonaName.isNotEmpty) {
                      setState(() {
                        _zonaController.text = zonaName;
                      });
                    }
                  });

                  _getRegionName(selection['region']?.toString() ?? '')
                      .then((regionName) {
                    if (regionName.isNotEmpty) {
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
                name: 'unidad',
                decoration: InputDecoration(
                    labelText: 'Unidad',
                    suffixIcon: Icon(Icons.scale_outlined)),
                items: ['CAJA', 'BOLSA', 'UNIDAD']
                    .map((unidad) =>
                        DropdownMenuItem(value: unidad, child: Text(unidad)))
                    .toList(),
                validator: FormBuilderValidators.required(
                    errorText: 'La unidad es requerida'),
              ),
              FormBuilderTextField(
                name: 'gramaje',
                decoration: InputDecoration(
                  labelText: 'Gramaje',
                  suffixIcon: Icon(Icons.balance),
                ),
                validator: FormBuilderValidators.required(
                    errorText: 'El gramaje es requerido'),
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
                      errorText: 'El precio es requerido'),
                  FormBuilderValidators.numeric(
                      errorText: 'Solo se permite números'),
                  FormBuilderValidators.min(0,
                      errorText: 'El precio debe ser mayor a 0 '),
                ]),
              ),
              FormBuilderDateTimePicker(
                name: 'fecha',
                inputType: InputType.date,
                format: DateFormat('dd/MM/yyyy'),
                decoration: InputDecoration(
                  labelText: 'Fecha de registro',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                initialValue: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now(),
                validator: FormBuilderValidators.required(
                    errorText: 'La fecha es requerida'),
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
              ),
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
