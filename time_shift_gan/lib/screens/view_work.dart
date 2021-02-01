// Basic
import 'package:flutter/material.dart';
import 'dart:io';

// Models

// Templates
import 'package:time_shift_gan/templates/container_template.dart';
import 'package:time_shift_gan/templates/dialog_template.dart';
import 'package:time_shift_gan/templates/button_template.dart';

// Backend
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewScreen extends StatefulWidget{
  ViewScreen({Key key});

  ViewState createState() => ViewState();
}

class ViewState extends State<ViewScreen>{
  ViewState({Key key});
  int pageCount;
  int primaryColor = 0;
  int primaryColorLight = 0;
  int primaryColorDark = 0;
  int textColor = 0;

  @override
  void initState(){
    super.initState();
    this.pageCount = 0;
  }

  Widget _buildTile(DocumentSnapshot snapshot) {
    return FutureBuilder(
      future: FirebaseStorage.instance.ref().child("shifted/"+ snapshot.get('imgname')).getDownloadURL(),
      builder: (context, url) {
        return ContainerTemplate.buildContainer(
          Column(
            children: <Widget>[
              Text(
                snapshot.get("user"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.infinity,
                height: 100,
                child: Image.network(url.data,
                  fit: BoxFit.fill,
                  loadingBuilder:(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          [10,10,10,10],
          15,
          5, 5, 0.15, 30,
        );
      },
    );
  }

  Widget _showImages(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Color(this.primaryColorDark).withOpacity(0.5),
            style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      width: double.infinity,
      height: 500,
      // REPLACE THIS LISTVIEW WITH LISTVIEW BUILDER WHEN IMPLEMENTING BACKEND
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("images").orderBy('id', descending: false).startAt([10*this.pageCount]).limit(10).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
          } else {
            if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return this._buildTile(snapshot.data.documents[index]);
                },
              );
            }
            else {
              return AlertDialog(
                title: Text("Aviso"),
                content: Text("Nadie ha compartido sus imágenes.\n¡Sé el primero!"),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Prev Button
        Visibility(
          visible: this.pageCount == 0,
          child: ButtonTemplate.buildBasicButton(
            () => {
              this.pageCount -= (this.pageCount > 0)? 1 : 0,
            },
            this.primaryColorLight, "Previous", this.textColor
          ),
        ),
        // Next Button
        ButtonTemplate.buildBasicButton(
            () => {
              this.pageCount += 1,
            },
            this.primaryColorLight, "Next", this.textColor
        ),
      ],
    );
  }

  Widget _showBigScreen(){
    return ListView(
      children: [
        // 10 images: Author + Image
        this._showImages(),
        // Buttons
        this._buildButtons()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._showBigScreen();
  }
}

