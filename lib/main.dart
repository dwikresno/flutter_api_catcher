import 'package:flutter/material.dart';
import 'package:flutter_api_catcher/model/product/product_model.dart';
import 'package:flutter_api_catcher/viewmodel/global_view_model.dart';
import 'package:flutter_api_catcher/viewmodel/product_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<GlobalViewModel>(
            create: (_) => GlobalViewModel(),
          ),
          ChangeNotifierProvider<ProductViewModel>(
            create: (_) => ProductViewModel(),
          ),
        ],
        builder: (context, child) {
          return MyApp();
        }),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Provider.of<GlobalViewModel>(context, listen: false)
          .alice
          .getNavigatorKey(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            children: [
              child!,
              Positioned(
                left: -8,
                top: MediaQuery.of(context).size.height / 2,
                child: GestureDetector(
                  onTap: () {
                    Provider.of<GlobalViewModel>(context, listen: false)
                        .alice
                        .showInspector();
                  },
                  child: Card(
                    child: Icon(
                      Icons.nearby_error,
                      color: Color(0xFFD6C800),
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<ProductModel>? getDataProduct;

  @override
  void initState() {
    getDataProduct = Provider.of<ProductViewModel>(context, listen: false)
        .getDataProduct(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<ProductModel>(
          future: getDataProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.products!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(snapshot.data!.products!
                                .elementAt(index)
                                .thumbnail!),
                            SizedBox(height: 10),
                            Text(
                              snapshot.data!.products!
                                  .elementAt(index)
                                  .description!,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("no data"),
                  );
                }
              }
              return Center(
                child: Text(snapshot.stackTrace.toString()),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
