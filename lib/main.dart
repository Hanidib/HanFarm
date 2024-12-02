import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Maps for animal and stock counts
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                        backgroundImage: AssetImage('images/Hanfarm.JPG'),
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
                      backgroundImage: AssetImage('images/Cow.jpg'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Chicken'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/Chick.JPG'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Goat'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/Goat.JPG'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => incrementAnimalCount('Sheep'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/Cheep.JPG'),
                      radius: 25,
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
                      backgroundImage: AssetImage('images/grass.JPG'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Grains'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/grains.JPG'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Water'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/water.JPG'),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: GestureDetector(
                    onTap: () => incrementStockCount('Vegetables'),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/vegetables.JPG'),
                      radius: 25,
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
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: SizedBox(
                height: 35.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a task',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Display animal and stock counts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: animalCounts.entries.map((entry) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: stockCounts.entries.map((entry) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Stocks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.transparent,
        onTap: _onItemTapped,
      ),
    );
  }
}
