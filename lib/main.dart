import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/bindings/product_binding.dart';
import 'presentation/pages/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: ProductBinding(),
      home: ProductListScreen(),
    );
  }
}
