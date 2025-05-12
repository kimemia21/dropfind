import 'package:dropfind/dropfind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DropFind widget', () {
    testWidgets('renders with initial state', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      
      await tester.pumpWidget(MaterialApp(
        home: DropFind<String>(
          hintText: 'Select item',
          value: null,
          onChanged: (_, __) {},
          items: items,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (_, item, isSelected, isSmall) => Text(item),
        ),
      ));

      expect(find.text('Select item'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('opens dropdown on tap', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      
      await tester.pumpWidget(MaterialApp(
        home: DropFind<String>(
          hintText: 'Select item', 
          value: null,
          onChanged: (_, __) {},
          items: items,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (_, item, isSelected, isSmall) => Text(item),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Others'), findsOneWidget);
    });

    testWidgets('filters items on search', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      
      await tester.pumpWidget(MaterialApp(
        home: DropFind<String>(
          hintText: 'Select item',
          value: null,
          onChanged: (_, __) {},
          items: items,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (_, item, isSelected, isSmall) => Text(item),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      await tester.enterText(find.byType(TextField), '1');
      await tester.pump();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsNothing);
    });

    testWidgets('shows validation error', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      
      await tester.pumpWidget(MaterialApp(
        home: DropFind<String>(
          hintText: 'Select item',
          value: null,
          onChanged: (_, __) {},
          items: items,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (_, item, isSelected, isSmall) => Text(item),
          validator: (_) => 'Required field',
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('selects item on tap', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      String? selectedValue;
      
      await tester.pumpWidget(MaterialApp(
        home: DropFind<String>(
          hintText: 'Select item',
          value: selectedValue,
          onChanged: (val, _) => selectedValue = val,
          items: items,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (_, item, isSelected, isSmall) => Text(item),
        ),
      ));

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      await tester.tap(find.text('Item 1'));
      await tester.pump();

      expect(selectedValue, equals('Item 1'));
      expect(find.text('Item 1'), findsOneWidget);
    });
  });
}