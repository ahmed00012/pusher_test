import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PusherClient? pusher;
  Channel? pusherChannel;
  StreamController<String> _eventData = StreamController<String>.broadcast();
  Sink get _inEventData => _eventData.sink;

  String msg = '';



  void initPusher() {

    PusherOptions options = PusherOptions(
      cluster: "eu",// Here Put cluster
      auth: PusherAuth(
        'https://app.karia.ly/broadcasting/auth', // Here Put authEndpoint
        headers: {
          'Authorization': 'Bearer 713|GboltnEn7OePYymJQL2K06Y3Tj5LNOlmpXMJjanK',// Here Put token
        },
      ),
    );
    pusher = new PusherClient("e79a1ca92ad32145e531", options,// Here Put APP_KEY
        autoConnect: true, enableLogging: true);

    pusher!.connect().then((value) {
      // pusherChannel = pusher!.subscribe("private-serviceRequests.104");
      // pusherChannel = pusher!.subscribe("private-serviceRequests.106.bids");
       pusherChannel = pusher!.subscribe("private-serviceRequests.106.messages");// Here Put Channel

      pusherChannel!.bind("message",// Here Put Event

              (PusherEvent? event) {
                String data = event!.data!;
                var json = jsonDecode(data);
                print('Pusher response : '+event.data!);
            _inEventData.add(event.data);
            setState(() {
              msg = json['message']['content'];
            });
          });

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    initPusher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(msg,style: TextStyle(fontSize: 20),),

          ],
        ),
      ),
    );
  }
}
