import 'package:flutter/material.dart';

import '../../../../core/config/app_styles.dart';
import '../../../../core/widget/custom_text.dart';

class NoLecturesView extends StatelessWidget {
  const NoLecturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 250,
        ),
        const  Icon(Icons.library_books_outlined,
            size: 80, color: Colors.grey),
        const  SizedBox(height: 24),
        const  Center(
          child: CustomText(
            title: 'No lectures yet',
            fontSize: AppFontSize.f18,
            fontWeight: FontWeight.bold,
            txtColor: Colors.grey,
          ),
        ),
        const  SizedBox(height: 12),
        const  Center(
          child: CustomText(
            title: 'Tap + to create your first lecture',
            fontSize: AppFontSize.f14,
            txtColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
