import 'package:basket_app/domain/listing_item.dart';
import 'package:meta/meta.dart';

class ListingItemModel {
  final String id;
  final String name;
  final String price;
  final String currency;
  final String image;

  ListingItemModel({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.currency,
    @required this.image,
  })  : assert(id != null),
        assert(name != null),
        assert(price != null),
        assert(currency != null),
        assert(image != null);

  ListingItemModel copyWith(
      {String id,
      String name,
      String price,
      String currency,
      String image}) {
    return ListingItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      image: image ?? this.image,
    );
  }

  factory ListingItemModel.fromDomain(ListingItem listingItem) {
    return ListingItemModel(
      id: listingItem.id,
      name: listingItem.name,
      price: listingItem.price,
      currency: listingItem.currency,
      image: listingItem.image,
    );
  }

  ListingItem toDomain() {
    return ListingItem(
      id: id,
      name: name,
      price: price,
      currency: currency,
      image: image,
    );
  }

  factory ListingItemModel.fromJson(Map<String, dynamic> json) {
    return ListingItemModel(
      id: json['id'].toString(),
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'ListingItemModel { id: $id, name: $name, price: $price, '
        'currency: $currency, image: $image }';
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      currency.hashCode ^
      image.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is ListingItemModel &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          currency == other.currency &&
          image == other.image;
}
