import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ListingItem extends Equatable {
  final String id;
  final String name;
  final String price;
  final String currency;
  final String image;

  ListingItem({
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

  @override
  List<Object> get props => [id, name, price, currency, image];

  @override
  String toString() {
    return 'ListingItem { id: $id, name: $name, price: $price, '
        'currency: $currency, image: $image }';
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
}
