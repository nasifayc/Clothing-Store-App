import 'package:shega_cloth_store_app/database/auth.dart';
import 'package:shega_cloth_store_app/utils/snackBar.dart';

import '/utils/likeanimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pro extends StatefulWidget {
  //final int indexes;
  const Pro({
    super.key,
    //required this.indexes,
  });

  @override
  State<Pro> createState() => _ProState();
}

class _ProState extends State<Pro> {
  bool isfinished = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB81736),
      appBar: AppBar(

        elevation: 0.0,
        backgroundColor:Color(0xffB81736),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(221, 255, 255, 255),
            size: 30,
          ),
        ),
        title: Center(
          child: Text(
            'Products',
            style: TextStyle(
              color: const Color.fromARGB(221, 255, 255, 255),
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child:  Container(
           height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffB81736),
                Color(0xff281537),
              ]
              ),
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: List.generate(snapshot.data!.docs.length, (index) {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 145,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[index]['photourl'],
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 150,
                                  child: likeAnimation(
                                    product: snapshot.data!.docs[index],
                                    snap: FirebaseAuth.instance.currentUser!,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '\$ ${snapshot.data!.docs[index]['price']} ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ClipOval(
                                    clipBehavior: Clip.antiAlias,
                                    child: Material(
                                      color: Color.fromARGB(214, 117, 73, 220),
                                      child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isfinished = false;
                                          });
                                          String res = await authMethod().toCart(
                                            imageurl: snapshot.data!.docs[index]
                                                ['photourl'],
                                            title: snapshot.data!.docs[index]
                                                ['title'],
                                            price: snapshot.data!.docs[index]
                                                ['price'],
                                          );
                                          setState(() {
                                            isfinished = true;
                                          });
                                          if (res == 'success') {
                                            showSnack('Added to cart', context);
                                          } else {
                                            showSnack(
                                                'some error occured.cheak your connection',
                                                context);
                                          }
                                          setState(() {
                                            isfinished = true;
                                          });
                                        },
                                        icon: Center(
                                          child: Icon(
                                            Icons.add,
                                            //color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
