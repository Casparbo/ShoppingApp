import 'package:flutter/material.dart';

Color themeColor = Colors.teal.shade900;

class Home extends StatelessWidget {
  const Home ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping App',
      home: MyHomePage(title: 'Shopping App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  late final TabController _tabController;
  List<String> locations = <String>["Lidl", "Fridge"];
  String selectedLocation = "";

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedLocation = locations.first;
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(widget.title),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const <Widget>[
            Tab(
              child: Text("Shopping"),
            ),
            Tab(
              child: Text("Storage"),
            )
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Text("Inb4 Shopping Items"),
          ),
          Center(
            child: Text("Inb4 Storage Items")
          ,)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeColor,
        child: DropdownMenu<String>(
          textStyle: const TextStyle(color: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            suffixIconColor: Colors.white,
          ),
          width: double.infinity,
          initialSelection: selectedLocation,
          onSelected: (String? value) {
            setState(() {
              selectedLocation = value!;
            });
          },
          dropdownMenuEntries: locations.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ),
    );
  }
}
