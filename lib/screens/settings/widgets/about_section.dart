import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/extensions.dart';

// About Information
class AboutSettingSection extends StatelessWidget {
  const AboutSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "About",
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Author",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Ammar Rangwala',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Version",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Text("1.1.0"),
            ],
          ),
        ),
      ],
    );
  }
}
