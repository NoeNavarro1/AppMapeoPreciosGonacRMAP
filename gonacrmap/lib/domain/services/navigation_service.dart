import 'package:flutter/material.dart';
import 'package:gonacrmap/presentation/pages/analisispage.dart';
import 'package:gonacrmap/presentation/pages/mapeo_precios.dart';
import 'package:gonacrmap/presentation/pages/reportespage.dart';

class NavigationService {
  final List<Widget> pages = [
    const MapeoPrecios(),
    const Reportespage(),
    const Analisispage(),
    
  ];

  Widget getPage(int index) {
    return pages[index];
  }
}
