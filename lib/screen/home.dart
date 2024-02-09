import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool value = false;
  final db = FirebaseDatabase.instance.ref('Home');
  String data = 'ON';
  onUpdate() {
    setState(() {
      value = !value;
    });
    // setState(() {
    //   data != 'ON' ? 'OFF' : "ON";
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: db.child('Data').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data != null) {
              final data = snapshot.data!.snapshot.value;
              print('======> data:$data');

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Temperature',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      // data['Humidity'],

                      snapshot.data!.snapshot.value.toString(),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          onUpdate();
                          writeData();
                        },
                        child: Text(value ? 'ON' : 'OFF'))
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> writeData() async {
    db.child('Data').set({'Humidity': '32', 'Temperature': '23'});
    db.child('LightState').set({'switch': value.toString()});
    // db.child('data').set({'switch': value.toString()});
  }
}
