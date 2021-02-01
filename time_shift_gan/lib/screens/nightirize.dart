// Basic
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';

// Models

// Templates
import 'package:time_shift_gan/templates/container_template.dart';
import 'package:time_shift_gan/templates/dialog_template.dart';

// Backend

class NightirizeScreen extends StatefulWidget{
  NightirizeScreen({Key key});

  NightirizeState createState() => NightirizeState();
}

class NightirizeState extends State<NightirizeScreen>{
  NightirizeState({Key key});
  final _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController _cameraController;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  XFile imageFile;

  @override
  void initState(){
    super.initState();
    this._initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cameraController != null
          ? this._initializeControllerFuture = this._cameraController.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    this._cameraController = CameraController(cameras.first,ResolutionPreset.high);
    this._initializeControllerFuture = this._cameraController.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  Widget _buidTakePictureButton(bool isPivot){
    return new Padding(padding: EdgeInsets.only(left: 5, right: 5),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          //padding: new EdgeInsets.only(left: 20, right: 20),
          onPressed: () async {
            if (!this._cameraController.value.isInitialized) {
              this._scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('An error ocurred, please try again')));
            }
            else if (_cameraController.value.isTakingPicture) {
            }
            else {
              try {
                this.imageFile = await _cameraController.takePicture(); //take photo
                setState(() {
                  this.showCapturedPhoto = true;
                });
              } catch (e) {
                print(e);
              }
            }
          },
          color: new Color(0xFF002FD3),
          textColor: Colors.white,
          child: Text("Open\nCamera",
            style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
        ),
    );
  }

  Widget _nightirizeButton(){
    return new Padding(padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        //padding: new EdgeInsets.only(left: 20, right: 20),
        onPressed: () async {
          DialogTemplate.showMessage(context, "Testing", "Warning", 0);

          /*
          if(this._signature == null){
            DialogTemplate.showMessage(context, "Please, select a signature to verify");
          }
          else if(!this._convolutionalClassification && !this._signer_signatureClassification && !this._siameseNetwork){
            DialogTemplate.showMessage(context, "Please, select a model to verify a signature");
          }
          else {
            // All good
            String aiserver_link = "";
            final CollectionReference misc = FirebaseFirestore.instance.collection('miscellaneous');
            await misc.doc("aiserver").get().then((
                snapshot) {
              if(snapshot.exists) {
                aiserver_link = snapshot.get("server");
              }
            });

            DialogTemplate.initLoader(context, "Please, wait for a moment...");
            AIResponse response = await AIHTTPRequest.predictRequest(aiserver_link, this.client.getUID(), this._models, this._signature, true);
            String clientName = this.client.getParameterByString("name") + " " + this.client.getParameterByString("lname");
            int logCode = await (new QueryLog()).pushLog(
                0, " requested a signature verification request on (CLIENT)" + clientName,
                this.issuer,
                clientName ,
                this.client.getUID(),
                0, "Issued a signature verification request.", 0
            );
            DialogTemplate.terminateLoader();

            // Conv model results
            String cm_results = "";
            String ss_results = "";
            String sm_results = "";
            if(response.getModelFlag("conv")) {
              cm_results = "\n\nThe Convolutional Model estimates that the signature is " + response.getConvPred()[0]
                  + ".\nThe signer was classified " + response.getConvPred()[1] + "ly.";
              if(response.getConvPred()[1] == 'correct') cm_results += "\nThe Model is " + response.getModelProbability('conv') + "% confident about its veredict.";
            }
            if(response.getModelFlag("ss")) {
              ss_results = "\n\nThe Signer-Signature Model classified the signer " + response.getSSPred()[0] + "ly."
                  + " It estimates that the signature is " + response.getSSPred()[1] + ".";
              if(response.getSSPred()[0] == 'correct') ss_results += "\nThe Model is " + response.getModelProbability('ss') + "% confident about its veredict.";
            }
            if(response.getModelFlag("siamese")) {
              sm_results = response.getSiameseSuccess()? "\n\nThe Siamese Model estimates that the signature is " + response.getSiamesePred() + "." :
              " \n\nAn error occurred with the Siamese Model, the client does not have any registered signatures." ;
            }

            String total_text = "Results:" + cm_results + ss_results + sm_results;

            // Show results
            this._showResult(context, total_text);
          }
          */
        },
        color: new Color(0xFF002FD3),
        textColor: Colors.white,
        child: Text("Verify",
            style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildNightirize(){
    return new Form(
      child: new ListView(
        //physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ContainerTemplate.buildContainer(
              new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 5),
                    child: new Text("Take Picture", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 28), textAlign: TextAlign.center,),
                  ),
                  this._buidTakePictureButton(false),
                  new Container(
                    padding: new EdgeInsets.all(30),
                    child: (this.showCapturedPhoto)? Image.file(File(imageFile.path)) : null,
                  ),
                  this._nightirizeButton(),
                ],
              ),
              [20, 20, 20, 40], 15,
              10, 10, 0.15, 30
          ),
        ],
      ),
      key: this._formkey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._buildNightirize();
  }
}

