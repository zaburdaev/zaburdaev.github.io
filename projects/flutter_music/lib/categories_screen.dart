import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'l10n.dart';
import 'tracks_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  List<CategoryItem> getCategories() {
    return [
      CategoryItem(id: 'lofi', icon: Icons.music_note),
      CategoryItem(id: 'ambient', icon: Icons.waves),
      CategoryItem(id: 'nature', icon: Icons.nature),
      CategoryItem(id: 'radio', icon: Icons.radio),
      CategoryItem(id: 'noise', icon: Icons.noise_aware),
      CategoryItem(id: 'meditation', icon: Icons.self_improvement),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategories();
    final loc = AppLocalizations.of(context)!;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TracksScreen(category: category),
              ),
            );
          },
          child: Card(
            color: Colors.deepPurple.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 48,
                  color: Colors.deepPurple.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.categoryTitle(category.id),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}