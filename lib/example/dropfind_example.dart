import 'package:dropfind/dropfind.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DropFind Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ProductFormScreen(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

// Sample product data
class Product {
  final String id;
  final String name;
  final double price;
  final String? category;
  final String? brand;
  final int? stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.category,
    this.brand,
    this.stockQuantity,
  });
}

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  // Selected values
  String? _selectedCategory;
  String? _selectedBrand;
  
  // Sample data
  final List<Category> _categories = [
    const Category(
      id: 'electronics', 
      name: 'Electronics', 
      description: 'Electronic devices and gadgets', 
      icon: Icons.devices
    ),
    const Category(
      id: 'clothing', 
      name: 'Clothing', 
      description: 'Apparel and fashion items', 
      icon: Icons.checkroom
    ),
    const Category(
      id: 'furniture', 
      name: 'Furniture', 
      description: 'Home and office furniture', 
      icon: Icons.chair
    ),
    const Category(
      id: 'groceries', 
      name: 'Groceries', 
      description: 'Food and household items', 
      icon: Icons.shopping_basket
    ),
    const Category(
      id: 'sports', 
      name: 'Sports & Outdoors', 
      description: 'Sports equipment and outdoor gear', 
      icon: Icons.sports_basketball
    ),
    const Category(
      id: 'beauty', 
      name: 'Beauty & Personal Care', 
      description: 'Beauty products and personal care items', 
      icon: Icons.face
    ),
    const Category(
      id: 'books', 
      name: 'Books & Stationery', 
      description: 'Books, office supplies, and stationery', 
      icon: Icons.book
    ),
    const Category(
      id: 'toys', 
      name: 'Toys & Games', 
      description: 'Toys, games, and entertainment items', 
      icon: Icons.toys
    ),
  ];
  
  final List<String> _brands = [
    'Apple', 'Samsung', 'Sony', 'Nike', 'Adidas', 'IKEA', 
    'Amazon Basics', 'Google', 'Microsoft', 'LG', 'H&M', 
    'Zara', 'Nestlé', 'Coca-Cola', 'Dell', 'HP', 'Canon',
    'Nikon', 'Philips', 'Dyson', 'Bosch', 'Panasonic',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1024;
    final isLargeScreen = screenWidth >= 1024;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 1200 : (isMediumScreen ? 800 : screenWidth),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 16 : 24,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Product Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    
                    // Form Layout - Adapts based on screen size
                    if (isLargeScreen)
                      _buildLargeScreenForm()
                    else if (isMediumScreen)
                      _buildMediumScreenForm()
                    else
                      _buildSmallScreenForm(),
                    
                    const SizedBox(height: 32),
                    
                    // Submit button
                    Center(
                      child: SizedBox(
                        width: isSmallScreen ? double.infinity : 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text('Save Product'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Layout for large screens (desktop/large tablet)
  Widget _buildLargeScreenForm() {
    return Column(
      children: [
        // Row 1: Name and Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                hintText: 'Enter product name',
                validator: (value) => (value == null || value.isEmpty) 
                    ? 'Please enter a product name' 
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildTextField(
                controller: _priceController,
                label: 'Price',
                hintText: 'Enter price',
                prefixText: '\$',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Row 2: Category and Brand
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCategoryDropdown(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBrandDropdown(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Row 3: Stock
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _stockController,
                label: 'Stock Quantity',
                hintText: 'Enter quantity available',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Space for future field
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  // Layout for medium screens (tablet/landscape phone)
  Widget _buildMediumScreenForm() {
    return Column(
      children: [
        // Row 1: Name
        _buildTextField(
          controller: _nameController,
          label: 'Product Name',
          hintText: 'Enter product name',
          validator: (value) => (value == null || value.isEmpty) 
              ? 'Please enter a product name' 
              : null,
        ),
        const SizedBox(height: 16),
        
        // Row 2: Price and Stock
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: _priceController,
                label: 'Price',
                hintText: 'Enter price',
                prefixText: '\$',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _stockController,
                label: 'Stock Quantity',
                hintText: 'Enter quantity',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Row 3: Category and Brand
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCategoryDropdown(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBrandDropdown(),
            ),
          ],
        ),
      ],
    );
  }

  // Layout for small screens (phones)
  Widget _buildSmallScreenForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Product Name',
          hintText: 'Enter product name',
          validator: (value) => (value == null || value.isEmpty) 
              ? 'Please enter a product name' 
              : null,
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _priceController,
          label: 'Price',
          hintText: 'Enter price',
          prefixText: '\$',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        _buildCategoryDropdown(),
        const SizedBox(height: 16),
        
        _buildBrandDropdown(),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _stockController,
          label: 'Stock Quantity',
          hintText: 'Enter quantity available',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

  // Reusable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
        ),
      ],
    );
  }

  // Category dropdown with DropFind
  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropFind<Category>(
          hintText: 'Select a category',
          value: _selectedCategory,
          onChanged: (value, item) {
            setState(() {
              _selectedCategory = value;
            });
          },
          items: _categories,
          getLabel: (item) => item.name,
          getSearchableTerms: (item) => [item.name, item.description],
          buildListItem: (context, item, isSelected, isSmall) {
            return Row(
              children: [
                Icon(
                  item.icon,
                  size: isSmall ? 16 : 20,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).iconTheme.color,
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
                          fontSize: isSmall ? 14 : 16,
                        ),
                      ),
                      if (!isSmall) // Show description only on larger screens
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
          validator: (value) => value == null ? 'Please select a category' : null,
        ),
      ],
    );
  }

  // Brand dropdown with DropFind
  Widget _buildBrandDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropFind<String>(
          hintText: 'Select a brand',
          value: _selectedBrand,
          onChanged: (value, item) {
            setState(() {
              _selectedBrand = value;
            });
          },
          items: _brands,
          getLabel: (item) => item,
          getSearchableTerms: (item) => [item],
          buildListItem: (context, item, isSelected, isSmall) {
            return Row(
              children: [
                CircleAvatar(
                  radius: isSmall ? 10 : 12,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    item[0],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: isSmall ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: isSmall ? 8 : 12),
                Text(
                  item,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: isSmall ? 14 : 16,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Get form values
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final stockQuantity = int.tryParse(_stockController.text);
      
      // Create product object
      final product = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        category: _selectedCategory,
        brand: _selectedBrand,
        stockQuantity: stockQuantity,
      );
      
      // In a real app, you would save the product to a database
      // For now, just show a success dialog
      _showSuccessDialog(product);
    }
  }
  
  void _showSuccessDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${product.name}'),
            const SizedBox(height: 4),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            if (product.category != null) Text('Category: ${product.category}'),
            if (product.brand != null) ...[
              const SizedBox(height: 4),
              Text('Brand: ${product.brand}'),
            ],
            if (product.stockQuantity != null) ...[
              const SizedBox(height: 4),
              Text('Stock: ${product.stockQuantity}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form
              _formKey.currentState?.reset();
              _nameController.clear();
              _priceController.clear();
              _stockController.clear();
              setState(() {
                _selectedCategory = null;
                _selectedBrand = null;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}