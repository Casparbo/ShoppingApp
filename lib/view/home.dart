import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';
import 'package:shopping_app/view/item_list.dart';

Color themeColor = Colors.teal.shade900;

class Home extends StatelessWidget {
  const Home ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shoppymara',
      home: MyHomePage(title: 'Shoppymara'),
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

  HashSet<String> stores = HashSet<String>();
  HashSet<String> locations = HashSet<String>();
  String selectedLocation = "";
  String selectedStore = "";
  bool storeView = true;

  List<Item> items = <Item>[
    Item(name: "Milk", store: "Lidl", location: "Fridge"),
    Item(name: "Oats", store: "Aldi", location: "Regal"),
    Item(name: "Lube", store: "Lidl", location: "Regal")
  ];

  void setItemStocked(Item item, bool value) {
    setState(() {
      item.stocked = value;
    });
  }

  void deleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  void loadStoresLocations() {
    for(final Item(:store, :location) in items) {
      stores.add(store);
      locations.add(location);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener((){
      if(!_tabController.indexIsChanging) {
        setState(() {
          storeView = !storeView;
        });
      }
    });

    loadStoresLocations();
    selectedLocation = locations.first;
    selectedStore = stores.first;
  }

  @override
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
        children: <Widget>[
          // Shopping
          Center(
            child: ItemList(
              themeColor: themeColor,
              items: items.where((Item value) {
                return value.store == selectedStore && !value.stocked;
              }).toList(),
              setItemStocked: setItemStocked,
              deleteItem: deleteItem,
            ),
          ),
          // Storage
          Center(
            child: ItemList(
              themeColor: themeColor,
              items: items.where((Item value) {
                return value.location == selectedLocation;
              }).toList(),
              setItemStocked: setItemStocked,
              deleteItem: deleteItem,
            )
          ,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
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
          initialSelection: (storeView ? selectedStore : selectedLocation),
          onSelected: (String? value) {
            setState(() {
              if(storeView) {
                selectedStore = value!;
              } else {
                selectedLocation = value!;
              }
            });
          },
          dropdownMenuEntries: (storeView ? stores : locations).map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ),
    );
  }
}
