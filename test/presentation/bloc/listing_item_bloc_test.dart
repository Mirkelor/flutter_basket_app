import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/presentation/bloc/listing_item_bloc.dart';
import 'package:basket_app/repository/listing_item_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockListingItemRepository extends Mock implements ListingItemRepository {}

void main() {
  ListingItemBloc bloc;
  MockListingItemRepository mockRepository;

  setUp(() {
    mockRepository = MockListingItemRepository();
    bloc = ListingItemBloc(repository: mockRepository);
  });

  group('listing item bloc tests', () {
    final listingItem = ListingItem(
        id: '1',
        name: 'test',
        price: '1',
        currency: 'try',
        image: 'test image url');
    final listingItemFail = ListingItem(
        id: '3',
        name: 'test fail',
        price: '1',
        currency: 'try',
        image: 'test image url');
    final List<ListingItem> listingItemList = [listingItem];
    final Map<String, int> testBasket1 = Map<String, int>();
    testBasket1['1'] = 1;
    final Map<String, int> testBasketFail = Map<String, int>();
    testBasketFail['3'] = 1;
    final String testErrorMessage = 'test error message';
    blocTest(
      'should emit [Loading, StoreLoad] when getting store items successfully',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.getAll())
            .thenAnswer((_) async => Right(listingItemList));
        bloc.add(LoadStoreEvent());
      },
      expect: [Loading(), StoreLoad(listingItemList)],
    );

    blocTest(
      'should emit [Loading, Error] when getting store items fail',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.getAll())
            .thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
        bloc.add(LoadStoreEvent());
      },
      expect: [Loading(), Error(message: testErrorMessage)],
    );

    blocTest(
      'should emit [Loading, BasketLoad] when getting basket items successfully',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.getBasket())
            .thenAnswer((_) async => Right(testBasket1));
        when(mockRepository.getStoreItemById(any)).thenReturn(listingItem);
        bloc.add(LoadBasketEvent());
      },
      expect: [Loading(), BasketLoad(testBasket1, listingItemList)],
    );

    blocTest(
      'should emit [Loading, Error] when getting basket items successfully',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.getBasket())
            .thenAnswer((_) async => Left(CacheFailure(testErrorMessage)));
        bloc.add(LoadBasketEvent());
      },
      expect: [Loading(), Error(message: testErrorMessage)],
    );

    blocTest(
      'should emit [] when adding basket items successfully',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.addToBasket(listingItem))
            .thenAnswer((_) async => null);
        bloc.add(AddToBasketEvent(listingItem));
      },
      expect: [],
    );

    blocTest(
      'should emit [Empty] when ordering basket items successfully',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.order(testBasket1))
            .thenAnswer((_) async => Right('successful'));
        bloc.add(OrderEvent(testBasket1));
      },
      expect: [Empty()],
    );

    blocTest(
      'should emit [Error] when ordering basket items fail',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.order(testBasket1))
            .thenAnswer((_) async => Left(ServerFailure(testErrorMessage)));
        bloc.add(OrderEvent(testBasket1));
      },
      expect: [Error(message: testErrorMessage)],
    );

    blocTest(
      'should emit [Error] when ordering out of stock basket item',
      build: () => bloc,
      act: (ListingItemBloc bloc) async {
        when(mockRepository.getStoreItemById(any))
            .thenReturn(listingItemFail);
        bloc.add(OrderEvent(testBasketFail));
      },
      expect: [Error(message: '$OUT_OF_STOCK_MESSAGE ${listingItemFail.name}')],
    );
  });
}
