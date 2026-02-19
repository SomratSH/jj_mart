import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/auth/login_page.dart';
import 'package:jj_mart/presentation/auth/splash_screen.dart';
import 'package:jj_mart/provider/auth_provider/auth_provider.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:jj_mart/provider/category_provider/category_provider.dart';
import 'package:jj_mart/provider/home_provider/home_provider.dart';
import 'package:jj_mart/provider/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => HomeProvider()
            ..getSliders()
            ..getOfferProducts()
            ..fetchTopSellingProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider()..fetchProfile(),
        ),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..fetchProfile()..getCartApi()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(), home: SplashScreen());
  }
}
