import 'package:buy_buy/features/cart/widgets/cart_item_list_tile.dart';
import 'package:buy_buy/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartItemListTile Widget Tests', () {
    late Product sampleProduct;
    late CartItemDetail cartItem;

    setUp(() {
      sampleProduct = Product(
        id: 'p1',
        name: 'Sample Phone',
        description: 'A sample phone for testing',
        price: 150.0,
        imageUrls: ['https://invalid-url-for-test'],
        categoryId: '_all',
        brandId: '_brand',
        isBrandNew: true,
      );
      cartItem = CartItemDetail(product: sampleProduct, quantity: 2);
    });

    testWidgets('displays name, price and quantity', (WidgetTester tester) async {
      var tapped = false;
      var added = false;
      var removed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItemListTile(
              cartItem: cartItem,
              onTap: () => tapped = true,
              onAdd: () => added = true,
              onRemove: () => removed = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sample Phone'), findsOneWidget);

      expect(find.text('RM 150.00 each'), findsOneWidget);

      expect(find.text('Total: RM 300.00'), findsOneWidget);

      expect(find.text('2'), findsOneWidget);

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();
      expect(added, isTrue);

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pumpAndSettle();
      expect(removed, isTrue);

      await tester.tap(find.byType(CartItemListTile));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('if onAdd / onRemove is null, icons not showing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItemListTile(cartItem: cartItem, onTap: () {}, onAdd: null, onRemove: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('if imageUrl incorrect, show broken_image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItemListTile(cartItem: cartItem, onTap: () {}, onAdd: null, onRemove: null),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}
