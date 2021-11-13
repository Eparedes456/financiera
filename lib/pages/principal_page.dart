import 'package:financiera/model/creditos_model.dart';
import 'package:financiera/model/cuenta_model.dart';
import 'package:financiera/model/tipo_credito_model.dart';
import 'package:financiera/model/tipo_cuenta_model.dart';
import 'package:financiera/pages/creditos_page.dart';
import 'package:financiera/pages/cuentas_page.dart';
import 'package:financiera/pages/detalle_credito.dart';
import 'package:financiera/pages/detalle_cuenta.dart';
import 'package:financiera/pages/login_page.dart';
import 'package:financiera/pages/password_change_page.dart';
import 'package:financiera/services/conexion.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
  
}

class _PrincipalState extends State<Principal> {
  final GlobalKey<_PrincipalState> expansionTile = new GlobalKey();

  
  var _connectionStatus = true;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  List<Cuenta> listcuentas = [];
  List<Creditos> listcreditos = [];
  List<TipoCuenta> list_tipoCuenta = [];
  List<TipoCredito> list_tipoCredito = [];
  bool haydatoscuentas = false;
  bool haydatoscreditos = false;
  var nombrecompletosocio = "";
  bool presionado = false;
  
  
datosocio() async{
SharedPreferences preferences = await SharedPreferences.getInstance();
           var name = await  preferences.getString('nombre_socio');
           var dni = await preferences.getString('dni');
           setState(() {
             nombrecompletosocio = name;
           });
           
           print('este el dni $dni');
}

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.datosocio();
    this.cargarCuentas();
    this.cargarCreditos();
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result ){
      
      //_connectionStatus = result.toString();
     
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        print('Hay conexion a internet');
        setState(()async {
          _connectionStatus = true;
          print(_connectionStatus);
          

          
          //cargarCreditos();
        });
      }else if(result == ConnectivityResult.none){
        mostrarAlertaConexion();
        setState(() {
          _connectionStatus = false;
          print(_connectionStatus);
        });
      }
    });
  }

  @override
  void dispose(){
    subscription.cancel();
    super.dispose();
    
  }

 

  void mostrarAlertaConexion(){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('Ups!',textAlign: TextAlign.center,),
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
            Text('Usted no tiene conexion a internet')
          ],
        ),
      );
    }
  );
}


cargarCuentas() async{

  Conexion conexion = new Conexion();

   final response = await conexion.cuentas();
   response.forEach((a, b) { 
          
          list_tipoCuenta.add(TipoCuenta(a));
          
          for(final value in b){
            
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
         
         setState(() {
           haydatoscuentas = true;
           list_tipoCuenta;
           listcuentas;
         });
       }
  

}

cargarCreditos() async{

  Conexion conexion = new Conexion();

   final response = await conexion.creditos();

   
    
      if(response == 0){
        setState(() {
          haydatoscreditos = false;
        });
      }else{
        response.forEach((a,b){
           
           list_tipoCredito.add(TipoCredito(a));

          for(final value in b){

            listcreditos.add(Creditos(value["NroCredito"], value["NroCredito"], 
            value["SaldoCredito"], value["Tipcredito_descripcion"], value["NroCuotas"], value["TasaInteres"],
            value["MontoDesembolso"],value["FechaDesembolso"]));
          }

        });

        if(list_tipoCredito.length == 0){
          setState(() {
           haydatoscreditos = false;
         });
        }else{
          setState(() {
           haydatoscreditos = true;
           list_tipoCredito;
           listcreditos;
         });
        }
      }
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
                            child: Container(
                              child: ListTile(
                                onTap: (){
                                  
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

Widget creditos(context){
  return haydatoscreditos == false?Center(child:Text('No tiene creditos') ,)
  :Container(
    padding: EdgeInsets.only(top: 10),
    child:  ListView.builder(
      itemCount: list_tipoCredito.length == null?0:list_tipoCredito.length,
      itemBuilder: (context,i){
        var tipo_credito = list_tipoCredito[i].descripcion;
        
        return 
        Card(
          child: Column(
            children: <Widget>[
               ExpansionTile(
                title:Text('$tipo_credito'),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: listcreditos.length == null?0:listcreditos.length,
                    itemBuilder: (context,i){
                      var flag = listcreditos[i].tipo_credito_descripcion;
                      final nro_credito = listcreditos[i].nro_credito;
                      final saldo_capital = listcreditos[i].saldo_capital;
                      final monto = listcreditos[i].montoDesembolsado;
                      final nro_cuotas = listcreditos[i].nro_cuota;
                      final tasa = listcreditos[i].tasa;
                      final fecha_desembolso = listcreditos[i].fecha_desembolso;
                       if(tipo_credito == flag){
                         return Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: (){
                                
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    DetalleCreditoPage(
                                      nro_credito: nro_credito,
                                      tipo_credito: flag,
                                      saldo_capital: saldo_capital,
                                      monto_prestamo: monto,
                                      nro_cuota: nro_cuotas,
                                      tasa: tasa,
                                      fechadesembolso: fecha_desembolso

                                      )
                                  )
                                );
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                   child: Text('Número de Credito',style: TextStyle(fontSize: 16,color: Colors.grey[600])),
                                  ),
                                  SizedBox(height: 8,),
                                  Container(
                                   child: Text('$nro_credito',style: TextStyle(fontSize: 14),),
                                  )

                                ],

                              ),
                              trailing: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text('Saldo',style: TextStyle(fontSize: 16,color: Colors.grey[600]),)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(child: Text('S/$saldo_capital',style: TextStyle(fontSize: 14),))
                                ],
                              ),
                            ),
                          );
                       }else{
                         return Container();
                       }


                    }
                  )

                ],

               )
            ],
          )
        );

      }
    )

  );

}

Future<bool> _onBackPressed(){
  return showDialog(
    context: context,
    builder: (context) =>AlertDialog(
      title: Text("¿Esta seguro que quiere salir de la app?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: ()=> Navigator.pop(context,false),
        ),
        FlatButton(
          child: Text("Si"),
          onPressed: ()async{
            SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.clear();
            Navigator.pop(context,true);
            
          } 
        )
      ],

    )
  );
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(238, 241, 242, 1),
          appBar: AppBar(
            backgroundColor: Colors.green[400],
            elevation: 0,
            title: Text('Hola, $nombrecompletosocio',style: TextStyle(fontSize: 15),),
            bottom: TabBar(
              labelColor: Colors.green[400],
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                color: Colors.white
              ),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Cuentas'),
                    ),
                  ),
                 ),
                Tab(
                  child: Container(
                   
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Creditos'),
                    ),
                  ),
                 ),
              ],

            ),
            
          ),
          drawer: Drawer(
            
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color:  Colors.green[400],),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.jpg'),
                    
                  ),
                  accountName: Text('$nombrecompletosocio'),
                  accountEmail: Text(''),
                ),
                  ListTile(
                  title: Text('Cambiar Contraseña'),
                  leading: Icon(Icons.lock),
                  onTap: (){

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChangePasswordPage()
                      )
                    );

                  },
                ),
                ListTile(
                  title: Text('Cuentas'),
                  leading: Icon(Icons.attach_money),
                  onTap: (){

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CuentasPage()
                      )
                    );

                  },
                ),
                ListTile(
                  title: Text('Creditos'),
                  leading: Icon(Icons.credit_card),
                  onTap: (){
                     Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CreditosPage()
                      )
                    );
                  },
                ),
                ListTile(
                  title: Text('Cerrar Sesión'),
                  leading: Icon(Icons.power_settings_new),
                  onTap: () async{
                     SharedPreferences preferences = await SharedPreferences.getInstance();
                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false); 
                      preferences.clear();  
                  },
                )
              ],
            ),
          ),

          body: TabBarView(
            children: <Widget>[
             cuentas(context),
              creditos(context)
            ],
          ),
          
        
        ),
      ),
    );
  }
}



