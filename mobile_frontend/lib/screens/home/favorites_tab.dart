import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail_screen.dart';

// PUBLIC_INTERFACE
class FavoritesTab extends StatelessWidget {
  /// Favorites tab that lists locally bookmarked recipes.
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipeProvider, FavoritesProvider>(
      builder: (context, provider, favs, _) {
        final recipes = provider.recipes.where((r) => favs.isFavorite(r.id)).toList();
        if (recipes.isEmpty) {
          return const Center(child: Text('No favorites yet.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: recipes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .72,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final r = recipes[i];
            return RecipeCard(
              recipe: r,
              isFavorite: true,
              onFavoriteToggle: () => favs.toggleFavorite(r),
              onTap: () => Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: r.id),
            );
          },
        );
      },
    );
  }
}
