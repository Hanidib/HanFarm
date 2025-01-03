import 'package:farmer/stocks.dart';
import 'package:farmer/tasks.dart';
import 'package:flutter/material.dart';
import 'animals.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final Map<String, int> animalCounts = {
    'Cow': 0,
    'Chicken': 0,
    'Goat': 0,
    'Sheep': 0,
  };

  final Map<String, int> stockCounts = {
    'Grass': 0,
    'Grains': 0,
    'Water': 0,
    'Vegetables': 0,
  };

  // Task variables
  final TextEditingController _taskController = TextEditingController();
  String _task = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
    else if(index==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnimalsScreen()),
      );

    }
    else if(index==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StocksScreen()),
      );

    }
    else if(index==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TasksScreen()),
      );

    }
  }


  // Increment animal count
  void incrementAnimalCount(String animal) {
    setState(() {
      animalCounts[animal] = animalCounts[animal]! + 1;
    });
  }

  // Increment stock count
  void incrementStockCount(String stock) {
    setState(() {
      stockCounts[stock] = stockCounts[stock]! + 1;
    });
  }

  // Update task when text is entered
  void _updateTask() {
    setState(() {
      _task = _taskController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/Hanfarm.JPG'),
                        radius: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    top: 10.0,
                    child: Text(
                      'HanFarm',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Animal Section
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Animals',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Cow'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Cow.jpg'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Chicken'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Chick.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Goat'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Goat.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Sheep'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Cheep.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // Stock Section
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Stocks',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Grass'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/grass.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Grains'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/grains.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Water'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/water.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Vegetables'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/vegetables.JPG'),
                      radius: 35,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Tasks Section
            const Row(
              children: [
                SizedBox(width: 5),
                Text(
                  'Tasks',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Task TextField
            Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 10),
              child: TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Enter a task',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (text) => _updateTask(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Task: $_task',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 8.0),
                  child: Text(
                    'Animal Counts',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.only(right: 10.0,left: 10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),

                  itemCount: animalCounts.length,
                  itemBuilder: (context, index) {
                    String animal = animalCounts.keys.elementAt(index);
                    int count = animalCounts[animal]!;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            animal,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

// Display stock counts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 8.0),
                  child: Text(
                    'Stock Counts',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                GridView.builder(

                  padding: const EdgeInsets.only(right: 10.0,left: 10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemCount: stockCounts.length,
                  itemBuilder: (context, index) {
                    String stock = stockCounts.keys.elementAt(index);
                    int count = stockCounts[stock]!;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stock,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.amber,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            backgroundColor: Colors.white,

            icon: Icon(Icons.home),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stocks',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}