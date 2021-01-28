// Basic Imports
import 'package:flutter/material.dart';

// Routes

// Templates
import 'package:time_shift_gan/templates/container_template.dart';
import 'package:time_shift_gan/templates/navbar_template.dart';
import 'package:time_shift_gan/templates/fade_template.dart';
import 'package:time_shift_gan/templates/dialog_template.dart';

// Models
import 'package:time_shift_gan/models/navbar.dart';

// Backend
import 'package:url_launcher/url_launcher.dart';

class Screen extends StatelessWidget {
  Screen({Key key});

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  bool isActive, landedWidget = false;
  //Option option;
  NavBar navBar;
  FadeAnimation _fadeAnimation;

  @override
  void initState(){
    super.initState();
    navBar = new NavBar(1, 1);
    this._fadeAnimation = new FadeAnimation(this);
  }

  MainScreenState({Key key, @required this.isActive});

  Widget defaultScreen() {
    return new Center(
      child: ContainerTemplate.buildContainer(
        new Padding(
            padding: new EdgeInsets.all(10),
            child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Text(
                    "Picture Time Shifter",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 5, top: 5),
                    child: new Divider(color: new Color(0x000000).withOpacity(0.15), thickness: 1,),
                  ),
                  new Text(
                    "Innovation Lab",
                    style: new TextStyle(fontSize: 18), textAlign: TextAlign.center,
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 5, top: 5),
                    child: new Divider(color: new Color(0x000000).withOpacity(0.15), thickness: 1,),
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        "¡Bienvenido!\nEsta es una aplicación que te permite cambiar de día a noche a las fotografías que le has tomado al cielo.\n"
                            + "Puedes publicar tus fotos modificadas y puedes ver el trabajo de otras personas.\n¡Diviértete!",
                        style: new TextStyle(fontSize: 15),
                      ),
                      new GestureDetector(
                        onTap: () async {
                          const url = 'https://www.instagram.com/innovationlabug/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            DialogTemplate.showMessage(context, "No se pudo abrir el navegador Browser, hubo un error.", "Aviso", 0);
                          }
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              height: 35,
                              width: 35,
                              child: new Image.asset('assets/images/instagram.png'),
                            ),
                            new Text("@innovationlabug", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ),
        [30, 40, 30, 20], 25,
        15, 15, 0.15, 30,
      ),
    );
  }

  Widget returnScreen() {
    Widget toShow;
    switch(this.navBar.getPageIndex()) {
      case 0:
        toShow = Container();
        break;
      case 1:
        toShow = this.defaultScreen();
        break;
      case 2:
        toShow = Container();
        break;
      default:
        toShow = new Container();
        break;
    }
    return toShow;
  }

  void navOnTap(index){
    setState(() {
      this.navBar.setBoth(index);
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  height: 40,
                  width: 40,
                  child: new Image.asset('assets/images/help.png'),
                ),
                new Padding(
                  padding: new EdgeInsets.only(left: 15),
                  child: new Text('Advertencia'),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new SingleChildScrollView(
              child: new Text('Si sales ahorita de la aplicación perderás todo tu progreso.\n¿Estás seguro que quieres salir?'),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Container(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/confirm.png'),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Container(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/cancel.png'),
                ),
              ),
            ],
          );
        }
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: NavBarTemplate.buildBottomNavBar(
        this.navBar,
        NavBarTemplate.buildTripletItems([Icons.collections, Icons.image], ["Collección", "Alterar"]),
        navOnTap,
        NavBarTemplate.buildFAB(
            Icons.home,
            () {
              setState(() {
                this.navBar.setBoth(1);
              });
            },
            "main_screen_fab"
        ),
        this._fadeAnimation.fadeNow(this.returnScreen()),
      ),
    );
  }
}

/*

Ideas:
- Card Hunter
	* 5 cards: Snowman, xmas tree, fireworks, Santa Claus, gift,
		- Fireworks: publish a comment on "What makes you happy on Xmas?"
		- Snowman: Collect 3 snowballs, a carrot and pebles
		- Xmas Tree: Turn on Dark mode then Light mode
		- Gift: Tap the home menu a total of 25 times then go to profile screen
		- Santa Claus: Tap on "December 25"
- Screens:
	1. Welcome screen
		* Welcome message
	2. Comment space
		*
	3. Quiz section
		* 5 random questions
	4. Profile Screen
		* Profile picture
		4.2 Card collection
			- Clicking on the not collected cards to give hints
			- Congrats Button → LInk →  Image
	6. FAQ Zone
		* Brief explanations of cool Guatemalan stuff
 */