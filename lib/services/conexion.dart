import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Conexion{

  final String url_global = "http://insideinnova.tk/Envio_json";
  

  //final String url_global = "http://192.168.1.102:8080/financiera/Envio_json";
  //final String url_global = "http://192.168.100.48:8080/financiera/Envio_json";


tipo_cuentas() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
    String dni_socio = preferences.getString('dni');

    final url = "$url_global/tipocuenta";

    final resp = await http.post(url,body: {
      "codfinan"  : "29",
      "dni"       : dni_socio
    });

    final decodedData = json.decode(resp.body);
    if(decodedData.length > 0){
      return decodedData;
    }else{
      return [];
    }

}

  cuentas() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dni_socio = preferences.getString('dni');
    String token = preferences.getString('token_acceso');

    final url = "$url_global/cuentaxusuario";
    final resp = await http.post(url,body: {
        "codfinan"  :"28",
        "dni"       : dni_socio,
        "token"     : token
        });
    

    final decodedData = json.decode(resp.body);
    

    if(decodedData.length > 0){
      return decodedData;
    }else{
      return [];
    }


  }

  
  
  creditos() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dni_socio = preferences.getString('dni');
    String token = preferences.getString('token_acceso');

    final url = "$url_global/cuentaxcredito";

    final resp = await http.post(url,body: {
        "codfinan"  :"28",
        "dni"       : dni_socio,
        "token"     : token
        });

    final decodedData = json.decode(resp.body);
    
    if(decodedData == -1){
      return -1;
    }
    else if(decodedData == 0){
      
      return 0;
      
    }else{
      return decodedData;
    }

  }

  movimientosCuenta(String nro_cuenta)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dni_socio = preferences.getString('dni');
    var token = preferences.getString('token_acceso');

     final url = "$url_global/SeleccionarDetalleCuenta";

    final resp = await http.post(url,body: {
        "codfinan"  :"28",
        "nrocuenta" : nro_cuenta,
        "token"     : token
        });

    final decodedData = json.decode(resp.body);
    
    if(decodedData.length > 0){
      return decodedData;
    }else{
      return [];
    }

  }

  cronogramaPagos_creditos(String nro_credito)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dni_socio = preferences.getString('dni');
    String token     = preferences.getString('token_acceso');

     final url = "$url_global/SeleccionarPlandeCuotas";

    final resp = await http.post(url,body: {
        "codfinan"  :"28",
        "NroPagare" : nro_credito,
        "token"     : token
        });

    final decodedData = json.decode(resp.body);
    print(decodedData);
    
    if(decodedData.length > 0){
      return decodedData;
    }else{
      return [];
    }

  }


}