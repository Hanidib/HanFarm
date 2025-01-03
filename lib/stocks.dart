import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseURL = 'hanfarm111.atwebpages.com';

// Stock Data Model
class Stock {
  final int id;
  final int userId;
  final String stockType;
  final int quantity;

  Stock({
    required this.id,
    required this.userId,
    required this.stockType,
    required this.quantity,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: int.parse(json['id']),
      userId: int.parse(json['user_id']),
      stockType: json['stock_type'],
      quantity: int.parse(json['quantity']),
    );
  }
}

List<Stock> stocks = [];
List<Stock> filteredStocks = [];

Future<void> fetchStocks(Function(bool) update) async {
  try {
    final url = Uri.http(baseURL, 'stock.php', {'status': 'all'});
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as List;
      stocks = jsonResponse.map((json) => Stock.fromJson(json)).toList();
      filteredStocks = List.from(stocks);
      update(true);
    } else {
      update(false);
    }
  } catch (e) {
    update(false);
  }
}

Future<void> deleteStock(int id, BuildContext context) async {
  try {
    final url = Uri.http(baseURL, 'stock.php', {'status': 'delete', 'id': '$id'});
    final response = await http.post(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      fetchStocks((success) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Stock deleted successfully!' : 'Failed to delete stock')),
      ));
    } else {
      throw Exception('Failed to delete stock');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error deleting stock')),
    );
  }
}

Future<void> addStock(int userId, String stockType, int quantity, BuildContext context) async {
  try {
    final url = Uri.http(baseURL, 'stock.php', {'status': 'new'});
    final response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'stock_type': stockType,
        'quantity': quantity.toString(),
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock added successfully!')),
      );
    } else {
      throw Exception('Failed to add stock');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error adding stock')),
    );
  }
}

// Update stock record
Future<void> updateStock(int id, int userId, String stockType, int quantity, BuildContext context) async {
  try {
    final url = Uri.http(baseURL, 'stock.php', {'status': 'update', 'id': '$id'});
    final response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'stock_type': stockType,
        'quantity': quantity.toString(),
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock updated successfully!')),
      );
    } else {
      throw Exception('Failed to update stock');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error updating stock')),
    );
  }
}

// Stock List UI
class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStocks((success) {
      setState(() => isLoading = !success);
    });
  }

  void searchStocks(String query) {
    setState(() {
      filteredStocks = stocks
          .where((stock) => stock.stockType.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(title: const Text('Stock Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchStocks,
              decoration: const InputDecoration(
                labelText: 'Search by Stock Type',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredStocks.isEmpty
                ? const Center(child: Text('No stocks found'))
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredStocks.length,
              itemBuilder: (context, index) {
                final stock = filteredStocks[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(stock.stockType),
                    subtitle: Text('Quantity: ${stock.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateStockScreen(stock: stock),
                              ),
                            );
                            fetchStocks((success) => setState(() => isLoading = !success));
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteStock(stock.id, context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStockScreen()),
          );
          fetchStocks((success) => setState(() => isLoading = !success));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Add Stock Screen
class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _stockTypeController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter user ID' : null,
              ),
              TextFormField(
                controller: _stockTypeController,
                decoration: const InputDecoration(labelText: 'Stock Type'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter stock type' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addStock(
                      int.parse(_userIdController.text),
                      _stockTypeController.text,
                      int.parse(_quantityController.text),
                      context,
                    );
                  }
                },
                child: const Text('Add Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Update Stock Screen
class UpdateStockScreen extends StatefulWidget {
  final Stock stock;

  const UpdateStockScreen({super.key, required this.stock});

  @override
  State<UpdateStockScreen> createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _stockTypeController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.stock.userId.toString());
    _stockTypeController = TextEditingController(text: widget.stock.stockType);
    _quantityController = TextEditingController(text: widget.stock.quantity.toString());
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _stockTypeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter user ID' : null,
              ),
              TextFormField(
                controller: _stockTypeController,
                decoration: const InputDecoration(labelText: 'Stock Type'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter stock type' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateStock(
                      widget.stock.id,
                      int.parse(_userIdController.text),
                      _stockTypeController.text,
                      int.parse(_quantityController.text),
                      context,
                    );
                  }
                },
                child: const Text('Update Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
