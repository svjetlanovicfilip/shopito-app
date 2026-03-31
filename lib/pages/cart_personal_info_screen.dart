import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/pages/order_preview_screen.dart';

class CartPersonalInfoScreen extends StatefulWidget {
  const CartPersonalInfoScreen({super.key});

  @override
  State<CartPersonalInfoScreen> createState() => _CartPersonalInfoScreenState();
}

class _CartPersonalInfoScreenState extends State<CartPersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    final user = getIt<AuthBloc>().currentUser;
    _nameController = TextEditingController(text: user?.fullname);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _postalCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          color: const Color(0xFF3C8D2F),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Text(
                "Podaci za dostavu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: const Color(0xFFF5F5F5),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Podaci za dostavu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Unesite vaše podatke za dostavu narudžbe",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  _buildInputField(
                    controller: _nameController,
                    label: "Ime i prezime",
                    hint: "Unesite ime i prezime",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  _buildInputField(
                    controller: _emailController,
                    label: "Email",
                    hint: "unesite@email.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  _buildInputField(
                    controller: _phoneController,
                    label: "Broj telefona",
                    hint: "+387 65 123 456",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Country field
                  _buildInputField(
                    controller: _countryController,
                    label: "Država",
                    hint: "Srbija",
                    icon: Icons.flag_outlined,
                  ),
                  const SizedBox(height: 16),

                  // City field
                  _buildInputField(
                    controller: _cityController,
                    label: "Grad",
                    hint: "Novi Sad",
                    icon: Icons.location_city_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Address field
                  _buildInputField(
                    controller: _addressController,
                    label: "Adresa",
                    hint: "Ulica i broj",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Postal code field
                  _buildInputField(
                    controller: _postalCodeController,
                    label: "Poštanski broj",
                    hint: "21000",
                    icon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_validatePersonalInfo()) {
                  context.pushNamed(
                    Routes.orderPreview,
                    extra: OrderPreviewScreenArguments(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      country: _countryController.text,
                      city: _cityController.text,
                      address: _addressController.text,
                      postalCode: _postalCodeController.text,
                      orderItems:
                          getIt<CartBloc>().cartItems
                              .map(
                                (e) => OrderItem(
                                  productId: e.product.id,
                                  quantity: e.quantity,
                                  comment: '',
                                  discount: e.product.discount ?? 0,
                                ),
                              )
                              .toList(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3C8D2F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Nastavi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121212),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(icon, color: Colors.grey.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _validatePersonalInfo() {
    if (_nameController.text.trim().isEmpty) {
      _showError("Molimo unesite ime i prezime");
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError("Molimo unesite email");
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError("Molimo unesite broj telefona");
      return false;
    }
    if (_countryController.text.trim().isEmpty) {
      _showError("Molimo unesite državu");
      return false;
    }
    if (_cityController.text.trim().isEmpty) {
      _showError("Molimo unesite grad");
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError("Molimo unesite adresu");
      return false;
    }
    if (_postalCodeController.text.trim().isEmpty) {
      _showError("Molimo unesite poštanski broj");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
