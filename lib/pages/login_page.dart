import 'dart:async';
import 'dart:convert';
import 'package:financiera/pages/principal_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var _connectionStatus = true;
  Connectivity connectivity;

  StreamSubscription<ConnectivityResult> subscription;
  //final String global_url = "http://192.168.1.102:8080";
  //final String global_url = "http://192.168.100.48:8080";
  final String global_url = "http://insideinnova.tk/";
  bool islogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generarToken();
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result ){
      
      //_connectionStatus = result.toString();
     
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        print('Hay conexion a inteernet');
        setState(() {
          _connectionStatus = true;
          print(_connectionStatus);
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

  var _formkey = GlobalKey<FormState>();
  TextEditingController controllerDni = new TextEditingController();

  TextEditingController controllerPassword = new TextEditingController();
  bool ver = true; 


  Widget fondo(context){
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height*1.0,
    width: double.infinity,
    //color: Colors.grey[50],
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.green[400],
          Colors.green[300],
          Colors.green[200]
        ]
      )
    ),
    child: Column(
      children: <Widget>[
        SizedBox(height: 40,),
        Container(
          alignment: Alignment.topCenter,
          height: size.height*0.5,
          width: size.width*0.7,
          child: CircleAvatar()
          ),
          
      ],
    ),
  );
}

Widget formulario(context,_formkey){
  
  final size = MediaQuery.of(context).size;

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180,
            //color: Colors.white,
          ),
        ),
        Container(
          width: size.width*0.87,
          padding: EdgeInsets.symmetric(vertical: 20),
          margin: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0,0.5),
                  spreadRadius: 3.0
                )
            ]
          ),
          child:Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text('Login',style:TextStyle(fontSize: 20.0,fontFamily: 'Roboto',fontWeight: FontWeight.bold) ,),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,

                    controller: controllerDni,
                    style: TextStyle(fontSize: 25),
                     validator: (String value){
                            if(value.isEmpty){
                              return "Campo no puede ser vacio";
                            }
                            if(value.length > 9){
                              return "Campo no tiene que tener más de 8 digitos";
                            }
                            if(value.length < 6){
                              return "Campo tiene que tener más de 6 digitos";
                            }
                          },
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                      
                    ],
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                      hintText: 'Ingrese DNI'
                    ),

                  ),
                ),
                SizedBox(height: 20.0,),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: controllerPassword,
                    obscureText: ver,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8)
                    ],
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                      hintText: 'Ingrese su contraseña',
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            ver = !ver;
                          });
                        },
                        icon: ver == true? Icon(Icons.visibility_off):Icon(Icons.visibility)
                      )
                    ),

                  ),
                ),

                SizedBox(height: 50.0,),

                Container(
                  height: 50,
                  width: 155.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[800]
                      
                    ),
                    child: MaterialButton(
                      child: Text('Ingresar',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Roboto'),),
                      onPressed: (){
                          if(_connectionStatus == true){
                            if(_formkey.currentState.validate()){
                              ingresar();
                            }

                          }else{
                            mostrarAlertaConexion();
                          }

                        
                      },
                    ),
                  ),
                )

              ],
            ),
          )
        ),

        //SizedBox(height: 30,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text('Impulsado por',style: TextStyle(color: Colors.grey[700],fontSize: 15),),
            ),
            SizedBox(width: 5,),
            Container(
          child: Text('INSIDE II',style: TextStyle(
            color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold,
            )
            ,),
        ),
          ],
        )
        /*Container(
          child: Text('Impulsado por',style: TextStyle(color: Colors.grey[200],fontSize: 14),),
        ),*/
        //SizedBox(height: 5,),
        /*Container(
          child: Text('INSIDE II',style: TextStyle(
            color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold,
            letterSpacing: 2.0)
            ,),
        ),*/
      ],
    ),
  );

}

Widget formulario1(context,_formkey){
  final size = MediaQuery.of(context).size;

  return Container(
    height: double.infinity,
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 0.0),
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 5.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               
                SizedBox(height: 40,),
                Container(
                  height: size.height*0.08,//60,
                  width: size.width*0.6,
                  alignment: Alignment.centerLeft,
                  
                  child: TextFormField(
                    //textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    controller: controllerDni,
                    style: TextStyle(fontSize: 20,color: Colors.black),
                    validator: (String value){
                            if(value.isEmpty){
                              return "Campo no puede ser vacio";
                            }
                            if(value.length > 9){
                              return "Campo no tiene que tener más de 8 digitos";
                            }
                            if(value.length < 6){
                              return "Campo tiene que tener más de 6 digitos";
                            }
                          },
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      //LengthLimitingTextInputFormatter(8),
                      
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 5),

                        child: Icon(Icons.person,color: Colors.black12,),
                      ),
                      //border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black12),
                      hintText: 'DNI',
                      
                    ),


                  ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                  
                  height: size.height*0.08,//60,
                  width: size.width*0.6,
                  alignment: Alignment.centerLeft,
                  
                 
                  child: TextFormField(
                    style: TextStyle(fontSize: 20,color: Colors.black),
                    controller: controllerPassword,
                    obscureText: ver,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8)
                    ],
                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black12),
                      hintText: 'Contraseña',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 5),

                        child: Icon(Icons.lock,color: Colors.black12,),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            ver = !ver;
                          });
                        },
                        icon: ver == true? Icon(Icons.visibility_off,color: Colors.black12,)
                        :Icon(Icons.visibility,color: Colors.black12,)
                      )
                    ),
                    

                  ),
                  ),

                   SizedBox(height: 30.0,),

                Container(
                  height: size.height*0.06,
                  width: size.width*0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green[300]
                      
                    ),
                    child: MaterialButton(
                      child: Text('Ingresar',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Roboto'),),
                      onPressed: () async{
                        if(_connectionStatus == true){
                            if(_formkey.currentState.validate()){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context){
                                  return Center(child: CircularProgressIndicator(),);
                                }

                              );
                              await ingresar();
                              if(islogin == false){
                                Timer(
                                  Duration(seconds: 3),(){
                                    //Navigator.pushReplacementNamed(context, 'login');
                                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false);
                                  }
                                );
                                
                              }
                              //Navigator.pop(context);
                            }

                          }else{
                            mostrarAlertaConexion();
                          }
                      },
                    ),
                  ),
                ),
                 Container(
                   padding: EdgeInsets.only(top: 100),
                   child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text('Impulsado por',style: TextStyle(color: Colors.black38,fontSize: 15),),
            ),
            SizedBox(width: 5,),
            Container(
          child: Text('INSIDE II',style: TextStyle(
            color: Colors.black45,fontSize: 20,fontWeight: FontWeight.bold,
            )
            ,),
        ),
          ],
        ),
                 )
          
              ],
            )
          ],
        ),
      ),
    ),
  );
  
}
void mostrarAlerta(){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('Ups!',textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.face),
            SizedBox(height: 20,),
            Text('Dni o contraseña erronea')
          ],
        ),
      );
    }
  );
}

  generarToken() async{

    
    final String url_global = "http://insideinnova.tk/Envio_json";
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    final url = '$url_global/token';

    final resp = await http.post(url,body:{
      "codfinan"  : "28",
    }
    );

    final decodedData = json.decode(resp.body);
    print(decodedData);

    var token = decodedData["access_token"];
    preferences.setString('token_acceso', token);
  }

  ingresar() async {

    

    SharedPreferences preferences = await SharedPreferences.getInstance(); 
    final url = '$global_url/Envio_json/loguear';
       
        //final resp = await http.get(url);
        var token_acceso = preferences.getString('token_acceso');
        
        final resp = await http.post(url,body: {
          "codfinan"  : "28",
          "usuario"   :controllerDni.text,
          "clave"     :controllerPassword.text,
          "token"     : token_acceso
        });

        final decodedData = json.decode(resp.body);        
        
        if(decodedData["estado"] == 1){

            var dni = decodedData["DNI"];
        String name = decodedData["Nombre"];
        String  lastname = decodedData["Apellido"];
        var nombresocio =  "$name  $lastname";
        var codsocio = decodedData["CodSocio"];
            
            preferences.setString('dni', dni);
            preferences.setString('nombre_socio',nombresocio);
            preferences.setString('CodSocio', codsocio);
            
            
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Principal()), (Route<dynamic> route) => false); 

          setState(() {
            islogin = true;
          });

        }else{

          mostrarAlerta();
          setState(() {
            islogin = false;
          });


        }
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
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        
        body:Container(
          width: double.infinity,
          decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          colors: [
            Colors.green[400],
            Colors.green[300],
            Colors.green[400]
          ]
        )
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          
          Column(
          children: <Widget>[

            Container(
              height: size.height*0.90,
                width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
                    
                    color: Colors.white
                  ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SafeArea(top: true,child: Container(),),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: AssetImage('assets/logo1.jpg'),
                            height: 150,
                          ),
                        )

                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: size.height*0.08,//60,
                            width: size.width*0.6,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: controllerDni,
                              style: TextStyle(fontSize: 20,color: Colors.black),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Campo no puede ser vacio";
                                }
                                if(value.length < 8){
                                  return "No tiene que ser menor a 8 digitos";
                                }
                                if(value.length == 9){
                                  return "Solo 8 digitos si es dni";
                                }
                                if(value.length == 10){
                                  return "Dni solo 8 digitos y 11 si es ruc";
                                }
                              },
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),  
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(Icons.person,color: Colors.black12,),
                                ),
                                hintStyle: TextStyle(color: Colors.black12),
                                hintText: 'DNI O RUC',
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            height: size.height*0.08,//60,
                            width: size.width*0.6,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Campo requerido";
                                }
                                if(value.length < 6){
                                  return "Contraseña minimo de 6 digitos";
                                }
                              },
                              style: TextStyle(fontSize: 20,color: Colors.black),
                              controller: controllerPassword,
                              obscureText: ver,
                              keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black12),
                                hintText: 'Contraseña',
                                prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(Icons.lock,color: Colors.black12,),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      ver = !ver;
                                    });
                                  },
                                  icon: ver == true? Icon(Icons.visibility_off,color: Colors.black12,)
                                    :Icon(Icons.visibility,color: Colors.black12,),
                                )
                              )
                            ),
                          ),
                          SizedBox(height: 30,),

                          Container(
                            height: size.height*0.06,
                            width: size.width*0.7,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green[300]
                              ),
                              child: MaterialButton(
                                child: Text('Ingresar',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Roboto'),),
                                onPressed: () async{
                                  if(_connectionStatus == true){
                                    if(_formkey.currentState.validate()){
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context){
                                          return Center(child: CircularProgressIndicator(),);

                                        }
                                      );
                                      await ingresar();
                                      if(islogin == false){
                                        Timer(
                                          Duration(seconds: 3),(){
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                            Login()), (Route<dynamic> route) => false);
                                          }
                                        );
                                      }
                                    }
                                  }else{
                                    await mostrarAlertaConexion();
                                    Timer(
                                          Duration(seconds: 3),(){
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                            Login()), (Route<dynamic> route) => false);
                                          }
                                        );
                                  }
                                },
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
            SizedBox(height: 17,),
            Center(
              child: Container(
                //color: Colors.black,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text('Impulsado por',style: TextStyle(color: Colors.white,fontSize: 13),),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      child: Text('INSIDE II',
                        style:TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,) ,
                      ),
                    )
                  ],
                ),
                ),
            )
          ],
        ),
        ],
         
      ),



        ),
        
        
        
        
        
           
        
        
       
        
      ),
    );
  }
}





Widget login(){
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[400]
        ]
      )
    ),
    child: Column(
      children: <Widget>[
        SizedBox(height: 80,),
        Container(
          height: 100,
          width: 200,
          child: CircleAvatar()
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60))
              ),
              child:Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 60,),
                SingleChildScrollView(
                  child: Container(
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Ingrese el número de DNI',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                          ),
                          SizedBox(height: 8,),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Ingrese su contraseña',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: (){},
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ) ,
            ),
          ),
          
      ],

    ),
  );
}