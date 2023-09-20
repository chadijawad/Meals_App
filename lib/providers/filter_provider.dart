import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum filter {
  gluteenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<filter, bool>> {
  FiltersNotifier()
      : super({
          filter.gluteenFree: false,
          filter.lactoseFree: false,
          filter.vegetarian: false,
          filter.vegan: false,
        });
  void setFilters(Map<filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void SetFilter(filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<filter, bool>>(
        (ref) => FiltersNotifier());

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[filter.gluteenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
