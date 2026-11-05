import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductEvent {}

class FilterCategoryEvent extends ProductEvent {
  final String category;
  const FilterCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class SearchProductEvent extends ProductEvent {
  final String query;
  const SearchProductEvent(this.query);
  @override
  List<Object?> get props => [query];
}