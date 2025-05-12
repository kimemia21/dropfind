import 'package:flutter/material.dart';

class DropFind<T> extends StatefulWidget {
  final String hintText;
  final String? value;
  final Function(String?, T?) onChanged;
  final List<T> items;
  final String Function(T) getLabel;
  final List<String> Function(T) getSearchableTerms;
  final Widget Function(BuildContext, T, bool, bool) buildListItem;
  final String? Function(String?)? validator;

  const DropFind({
    Key? key, // Added key parameter
    required this.hintText,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.getLabel,
    required this.getSearchableTerms,
    required this.buildListItem,
    this.validator,
  }) : super(key: key); // Pass key to super

  @override
  DropFindState<T> createState() => DropFindState<T>();
}

class DropFindState<T> extends State<DropFind<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<T>> _filteredItems = ValueNotifier<List<T>>([]);
  final ValueNotifier<bool> _isOpen = ValueNotifier<bool>(false);
  bool _isTouched = false;

  @override
  void initState() {
    super.initState();
    _filteredItems.value = widget.items;
  }

  @override
  void didUpdateWidget(DropFind<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems.value = widget.items;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredItems.dispose();
    _isOpen.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _filteredItems.value = widget.items;
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredItems.value =
          widget.items.where((item) {
            return widget
                .getSearchableTerms(item)
                .any((term) => term.toLowerCase().contains(lowercaseQuery));
          }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return FormField<String>(
      initialValue: widget.value,
      validator: (val) {
        if (_isTouched && widget.validator != null) {
          return widget.validator!(val);
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.hasError 
                      ? theme.colorScheme.error 
                      : theme.dividerColor,
                ),
                borderRadius: BorderRadius.circular(8),
                color: theme.cardColor,
              ),
              child: Column(
                children: [
                  // Added Material widget here to fix the "No Material widget found" error
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isTouched = true;
                          _isOpen.value = !_isOpen.value;
                          if (!_isOpen.value) {
                            _searchController.clear();
                            _filteredItems.value = widget.items;
                          }
                        });
                        state.didChange(widget.value);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _isOpen,
                                builder: (context, isOpen, _) {
                                  if (isOpen) {
                                    return TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: "Search...",
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                          color: theme.hintColor,
                                          fontSize: isSmallScreen ? 14 : 16,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                      onChanged: _performSearch,
                                      autofocus: true,
                                    );
                                  } else {
                                    return Text(
                                      widget.value ?? widget.hintText,
                                      style: TextStyle(
                                        color: widget.value == null
                                            ? theme.hintColor
                                            : theme.textTheme.bodyLarge?.color,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                },
                              ),
                            ),
                            Icon(
                              _isOpen.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: theme.iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Dropdown list
                  ValueListenableBuilder<bool>(
                    valueListenable: _isOpen,
                    builder: (context, isOpen, _) {
                      if (!isOpen) return const SizedBox.shrink();

                      // Modified to use a LimitedBox to fix the "RenderFlex overflowed" error
                      return LimitedBox(
                        maxHeight: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: theme.dividerColor),
                            ),
                          ),
                          child: ValueListenableBuilder<List<T>>(
                            valueListenable: _filteredItems,
                            builder: (context, items, _) {
                              if (items.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "No items found",
                                      style: TextStyle(
                                        color: theme.hintColor,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Using SingleChildScrollView to handle potential overflow
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Item list
                                    ...items.map((item) {
                                      final isSelected = widget.value == widget.getLabel(item);
                                      
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            final label = widget.getLabel(item);
                                            widget.onChanged(label, item);
                                            state.didChange(label);
                                            setState(() {
                                              _isOpen.value = false;
                                              _searchController.clear();
                                              _filteredItems.value = widget.items;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isSmallScreen ? 8 : 12,
                                              vertical: isSmallScreen ? 8 : 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected 
                                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                                  : Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: theme.dividerColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: widget.buildListItem(
                                              context,
                                              item,
                                              isSelected,
                                              isSmallScreen,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),

                                    // Others option
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          widget.onChanged("Others", null);
                                          state.didChange("Others");
                                          setState(() {
                                            _isOpen.value = false;
                                            _searchController.clear();
                                            _filteredItems.value = widget.items;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isSmallScreen ? 8 : 12,
                                            vertical: isSmallScreen ? 8 : 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: widget.value == "Others"
                                                ? theme.colorScheme.primary.withOpacity(0.1)
                                                : Colors.transparent,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: theme.dividerColor,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Others",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 14 : 16,
                                              fontWeight: widget.value == "Others" ? FontWeight.bold : FontWeight.normal,
                                              color: theme.textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
              
                ],
              ),
            ),

            // Error message
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}