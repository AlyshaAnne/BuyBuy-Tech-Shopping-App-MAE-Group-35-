import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.isFavorite, required this.onToggleFavorite, this.size = 24});

  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  final double size;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onToggleFavorite,
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
        padding: const EdgeInsets.all(6),
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: widget.size,
          color: widget.isFavorite ? theme.primaryColor : theme.hintColor,
        ),
      ),
    );
  }
}
