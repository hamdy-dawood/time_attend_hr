import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_text.dart';
import 'table_pagination_container.dart';

class CustomPaginationTable extends StatelessWidget {
  const CustomPaginationTable({
    super.key,
    required this.onTapNext,
    required this.onTapPrevious,
    required this.onTapNumber,
    required this.pagesCount,
    required this.currentPage,
  });

  final void Function() onTapNext;
  final void Function() onTapPrevious;
  final void Function(int number) onTapNumber;
  final int pagesCount;
  final int currentPage;

  List<int> buildPages({
    required int pagesCount,
    required int currentPage,
    int delta = 2,
  }) {
    if (pagesCount <= 8) {
      return List.generate(pagesCount, (i) => i + 1);
    }

    final List<int> pages = [];
    pages.add(1);

    final int start = (currentPage - delta).clamp(2, pagesCount - 1);
    final int end = (currentPage + delta).clamp(2, pagesCount - 1);

    if (start > 2) {
      pages.add(-1); // ellipsis
    }

    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    if (end < pagesCount - 1) {
      pages.add(-1); // ellipsis
    }

    pages.add(pagesCount);
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pagesToDisplay = buildPages(
      pagesCount: pagesCount,
      currentPage: currentPage,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // PREVIOUS BUTTON (hidden on first page)
          if (currentPage > 1)
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: AppColors.black.withOpacity(0.16),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              onPressed: onTapPrevious,
              child: const CustomText(
                text: "السابق",
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (currentPage > 1) const SizedBox(width: 20),

          // PAGE NUMBERS
          ...pagesToDisplay.map(
            (page) {
              if (page == -1) {
                // Ellipsis marker
                return const Text('...');
              } else {
                // Actual page number
                return TablePaginationContainer(
                  onTap: () {
                    if (page == currentPage) return;
                    onTapNumber(page);
                  },
                  number: "$page",
                  selected: currentPage == page,
                );
              }
            },
          ),

          const SizedBox(width: 20),

          // NEXT BUTTON (hidden on last page)
          if (currentPage < pagesCount)
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: AppColors.black.withOpacity(0.16),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              onPressed: onTapNext,
              child: const CustomText(
                text: "التالي",
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
