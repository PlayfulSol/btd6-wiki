// import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/services.dart';
//
// import '/utilities/global_state.dart';
// import '/utilities/requests.dart';
// import '/utilities/images_url.dart';
//
// import '/presentation/widgets/loader.dart';
// import '/presentation/screens/hero/single_hero.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
//
// class Maps extends StatefulWidget {
//   const Maps({required Key key}) : super(key: key);
//
//   @override
//   _MapsState createState() => _MapsState();
// }
//
// class _MapsState extends State<Maps> {
//   List<dynamic> _jsonData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _listofFiles();
//     // _loadJsonData();
//   }
//
//   void _listofFiles() async {
//     final file = File('${Directory.current.path}/data/maps/#ouch.json');
//     final contents = file.readAsStringSync();
//     print(file);
//     print(contents);
//     final directory = Directory('${Directory.current.path}/data/maps');
//     final files = await directory.list().toList();
//     final jsonFiles = files.where((file) => file.path.endsWith('.json'));
//     for (final file in jsonFiles) {
//       print(file.path);
//     }
//     // final directory = (await getApplicationDocumentsDirectory()).path;
//     // setState(() {
//     //   final file = Directory("$directory/data").listSync();
//     //   print(file);
//     // });
//   }
//
//   Future<void> _loadJsonData() async {
//     final String response =
//         await rootBundle.loadString('/presentation/screens/maps/data');
//     final directory = Directory('${Directory.current.path}/data');
//     final files = await directory.list().toList();
//
//     final jsonData = await Future.wait(
//       files.map((file) async {
//         final contents = await (file as File).readAsString();
//         return json.decode(contents);
//       }),
//     );
//
//     setState(() {
//       _jsonData = jsonData;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Maps'),
//         ),
//         body: Text('Maps')
//         //   body: _jsonData.isEmpty
//         //       ? Center(
//         //           child: CircularProgressIndicator(),
//         //         )
//         //       : ListView.builder(
//         //           itemCount: _jsonData.length,
//         //           itemBuilder: (context, index) {
//         //             final data = _jsonData[index];
//         //             return ListTile(
//         //               title: Text(data['name']),
//         //               subtitle: Text(data['description']),
//         //             );
//         //           },
//         //         ),
//         );
//   }
// }
//
// // class Maps extends StatefulWidget {
// //   const Maps({super.key});
//
// //   @override
// //   State<Maps> createState() => _HeroesState();
// // }
//
// // class _HeroesState extends State<Maps> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(10.0),
// //         child: FutureBuilder(
// //           future: Future.value(GlobalState.heroes),
// //           builder: (BuildContext context, AsyncSnapshot snapshot) {
// //             if (snapshot.data == null) {
// //               return const Loader();
// //             } else {
// //               return LayoutBuilder(builder: (context, constraints) {
// //                 int crossAxisCount = 2;
// //                 double childAspectRatio = 1.5;
// //                 double cardHeight = 130;
// //                 double titleFontSize = 15;
// //                 double subtitleFontSize = 13;
//
// //                 if (constraints.maxWidth < 450) {
// //                   crossAxisCount = 1;
// //                   titleFontSize = 18;
// //                   subtitleFontSize = 15;
// //                   cardHeight = 100;
// //                 } else if (constraints.maxWidth < 1200) {
// //                   crossAxisCount = 2;
// //                   childAspectRatio = 1;
// //                   titleFontSize = 20;
// //                   subtitleFontSize = 16;
// //                 } else {
// //                   crossAxisCount = 3;
// //                   childAspectRatio = 0.75;
// //                   titleFontSize = 24;
// //                   subtitleFontSize = 18;
// //                 }
//
// //                 return GridView.builder(
// //                     itemCount: snapshot.data.length,
// //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                       crossAxisCount: crossAxisCount,
// //                       childAspectRatio: childAspectRatio,
// //                       mainAxisSpacing: 7,
// //                       crossAxisSpacing: 7,
// //                       mainAxisExtent: cardHeight,
// //                     ),
// //                     shrinkWrap: true,
// //                     itemBuilder: (context, index) {
// //                       return Card(
// //                           child: ListTile(
// //                               dense: false,
// //                               isThreeLine: true,
// //                               mouseCursor: SystemMouseCursors.click,
// //                               leading: SizedBox(
// //                                 height: double.infinity,
// //                                 child: CircleAvatar(
// //                                     backgroundColor: Colors.transparent,
// //                                     child: Image.network(heroBaseImage(
// //                                         snapshot.data[index].id))),
// //                               ),
// //                               title: AutoSizeText(snapshot.data[index].name,
// //                                   wrapWords: false,
// //                                   style: TextStyle(fontSize: titleFontSize)),
// //                               subtitle: AutoSizeText(
// //                                 snapshot.data[index].description,
// //                                 overflow: TextOverflow.ellipsis,
// //                                 maxLines: 3,
// //                                 wrapWords: false,
// //                                 style: TextStyle(fontSize: subtitleFontSize),
// //                               ),
// //                               onTap: () => {
// //                                     if (!GlobalState.isLoading)
// //                                       {
// //                                         getHeroData(snapshot.data[index].id)
// //                                             .then((value) => Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                     builder: (context) =>
// //                                                         SingleHero(
// //                                                           singleHero: value,
// //                                                           heroId: snapshot
// //                                                               .data[index].id,
// //                                                         )))),
// //                                       }
// //                                   }));
// //                     });
// //               });
// //             }
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
