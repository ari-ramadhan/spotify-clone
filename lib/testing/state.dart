// lib/item_state.dart
part of 'cubit.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoaded extends ItemState {
  final List<String> items;

  const ItemLoaded(this.items);

  @override
  List<Object> get props => [items];
}
