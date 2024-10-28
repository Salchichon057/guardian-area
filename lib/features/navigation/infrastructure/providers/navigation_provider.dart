import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int selectedIndex;
  NavigationState(this.selectedIndex);
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(0));

  void updateIndex(int index) {
    state = NavigationState(index);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
