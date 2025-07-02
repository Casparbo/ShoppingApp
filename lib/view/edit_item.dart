import 'package:flutter/material.dart';
import 'package:shopping_app/model/item.dart';

class EditItem extends StatefulWidget {
	final Color themeColor;
	final Function(Item item) addItem;
	final Item item;

	const EditItem({
		super.key,
		required this.themeColor,
		required this.item,
		this.addItem = _defaultAddItem,
	});

	static void _defaultAddItem(Item item) {}

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	late Map<String, String> fields;

	@override
	  void initState() {
	    super.initState();

	    fields = {"Name": widget.item.name, "Location": widget.item.location, "Store": widget.item.store};
	  }

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
								initialValue: fields[fields.keys.elementAt(index)],
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
			bottomNavigationBar: BottomAppBar(
				color: widget.themeColor,
				child: FilledButton(
					onPressed: () {
						if(_formKey.currentState!.validate()) {
							Item item = Item(name: fields["Name"]!, store: fields["Store"]!, location: fields["Location"]!);
							widget.addItem(item);
							Navigator.pop(context);
						}
					},
					style: FilledButton.styleFrom(
						foregroundColor: Colors.white,
				        backgroundColor: widget.themeColor,
					),
			        child: const Icon(Icons.check),
				),
			),
		);
	}
}