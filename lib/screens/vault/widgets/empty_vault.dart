import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memoir/classes/assets.dart';
import 'package:memoir/extensions.dart';

/// Displays message when vault is empty
class EmptyVault extends StatelessWidget {
  const EmptyVault({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.emptyVault,
            width: context.mediaQuery.size.width * 0.5,
          ),
          const Gap(20),
          Text("Vault Empty!", style: context.textTheme.titleMedium),
          const Gap(10),
          Text(
            "Try adding new Container from below",
            style: context.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
