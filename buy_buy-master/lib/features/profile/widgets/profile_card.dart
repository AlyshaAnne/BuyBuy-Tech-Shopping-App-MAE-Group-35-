import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile, this.nameBuilder, this.genderBuilder});

  final Profile profile;
  final WidgetBuilder? nameBuilder;
  final WidgetBuilder? genderBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: theme.hintColor),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: theme.cardColor),
              child: CircleAvatar(
                radius: 64,
                foregroundImage: NetworkImage(profile.avatarUrl),
                backgroundColor: theme.scaffoldBackgroundColor,
                child: const Icon(Icons.person_outlined, size: 96),
              ),
            ),
          ),
          SizedBox(height: 24),
          nameBuilder != null ? nameBuilder!(context) : Text(profile.name, style: theme.textTheme.titleLarge),
          Text(profile.email, style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor)),
          SizedBox(height: 8),
          genderBuilder != null
              ? genderBuilder!(context)
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profile.gender.icon,
                  const SizedBox(width: 4),
                  Text(profile.gender.description, style: theme.textTheme.bodyLarge),
                ],
              ),
        ],
      ),
    );
  }
}
