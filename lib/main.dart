import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newapp/views/login_view.dart';
import 'package:newapp/views/register_view.dart';
import 'package:newapp/views/verify_email_view.dart';
import 'firebase_options.dart';

import 'dart:developer' as devtool show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
        '/verifyEmail/': (context) => const VerifyEmailView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = (FirebaseAuth.instance.currentUser);
            if (user != null) {
              if (user.emailVerified == false) {
                devtool.log(' email not ver');
                return VerifyEmailView();
              } else {
                devtool.log('this func');
                return const NotesView();
              }
            } else {
              //devtool.log(user.toString());
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('main UI'),
      actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (_) => false);
                }
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text('Logout'))
            ];
          },
        )
      ],
    ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('are you sure you want to sign out '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout'))
          ],
        );
      }).then((value) => value ?? false);
}

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_timetable/flutter_timetable.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         routes: {
//           '/': (context) => const TimetableScreen(),
//           '/custom': (context) => const CustomizedTimetableScreen(),
//         },
//       );
// }

// /// Plain old default time table screen.
// class TimetableScreen extends StatelessWidget {
//   const TimetableScreen({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey,
//           actions: [
//             TextButton(
//               onPressed: () async => Navigator.pushNamed(context, '/custom'),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: const [
//                   Icon(Icons.celebration_outlined, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text("Custom builders",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                   SizedBox(width: 8),
//                   Icon(Icons.chevron_right_outlined, color: Colors.white),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: const Timetable(),
//       );
// }

// /// Timetable screen with all the stuff - controller, builders, etc.
// class CustomizedTimetableScreen extends StatefulWidget {
//   const CustomizedTimetableScreen({Key? key}) : super(key: key);
//   @override
//   State<CustomizedTimetableScreen> createState() =>
//       _CustomizedTimetableScreenState();
// }

// class _CustomizedTimetableScreenState extends State<CustomizedTimetableScreen> {
//   final items = generateItems();
//   final controller = TimetableController(
//     start: DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 7)),
//     initialColumns: 3,
//     cellHeight: 100.0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         controller.jumpTo(DateTime.now());
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey,
//           actions: [
//             TextButton(
//               onPressed: () async => Navigator.pop(context),
//               child: Row(
//                 children: const [
//                   Icon(Icons.chevron_left_outlined, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text("Default",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_day),
//               onPressed: () => controller.setColumns(1),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_month_outlined),
//               onPressed: () => controller.setColumns(3),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_view_week),
//               onPressed: () => controller.setColumns(5),
//             ),
//             IconButton(
//               icon: const Icon(Icons.zoom_in),
//               onPressed: () =>
//                   controller.setCellHeight(controller.cellHeight + 10),
//             ),
//             IconButton(
//               icon: const Icon(Icons.zoom_out),
//               onPressed: () =>
//                   controller.setCellHeight(controller.cellHeight - 10),
//             ),
//           ],
//         ),
//         body: Timetable<String>(
//           controller: controller,
//           items: items,
//           cellBuilder: (datetime) => Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blueGrey, width: 0.2),
//             ),
//             child: Center(
//               child: Text(
//                 DateFormat("MM/d/yyyy\nha").format(datetime),
//                 style: TextStyle(
//                   color: Color(0xff000000 +
//                           (0x002222 * datetime.hour) +
//                           (0x110000 * datetime.day))
//                       .withOpacity(0.5),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           cornerBuilder: (datetime) => Container(
//             color: Colors.accents[datetime.day % Colors.accents.length],
//             child: Center(child: Text("${datetime.year}")),
//           ),
//           headerCellBuilder: (datetime) {
//             final color =
//                 Colors.primaries[datetime.day % Colors.accents.length];
//             return Container(
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: color, width: 2)),
//               ),
//               child: Center(
//                 child: Text(
//                   DateFormat("E\nMMM d").format(datetime),
//                   style: TextStyle(
//                     color: color,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           },
//           hourLabelBuilder: (time) {
//             final hour = time.hour == 12 ? 12 : time.hour % 12;
//             final period = time.hour < 12 ? "am" : "pm";
//             final isCurrentHour = time.hour == DateTime.now().hour;
//             return Text(
//               "$hour$period",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
//               ),
//             );
//           },
//           itemBuilder: (item) => Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withAlpha(220),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: Offset(0, 2)),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 item.data ?? "",
//                 style: TextStyle(fontSize: 14),
//               ),
//             ),
//           ),
//           nowIndicatorColor: Colors.red,
//           snapToDay: true,
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Text("Now"),
//           onPressed: () => controller.jumpTo(DateTime.now()),
//         ),
//       );
// }

// /// Generates some random items for the timetable.
// List<TimetableItem<String>> generateItems() {
//   final random = Random();
//   final items = <TimetableItem<String>>[];
//   final today = DateUtils.dateOnly(DateTime.now());
//   for (var i = 0; i < 100; i++) {
//     int hourOffset = random.nextInt(56 * 24) - (7 * 24);
//     final date = today.add(Duration(hours: hourOffset));
//     items.add(TimetableItem(
//       date,
//       date.add(Duration(minutes: (random.nextInt(8) * 15) + 15)),
//       data: "item $i",
//     ));
//   }
//   return items;
// }
