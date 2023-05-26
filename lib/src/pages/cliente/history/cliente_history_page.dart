import 'package:farefinder/src/pages/cliente/history/cliente_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClienteHistoryPage extends StatefulWidget {
  const ClienteHistoryPage({super.key});

  @override
  State<ClienteHistoryPage> createState() => _ClienteHistoryPageState();
}

class _ClienteHistoryPageState extends State<ClienteHistoryPage> {
  ClienteHistoryController _con = new ClienteHistoryController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      
       appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
         title: Text('Historial de viajes'),
        backgroundColor: Color.fromARGB(255, 7, 7, 7),
      ),
      body: ListView(children: [
        _cardHistoryInfo(),
        _cardHistoryInfo(),
         _cardHistoryInfo(),
      ]),
    );
  }

  Widget _cardHistoryInfo() {
    return Container(
      margin:EdgeInsets.only(left: 10,right: 10,top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(10))
          
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.location_on),
                  SizedBox(width: 5,),
                  Text(
                    'Recoger en ',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        'calle falsa con carrera falsa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    
                  )
                ],
              ),
              SizedBox(height: 5,),
               Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.location_searching),
                  SizedBox(width: 5,),
                  Text(
                    'Destino ',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        'calle falsa con carrera falsa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    
                  )
                ],
              ),
               SizedBox(height: 5,),
               Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.monetization_on),
                  SizedBox(width: 5,),
                  Text(
                    'Precio ',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    
                  )
                ],
              ),
               SizedBox(height: 5,),
               Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.format_list_numbered_sharp),
                  SizedBox(width: 5,),
                  Text(
                    'Calificacion ',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        '2.5',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    
                  )
                ],
              ),
               SizedBox(height: 5,),
               Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.timer_sharp),
                  SizedBox(width: 5,),
                  Text(
                    'Hace',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        'hace 5 minutos ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    
                  )
                ],
              ),
            ],

          ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
