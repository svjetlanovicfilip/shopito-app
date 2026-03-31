import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopito_app/config/constants.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/firebase_options.dart';

import 'app.dart';
import 'flavors.dart';

String baseUrl = '';
String baseImageUrl = '';

Future<void> main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  baseUrl = await Constants.baseUrl;
  baseImageUrl = await Constants.baseImageUrl;

  initDeps();

  runApp(const App());
}
