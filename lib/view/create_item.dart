import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';

class CreateItem extends StatefulWidget {
	final Color themeColor;
	final Function(Item item) addItem;

	const CreateItem({
		super.key,
		required this.themeColor,
		this.addItem = _defaultAddItem
	});

	static void _defaultAddItem(Item item) {}

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	Map<String, String> fields = {"Name":"", "Location": "", "Store": ""};

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: widget.themeColor,
				foregroundColor: Colors.white,
				title: const Text("Create Item"),
			),
			body:
			Padding(
				padding: const EdgeInsets.all(12),
				child: Form(
					key: _formKey,
					child: ListView.builder(
						itemCount: fields.length,
						itemBuilder: (BuildContext context, int index) {
							return TextFormField(
								decoration: InputDecoration(
									border: const UnderlineInputBorder(),
									focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
									labelText: fields.keys.elementAt(index),
									labelStyle: const TextStyle(color: Colors.black)
								),
								validator: (String? value) {
									if(value == null || value.isEmpty) {
										return "Field is required";
									}
									return null;
								},
								onChanged: (value) {
									fields[fields.keys.elementAt(index)] = value;
								},
							);
						},
					),
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					if(_formKey.currentState!.validate()) {
						Item item = Item(name: fields["Name"]!, store: fields["Store"]!, location: fields["Location"]!);
						widget.addItem(item);
						Navigator.pop(context);
					}
				},
				foregroundColor: Colors.white,
		        backgroundColor: widget.themeColor,
		        child: const Icon(Icons.check),
			),
		);
	}
}