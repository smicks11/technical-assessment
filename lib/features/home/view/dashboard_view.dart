import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'home_tab_view.dart';
import 'cards_placeholder_view.dart';
import 'transactions_placeholder_view.dart';
import 'more_placeholder_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.credit_card_rounded, label: 'Cards'),
    _NavItem(icon: Icons.swap_horiz_rounded, label: 'Transactions'),
    _NavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTabView(),
          CardsPlaceholderView(),
          TransactionsPlaceholderView(),
          MorePlaceholderView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final selected = _currentIndex == i;
                return InkWell(
                  onTap: () => setState(() => _currentIndex = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 24,
                          color: selected ? AppColors.primary : AppColors.subtitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: selected ? AppColors.primary : AppColors.subtitle,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
