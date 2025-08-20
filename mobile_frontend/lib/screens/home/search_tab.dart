import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail_screen.dart';

// PUBLIC_INTERFACE
class SearchTab extends StatefulWidget {
  /// Search tab allowing query and filter usage.
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController();
  String? _difficultyFilter;

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final favorites = context.watch<FavoritesProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: 'Filter',
                icon: const Icon(Icons.filter_list),
                onSelected: (v) {
                  setState(() => _difficultyFilter = v == 'Any' ? null : v);
                  _search();
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'Any', child: Text('Any difficulty')),
                  const PopupMenuItem(value: 'Easy', child: Text('Easy')),
                  const PopupMenuItem(value: 'Medium', child: Text('Medium')),
                  const PopupMenuItem(value: 'Hard', child: Text('Hard')),
                ],
              )
            ],
          ),
        ),
        if (recipeProvider.isLoading) const LinearProgressIndicator(),
        Expanded(
          child: Builder(builder: (_) {
            if (recipeProvider.error != null) {
              return Center(child: Text(recipeProvider.error!));
            }
            final list = recipeProvider.recipes;
            if (list.isEmpty) {
              return const Center(child: Text('No results. Try searching.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .72,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (ctx, i) {
                final r = list[i];
                final isFav = favorites.isFavorite(r.id);
                return RecipeCard(
                  recipe: r,
                  isFavorite: isFav,
                  onFavoriteToggle: () => favorites.toggleFavorite(r),
                  onTap: () => Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: r.id),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _search() {
    final q = _controller.text.trim();
    final filters = <String, String>{};
    if (_difficultyFilter != null) {
      filters['difficulty'] = _difficultyFilter!;
    }
    context.read<RecipeProvider>().fetchRecipes(query: q, filters: filters.isEmpty ? null : filters);
  }
}
