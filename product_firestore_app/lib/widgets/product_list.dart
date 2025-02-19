import 'package:flutter/material.dart';
import 'package:product_firestore_app/service/database.dart';
import 'package:product_firestore_app/widgets/product_item.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {

    Database db = Database.myInstance;
    var myStream = db.getAllProductStream();    
    
    
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: myStream, 
        builder: (context, snapshot){
          if(snapshot.data!.isEmpty){
            return const Center(child: Text('ยังไม่มีข้อมูลสินค้า'),);
          }else if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    db.deleteProduct(product: snapshot.data![index]);

                  // แสดงแจ้งเตือนเมื่อสินค้าถูกลบ
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ลบสินค้าเรียบร้อยแล้ว')),);
                  }
                },
                direction: DismissDirection.endToStart,
                background:  Container(color: Colors.red,),
                child: ProductItem(product: snapshot.data![index],)
              );
            });
          }
          return const Center(child:  CircularProgressIndicator(),);
        }),
      
    );
  }
}