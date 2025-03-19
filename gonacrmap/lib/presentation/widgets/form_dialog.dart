import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gonacrmap/data/models/producto_model.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gonacrmap/data/datasources/mapeo_service.dart';
import 'package:gonacrmap/data/datasources/formulario_service.dart';
import 'package:gonacrmap/presentation/providers/formulario_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class FormDialog extends StatefulWidget {
  const FormDialog({
    super.key,
  });

  @override
  _FormDialogState createState() => _FormDialogState();
}

//Funcion para obtener los valores de los controladores
class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  //instancia de servicios
  final MapeoService _mapeoService = MapeoService();
  final FormularioService _formularioService = FormularioService();
  final logger = Logger();
  late FormularioProvider formularioProvider;


////////////////////////////////////////////////
  Future<void> _handleFormSubmission() async {
    // Obtener el producto desde los controladores
    ProductoModel producto = _formularioService.getProductoFromControllers(context);

    // Ruta de la imagen (si es necesario)
    String? imagePath =
        _productImage?.path; // Cambia esto según tu implementación

    // Llamar a submitForm con el producto y la imagen
    bool result = await _formularioService.submitForm(context, producto, imagePath);

    if (result) {
      logger.i('Formulario Enviado Correctamente');
    } else {
      logger.e('Error al enviar el formulario');
    }
  }
///////////////////////////////////////////////


///////////////////////////////////////////////
  final ImagePicker _picker = ImagePicker();
  File? _productImage;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File newImage = File(pickedFile.path);

      if (mounted) {
          _productImage = newImage;
      }
      logger.i('Imagen Seleccionada :${_productImage?.path}');
    } else {
      logger.i('No se selecciono ninguna Imagen');
    }
  }
///////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    formularioProvider = Provider.of<FormularioProvider>(context, listen: false);

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
                  return await _mapeoService.fetchProductos(textEditingValue.text);
                }
              }, displayStringForOption: (Map<String, dynamic> option) {
                return option['nombre_producto'];
              }, fieldViewBuilder: (BuildContext context,
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
              }, onSelected: (Map<String, dynamic> selection) async {
                // Actualizamos el texto de los controladores en formularioProvider
                formularioProvider.controllers['nombreProducto']!.text = selection['nombre_producto'];
                
                String marcaId = selection['marca']?.toString() ?? '';
                String categoriaId = selection['categoria']?.toString() ?? '';

                // Variables temporales para guardar los valores de nombre de marca y categoría
                String? marcaName = '';
                String? categoriaName = '';

                try {
                  // Solo hacer la llamada si el valor del ID no está vacío
                  if (marcaId.isNotEmpty) {
                    marcaName = await _mapeoService.getMarcaNombre(marcaId);
                  }

                  if (categoriaId.isNotEmpty) {
                    categoriaName =
                        await _mapeoService.getCategoriaName(categoriaId);
                  }
                } catch (e) {
                  logger.e('Error obteniendo datos: $e');
                }

                // Evitar el setState si los valores no cambiaron
                if (mounted && (marcaName != null || categoriaName != null)) {

                    // Actualizamos 'selectedValues' solo si el valor no es nulo o vacío
                    if (marcaName != null && marcaName.isNotEmpty) {
                      formularioProvider.updateSelectedValue('marca', selection['marca']?.toString());
                      formularioProvider.controllers['marca']!.text = marcaName;
                    }

                    if (categoriaName != null && categoriaName.isNotEmpty) {
                      formularioProvider.updateSelectedValue('categoria', selection['categoria']?.toString());
                      formularioProvider.controllers['categoria']!.text = categoriaName;
                    }
                }
              }),
              FormBuilderTextField(
                name: 'marca',
                controller: formularioProvider.controllers['marca'],
                decoration: InputDecoration(labelText: 'Marca'),
                enabled: false,
              ),
              FormBuilderTextField(
                name: 'categoria',
                controller: formularioProvider.controllers['categoria'],
                decoration: InputDecoration(labelText: 'Categoría'),
                enabled: false,
              ),
              Autocomplete<Map<String, dynamic>>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text == '') {
                  return [];
                } else {
                  return await _mapeoService.fetchEstablecimientos(textEditingValue.text);
                }
              }, displayStringForOption: (Map<String, dynamic> option) {
                return option['nombre_cliente'];
              }, fieldViewBuilder: (BuildContext context,
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
              }, onSelected: (Map<String, dynamic> selection) async {
                // Actualizamos el texto de los controladores en formularioProvider
                formularioProvider.controllers['establecimiento']!.text = selection['nombre_cliente']; // Manejar null para establecimiento

                String zonaId = selection['zona']?.toString() ?? '';
                String regionId = selection['region']?.toString() ?? '';

                // Variables temporales para almacenar los nombres de zona y región
                String? zonaName;
                String? regionName;

                try {
                  // Solo hacer las llamadas si los IDs no están vacíos
                  if (zonaId.isNotEmpty) {
                    zonaName = await _mapeoService.getZonaName(zonaId);
                  }

                  if (regionId.isNotEmpty) {
                    regionName = await _mapeoService.getRegionName(regionId);
                  }
                } catch (e) {
                  logger.e('Error al obtener datos: $e');
                }

                // Evitar setState si no es necesario
                if (mounted && (zonaName != null || regionName != null)) {
                    // Actualizamos 'selectedValues' solo si los valores son válidos
                    if (zonaName != null && zonaName.isNotEmpty) {
                      formularioProvider.updateSelectedValue('zona', selection['zona']?.toString() ?? '');
                      formularioProvider.controllers['zona']!.text = zonaName;
                    } else {
                      formularioProvider.controllers['zona']!.text = ''; // Asignar valor vacío si es null
                    }

                    if (regionName != null && regionName.isNotEmpty) {
                      formularioProvider.updateSelectedValue('region', selection['region']?.toString() ?? '');
                      formularioProvider.controllers['region']!.text = regionName;
                    } else {
                      formularioProvider.controllers['region']!.text = ''; // Asignar valor vacío si es null
                    }
                }
              }),
              FormBuilderTextField(
                name: 'zona',
                controller: formularioProvider.controllers['zona'],
                decoration: InputDecoration(labelText: 'Zona'),
                enabled: false,
              ),
              FormBuilderTextField(
                name: 'region',
                controller: formularioProvider.controllers['region'],
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
                onChanged: (value) {
                formularioProvider.updateSelectedValue('unidad', value);
                },
              ),
              FormBuilderTextField(
                name: 'gramaje',
                controller: formularioProvider.controllers['gramaje'],
                decoration: InputDecoration(
                  labelText: 'Gramaje',
                  suffixIcon: Icon(Icons.balance),
                ),
                validator: FormBuilderValidators.required(
                errorText: 'El gramaje es requerido'),
              ),
              FormBuilderTextField(
                name: 'precio',
                controller: formularioProvider.controllers['precio'],
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
                controller: formularioProvider.controllers['fecha'],
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
                mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos en el Row
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
                  if (_productImage == null) // Solo mostrar el ícono si no hay imagen
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding: const EdgeInsets.all(15), // Espaciado alrededor del ícono
                        decoration: BoxDecoration(
                          shape:BoxShape.circle, // Hace que el fondo sea circular
                          color: Colors.orange[200], // Fondo gris claro para resaltar el ícono
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, size: 40), // Aumenta el tamaño del ícono
                          onPressed:_pickImage) // Llama al método _pickImage para tomar la foto
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
        ElevatedButton(
          onPressed: _handleFormSubmission,
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
