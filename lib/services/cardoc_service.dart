import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fire_crud/models/cardoc.dart';
import 'package:fire_crud/services/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarDocService extends ChangeNotifier {
  final List<CarDoc> carsList = [];
  String error = '';
  String verificationId = '';
  String collection = 'Cardoc';

  late CarDoc carSel;

  final bool _isLoading = false;

  set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  CarDocService() {
    carSel = CarDoc(
        filtroAceite: "-",
        filtroCombustible: "-",
        filtroAire: "-",
        bujias: "-",
        encendido: "-",
        anticongelante: "-",
        aceiteMotor: "-",
        aceiteCaja: "-",
        aceiteDiferencial: "-",
        liquidoFrenos: "-",
        raquetasLimp: "-",
        limpiaparabrisa: "-",
        alternador: "-",
        bateria: "-",
        servodireccion: "-",
        gases: "-",
        puestaApunto: "-",
        presionNeumaticos: "-",
        engrase: "-",
        amortiguadores: "-",
        tuboEscape: "-",
        pFreno: "-",
        discosFreno: "-",
        zapatas: "-",
        tamboresFreno: "-",
        frenoMano: "-",
        luces: "-",
        guardapolvos: "-",
        rotulas: "-",
        transmisiones: "-",
        mangueras: "-",
        direccion: "-",
        catalizador: "-",
        distribuidor: "-",
        km: "",
        matricula: "",
        fecha: "",
        usuario: 'USUARIO');
  }

  Future snapshots() async {
    return FirebaseFirestore.instance.collection(collection).snapshots();
  }

  Future<List<CarDoc>> saveCarDoc(CarDoc car) async {
    isLoading = true;
    bool isNew = true;
    notifyListeners();

    //Se busca el indice en el que se encuentra el producto
    final index = carsList.indexWhere(((element) => element.id == car.id));
    print('Se va a editar ${car.id} esta en la posicion ${index}');

    if (car.id != '-1') isNew = false;
    if (car.id == '-1') car.id = new DateTime.now().toString();

    final DateTime now = DateTime.now();
    if (index >= 0) {
      //Si es una actualizacion
      carsList[index] = car;
      print('se edita${carsList[index].matricula}');
    } else {
      //Si es uno nuevo se añade la fecha
      car.fecha = car.fecha.isEmpty ? '${now.day}/${now.month}/${now.year}': car.fecha;
      carsList.add(car);
      print('se add');
    }

    //Inserta el ToDo en la colleccion del usuario
    FirebaseFirestore.instance
        .collection(collection)
        .doc(car.id)
        .set(car.toMap());

    isLoading = false;
    notifyListeners();

    return carsList;
  }

  Future<CarDoc> getCarDoc(String? id) async {
    final doc = await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get()
        .catchError((e) {
      print(e);
    });

    final data = doc.data() as Map<String, dynamic>;
    final CarDoc carTMP = CarDoc.fromMap(data);
    return carTMP.clone();
  }

  Future<void> updateCarDoc(String id, Map<String, dynamic> car) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update(car)
        .catchError((e) {
      print(e);
    });
    return;
  }

  Future<List<CarDoc>> deleteCarDoc(String id) async {
    isLoading = true;
    notifyListeners();

    final index = carsList.indexWhere(((element) => element.id == id));
    print('Se va a borrar ${id} esta en la posicion ${index}');

    //codigo para borrar el car firebase
    carsList.removeAt(index);
    FirebaseFirestore.instance.collection(collection).doc(id).delete().onError(
        (error, stackTrace) => NotificationsService.showSnackBar('$error'));

    isLoading = false;
    notifyListeners();

    return carsList;
  }
}
