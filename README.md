# DropFind Widget

DropFind is a highly customizable, searchable dropdown widget for Flutter that provides a modern user experience with features like filtering, searching, and custom item rendering.

## Features

- **Searchable dropdown** with real-time filtering
- **Custom item rendering** for maximum flexibility
- **Responsive design** that adapts to different screen sizes
- **Form validation** integration
- **"Others" option** built-in
- **Keyboard navigation** support
- **Customizable styling** to match your app's theme

## Usage

### Basic Example

```dart
DropFind<String>(
  hintText: 'Select an item',
  value: selectedValue,
  onChanged: (value, item) {
    setState(() {
      selectedValue = value;
    });
  },
  items: ['Item 1', 'Item 2', 'Item 3'],
  getLabel: (item) => item,
  getSearchableTerms: (item) => [item],
  buildListItem: (context, item, isSelected, isSmall) => Text(item),
)
```

### Advanced Example with Custom Items

```dart
DropFind<Category>(
  hintText: 'Select a category',
  value: selectedCategory,
  onChanged: (value, item) {
    setState(() {
      selectedCategory = value;
    });
  },
  items: categories,
  getLabel: (item) => item.name,
  getSearchableTerms: (item) => [item.name, item.description],
  buildListItem: (context, item, isSelected, isSmall) {
    return Row(
      children: [
        Icon(
          item.icon,
          size: isSmall ? 16 : 20,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        SizedBox(width: isSmall ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  },
  validator: (value) => value == null ? 'Please select a category' : null,
)
```

## API Reference

### Constructor

```dart
DropFind<T>({
  Key? key,
  required String hintText,
  required String? value,
  required Function(String?, T?) onChanged,
  required List<T> items,
  required String Function(T) getLabel,
  required List<String> Function(T) getSearchableTerms,
  required Widget Function(BuildContext, T, bool, bool) buildListItem,
  String? Function(String?)? validator,
})
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `hintText` | `String` | Text to display when no item is selected |
| `value` | `String?` | Currently selected value |
| `onChanged` | `Function(String?, T?)` | Callback when selection changes |
| `items` | `List<T>` | List of items to display in the dropdown |
| `getLabel` | `String Function(T)` | Function to extract display label from an item |
| `getSearchableTerms` | `List<String> Function(T)` | Function to extract terms for searching |
| `buildListItem` | `Widget Function(BuildContext, T, bool, bool)` | Function to build each item's UI |
| `validator` | `String? Function(String?)?` | Optional form validator function |

### buildListItem Parameters

The `buildListItem` function receives these parameters:

- `context`: The BuildContext
- `item`: The item to render
- `isSelected`: Whether this item is currently selected
- `isSmall`: Whether to use a compact layout (for small screens)

## Responsive Design

The widget automatically adapts to different screen sizes:

- **Small screens**: Optimized for touch interaction
- **Large screens**: More detailed display with additional information

## Validation

DropFind integrates with Flutter's Form validation:

```dart
DropFind<String>(
  // ... other parameters
  validator: (value) => value == null ? 'Please select an item' : null,
)
```

## Styling

The widget takes styling cues from the current Theme and supports customization through the `buildListItem` function.

## Implementation Notes

- Uses Material design for ink effects
- Manages overflow with scroll views
- Handles state changes efficiently
- Supports form validation

## Best Practices

1. **Clear Labels**: Provide descriptive hint text
2. **Search Terms**: Include relevant terms for better searchability
3. **Responsive Design**: Use the `isSmall` parameter to adapt your UI
4. **Validation**: Add validators for required fields
5. **Custom Rendering**: Take advantage of the flexible item rendering

## Common Patterns

### Category Selection
Perfect for selecting from a categorized list with icons and descriptions.

### Complex Data
Works well with complex data objects by extracting searchable terms.

### Form Integration
Integrates seamlessly with Flutter's Form validation system.