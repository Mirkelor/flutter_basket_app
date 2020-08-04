import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/presentation/bloc/listing_item_bloc.dart';
import 'package:basket_app/presentation/widgets/basket_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';

class BasketPage extends StatelessWidget {
  final _bloc = getIt<ListingItemBloc>();
  Map<String, int> _basketMap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingItemBloc, ListingItemState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Basket Page'),
          ),
          body: Container(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder(
              cubit: _bloc..add(LoadBasketEvent()),
              builder: (context, state) {
                if (state is Empty) {
                  return Container();
                } else if (state is Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is BasketLoad) {
                  _basketMap = state.basketMap;
                  return buildListingItemList(state.listingItemList);
                }
                return Container();
              },
            ),
          ),
          floatingActionButton: RaisedButton(
            textTheme: ButtonTextTheme.accent,
            child: Text('Order'),
            onPressed: () => _bloc.add(OrderEvent(_basketMap)),
          ),
        );
      },
    );
  }

  Widget buildListingItemList(List<ListingItem> _listingItemList) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(thickness: 1),
        itemCount: _listingItemList.length,
        itemBuilder: (context, index) {
          final _listingItem = _listingItemList.elementAt(index);
          return BasketItem(
            listingItem: _listingItem,
            basketMap: _basketMap,
          );
        });
  }
}
