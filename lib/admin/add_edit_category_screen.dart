import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/theme/colors.dart';
import 'package:shopito_app/data/models/category.dart';

class AddEditCategoryScreen extends StatefulWidget {
  const AddEditCategoryScreen({super.key, this.category});

  final Category? category;

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryBloc _categoryBloc = getIt<CategoryBloc>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();

    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description ?? '';
      _imageUrlController.text = widget.category!.image ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      isEditing ? 'Uredi kategoriju' : 'Dodaj kategoriju',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: BlocListener<CategoryBloc, CategoryState>(
                  bloc: _categoryBloc,
                  listener: (context, state) {
                    if (state is CategoryOperationInProgress) {
                      setState(() => _isLoading = true);
                    } else if (state is CategoryOperationSuccess) {
                      setState(() => _isLoading = false);
                      context.pop(true);
                    } else if (state is CategoryOperationFailure) {
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
                          _buildInputSection(
                            'Naziv kategorije',
                            _buildTextFormField(
                              controller: _nameController,
                              hintText: 'Unesite naziv kategorije',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Naziv kategorije je obavezan';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputSection(
                            'Opis (opcionalno)',
                            _buildTextFormField(
                              controller: _descriptionController,
                              hintText: 'Unesite opis',
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputSection(
                            'Slika (URL, opcionalno)',
                            _buildTextFormField(
                              controller: _imageUrlController,
                              hintText: 'https://example.com/image.jpg',
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final uri = Uri.tryParse(value);
                                  if (uri == null || !uri.hasAbsolutePath) {
                                    return 'Unesite valjan URL';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveCategory,
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
                                            ? 'Ažuriraj kategoriju'
                                            : 'Dodaj kategoriju',
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
      decoration: InputDecoration(
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
          borderSide: const BorderSide(color: Color(0xFF3C8D2F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    final category = Category(
      id: widget.category?.id ?? 0,
      name: name,
      description: description.isEmpty ? null : description,
      image: imageUrl.isEmpty ? null : imageUrl,
    );

    if (widget.category != null) {
      _categoryBloc.add(CategoryUpdate(category: category));
    } else {
      _categoryBloc.add(CategoryCreate(category: category));
    }
  }
}
