import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, required this.onTap, required this.controller});

  final VoidCallback onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.hintColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: theme.primaryColor),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Text(
                  controller.text.isEmpty ? 'Search products...' : controller.text,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.hintColor.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
