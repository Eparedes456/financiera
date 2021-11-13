import 'dart:async';
import 'dart:convert';

import 'package:financiera/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  var _formkey = GlobalKey<FormState>();
  
  TextEditingController controllerPassword1 = new TextEditingController();
  TextEditingController controllerPassword2 = new TextEditingController();
  bool ver = true; 
  ProgressDialog progressDialog;


   cambiarpass(context) async{

     if(_formkey.currentState.validate()){

       
       
       SharedPreferences preferences = await SharedPreferences.getInstance(); 
     final String global_url = "http://fancytechnology.tk/";
     final url = '$global_url/Envio_json/cambioclave';
     var token_acceso = preferences.getString('token_acceso');
     var dni = preferences.getString('dni');

     final resp = await http.post(url,body:{
       "codfinan"  : "28",
       "usuario"   :dni,
       "clave"     :controllerPassword1.text,
       "token"     : token_acceso
     } 
     );
     final decodedData = json.decode(resp.body);

      print(decodedData["estado"]);
      if(decodedData["estado"] == 1){

        
        final snackBar = SnackBar(
            content: Text('Cambio de contraseña exitoso!'),
            
            );

            Scaffold.of(context).showSnackBar(snackBar);
          return 1;
      }else{
        return 0;
      }

     }else{
       return 0;
     }
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


  @override
  Widget build(BuildContext context) {

    progressDialog = ProgressDialog(context,type:ProgressDialogType.Normal);
    progressDialog.style(
      message: 'Espere por favor..',
      progressWidget: CircularProgressIndicator(),
      elevation: 5
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
        backgroundColor: Colors.green[400],
      ),

      body: Builder(builder: (context){
        return  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Card(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      /*Container(
                        padding: EdgeInsets.only(left:20,right: 20),
                        child: TextFormField(
                          controller: controllerDni,
                          decoration: InputDecoration(
                            hintText: 'Ingrese su documento de identidad',
                            prefixIcon: Icon(Icons.person)
                          ),
                        ),
                      ),*/
                      SizedBox(height: 25,),

                      Container(
                        padding: EdgeInsets.only(left:20,right: 20),
                        child: TextFormField(
                          controller: controllerPassword1,
                          obscureText: ver,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          validator: (value){
                            if(value.isEmpty){
                              return 'La contraseña no puede ser vacio';
                            }else if(value.length > 6){
                              return 'La contraseña no puede tener más de 6 digitos';
                            }else if(value.length < 6){
                              return 'El campo debe tener 6 digitos';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Ingrese su nueva contraseña',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  ver = !ver;
                                });
                              },
                              icon: ver == true? Icon(Icons.visibility_off,color: Colors.black12,)
                                      :Icon(Icons.visibility,color: Colors.black12,),
                            )
                          ),
                        ),
                      ),

                      SizedBox(height: 30,),

                      Container(
                        padding: EdgeInsets.only(left:20,right: 20),
                        child: TextFormField(
                          controller: controllerPassword2,
                          obscureText: ver,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          validator: (value){
                            if(value.isEmpty){
                              return 'El campo es requerido!';
                            }
                            else if(value !=controllerPassword1.text){
                              return "No coinciden las contraseñas";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Confirme su nueva contraseña',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  ver = !ver;
                                });
                              },
                              icon: ver == true? Icon(Icons.visibility_off,color: Colors.black12,)
                                      :Icon(Icons.visibility,color: Colors.black12,),
                            ),
                            
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      RaisedButton(
                        color: Colors.greenAccent[700],
                        child: Text('Cambiar',style: TextStyle(color: Colors.white),),
                        onPressed: ()async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          progressDialog.show();
                           final resultado = await cambiarpass(context);
                           if(resultado == 1){
                             progressDialog.hide();
                             print('se cambio la contraseña');
                             Timer(
                                  Duration(seconds: 2),(){
                                    //Navigator.pushReplacementNamed(context, 'login');
                                    
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false); 
                      preferences.clear();
                                  
                                  }
                                );
                           }else if(resultado == 0){
                             progressDialog.hide();
                              await mostrarAlertaConexion();

                              Timer(
                                  Duration(seconds: 2),(){
                                    //Navigator.pushReplacementNamed(context, 'login');
                                    
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false); 
                      preferences.clear();
                                  
                                  }
                                );
                           }
                              
                            /*Timer(
                                  Duration(seconds: 2),(){
                                    //Navigator.pushReplacementNamed(context, 'login');
                                    
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Login()), (Route<dynamic> route) => false); 
                      preferences.clear();
                                  
                                  }
                                );*/

                          

                        },
                      ),


                      SizedBox(height: 35,),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
        
      ),
      
    );
  }
}