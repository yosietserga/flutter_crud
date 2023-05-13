import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fire_crud/models/cardoc.dart';
import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/providers/providers.dart';
import 'package:fire_crud/widgets/widgets.dart';
import 'package:fire_crud/services/services.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CarDocService carService = Provider.of<CarDocService>(context);

    return ChangeNotifierProvider(
      create: (_) => CarDocFormProvider(carService.carSel),
      child: _CarBody(carService: carService),
    );
  }
}

class _CarBody extends StatelessWidget {
  final CarDocService carService;
  const _CarBody({Key? key, required this.carService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final List<String> statuses = ['R', 'S'];
    final carForm = Provider.of<CarDocFormProvider>(context);
    CarDoc carSel = carForm.cardoc;
    String? filtroAceite;

    //Se agrega para poder editar el texto desde codigo
    var txtEditCrl = TextEditingController();

    const placeholderImage =
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('CarDocs'),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL ??
                          placeholderImage))),
          actions: [
            IconButton(
                onPressed: () {
                  authService.signOut(); //Cierra session
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routerName);
                },
                icon: const Icon(Icons.login_outlined))
          ]),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Center(
          child: ElevatedButton(
            child: const Text(' + '),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarDocFormScreen()),
              );
            },
          ),
        ),
        _RecordsListTableScreenState()
      ])),
    );
  }
}

class _RecordsListTableScreenState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CarDocService carService = Provider.of<CarDocService>(context);

    return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Cardoc").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: \${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              List rows = [];
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                rows.add(data);
              }

              return DataTable(
                columns: [
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Matricula')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: rows.map((record) {
                  return DataRow(cells: [
                    DataCell(Text(record["fecha"] ?? "-")),
                    DataCell(Text(record["matricula"] ?? "-")),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Edit action

                            carService.getCarDoc(record['id']).then((c) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CarDocFormScreen(c: c)));
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Delete action
                            await carService.deleteCarDoc(record["id"]);
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              );
            },
          ),
        ]));
  }
}
