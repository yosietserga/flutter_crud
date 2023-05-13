import 'package:fire_crud/models/cardoc.dart';
import 'package:flutter/material.dart';

class CarDocFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  CarDoc cardoc;

  CarDocFormProvider(this.cardoc);
}
