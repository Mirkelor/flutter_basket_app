part of 'listing_item_bloc.dart';

abstract class ListingItemEvent extends Equatable {
  const ListingItemEvent();

  @override
  List<Object> get props => [];
}

class LoadStoreEvent extends ListingItemEvent {}

class LoadBasketEvent extends ListingItemEvent {}

class AddToBasketEvent extends ListingItemEvent {
  final ListingItem listingItem;

  AddToBasketEvent(this.listingItem);

  @override
  List<Object> get props => [listingItem];
}

class OrderEvent extends ListingItemEvent {
  final Map<String, int> basketMap;

  OrderEvent(this.basketMap);

  @override
  List<Object> get props => [basketMap];
}
