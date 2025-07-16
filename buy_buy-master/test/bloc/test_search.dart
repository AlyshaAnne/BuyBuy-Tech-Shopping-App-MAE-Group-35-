import 'package:bloc_test/bloc_test.dart';
import 'package:buy_buy/features/explorer/bloc/search/search_bloc.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchBloc', () {
    final category = allCategory;

    final products = [
      Product(
        id: '1',
        name: 'IPhone',
        price: 2000.0,
        description: '',
        imageUrls: [],
        categoryId: '_all',
        brandId: '',
        isBrandNew: true,
      ),
      Product(
        id: '2',
        name: 'Xiaomi',
        price: 1500.0,
        description: '',
        imageUrls: [],
        categoryId: '_all',
        brandId: '',
        isBrandNew: false,
      ),
      Product(
        id: '3',
        name: 'POCO',
        price: 1500.0,
        description: '',
        imageUrls: [],
        categoryId: '_all',
        brandId: '',
        isBrandNew: true,
      ),
    ];

    late SearchBloc searchBloc;

    setUp(() {
      searchBloc = SearchBloc(productRepository: FakeProductRepository(products: products));
    });

    tearDown(() {
      searchBloc.close();
    });

    test('Initial state - SearchInitial', () {
      expect(searchBloc.state, isA<SearchInitial>());
    });

    blocTest<SearchBloc, SearchState>(
      'Emits SearchInitial on empty query',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchQueryChanged(category: category, query: '')),
      expect: () => <Matcher>[isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'Emits SearchInitial on multiple space query',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchQueryChanged(category: category, query: '     ')),
      expect: () => <Matcher>[isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'Emits [SearchLoading, SearchLoaded] on valid query',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchQueryChanged(category: category, query: 'I')),
      expect: () => <Matcher>[isA<SearchLoading>(), isA<SearchLoaded>()],
    );

    blocTest<SearchBloc, SearchState>(
      'Emits [SearchLoading, SearchLoaded with [] on empty result]',
      build: () {
        return SearchBloc(productRepository: FakeProductRepository(products: []));
      },
      act: (bloc) => bloc.add(SearchQueryChanged(query: 'random query', category: category)),
      expect: () => <Matcher>[isA<SearchLoading>(), predicate<SearchLoaded>((state) => state.filteredProducts.isEmpty)],
    );

    blocTest<SearchBloc, SearchState>(
      'Emits [SearchLoading, SearchLoadFailed] when repository throws',
      build: () {
        return SearchBloc(productRepository: FakeProductRepositoryWithError());
      },
      act: (bloc) => bloc.add(SearchQueryChanged(query: 'any', category: category)),
      expect: () => <Matcher>[isA<SearchLoading>(), isA<SearchLoadFailed>()],
    );
  });
}
