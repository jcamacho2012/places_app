import 'package:flutter/material.dart';
import 'package:places_app/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:places_app/src/services/services.dart' show PlacesServices;

class MainAPP extends StatelessWidget {
  const MainAPP({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FMS APP',
      // theme: AppTheme.ligthTheme,
      routes: getRoutes(),
      initialRoute: 'home',
    );
  }
}

class APPState extends StatelessWidget {
  const APPState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlacesServices(), lazy: false),
        // ChangeNotifierProvider(create: (_) => CitasDPService(), lazy: false),
        // ChangeNotifierProvider(create: (_) => DepositoService(), lazy: false),
      ],
      child: const MainAPP(),
    );
  }
}
