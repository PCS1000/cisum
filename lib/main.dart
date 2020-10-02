import 'package:cisum/presentation/presentation_screen.dart';
import 'package:cisum/root/auth.dart';
import 'package:cisum/root/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final _darkMainColor = const Color(0xFFE8BE33);
  final _mainColor = const Color(0xFFF0F2F6);
  final _inBetweenMainColor = const Color(0xFF31373C);
  final _brightMainColor = const Color(0xFFEAEBF3);//F1F3F6
  final _backgroundColor = const Color(0xFF1D1C1A);//1D1C1A
  final _alternativeColor = const Color(0xFFFFD182);
  final _otherAlternativeColor = const Color(0xFFF0C881);//E6C77E

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: "Cisum",
        theme: ThemeData(
          fontFamily: "MontSerrat",
          primarySwatch: Colors.blue,
          highlightColor: _darkMainColor,
          primaryColor: _mainColor,//COR PRIMARIA
          primaryColorDark: _inBetweenMainColor,//COR SECUNDÁRIA
          primaryColorLight: _brightMainColor,//COR MAIS CLARA
          backgroundColor: _backgroundColor,//COR DE FUNDO
          accentColor: _alternativeColor,//COR ALTERNATIVA
          cursorColor: _otherAlternativeColor,//OUTRA COR ALTERNATIVA
        ),
        debugShowCheckedModeBanner: false,
        home: PresentationScreen(),
      ),
    );
  }
}






