import 'package:flutter/material.dart';

class CreateItem extends StatefulWidget {
	final Color themeColor;

	const CreateItem({
		super.key,
		required this.themeColor,
	});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							TextFormField(
								decoration: const InputDecoration(
									border: UnderlineInputBorder(),
									focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
									labelText: "Name",
									labelStyle: TextStyle(color: Colors.black)
								),
								validator: (String? value) {
									if(value == null || value.isEmpty) {
										return "Field is required";
									}
									return null;
								},
							),
							ElevatedButton(
								child: Text("Submit", style: TextStyle(color: widget.themeColor),),
								onPressed: () {
									if(_formKey.currentState!.validate()) {
										// Process Data
									}
								},
							)
						],
					),
				),
			)
		);
	}
}