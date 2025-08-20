import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/recipe/recipe_detail_screen.dart';
import 'theme/app_theme.dart';

// PUBLIC_INTERFACE
Future<void> main() async {
  /// Entry point for the Flutter app. Loads environment variables and runs the app with Providers.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const RecipeExplorerApp());
}

class RecipeExplorerApp extends StatelessWidget {
  const RecipeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.buildTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProxyProvider<AuthProvider, RecipeProvider>(
          create: (_) => RecipeProvider(),
          update: (_, auth, recipes) => recipes!..setAuthToken(auth.token),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Recipe Explorer',
            theme: theme,
            debugShowCheckedModeBanner: false,
            initialRoute: auth.isAuthenticated ? HomeScreen.routeName : LoginScreen.routeName,
            routes: {
              HomeScreen.routeName: (_) => const HomeScreen(),
              LoginScreen.routeName: (_) => const LoginScreen(),
              RegisterScreen.routeName: (_) => const RegisterScreen(),
              RecipeDetailScreen.routeName: (_) => const RecipeDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
