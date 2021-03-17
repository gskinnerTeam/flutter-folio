// import 'dart:math';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_folio/commands.dart/app/authenticate_user_command.dart';
// import 'package:flutter_folio/data/book_data.dart';
// import 'package:flutter_folio/styled_widgets/styled_spinner.dart';
// import 'package:flutter_folio/styled_widgets/styled_stream_builder.dart';
//
//
// // Test Design
// // * Nested Streams of the Same Type
// // * Sibling Streams of the Same Type
//
// class AnimationDriver extends Listenable {
//   Ticker _ticker;
//   List<VoidCallback> _listeners = [];
//
//   void init() {
//     _ticker = Ticker(_handleTick);
//     //_ticker.start();
//   }
//
//   void dispose() {
//     _ticker.stop();
//     _ticker.dispose();
//   }
//
//   void _handleTick(Duration _) {
//     for (final cb in _listeners) {
//       cb();
//     }
//   }
//
//   void addListener(VoidCallback callback) {
//     _listeners.add(callback);
//   }
//
//   void removeListener(VoidCallback callback) {
//     _listeners.remove(callback);
//   }
// }
//
// class FiredartStreamSpike extends StatefulWidgetMixin {
//   State createState() => _FiredartStreamSpikeState();
// }
//
// class _FiredartStreamSpikeState extends State<FiredartStreamSpike> {
//   AnimationDriver _driver = null;
//   bool _signedIn = false;
//   String _currentPage;
//
//   @override
//   void initState() {
//     super.initState();
//     print("Is LoggedIn =${firebase.isSignedIn}");
//     _signedIn = firebase.isSignedIn;
//     _togglePage();
//   }
//
//   void _togglePage() {
//     String page1 = "AxbsfNiVgfPm8gvty1aT";
//     String page2 = "c42ybWbd9550tXmhR9Mf";
//     setState(() {
//       _currentPage = (_currentPage == page2) ? page1 : page2;
//     });
//   }
//
//   void _authenticate() async {
//     bool success = await AuthenticateUserCommand().run(
//       email: "shawn@test.com",
//       pass: "password",
//       createNew: false,
//     );
//     if (success) setState(() => _signedIn = true);
//   }
//
//   void _changeBook(ScrapBookData book) {
//     firebase.setBookData(book.copyWith(title: book.title + "_"));
//   }
//
//   void _changePage(ScrapPageData page) {
//     firebase.setPageData(page.copyWith(title: page.title + "_"));
//   }
//
//   Widget build(BuildContext context) {
//     if (_driver == null) {
//       _driver = AnimationDriver();
//       _driver.init();
//     }
//     if (!_signedIn) {
//       Future.delayed(Duration(seconds: 1), _authenticate);
//     }
//     return MaterialApp(
//       home: Scaffold(
//         body: Container(
//           key: ValueKey(Random().nextInt(999)),
//           color: _signedIn ? Colors.green : Colors.red,
//           child: _signedIn
//               ? AnimatedBuilder(
//                   animation: _driver,
//                   builder: (BuildContext context, Widget widget) {
//                     print('build');
//                     return Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Column(
//                             children: [
//                               Text("BOOK TEST - Test multiple streams of the same book. Click a title to change it."),
//                               StreamBuilder<ScrapBookData>(
//                                   stream: firebase.bookStream(bookId: "893714"),
//                                   builder: (context, snapshot) {
//                                     if (!snapshot.hasData) return LoadingIndicator();
//                                     return FlatButton(
//                                         onPressed: () => _changeBook(snapshot.data), child: Text(snapshot.data.title));
//                                   }),
//                               StyledStreamBuilder<ScrapBookData>(
//                                 //createStream: () => firebase.bookStream(bookId: "893714"),
//                                 stream: firebase.bookStream(bookId: "893714"),
//                                 builder: (BuildContext, data) =>
//                                     FlatButton(onPressed: () => _changeBook(data), child: Text(data.title)),
//                               ),
//                               Text(
//                                   "Collection Test - Test switching from an empty stream to non-empty. Press the boxCount to toggle."),
//                               StreamBuilder<List<PlacedScrapItem>>(
//                                 stream: firebase.allPlacedScrapsStream(bookId: "893714", pageId: _currentPage),
//                                 builder: (BuildContext, data) {
//                                   print("$_currentPage ${data.hasData}, ${data.hasData}");
//                                   return FlatButton(
//                                       onPressed: _togglePage,
//                                       child: Text("$_currentPage.boxCount = ${data.data?.length ?? ""}"));
//                                 },
//                               ),
//                               // StyledStreamBuilder<ScrapBookData>(
//                               //   createStream: () => firebase.bookStream(bookId: "893714"),
//                               //   builder: (BuildContext, data) =>
//                               //       FlatButton(onPressed: () => _changeBook(data), child: Text(data.title)),
//                               // ),
//                               // StyledStreamBuilder<ScrapBookData>(
//                               //   createStream: () => firebase.bookStream(bookId: "893714"),
//                               //   builder: (BuildContext, data) =>
//                               //       FlatButton(onPressed: () => _changeBook(data), child: Text(data.title)),
//                               // ),
//                             ],
//                           ),
//                           // Column(children: [
//                           //   Text("PAGE  TEST - Test multiple streams of the same page. Click a title to change it."),
//                           //   StyledStreamBuilder<ScrapPageData>(
//                           //     createStream: () => firebase.pageStream(bookId: "893714", pageId: "AxbsfNiVgfPm8gvty1aT"),
//                           //     builder: (BuildContext, data) =>
//                           //         FlatButton(onPressed: () => _changePage(data), child: Text(data.title)),
//                           //   ),
//                           //   StyledStreamBuilder<ScrapPageData>(
//                           //     createStream: () => firebase.pageStream(bookId: "893714", pageId: "AxbsfNiVgfPm8gvty1aT"),
//                           //     builder: (BuildContext, data) =>
//                           //         FlatButton(onPressed: () => _changePage(data), child: Text(data.title)),
//                           //   ),
//                           //   StyledStreamBuilder<ScrapPageData>(
//                           //     createStream: () => firebase.pageStream(bookId: "893714", pageId: "AxbsfNiVgfPm8gvty1aT"),
//                           //     builder: (BuildContext, data) =>
//                           //         FlatButton(onPressed: () => _changePage(data), child: Text(data.title)),
//                           //   ),
//                           // ]),
//                           FlatButton(onPressed: () => setState(() {}), child: Text("REBUILD ALL"))
//                         ],
//                       ),
//                     );
//                     // return StreamBuilder<List<ScrapBookData>>(
//                     //     stream: firebase.allBooksStream(),
//                     //     builder: (context, snapshot) {
//                     //       if (snapshot.hasError) {
//                     //         print(snapshot.error);
//                     //       }
//                     //       return snapshot.hasData
//                     //           ? ListView(
//                     //               children: snapshot.data.map((doc) {
//                     //                 return Row(
//                     //                   children: [
//                     //                     Text(doc.toString()),
//                     //                     // Padding(padding: EdgeInsets.only(left: 10)),
//                     //                     // Text('${doc['index'] as int}'),
//                     //                     // Padding(padding: EdgeInsets.only(left: 10)),
//                     //                     // Text(doc['name'] as String),
//                     //                   ],
//                     //                 );
//                     //               }).toList(),
//                     //             )
//                     //           : Container();
//                     //     });
//                   },
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
