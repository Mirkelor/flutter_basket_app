import 'package:basket_app/domain/listing_item.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ListingItemGridItem extends StatelessWidget {
  final ListingItem listingItem;

  const ListingItemGridItem({@required this.listingItem})
      : assert(listingItem != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(listingItem.image),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            listingItem.name,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            '${listingItem.price} ${listingItem.currency}',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
