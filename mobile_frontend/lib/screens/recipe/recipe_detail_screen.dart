import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../models/recipe.dart';

// PUBLIC_INTERFACE
class RecipeDetailScreen extends StatefulWidget {
  /// Detailed recipe page showing image, ingredients, and steps.
  static const routeName = '/recipe';
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? _recipe;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)?.settings.arguments?.toString();
    if (id != null && _recipe == null) {
      _fetch(id);
    }
  }

  Future<void> _fetch(String id) async {
    setState(() => _loading = true);
    final r = await context.read<RecipeProvider>().fetchRecipeDetail(id);
    setState(() {
      _recipe = r;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final r = _recipe;
    if (r == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Recipe not found. Go back'),
          ),
        ),
      );
    }
    final isFav = favs.isFavorite(r.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(r.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: () => favs.toggleFavorite(r),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => favs.toggleFavorite(r),
        icon: Icon(isFav ? Icons.bookmark_remove : Icons.bookmark_add_outlined),
        label: Text(isFav ? 'Remove Favorite' : 'Save Favorite'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                r.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Meta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (r.duration != null)
                    _metaChip(context, Icons.timer_outlined, '${r.duration} min'),
                  const SizedBox(width: 8),
                  if (r.difficulty != null)
                    _metaChip(context, Icons.local_fire_department_outlined, r.difficulty!),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(r.description, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: 16),
            // Ingredients
            _sectionTitle(context, 'Ingredients'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: r.ingredients.map((i) => _bullet(i)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Steps
            _sectionTitle(context, 'Steps'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (int i = 0; i < r.steps.length; i++)
                    _stepItem(i + 1, r.steps[i]),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _metaChip(BuildContext context, IconData icon, String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: cs.secondary),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: cs.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline, size: 18),
      title: Text(text),
      visualDensity: const VisualDensity(vertical: -2),
    );
  }

  Widget _stepItem(int index, String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 14,
        child: Text('$index', style: const TextStyle(fontSize: 12)),
      ),
      title: Text(text),
      subtitle: const Divider(height: 20),
    );
  }
}
