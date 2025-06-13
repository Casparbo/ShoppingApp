import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:shopping_app/model/item.dart';
import 'package:shopping_app/view/create_item.dart';
import 'package:shopping_app/view/item_view.dart';
import 'package:shopping_app/model/item_storage.dart';

Color themeColor = Colors.teal.shade900;

class Home extends StatelessWidget {
  const Home ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Groceries',
      home: MyHomePage(title: 'Groceries'),
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

  late ItemStorage storage;
  List<Item> items = <Item>[];

  void setItemStocked(Item item, bool value) {
    setState(() {
      item.stocked = value;
      loadStoresLocations();
    });
    storage.writeItems(items);
  }

  void addItem(Item item) {
    setState(() {
      items.add(item);
      loadStoresLocations();
    });
    storage.writeItems(items);
  }

  void deleteItem(Item item) {
    setState(() {
      items.remove(item);
      loadStoresLocations();
    });
    storage.writeItems(items);
  }

  void loadStoresLocations() {
    stores = HashSet<String>();
    locations = HashSet<String>();

    stores.add("ALL");
    locations.add("ALL");

    for(final Item(:store, :location, :stocked) in items) {
      locations.add(location);
      if (!stocked) {
        stores.add(store);
      }
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

    initStorage();
  }

  Future<void> initStorage() async {
    storage = await ItemStorage.create("items.txt");
    List<Item> tmp = await storage.readItems();

    setState(() {
      items = tmp;
      loadStoresLocations();
      selectedLocation = locations.first;
      selectedStore = stores.first;
    });
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
            child: ItemView(
              themeColor: themeColor,
              items: items.where((Item value) {
                return !value.stocked && (selectedStore=="ALL" || value.store == selectedStore);
              }).toList(),
              setItemStocked: setItemStocked,
              deleteItem: deleteItem,
            ),
          ),
          // Storage
          Center(
            child: ItemView(
              themeColor: themeColor,
              items: selectedLocation == "ALL" ? items : items.where((Item value) {
                return value.location == selectedLocation;
              }).toList(),
              setItemStocked: setItemStocked,
              deleteItem: deleteItem,
            )
          ,)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
                }).toList()..sort((a, b) {
                    if(a.value=="ALL") {
                      return -1;
                    }
                    if(b.value=="ALL") {
                      return 1;
                    }
                    return 0;
                  }),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateItem(themeColor: themeColor, addItem: addItem,)),
                  );
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: themeColor,
                  iconSize: 25,
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
