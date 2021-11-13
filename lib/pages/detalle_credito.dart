import 'package:financiera/model/cronograma_pagos_model.dart';
import 'package:financiera/pages/login_page.dart';
import 'package:financiera/services/conexion.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class DetalleCreditoPage extends StatefulWidget {

  final String nro_credito;
  final String tipo_credito;
  final String saldo_capital;
  final String monto_prestamo;
  final String nro_cuota;
  final String tasa;
  final String fechadesembolso;

  DetalleCreditoPage({this.nro_credito,this.tipo_credito,this.saldo_capital,this.monto_prestamo,
  this.nro_cuota,this.tasa,this.fechadesembolso});


  @override
  _DetalleCreditoPageState createState() => _DetalleCreditoPageState();
}

class _DetalleCreditoPageState extends State<DetalleCreditoPage> {


  List<CronogramaPagos> lista_cronogramas = [];
  bool datosCronogramaPagos = false;
  
  
  @override

  _pantallaFlotante(BuildContext context,String amortizacion,String interes,String mora,String diasmora){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Amortización'),
                trailing: amortizacion == ""?Text('S/0') :Text('S/$amortizacion'),
              ),
              ListTile(
                title: Text('Interes'),
                trailing: interes== "" ?Text('S/0') :Text('S/$interes'),
              ),
              ListTile(
                title: Text('Mora'),
                trailing: mora == ""?Text('S/0') :Text('S/$mora'),
              ),
              ListTile(
                title: Text('Dias Mora'),
                trailing: diasmora =="" ?Text('0'):Text('$diasmora'),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }
 
void mostrarAlertaConexion(){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('Alerta!',textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              child: Image(
                image: AssetImage('assets/no_internet.png'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20,),
            Text('Session expirada')
          ],
        ),
      );
    }
  );
}

  cronogramaPagos()async{
    Conexion conectar = new Conexion();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await conectar.cronogramaPagos_creditos(widget.nro_credito);
    //print(response);
    if(response == "-1"){
      await mostrarAlertaConexion();
      Timer(
      Duration(seconds: 3),(){
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
         Login()), (Route<dynamic> route) => false);  
         preferences.clear();               
      }
    );

    }else
    if(response == null){
      setState(() {
        datosCronogramaPagos = false;
      });
    }else{
      response.forEach((item){
        lista_cronogramas.add(CronogramaPagos(
          item["Pagare"],item["FECHA_VCMTO"],item["NRO_CUO"]
          ,item["TOTAL_CUOTA"],item["monto_amortizacion"],item["interes_credito"],item["Mora"],
          item["DiasMora"]
        ));
      });

      if(lista_cronogramas.length == 0){
        setState(() {
          datosCronogramaPagos = false;
        });
      }else{
        setState(() {
          lista_cronogramas;
          datosCronogramaPagos = true;

        });
      }
    }
  }

@override
void initState() { 
  super.initState();
  this.cronogramaPagos();
  
}

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Mi credito'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
               //height: size.height*0.22,
              width: size.width*0.8,
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0,0.5),
                    spreadRadius: 3.0
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text('${widget.tipo_credito}'),
                  SizedBox(height: 10,),
                  Text('S/${widget.saldo_capital}',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  Text('Saldo Capital'),
                  SizedBox(height: 20,)
                ],
              ),

            ),

            //SizedBox(height: 8,),

            Container(
              child: ListTile(
                title: Text('Monto Desembolsado',),
                trailing: Text('S/${widget.monto_prestamo}',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15
                  ),

                ),
              ),
            ),
            //SizedBox(height: 4,),

            Container(
              child: ListTile(
                title: Text('Información del Credito',style: TextStyle(color: Colors.blue),), 
              ),
            ),
            //SizedBox(height: 1,),
            Card(
              elevation: 5,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Número del credito',style: TextStyle(fontSize: 15),),
                    trailing: Text('${widget.nro_credito}',style: TextStyle(fontSize: 14),),
                  ),
                  ListTile(
                    title: Text('Número de Cuotas',style: TextStyle(fontSize: 15),),
                    trailing: Text('${widget.nro_cuota}',style: TextStyle(fontSize: 14)),
                  ),
                  ListTile(
                    title: Text('Tasa',style: TextStyle(fontSize: 15)),
                    trailing: Text('${widget.tasa}%',style: TextStyle(fontSize: 14)),
                  ),
                  ListTile(
                    title: Text('Fecha desembolso',style: TextStyle(fontSize: 15)),
                    trailing: Text('${widget.fechadesembolso}',style: TextStyle(fontSize: 14)),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),

            Card(
              elevation: 5,
              child: ExpansionTile(
                initiallyExpanded: false,
                title: Text('Cronograma de Pagos'),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: lista_cronogramas.length == null?0:lista_cronogramas.length,
                    itemBuilder: (context,i){
                      final fecha = lista_cronogramas[i].fecha_vencimiento;
                      final nro_cuota = lista_cronogramas[i].nro_cuota;
                      final cuota_final = lista_cronogramas[i].cuota_final;
                      final amortizacion = lista_cronogramas[i].monto_amortizacion;
                      final interes = lista_cronogramas[i].interes;
                      final mora = lista_cronogramas[i].mora;
                      final dias_mora = lista_cronogramas[i].dias_mora;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Vence el $fecha'),
                            subtitle: Text('Cuota $nro_cuota'),
                            trailing: Text(cuota_final == null? 'S/0': 'S/$cuota_final',style: TextStyle(fontSize: 15),),
                            onTap: (){
                              _pantallaFlotante(context,amortizacion,interes,mora,dias_mora);
                            },
                          ),
                          Divider()
                        ],
                      );

                    },
                  ),
                ],
              ),
            )

           
          ],
        ),
      ),
      
    );
  }
}

