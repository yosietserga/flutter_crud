import 'dart:convert';

import 'package:flutter/material.dart';

class CarDoc {
  CarDoc({
    this.id = '-1',
    required this.filtroAceite,
    required this.filtroCombustible,
    required this.filtroAire,
    required this.bujias,
    required this.encendido,
    required this.anticongelante,
    required this.aceiteMotor,
    required this.aceiteCaja,
    required this.aceiteDiferencial,
    required this.liquidoFrenos,
    required this.raquetasLimp,
    required this.limpiaparabrisa,
    required this.alternador,
    required this.bateria,
    required this.servodireccion,
    required this.gases,
    required this.puestaApunto,
    required this.presionNeumaticos,
    required this.engrase,
    required this.amortiguadores,
    required this.tuboEscape,
    required this.pFreno,
    required this.discosFreno,
    required this.zapatas,
    required this.tamboresFreno,
    required this.frenoMano,
    required this.luces,
    required this.guardapolvos,
    required this.rotulas,
    required this.transmisiones,
    required this.mangueras,
    required this.direccion,
    required this.catalizador,
    required this.distribuidor,
    required this.km,
    required this.matricula,
    required this.fecha,
    required this.usuario,
  });

  String? id;
  String filtroAceite;
  String filtroCombustible;
  String filtroAire;
  String bujias;
  String encendido;
  String anticongelante;
  String aceiteMotor;
  String aceiteCaja;
  String aceiteDiferencial;
  String liquidoFrenos;
  String raquetasLimp;
  String limpiaparabrisa;
  String alternador;
  String bateria;
  String servodireccion;
  String gases;
  String puestaApunto;
  String presionNeumaticos;
  String engrase;
  String amortiguadores;
  String tuboEscape;
  String pFreno;
  String discosFreno;
  String zapatas;
  String tamboresFreno;
  String frenoMano;
  String luces;
  String guardapolvos;
  String rotulas;
  String transmisiones;
  String mangueras;
  String direccion;
  String catalizador;
  String distribuidor;
  String km;
  String matricula;
  String fecha;
  String usuario;

  factory CarDoc.fromJson(String str) => CarDoc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarDoc.fromMap(Map<String, dynamic> json) => CarDoc(
        id: json["id"],
        filtroAceite: json["filtroAceite"],
        filtroCombustible: json["filtroCombustible"],
        filtroAire: json["filtroAire"],
        bujias: json["bujias"],
        encendido: json["encendido"],
        anticongelante: json["anticongelante"],
        aceiteMotor: json["aceiteMotor"],
        aceiteCaja: json["aceiteCaja"],
        aceiteDiferencial: json["aceiteDiferencial"],
        liquidoFrenos: json["liquidoFrenos"],
        raquetasLimp: json["raquetasLimp"],
        limpiaparabrisa: json["limpiaparabrisa"],
        alternador: json["alternador"],
        bateria: json["bateria"],
        servodireccion: json["servodireccion"],
        gases: json["gases"],
        puestaApunto: json["puestaApunto"],
        presionNeumaticos: json["presionNeumaticos"],
        engrase: json["engrase"],
        amortiguadores: json["amortiguadores"],
        tuboEscape: json["tuboEscape"],
        pFreno: json["pFreno"],
        discosFreno: json["discosFreno"],
        zapatas: json["zapatas"],
        tamboresFreno: json["tamboresFreno"],
        frenoMano: json["frenoMano"],
        luces: json["luces"],
        guardapolvos: json["guardapolvos"],
        rotulas: json["rotulas"],
        transmisiones: json["transmisiones"],
        mangueras: json["mangueras"],
        direccion: json["direccion"],
        catalizador: json["catalizador"],
        distribuidor: json["distribuidor"],
        km: json["km"],
        matricula: json["matricula"],
        fecha: json["fecha"],
        usuario: json["usuario"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "filtroAceite": filtroAceite,
        "filtroCombustible": filtroCombustible,
        "filtroAire": filtroAire,
        "bujias": bujias,
        "encendido": encendido,
        "anticongelante": anticongelante,
        "aceiteMotor": aceiteMotor,
        "aceiteCaja": aceiteCaja,
        "aceiteDiferencial": aceiteDiferencial,
        "liquidoFrenos": liquidoFrenos,
        "raquetasLimp": raquetasLimp,
        "limpiaparabrisa": limpiaparabrisa,
        "alternador": alternador,
        "bateria": bateria,
        "servodireccion": servodireccion,
        "gases": gases,
        "puestaApunto": puestaApunto,
        "presionNeumaticos": presionNeumaticos,
        "engrase": engrase,
        "amortiguadores": amortiguadores,
        "tuboEscape": tuboEscape,
        "pFreno": pFreno,
        "discosFreno": discosFreno,
        "zapatas": zapatas,
        "tamboresFreno": tamboresFreno,
        "frenoMano": frenoMano,
        "luces": luces,
        "guardapolvos": guardapolvos,
        "rotulas": rotulas,
        "transmisiones": transmisiones,
        "mangueras": mangueras,
        "direccion": direccion,
        "catalizador": catalizador,
        "distribuidor": distribuidor,
        "km": km,
        "matricula": matricula,
        "fecha": fecha,
        "usuario": usuario,
      };

  CarDoc clone() => CarDoc(
        id: id,
        filtroAceite: filtroAceite,
        filtroCombustible: filtroCombustible,
        filtroAire: filtroAire,
        bujias: bujias,
        encendido: encendido,
        anticongelante: anticongelante,
        aceiteMotor: aceiteMotor,
        aceiteCaja: aceiteCaja,
        aceiteDiferencial: aceiteDiferencial,
        liquidoFrenos: liquidoFrenos,
        raquetasLimp: raquetasLimp,
        limpiaparabrisa: limpiaparabrisa,
        alternador: alternador,
        bateria: bateria,
        servodireccion: servodireccion,
        gases: gases,
        puestaApunto: puestaApunto,
        presionNeumaticos: presionNeumaticos,
        engrase: engrase,
        amortiguadores: amortiguadores,
        tuboEscape: tuboEscape,
        pFreno: pFreno,
        discosFreno: discosFreno,
        zapatas: zapatas,
        tamboresFreno: tamboresFreno,
        frenoMano: frenoMano,
        luces: luces,
        guardapolvos: guardapolvos,
        rotulas: rotulas,
        transmisiones: transmisiones,
        mangueras: mangueras,
        direccion: direccion,
        catalizador: catalizador,
        distribuidor: distribuidor,
        km: km,
        matricula: matricula,
        fecha: fecha,
        usuario: usuario,
      );
}
