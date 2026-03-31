import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/blocs/product/product_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/theme/colors.dart';
import 'package:shopito_app/data/models/category.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key, this.product});

  final Product? product;

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductBloc _productBloc = getIt<ProductBloc>();
  final CategoryBloc _categoryBloc = getIt<CategoryBloc>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _discountController;
  late TextEditingController _videoUrlController;

  Category? _selectedCategory;
  bool _isLoading = false;

  // Image URLs list
  List<String> _imageUrls = [];
  final TextEditingController _newImageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _categoryBloc.add(CategoryFetch());

    if (widget.product != null) {
      _populateFormWithProduct();
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _discountController = TextEditingController();
    _videoUrlController = TextEditingController();
  }

  void _populateFormWithProduct() {
    final product = widget.product!;
    _nameController.text = product.name;
    _descriptionController.text = product.description ?? '';
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    _discountController.text = product.discount?.toString() ?? '';

    _selectedCategory = product.category;

    // Populate image URLs
    _imageUrls = List<String>.from(product.images);

    // Populate video URL
    _videoUrlController.text = product.videoUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _videoUrlController.dispose();
    _newImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      isEditing ? "Uredi proizvod" : "Dodaj proizvod",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 44), // Balance for back button
                ],
              ),
            ),

            // Form
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: BlocListener<ProductBloc, ProductState>(
                  bloc: _productBloc,
                  listener: (context, state) {
                    if (state is ProductOperationInProgress) {
                      setState(() => _isLoading = true);
                    } else if (state is ProductOperationSuccess) {
                      setState(() => _isLoading = false);

                      context.pop();
                    } else if (state is ProductOperationFailure) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Product Name
                          _buildInputSection(
                            "Naziv proizvoda",
                            _buildTextFormField(
                              controller: _nameController,
                              hintText: "Unesite naziv proizvoda",
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Naziv proizvoda je obavezan";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Description
                          _buildInputSection(
                            "Opis proizvoda",
                            _buildTextFormField(
                              controller: _descriptionController,
                              hintText: "Unesite opis proizvoda",
                              maxLines: 3,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Price and Quantity Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputSection(
                                  "Cijena (RSD)",
                                  _buildTextFormField(
                                    controller: _priceController,
                                    hintText: "0.00",
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Cijena je obavezna";
                                      }
                                      if (double.tryParse(value) == null) {
                                        return "Unesite validnu cijenu";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInputSection(
                                  "Količina",
                                  _buildTextFormField(
                                    controller: _quantityController,
                                    hintText: "0",
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Količina je obavezna";
                                      }
                                      if (int.tryParse(value) == null) {
                                        return "Unesite validnu količinu";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Category Dropdown
                          _buildInputSection(
                            "Kategorija",
                            BlocBuilder<CategoryBloc, CategoryState>(
                              bloc: _categoryBloc,
                              builder: (context, state) {
                                if (state is CategoryLoaded) {
                                  final categories = state.categories;
                                  Category? selectedCategoryValue;
                                  if (_selectedCategory != null) {
                                    try {
                                      selectedCategoryValue = categories
                                          .firstWhere(
                                            (c) =>
                                                c.id == _selectedCategory!.id,
                                          );
                                    } catch (_) {
                                      selectedCategoryValue = null;
                                    }
                                  }
                                  return DropdownButtonFormField<Category>(
                                    value: selectedCategoryValue,
                                    decoration: _getInputDecoration(
                                      "Odaberite kategoriju",
                                    ),
                                    items:
                                        categories.map((category) {
                                          return DropdownMenuItem(
                                            value: category,
                                            child: Text(category.name),
                                          );
                                        }).toList(),
                                    onChanged: (category) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Kategorija je obavezna";
                                      }
                                      return null;
                                    },
                                  );
                                }
                                return Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: const Center(child: Loader()),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Discount
                          _buildInputSection(
                            "Popust (%)",
                            _buildTextFormField(
                              controller: _discountController,
                              hintText: "0",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final discount = int.tryParse(value);
                                  if (discount == null ||
                                      discount < 0 ||
                                      discount > 100) {
                                    return "Popust mora biti između 0 i 100";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Image URLs Section
                          _buildInputSection(
                            "Slike proizvoda",
                            _buildImageUrlsSection(),
                          ),

                          const SizedBox(height: 20),

                          // Video URL
                          _buildInputSection(
                            "Video URL (opcionalno)",
                            _buildTextFormField(
                              controller: _videoUrlController,
                              hintText: "https://example.com/video.mp4",
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final uri = Uri.tryParse(value);
                                  if (uri == null || !uri.hasAbsolutePath) {
                                    return "Unesite valjan URL";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        isEditing
                                            ? "Ažuriraj proizvod"
                                            : "Dodaj proizvod",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121212),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: _getInputDecoration(hintText),
    );
  }

  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final quantity = int.parse(_quantityController.text.trim());
    final discount =
        _discountController.text.trim().isNotEmpty
            ? int.parse(_discountController.text.trim())
            : null;
    final videoUrl = _videoUrlController.text.trim();

    final product = Product(
      id: widget.product?.id ?? 0,
      name: name,
      description: description.isEmpty ? null : description,
      price: price,
      quantity: quantity,
      category: _selectedCategory!,
      images: _imageUrls,
      discount: discount,
      videoUrl: videoUrl.isEmpty ? null : videoUrl,
    );

    if (widget.product != null) {
      // Edit existing product

      _productBloc.add(ProductUpdate(product: product));
    } else {
      // Add new produc
      _productBloc.add(ProductCreate(product: product));
    }
  }

  Widget _buildImageUrlsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Add new image URL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newImageUrlController,
                    decoration: InputDecoration(
                      hintText: "https://example.com/image.jpg",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addImageUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Dodaj"),
                ),
              ],
            ),
          ),

          // Display existing image URLs
          if (_imageUrls.isNotEmpty) ...[
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return _buildImageUrlItem(_imageUrls[index], index);
              },
            ),
          ],

          if (_imageUrls.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Dodajte URL-ove slika proizvoda",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageUrlItem(String imageUrl, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Image preview (if possible)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_outlined,
                    color: Colors.grey.shade500,
                    size: 20,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // URL text
          Expanded(
            child: Text(
              imageUrl,
              style: const TextStyle(fontSize: 14, color: Color(0xFF121212)),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Remove button
          IconButton(
            onPressed: () => _removeImageUrl(index),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  void _addImageUrl() {
    final url = _newImageUrlController.text.trim();
    if (url.isNotEmpty) {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.hasAbsolutePath) {
        setState(() {
          _imageUrls.add(url);
          _newImageUrlController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Molimo unesite valjan URL"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImageUrl(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }
}
