import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fire_crud/models/cardoc.dart';
import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/providers/providers.dart';
import 'package:fire_crud/widgets/widgets.dart';
import 'package:fire_crud/services/services.dart';

class CarDocFormScreen extends StatelessWidget {
  static const String routerName = "CarDocFormScreen";
  const CarDocFormScreen({Key? key, this.c}) : super(key: key);
  final CarDoc? c;
  @override
  Widget build(BuildContext context) {
    final CarDocService carService = Provider.of<CarDocService>(context);

    return ChangeNotifierProvider(
      create: (_) => CarDocFormProvider(carService.carSel),
      child: _CarBody(carService: carService, c: c),
    );
  }
}

class _CarBody extends StatelessWidget {
  final CarDocService carService;
  final CarDoc? c;
  const _CarBody({Key? key, required this.carService, this.c})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final List<String> statuses = ['-', 'R', 'S'];
    final carForm = Provider.of<CarDocFormProvider>(context);
    CarDoc carSel = c ?? carForm.cardoc;

    String? filtroAceite;
    String? filtroCombustible;
    String? filtroAire;
    String? bujias;
    String? encendido;
    String? anticongelante;
    String? aceiteMotor;
    String? aceiteCaja;
    String? aceiteDiferencial;
    String? liquidoFrenos;
    String? raquetasLimp;
    String? limpiaparabrisa;
    String? alternador;
    String? bateria;
    String? servodireccion;
    String? gases;
    String? puestaApunto;
    String? presionNeumaticos;
    String? engrase;
    String? amortiguadores;
    String? tuboEscape;
    String? pFreno;
    String? discosFreno;
    String? zapatas;
    String? tamboresFreno;
    String? frenoMano;
    String? guardapolvos;
    String? rotulas;
    String? transmisiones;
    String? mangueras;
    String? direccion;
    String? catalizador;
    String? distribuidor;

    //Se agrega para poder editar el texto desde codigo
    var matricula = TextEditingController();
    var km = TextEditingController();
    var fecha = TextEditingController();
    var usuario = TextEditingController();

    print('filtroAceite ${carSel.filtroAceite}-${filtroAceite}');

    if (c != null) {
      usuario.text = carSel.usuario;
      matricula.text = carSel.matricula;
      km.text = carSel.km;
      fecha.text = carSel.fecha;
    }

    const placeholderImage =
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('CarDoc Form'),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(placeholderImage))),
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
            child: TextButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Column(children: [
            TextFormField(
                controller: usuario,
                enabled: false,
                decoration: const InputDecoration(
                  hintText: 'Usuario logueado',
                  labelText: 'Usuario',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: fecha,
                enabled: carSel.id == '-1' ? true : false,
                readOnly: carSel.id != '-1' ? true : false,
                onChanged: (value) {
                  carSel.fecha = value;
                },
                onTap: () async {
                  if (carSel.id == '-1') {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      carSel.fecha = formattedDate;
                      fecha.text = formattedDate;
                    }
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Fecha de la revision',
                  labelText: 'Fecha',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: matricula,
                enabled: carSel.id == '-1' ? true : false,
                readOnly: carSel.id != '-1' ? true : false,
                onChanged: (value) async {
                  carSel.matricula = value;
                  //update usuario field
                  usuario.text = authService.getName();
                  carSel.usuario = authService.getName();
                },
                decoration: const InputDecoration(
                  hintText: 'Matricula del vehiculo',
                  labelText: 'Matricula',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: km,
                onChanged: (value) {
                  carSel.km = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Km del vehiculo',
                  labelText: 'Km',
                )),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.filtroAceite,
              decoration: InputDecoration(labelText: 'Filtro de Aceite'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                filtroAceite = value;
                carSel.filtroAceite = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.filtroCombustible,
              decoration: InputDecoration(labelText: 'Filtro de Combustible'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                filtroCombustible = value;
                carSel.filtroCombustible = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.filtroAire,
              decoration: InputDecoration(labelText: 'Filtro de Aire'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                filtroAire = value;
                carSel.filtroAire = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.bujias,
              decoration: InputDecoration(labelText: 'Bujias'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                bujias = value;
                carSel.bujias = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.encendido,
              decoration: InputDecoration(labelText: 'Encendido'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                encendido = value;
                carSel.encendido = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.anticongelante,
              decoration: InputDecoration(labelText: 'Anticongelante'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                anticongelante = value;
                carSel.anticongelante = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.aceiteMotor,
              decoration: InputDecoration(labelText: 'Aceite del Motor'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                aceiteMotor = value;
                carSel.aceiteMotor = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.aceiteCaja,
              decoration: InputDecoration(labelText: 'Aceite de la Caja'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                aceiteCaja = value;
                carSel.aceiteCaja = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.aceiteDiferencial,
              decoration: InputDecoration(labelText: 'Aceite del Diferencial'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                aceiteDiferencial = value;
                carSel.aceiteDiferencial = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.liquidoFrenos,
              decoration: InputDecoration(labelText: 'Liquido Frenos'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                liquidoFrenos = value;
                carSel.liquidoFrenos = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.raquetasLimp,
              decoration: InputDecoration(labelText: 'Raquetas Limp.'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                raquetasLimp = value;
                carSel.raquetasLimp = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.limpiaparabrisa,
              decoration: InputDecoration(labelText: 'Limpia Parabrisa'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                limpiaparabrisa = value;
                carSel.limpiaparabrisa = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.alternador,
              decoration: InputDecoration(labelText: 'Alternador'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                alternador = value;
                carSel.alternador = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.bateria,
              decoration: InputDecoration(labelText: 'Bateria'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                bateria = value;
                carSel.bateria = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.servodireccion,
              decoration: InputDecoration(labelText: 'Serv. Direccion'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                servodireccion = value;
                carSel.servodireccion = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.gases,
              decoration: InputDecoration(labelText: 'Gases'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                gases = value;
                carSel.gases = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.puestaApunto,
              decoration: InputDecoration(labelText: 'Puesta Apunto'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                puestaApunto = value;
                carSel.puestaApunto = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.presionNeumaticos,
              decoration: InputDecoration(labelText: 'Presion Neumaticos'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                presionNeumaticos = value;
                carSel.presionNeumaticos = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.engrase,
              decoration: InputDecoration(labelText: 'Engrase'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                engrase = value;
                carSel.engrase = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.amortiguadores,
              decoration: InputDecoration(labelText: 'Amortiguadores'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                amortiguadores = value;
                carSel.amortiguadores = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.tuboEscape,
              decoration: InputDecoration(labelText: 'Tubo Escape'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                tuboEscape = value;
                carSel.tuboEscape = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.pFreno,
              decoration: InputDecoration(labelText: 'Pedal Freno'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                pFreno = value;
                carSel.pFreno = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.discosFreno,
              decoration: InputDecoration(labelText: 'Discos Freno'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                discosFreno = value;
                carSel.discosFreno = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.zapatas,
              decoration: InputDecoration(labelText: 'Zapatas'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                zapatas = value;
                carSel.zapatas = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.tamboresFreno,
              decoration: InputDecoration(labelText: 'Tambores Frenos'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                tamboresFreno = value;
                carSel.tamboresFreno = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.frenoMano,
              decoration: InputDecoration(labelText: 'Freno de Mano'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                frenoMano = value;
                carSel.frenoMano = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.guardapolvos,
              decoration: InputDecoration(labelText: 'Guardapolvos'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                guardapolvos = value;
                carSel.guardapolvos = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.rotulas,
              decoration: InputDecoration(labelText: 'Rotulas'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                rotulas = value;
                carSel.rotulas = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.transmisiones,
              decoration: InputDecoration(labelText: 'Transmisiones'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                transmisiones = value;
                carSel.transmisiones = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.mangueras,
              decoration: InputDecoration(labelText: 'Mangueras'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                mangueras = value;
                carSel.mangueras = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.direccion,
              decoration: InputDecoration(labelText: 'Direccion'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                direccion = value;
                carSel.direccion = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.catalizador,
              decoration: InputDecoration(labelText: 'Catalizador'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                catalizador = value;
                carSel.catalizador = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.distribuidor,
              decoration: InputDecoration(labelText: 'Distribuidor'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                distribuidor = value;
                carSel.distribuidor = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Column(children: [SizedBox(height: 100)]),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!carService.isLoading) {
              FocusScope.of(context).requestFocus(FocusNode());

              carService.saveCarDoc(carSel.clone()); //Guarda el ToDo actual

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('SAVED!'),
                ),
              );
            }
          },
          child: carService.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
