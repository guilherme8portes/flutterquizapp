import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/firebase_options.dart';
import 'package:untitled2/quiz/0firestore/firestore_services.dart';
import 'login/landing_page.dart';
import 'package:provider/single_child_widget.dart';


Future<void> main() async {
  // Garante que o binding do widget esteja inicializado. Isso deve ser chamado antes de usar qualquer método do Flutter framework.
  WidgetsFlutterBinding.ensureInitialized();
  //Inicializa o Firebase com as opções padrão.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // O MultiProvider fornece uma instância de um objeto a seus descendentes.
    return MultiProvider(
      providers: <SingleChildWidget>[
        // A instância do UserService é criada e fornecida aos widgets filhos.
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
       // A instância do FirestoreService é criada e fornecida aos widgets filhos
         Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
          ),
        ),
        home: const LandingPage(),
      ),
    );
  }
}

