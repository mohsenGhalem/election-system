import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'src/interface/auth/view/auth_view.dart';
import 'src/interface/candidates/view/candidates_view.dart';
import 'src/interface/dashboard/view/dashboard_view.dart';
import 'src/interface/elections/view/elections_view.dart';
import 'src/interface/initial/home_page.dart';
import 'src/interface/requests/view/requests_view.dart';
import 'src/interface/security_log/view/security_log_view.dart';
import 'src/interface/voters/view/voter_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  await sb.Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        useMaterial3: true,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: Colors.blue,
            ),
      ),
      home: StreamBuilder(
        stream: sb.Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.session != null) {
              return const HomePage();
            } else {
              return AuthView();
            }
          }
          return AuthView();
        },
      ),
      getPages: [
        GetPage(name: '/auth', page: () => AuthView()),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          children: [
            GetPage(name: '/dashboar', page: () => const DashboardView()),
            GetPage(name: '/election', page: () => const ElectionView()),
            GetPage(name: '/candidate', page: () => const CandidatesView()),
            GetPage(name: '/voter', page: () => const VotersView()),
            GetPage(name: '/requests', page: () => const RequestsView()),
            GetPage(name: '/security', page: () => const SecurityLogView()),
          ],
        ),
      ],
    );
  }
}
