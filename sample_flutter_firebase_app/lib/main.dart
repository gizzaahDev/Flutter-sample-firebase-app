import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_firebase_app/service/database.dart';
 // Import your DatabaseMethods class
import 'contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Instantiate DatabaseMethods class
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Future<void> _addData() async {
    // Create a Contact object from the entered data
    Contact contact = Contact(name: _nameController.text, phoneNumber: _phoneController.text);
    // Call the addEventDetails method from DatabaseMethods
    await _databaseMethods.addEventDetails(contact.toJson(), DateTime.now().millisecondsSinceEpoch.toString());
    _nameController.clear();
    _phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
          ),
          ElevatedButton(
            onPressed: _addData,
            child: Text('Add Data'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              // Call the getEventDetails method from DatabaseMethods
              stream: _databaseMethods.getEventDetails(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: documents?.length,
                  itemBuilder: (ctx, index) {
                    final contact = Contact.fromJson(documents![index].data() as Map<String, dynamic>);
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
