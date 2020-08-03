import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/injection.dart';
import 'package:basket_app/presentation/bloc/listing_item_bloc.dart';
import 'package:basket_app/presentation/widgets/listing_item_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorePage extends StatelessWidget {
  final _bloc = getIt<ListingItemBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingItemBloc, ListingItemState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Flutter Basket App'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder(
              cubit: _bloc..add(LoadStoreEvent()),
              builder: (context, state) {
                if (state is Empty) {
                  return Container();
                } else if (state is Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is StoreLoad) {
                  return buildListingItemGrid(state.listingItemList);
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildListingItemGrid(List<ListingItem> _listingItemList) {
    return GridView.count(
        padding: EdgeInsets.all(8),
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        children: _listingItemList.map((listingItem) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListingItemGridItem(
                  listingItem: listingItem,
                ),
              ),
              RaisedButton(
                child: Text('Add to basket'),
                onPressed: () => _bloc.add(AddToBasketEvent(listingItem)),
              ),
            ],
          );
        }).toList());
  }
}
