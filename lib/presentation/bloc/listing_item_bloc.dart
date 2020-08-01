import 'dart:async';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/repository/listing_item_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'listing_item_event.dart';

part 'listing_item_state.dart';

class ListingItemBloc extends Bloc<ListingItemEvent, ListingItemState> {
  final ListingItemRepository repository;

  ListingItemBloc({
    @required this.repository,
  }) : super(Empty());

  @override
  Stream<ListingItemState> mapEventToState(
    ListingItemEvent event,
  ) async* {
    if (event is LoadStoreEvent) {
      yield Loading();
      yield* _mapLoadStoreEventToState();
    } else if (event is LoadBasketEvent) {
      yield Loading();
      yield* _mapLoadBasketEventToState();
    } else if (event is AddToBasketEvent) {
      await _mapAddToBasketEventToState(event);
    } else if (event is OrderEvent) {}
  }

  Stream<ListingItemState> _mapLoadStoreEventToState() async* {
    final failureOrListingItemList = await repository.getAll();
    yield failureOrListingItemList.fold(
      (failure) => Error(message: failure.message),
      (listingItemList) => StoreLoad(listingItemList),
    );
  }

  Stream<ListingItemState> _mapLoadBasketEventToState() async* {
    final failureOrListingItemList = await repository.getBasket();
    yield failureOrListingItemList.fold(
      (failure) => Error(message: failure.message),
      (basketMap) => BasketLoad(basketMap),
    );
  }

  Future<void> _mapAddToBasketEventToState(AddToBasketEvent event) async {
    await repository.addToBasket(event.listingItem);
  }

  Stream<ListingItemState> _mapOrderEventToState(OrderEvent event) async* {
    if (event.basketMap.containsKey('3')) {
      final outOfStockItem = await repository.getStoreItemById('3');
      yield Error(message: '$OUT_OF_STOCK_MESSAGE ${outOfStockItem.name}');
    } else {
      final successOrFailMessage = await repository.order(event.basketMap);
      yield successOrFailMessage.fold(
        (failure) => Error(message: failure.message),
        (success) => Empty(),
      );
    }
  }
}
