import 'package:financiera/model/cuenta_model.dart';
import 'package:financiera/model/tipo_cuenta_model.dart';
import 'package:financiera/pages/detalle_cuenta.dart';
import 'package:financiera/services/conexion.dart';
import 'package:flutter/material.dart';

class CuentasPage extends StatefulWidget {
  @override
  _CuentasPageState createState() => _CuentasPageState();
}

class _CuentasPageState extends State<CuentasPage> {

List<Cuenta> listcuentas = [];
 List<TipoCuenta> list_tipoCuenta = [];
bool haydatoscuentas = false;

cargarCuentas() async{

  Conexion conexion = new Conexion();

   final response = await conexion.cuentas();
   response.forEach((a, b) { 
          //print(b);
          list_tipoCuenta.add(TipoCuenta(a));
          
          for(final value in b){
            print(value["Tipo_Cuenta"]);
            listcuentas.add(Cuenta(value["nrocuenta"],value["nrocuenta"],
            value["Saldo"],value["Saldocontable"],value["TasaInteres"],value["Tipo_Cambio"],
            value["Fecha_Apertura"],value["tipcuenta_descripcion"]));
            
          }
       } );

       if(list_tipoCuenta.length == 0){
         setState(() {
           haydatoscuentas = false;
         });
       }else{
         //print('Hay datos');
         setState(() {
           haydatoscuentas = true;
           list_tipoCuenta;
           listcuentas;
         });
       }
  

}


@override
void initState() { 
  super.initState();
  this.cargarCuentas();
}

 Widget cuentas(context){
  return haydatoscuentas == false?Center(child:CircularProgressIndicator() ,)
  : Container(
    padding: EdgeInsets.only(top: 10),
    child:  ListView.builder(
      itemCount: list_tipoCuenta == null?0:list_tipoCuenta.length,
          itemBuilder: (context,i){
            var tipo_cuenta = list_tipoCuenta[i].descripcion;
            
            return
            Card(
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title:Text('$tipo_cuenta',),  
                    children: <Widget>[
                      
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: listcuentas.length == null?0:listcuentas.length,
                        itemBuilder: (context,i){
                          var flag = listcuentas[i].tipo_cuenta_descripcion;
                          final nro_cuenta = listcuentas[i].nro_cuenta;
                          final saldo_disponible = listcuentas[i].saldoDisponilbe; 
                          final fecha_apertura = listcuentas[i].fecha_apertura;
                          final tasa = listcuentas[i].tasa;
                          if(tipo_cuenta == flag){
                            return Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: (){
                                print('$nro_cuenta');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    DetalleCuentaPage(
                                      nro_cuenta: nro_cuenta,
                                      tipo_cuenta: flag,
                                      fecha_apertura: fecha_apertura,
                                      tasa: tasa,
                                      saldo: saldo_disponible,
                                      )
                                  )
                                );
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                   child: Text('Número de Cuenta',style: TextStyle(fontSize: 16,color: Colors.grey[600]),),
                                  ),
                                  SizedBox(height: 8,),
                                  Container(
                                   child: Text('$nro_cuenta',style: TextStyle(fontSize: 14)),
                                  )

                                ],

                              ),
                              trailing: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 5,left: 5),
                                    child: Text('Saldo',style: TextStyle(fontSize: 16,color: Colors.grey[600]),)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(child: Text('S/$saldo_disponible',style: TextStyle(fontSize: 14),))
                                ],
                              ),
                            ),
                          );
                          }else{
                            return Container();
                          }
                          

                        },
                      )
                      
                    ],
                  )
                ],
              ),
            );
          }

    ),
  );
   

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Mis Cuentas'),
      ),
      body: cuentas(context)
      
    );
  }
}