part of 'listing_item_bloc.dart';

abstract class ListingItemState extends Equatable {
  const ListingItemState();

  @override
  List<Object> get props => [];
}

class Empty extends ListingItemState {}

class Loading extends ListingItemState {}

class StoreLoad extends ListingItemState {
  final List<ListingItem> listingItemList;

  StoreLoad(this.listingItemList);

  @override
  List<Object> get props => [listingItemList];
}

class BasketLoad extends ListingItemState {
  final Map<String, int> basketMap;

  BasketLoad(this.basketMap);

  @override
  List<Object> get props => [basketMap];
}

class Order extends ListingItemState {
  final Map<String, int> basketMap;

  Order(this.basketMap);

  @override
  List<Object> get props => [basketMap];
}

class Error extends ListingItemState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
