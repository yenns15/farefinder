import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_history.dart';
import 'package:farefinder/src/pages/cliente/history/cliente_history_controller.dart';
import 'package:farefinder/src/providers/travel_history_provider.dart';
import 'package:farefinder/src/utils/relative_time_util.dart';
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
        body: StreamBuilder(
          stream: TravelHistoryProvider.consulta(""),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("------------------------------");
            print(snapshot.data?.docs.length);

            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (_, index) {
                  print(snapshot.data?.docs[index]['price']);
                 
                  return _cardHistoryInfo(
                      snapshot.data?.docs[index]['from'] ?? "",
                      snapshot.data?.docs[index]['to'] ?? "",
                      snapshot.data?.docs[index]['price']?.toString()?? '',
                      snapshot.data?.docs[index]['calificacionesConductor']?.toString()?? '',
                    RelativeTimeUtil.getRelativeTime(snapshot.data?.docs[index]['timestamp']?? 0),
                    );
                });
          },
        ));
  }

  Widget _cardHistoryInfo(
    String from,
    String to,
    String price,
    String calificaciones,
    String timestamp,
    //  String idTravelHistory,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.location_on),
              SizedBox(
                width: 5,
              ),
              Text(
                'Recoger en ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  from ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.location_searching),
              SizedBox(
                width: 5,
              ),
              Text(
                'Destino ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  to ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.monetization_on),
              SizedBox(
                width: 5,
              ),
              Text(
                'Precio ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  price ?? '0\$',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.format_list_numbered_sharp),
              SizedBox(
                width: 5,
              ),
              Text(
                'Calificacion ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  calificaciones ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.timer_sharp),
              SizedBox(
                width: 5,
              ),
              Text(
                'Hace',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  timestamp ?? '',
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
