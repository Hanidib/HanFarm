import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseURL = 'hanfarm111.atwebpages.com';

// Animal Data Model
class Animal {
  final int id;
  final int userId;
  final String animalType;
  final int count;
  final String healthStatus;

  Animal({
    required this.id,
    required this.userId,
    required this.animalType,
    required this.count,
    required this.healthStatus,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: int.parse(json['id']),
      userId: int.parse(json['user_id']),
      animalType: json['animal_type'],
      count: int.parse(json['count']),
      healthStatus: json['health_status'],
    );
  }
}

List<Animal> animals = [];
List<Animal> filteredAnimals = [];

// Fetch all animals
Future<void> fetchAnimals(Function(bool) update) async {
  try {
    final url = Uri.http(baseURL, 'animal.php', {'status': 'all'});
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as List;
      animals = jsonResponse.map((json) => Animal.fromJson(json)).toList();
      filteredAnimals = List.from(animals);
      update(true);
    } else {
      update(false);
    }
  } catch (e) {
    update(false);
  }
}

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAnimals((success) {
      setState(() => isLoading = !success);
    });
  }

  void deleteAnimal(int id) async {
    try {
      final url = Uri.http(baseURL, 'animal.php', {'status': 'delete', 'id': '$id'});
      final response = await http.post(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        fetchAnimals((success) => setState(() => isLoading = !success));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal deleted successfully!')),
        );
      } else {
        throw Exception('Failed to delete animal');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting animal')),
      );
    }
  }

  void searchAnimals(String query) {
    setState(() {
      filteredAnimals = animals
          .where((animal) => animal.animalType.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal Management')),
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchAnimals,
              decoration: const InputDecoration(
                labelText: 'Search by Animal Type',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAnimals.isEmpty
                ? const Center(child: Text('No animals found'))
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredAnimals.length,
              itemBuilder: (context, index) {
                final animal = filteredAnimals[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(animal.count.toString()),
                    ),
                    title: Text(animal.animalType),
                    subtitle: Text('Health: ${animal.healthStatus}'),
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
                                builder: (context) => UpdateAnimalScreen(animal: animal),
                              ),
                            );
                            fetchAnimals((success) => setState(() => isLoading = !success));
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteAnimal(animal.id),
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
            MaterialPageRoute(builder: (context) => const AddAnimalScreen()),
          );
          fetchAnimals((success) => setState(() => isLoading = !success));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _animalTypeController = TextEditingController();
  final _countController = TextEditingController();
  final _healthStatusController = TextEditingController();

  Future<void> addAnimal() async {
    try {
      final url = Uri.http(baseURL, 'animal.php', {'status': 'new'});
      final response = await http.post(
        url,
        body: {
          'user_id': _userIdController.text,
          'animal_type': _animalTypeController.text,
          'count': _countController.text,
          'health_status': _healthStatusController.text,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
      } else {
        throw Exception('Failed to add animal');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding animal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Animal')),
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
                controller: _animalTypeController,
                decoration: const InputDecoration(labelText: 'Animal Type'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter animal type' : null,
              ),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'Count'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter count' : null,
              ),
              TextFormField(
                controller: _healthStatusController,
                decoration: const InputDecoration(labelText: 'Health Status'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter health status' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addAnimal();
                  }
                },
                child: const Text('Add Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateAnimalScreen extends StatefulWidget {
  final Animal animal;

  const UpdateAnimalScreen({super.key, required this.animal});

  @override
  State<UpdateAnimalScreen> createState() => _UpdateAnimalScreenState();
}

class _UpdateAnimalScreenState extends State<UpdateAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _animalTypeController;
  late TextEditingController _countController;
  late TextEditingController _healthStatusController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.animal.userId.toString());
    _animalTypeController = TextEditingController(text: widget.animal.animalType);
    _countController = TextEditingController(text: widget.animal.count.toString());
    _healthStatusController = TextEditingController(text: widget.animal.healthStatus);
  }

  Future<void> updateAnimal() async {
    try {
      final url = Uri.http(baseURL, 'animal.php', {
        'status': 'update',
        'id': '${widget.animal.id}',  // Animal ID for update
      });

      final response = await http.post(
        url,
        body: {
          'user_id': _userIdController.text,
          'animal_type': _animalTypeController.text,
          'count': _countController.text,
          'health_status': _healthStatusController.text,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal updated successfully!')),
        );
      } else {
        throw Exception('Failed to update animal');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating animal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Animal')),
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
                controller: _animalTypeController,
                decoration: const InputDecoration(labelText: 'Animal Type'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter animal type' : null,
              ),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'Count'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Please enter count' : null,
              ),
              TextFormField(
                controller: _healthStatusController,
                decoration: const InputDecoration(labelText: 'Health Status'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter health status' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateAnimal();
                  }
                },
                child: const Text('Update Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
