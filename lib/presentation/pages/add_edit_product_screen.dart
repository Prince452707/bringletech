import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/product_controller.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  ProductController get _controller => Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final desc = _descriptionController.text;
      final category =
          _controller.selectedCategory.value == 'All' ||
              _controller.selectedCategory.value.isEmpty
          ? 'misc'
          : _controller.selectedCategory.value;

      final newProduct = ProductEntity(
        id: widget.product?.id ?? 0,
        title: title,
        description: desc,
        price: price,
        rating: widget.product?.rating ?? 4.5,
        thumbnail:
            widget.product?.thumbnail ?? 'https://via.placeholder.com/150',
        images: widget.product?.images ?? [],
        category: widget.product?.category ?? category,
        brand: widget.product?.brand ?? 'Generic',
      );

      bool success;
      if (widget.product != null) {
        success = await _controller.updateProduct(newProduct);
      } else {
        success = await _controller.addProduct(newProduct);
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Product' : 'Add Product',
          style: AppFonts.titleLarge,
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (double.tryParse(v ?? '') == null) ? 'Invalid Price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEdit ? 'Update' : 'Create',
                  style: AppFonts.labelLarge.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
