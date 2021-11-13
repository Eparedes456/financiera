import 'package:financiera/model/creditos_model.dart';
import 'package:financiera/model/tipo_credito_model.dart';
import 'package:financiera/pages/detalle_credito.dart';
import 'package:financiera/services/conexion.dart';
import 'package:flutter/material.dart';

class CreditosPage extends StatefulWidget {
  @override
  _CreditosPageState createState() => _CreditosPageState();
}

class _CreditosPageState extends State<CreditosPage> {

List<TipoCredito> list_tipoCredito = [];
 List<Creditos> listcreditos = [];
 bool haydatoscreditos = false;

cargarCreditos() async{

  Conexion conexion = new Conexion();

   final response = await conexion.creditos();

   //print(response);
    
      if(response == 0){
        setState(() {
          haydatoscreditos = false;
        });
      }else{
        response.forEach((a,b){
           print(a);
           print(b);
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

@override
void initState() { 
  super.initState();
  this.cargarCreditos();
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
                      final fechadesembolso = listcreditos[i].fecha_desembolso;
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
                                      fechadesembolso: fechadesembolso,
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 242, 1),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Mis Creditos'),
      ),
      body: creditos(context)
      
    );
  }
}