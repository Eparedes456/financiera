import 'dart:async';

import 'package:financiera/model/detalle_cuenta_model.dart';
import 'package:financiera/model/movimientos_model.dart';
import 'package:financiera/pages/login_page.dart';
import 'package:financiera/services/conexion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleCuentaPage extends StatefulWidget {

  final String nro_cuenta;
  final String tipo_cuenta;
  final String fecha_apertura;
  final String tasa;
  final String saldo;

  DetalleCuentaPage({this.nro_cuenta,this.tipo_cuenta,this.fecha_apertura,this.tasa,this.saldo});
  @override
  _DetalleCuentaPageState createState() => _DetalleCuentaPageState();
}

class _DetalleCuentaPageState extends State<DetalleCuentaPage> {

  List<Movimientos> lista_movimiento = [];
  bool datosMovimientos = false;

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
  cargarMovimientosCuentas() async{
    Conexion conectar = new Conexion();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await conectar.movimientosCuenta(widget.nro_cuenta);

 
  if (response == "-1") {
    await mostrarAlertaConexion();
    Timer(
      Duration(seconds: 3),(){
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false);  
         preferences.clear();               
      }
    );
    
  } else {
    
    if(response == null){
      datosMovimientos = false;
      setState(() {
        
      });
    }else{
      response.forEach((item){
        print(item);
      lista_movimiento.add(Movimientos(
        item["Idmovimiento"],item["Descripcionmovimiento"],item["FechaMovimiento"],
        item["Montomovimiento"].toDouble(),item["Estado"]
      ));
    });

    if(lista_movimiento.length == 0){
      setState(() {
        datosMovimientos = false;
      });
    }else{
      setState(() {
        lista_movimiento;
        datosMovimientos = true;
      });

    }
    }
  }  
    
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.cargarMovimientosCuentas();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Mi Cuenta'),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
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
                  Center(child: Text('${widget.tipo_cuenta}')),
                  SizedBox(height: 10,),
                  Center(child: Text('S/${widget.saldo}',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
                  SizedBox(height: 20,),
                  Center(child: Text('Saldo Disponible')),
                  SizedBox(height: 20,)
                ],
              ),

            ),

            //SizedBox(height: 10,),

            Container(
              child: ListTile(
                title: Text('Información de Cuenta',style: TextStyle(color: Colors.blue,),),
              ),
            ),
            

            Card(
              elevation: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Nro cuenta',style: TextStyle(fontSize: 15,)),
                    trailing: Text('${widget.nro_cuenta}',style: TextStyle(fontSize: 14),),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Fecha de Apertura',style: TextStyle(fontSize: 15),),
                    trailing: Text('${widget.fecha_apertura}',style: TextStyle(fontSize: 14),),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Tasa',style: TextStyle(fontSize: 15),),
                    trailing: Text('${widget.tasa}%',style: TextStyle(fontSize: 14),),
                    dense: true,
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            

            Card(
              elevation: 5,
              child: ExpansionTile(
                initiallyExpanded: false,
                title: Text('Ver Movimientos'),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: lista_movimiento.length == null?0:lista_movimiento.length,
                    itemBuilder: (context,i){
                      final estado = lista_movimiento[i].estado;
                      final descripcion =lista_movimiento[i].descripcion_movimiento;
                      final fecha = lista_movimiento[i].fecha_movimiento;
                      final monto = lista_movimiento[i].monto_movimiento;

                      return ListTile(
                        title: Text('$descripcion'),
                        subtitle: Text('$fecha'),
                        trailing: Text('S/$monto',
                        style: TextStyle(color: estado == "Rojo"?Colors.redAccent[700]:Colors.green[700]),),
                      );
                    },
                  ),
                  
                   
                ],
              ),
            )

           
          ],
        ),
      )
    );
  }
}