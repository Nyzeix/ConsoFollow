import 'package:flutter/material.dart';

/// Objet de navigation.
class NavDestination {
  final String label;
  final IconData iconSelected;
  final IconData iconUnselected;
  final Widget screen;

  NavDestination({
    required this.label,
    required this.iconSelected,
    required this.iconUnselected,
    required this.screen,
  });

  BottomNavigationBarItem toNavigationBarItem() {
    return BottomNavigationBarItem(
      activeIcon: Icon(iconSelected),
      icon: Icon(iconUnselected),
      label: label,
    );
  }

  NavigationRailDestination toNavigationRailDestination() {
    return NavigationRailDestination(
      icon: Icon(iconUnselected),
      selectedIcon: Icon(iconSelected),
      label: Text(label),
    );
  }
  
}