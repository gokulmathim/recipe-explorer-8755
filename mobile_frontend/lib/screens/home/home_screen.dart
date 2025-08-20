import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail_screen.dart';
import 'search_tab.dart';
import 'favorites_tab.dart';

// PUBLIC_INTERFACE
class HomeScreen extends StatefulWidget {
  /// Main shell screen with bottom navigation: Home, Search, Favorites.
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Prefetch recipes for Home tab
    Future.microtask(() => context.read<RecipeProvider>().fetchRecipes());
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _HomeTab(onOpenRecipe: _openRecipe),
      const SearchTab(),
      const FavoritesTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }

  void _openRecipe(String id) {
    Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: id);
  }
}

class _HomeTab extends StatelessWidget {
  final void Function(String id) onOpenRecipe;
  const _HomeTab({required this.onOpenRecipe});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipeProvider, FavoritesProvider>(
      builder: (context, provider, favs, _) {
        if (provider.isLoading && provider.recipes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }
        if (provider.recipes.isEmpty) {
          return Center(
            child: TextButton.icon(
              onPressed: () => provider.fetchRecipes(),
              icon: const Icon(Icons.refresh),
              label: const Text('No recipes. Tap to retry'),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: GridView.builder(
            itemCount: provider.recipes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (_, i) {
              final r = provider.recipes[i];
              final isFav = favs.isFavorite(r.id);
              return RecipeCard(
                recipe: r,
                isFavorite: isFav,
                onFavoriteToggle: () => favs.toggleFavorite(r),
                onTap: () => onOpenRecipe(r.id),
              );
            },
          ),
        );
      },
    );
  }
}
