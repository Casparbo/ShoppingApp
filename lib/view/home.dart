import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:shopping_app/view/edit_item.dart';
import 'package:shopping_app/view/item_view.dart';
import 'package:shopping_app/view/select_store.dart';
import 'package:shopping_app/view/shopping.dart';
import 'package:shopping_app/model/item_storage.dart';
import 'package:shopping_app/model/item.dart';

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
  HashSet<String> locations = HashSet<String>();
  String selectedLocation = "";

  late ItemStorage storage;
  List<Item> items = <Item>[];

  void setItemStocked(Item item, bool value) {
    setState(() {
      item.stocked = value;
      loadLocations();
    });
    storage.writeItems(items);
  }

  void addItem(Item item) {
    setState(() {
      items.add(item);
      loadLocations();
    });
    storage.writeItems(items);
  }

  void editItem(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItem(
          themeColor: themeColor,
          addItem: itemReplacer(item),
          item: item,
        )
      ),
    );
  }

  Function(Item) itemReplacer(Item item) {
    return (Item jtem) {
      jtem.stocked = item.stocked;
      if(!jtem.isEmpty()) {
        setState(() {
          items.remove(item);
          items.add(jtem);
          loadLocations();
        });
      }
    };
  }

  void deleteItem(Item item) {
    setState(() {
      items.remove(item);
      loadLocations();
    });
    storage.writeItems(items);
  }

  void loadLocations() {
    locations = HashSet.from(items.map((item) => item.location))..add("ALL");
  }

  void shopStore(String store) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Shopping(
        themeColor: themeColor,
        items: items.where((Item item) {
          return !item.stocked && (store == "ALL" || item.store == store);
        }).toList(),
        markAsStocked: markAsStocked,
      ))
    );
  }

  void markAsStocked(List<Item> toBeMarked) {
    setState(() {
      for(final Item mark in toBeMarked) {
        Item i = items.firstWhere((item) => item == mark);
        i.stocked = true;
      }      
    });
    
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();

    initStorage();
  }

  Future<void> initStorage() async {
    storage = await ItemStorage.create("items.txt");
    List<Item> tmp = await storage.readItems();

    setState(() {
      items = tmp;
      loadLocations();
      selectedLocation = locations.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(widget.title),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: ItemView(
          themeColor: themeColor,
          items: selectedLocation == "ALL" ? items : items.where((Item value) {
            return value.location == selectedLocation;
          }).toList(),
          setItemStocked: setItemStocked,
          deleteItem: deleteItem,
          editItem: editItem,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectStore(
                      themeColor: themeColor,
                      stores: HashSet.from(items.map<String>((item) => item.store).toSet())..add("ALL"),
                      shopStore: shopStore,
                    )),
                  );
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: themeColor,
                  iconSize: 25,
                ),
                child: const Icon(Icons.playlist_add_check),
              ),
            ),
            Expanded(
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
                dropdownMenuEntries:  locations.map<DropdownMenuEntry<String>>((String value) {
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
                    MaterialPageRoute(
                      builder: (context) => EditItem(
                        themeColor: themeColor,
                        addItem: addItem,
                        item: Item(name: "", store: "", location: ""),
                      )
                    ),
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
