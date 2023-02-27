import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/widget_class.dart';

class FilterClass extends StatelessWidget {
  final Query dbRef;
  final String category;

  const FilterClass({Key? key, required this.dbRef, required this.category,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          Map hospital = snapshot.value as Map;
          hospital['key'] = snapshot.key;

          //final name = snapshot.child('name').value.toString();
          //var public = snapshot.child('type').value.toString();
          //Query public = dbRef.orderByChild('type').equalTo('public');



          // if(category == 'public'){
          //   //dbRef.orderByChild('type').equalTo('public').once();
          //   final public = dbRef.orderByChild('type').equalTo('public');
          //   return WidgetClass(hospital: hospital,  db: public, name: name,);
          //
          // }
          // else{
          //   return Container(
          //     color: Colors.white,
          //   );
          // }
          return WidgetClass(hospital: hospital,  db: dbRef.orderByChild('type').equalTo('private'), name: "name",);
        },
      ),
    );
  }
}
