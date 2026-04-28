import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'tabs/plant_encyclopedia_tab.dart';
import 'tabs/organic_recipes_tab.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('তথ্য ভাণ্ডার 📚',
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'গাছপালা'),
              Tab(text: 'সার ও কীটনাশক'),
              Tab(text: 'সাথী রোপণ'),
              Tab(text: 'পোকামাকড়'),
              Tab(text: 'টিপস'),
              Tab(text: 'ভিডিও'),
              
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PlantEncyclopediaTab(),
            OrganicRecipesTab(),
            Center(child: Text('সাথী রোপণ গাইড শীঘ্রই আসছে...')),
            Center(child: Text('পোকামাকড় দমন গাইড শীঘ্রই আসছে...')),
            Center(child: Text('বাগান টিপস শীঘ্রই আসছে...')),
            Center(child: Text('ভিডিও টিউটোরিয়াল শীঘ্রই আসছে...')),
           
          ],
        ),
      ),
    );
  }
}
