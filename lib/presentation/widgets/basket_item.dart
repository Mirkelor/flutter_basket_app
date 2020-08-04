import 'package:basket_app/domain/listing_item.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class BasketItem extends StatelessWidget {
  final ListingItem listingItem;
  final Map<String, int> basketMap;

  const BasketItem({
    @required this.listingItem,
    @required this.basketMap,
  })  : assert(listingItem != null),
        assert(basketMap != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.black12,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent,
                          radius: 10,
                          child: IconButton(
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          shape: BoxShape.rectangle,
                        ),
                        child: Text('${basketMap[listingItem.id]}'),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.black12,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent,
                          radius: 10,
                          child: IconButton(
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  listingItem.name,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  '${listingItem.price} ${listingItem.currency}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
