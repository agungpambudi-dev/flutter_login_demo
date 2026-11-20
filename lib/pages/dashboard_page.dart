import 'package:material_ui/material_ui.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/preference_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Service
  final AuthService authService = AuthService();
  final PreferenceService preferenceService = PreferenceService();

  // Data user
  UserModel? user;

  // Status halaman
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // Saat Dashboard pertama kali dibuka,
    // ambil token dan data user
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // 1. Ambil access token dari SharedPreferences
      final accessToken =
          await preferenceService.getAccessToken();

      // Jika token tidak ditemukan,
      // kembali ke halaman Login
      if (accessToken == null || accessToken.isEmpty) {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/',
        );

        return;
      }

      // 2. Ambil data user dari API menggunakan access token
      final userData =
          await authService.getCurrentUser(accessToken);

      if (!mounted) return;

      // 3. Simpan data user ke state
      setState(() {
        user = userData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    // Hapus access token dari SharedPreferences
    await preferenceService.removeAccessToken();

    if (!mounted) return;

    // Hapus semua halaman sebelumnya
    // dan kembali ke Login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    // Menampilkan loading
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    // Menampilkan error
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                loadUserData();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // Jika data user kosong
    if (user == null) {
      return const Text('Data user tidak ditemukan');
    }

    // Menampilkan data user
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.image),
              ),

              const SizedBox(height: 20),

              Text(
                '${user!.firstName} ${user!.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user!.email,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              const Divider(),

              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Username'),
                subtitle: Text(user!.username),
              ),

              ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('User ID'),
                subtitle: Text(user!.id.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}