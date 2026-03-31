import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/config/router/router.dart';

showSuccessSnackBar(BuildContext context, String productName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$productName dodano u korpu!"),
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFF3C8D2F),
      action: SnackBarAction(
        label: "Vidi korpu",
        textColor: Colors.white,
        onPressed: () {
          context.goNamed(Routes.cart);
        },
      ),
    ),
  );
}
