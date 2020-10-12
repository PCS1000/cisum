import 'dart:io';
import 'package:audioplayer2/audioplayer2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';

class PlayerWhite extends StatefulWidget {
  final PageController controller;

  PlayerWhite({this.controller});

  @override
  _PlayerWhiteState createState() => _PlayerWhiteState();
}

class _PlayerWhiteState extends State<PlayerWhite> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();

  final FocusNode _titleFocus = new FocusNode();
  final FocusNode _nameFocus = new FocusNode();

  bool _isSquare = false;
  String url = '';
  String path = '';
  String name = 'Song Title';
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState playerState;
  Duration position;
  Duration duration;
  var _positionSubscription;
  var _audioPlayerStateSubscription;

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);

    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = AudioPlayerState.STOPPED;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });

    var durationText = duration != null
        ? duration.toString().split('.').first.replaceRange(0, 2, '')
        : '';
    var positionText = position != null
        ? position.toString().split('.').first.replaceRange(0, 2, '')
        : '';

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  height: data.size.height / 2,
                ),
                GestureDetector(
                  onTap: () {
                    alertDialog(context: context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: _isSquare == true ? 15 : 0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _titleController.text.isNotEmpty ? _titleController.text : 'MUSICA',
                          // _titleController.text.isNotEmpty ? _titleController.text : 'MUSICA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColorDark,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          _nameController.text.isNotEmpty ? _nameController.text : 'ARTISTA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              var path =
                                  await FlutterDocumentPicker.openDocument();
                              this.path = path;
                            },
                            child: duration == null
                                ? new Container()
                                : new Slider(
                                    value:
                                        position?.inMilliseconds?.toDouble() ??
                                            0,
                                    onChanged: (double value) async {
                                      await audioPlayer.play(path);
                                      setState(() {
                                        isPlaying = true;
                                      });
                                      audioPlayer
                                          .seek((value / 1000).roundToDouble());
                                    },
                                    min: 0.0,
                                    max: duration.inMilliseconds.toDouble(),
                                    activeColor: Color(0xFFFCB3FF),
                                    inactiveColor: Color(0xFF7B8285),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              position != null
                                  ? "${positionText ?? ''} / ${durationText ?? ''}"
                                  : duration != null
                                      ? durationText
                                      : '',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColorDark,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            if (duration != null) {
                              await audioPlayer.stop();
                              audioPlayer.play(path);
                              setState(() {
                                isPlaying = true;
                              });
                            }
                          },
                          child: _buttonPlayer(
                              height: 60,
                              width: 60,
                              height2: 55,
                              width2: 55,
                              icon: Icons.fast_rewind),
                        ),
                        isPlaying == false
                            ? GestureDetector(
                                onTap: () async {
                                  if (duration != null) {
                                    audioPlayer.play(path);

                                    setState(() {
                                      isPlaying = true;
                                    });
                                  }
                                },
                                child: _buttonPlayer(
                                  height: 80,
                                  width: 80,
                                  height2: 75,
                                  width2: 75,
                                  icon: Icons.play_arrow,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (duration != null) {
                                    audioPlayer.pause();

                                    setState(() {
                                      isPlaying = false;
                                    });
                                  }
                                },
                                child: _buttonPlayer(
                                  height: 80,
                                  width: 80,
                                  height2: 75,
                                  width2: 75,
                                  icon: Icons.pause,
                                )),
                        GestureDetector(
                          onTap: () async {
                            var path =
                                await FlutterDocumentPicker.openDocument();
                            this.path = path;
                          },
                          child: _buttonPlayer(
                            height: 60,
                            width: 60,
                            height2: 55,
                            width2: 55,
                            icon: Icons.fast_forward,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () async {
                if (this.url != '')
                  await FirebaseStorage.instance
                      .getReferenceFromUrl(this.url)
                      .then((image) => image.delete());
                File imgFile =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                StorageUploadTask task = FirebaseStorage.instance
                    .ref()
                    .child(imgFile.toString())
                    .putFile(imgFile);
                StorageTaskSnapshot taskSnapshot = await task.onComplete;
                String url = await taskSnapshot.ref.getDownloadURL();

                setState(() {
                  this.url = url;
                });
              },
              child: url == ''
                  ? Container(
                      margin: EdgeInsets.only(top: 50),
                      child: _buttonPlayer(
                          height: 200,
                          width: _isSquare == true ? 300 : 200,
                          height2: 185,
                          width2: _isSquare == true ? 285 : 185,
                          isBigButton: true,
                          isSquare: _isSquare),
                    )
                  : Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: _buttonPlayer(
                                height: 200,
                                width: _isSquare == true ? 300 : 200,
                                height2: 185,
                                width2: _isSquare == true ? 285 : 185,
                                isBigButton: true,
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(url),
                                ),
                                isSquare: _isSquare),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  widget.controller.previousPage(
                      duration: Duration(microseconds: 1),
                      curve: Curves.ease);
                },
                child: _buttonPlayer(
                  height: 60,
                  width: 60,
                  height2: 55,
                  width2: 55,
                  icon: Icons.brightness_medium,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  if (_isSquare == false) {
                    setState(() {
                      _isSquare = true;
                    });
                  } else {
                    setState(() {
                      _isSquare = false;
                    });
                  }
                },
                child: _buttonPlayer(
                  height: 60,
                  width: 60,
                  height2: 55,
                  width2: 55,
                  icon: Icons.photo_size_select_actual,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  alertDialog({BuildContext context}) {
    var data = MediaQuery.of(context);

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (ctx, setState) {
            return Container(
              margin: EdgeInsets.only(top: 50.0),
              child: AlertDialog(
                backgroundColor: Theme.of(context).primaryColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _titleController.text;
                        _nameController.text;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
                content: Container(
                  height: data.size.height / 2,
                  width: data.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      textField(_titleController, _titleFocus, _nameFocus,
                          Icons.music_note),
                      textField(_nameController, _nameFocus, new FocusNode(),
                          Icons.photo),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget textField(TextEditingController controller, FocusNode focus,
      FocusNode nextFocus, IconData icon) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: TextFormField(
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).cursorColor,
          letterSpacing: 1.0,
          fontFamily: 'WinterSans',
        ),
        focusNode: focus,
        onFieldSubmitted: (String value) {
          if (value != null || value.isNotEmpty) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 18.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Theme.of(context).cursorColor,
          )),
          hintText: controller == _titleController ? "Song Title" : "Artist",
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).cursorColor,
            letterSpacing: 1.0,
            fontFamily: 'WinterSans',
          ),
        ),
      ),
    );
  }

  Widget _buttonPlayer(
      {double height,
      double width,
      double height2,
      double width2,
      IconData icon,
      bool isBigButton,
      Widget child,
      DecorationImage image,
      bool isSquare}) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      margin:
          EdgeInsets.only(top: isSquare == true ? 70 : 25, left: 15, right: 15),
      decoration: BoxDecoration(
        shape: isSquare == true ? BoxShape.rectangle : BoxShape.circle,
        color: Color(0xFFF0F0F3),
        boxShadow: [
          BoxShadow(
            spreadRadius: 4,
            blurRadius: isBigButton == true ? 20 : 10,
            offset: isBigButton == true ? Offset(-16, -14) : Offset(-5, -7),
            color: Color(0xFFFFFFFF)
                .withOpacity(isBigButton == true ? 0.60 : 0.80),
          ),
          BoxShadow(
            spreadRadius: 0,
            blurRadius: isBigButton == true ? 20 : 15,
            offset: isBigButton == true ? Offset(28, 15) : Offset(10, 10),
            color: Color(0xFFAEAEC0)
                .withOpacity(isBigButton == true ? 0.20 : 0.40),
          ),
        ],
      ),
      child: Container(
        height: height2,
        width: width2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: isSquare == true ? BoxShape.rectangle : BoxShape.circle,
            image: image,
            gradient: LinearGradient(colors: [
              Color(0xFFF0F0F3),
              Color(0xFFFFFFFF),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: icon != null
            ? Icon(
                icon,
                color: Colors.black54,
              )
            : child ?? Container(),
      ),
    );
  }
}
