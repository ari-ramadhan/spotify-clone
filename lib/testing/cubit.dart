// lib/item_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemInitial());

  void addItem(String item) {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final updatedItems = List<String>.from(currentState.items)..add(item);
      emit(ItemLoaded(updatedItems));
    } else {
      emit(ItemLoaded([item]));
    }
  }
}
