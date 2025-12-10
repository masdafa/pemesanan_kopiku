// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'main_tabs_screen.dart';

// --- WIDGET UNTUK LOGIN ---
class _LoginWidget extends StatefulWidget {
  final Function(String, String) onSubmit;
  const _LoginWidget({required this.onSubmit});

  @override
  __LoginWidgetState createState() => __LoginWidgetState();
}

class __LoginWidgetState extends State<_LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {'username': '', 'password': ''};
  
  // Controller untuk fitur "Isi Demo"
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(_authData['username']!, _authData['password']!);
  }

  void _fillDemoAccount() {
    setState(() {
      _userController.text = 'admin@kopi.com';
      _passController.text = 'admin123';
    });
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _userController,
            decoration: InputDecoration(
              labelText: 'Email / Username', 
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) { return 'Masukkan Username!'; }
              return null;
            },
            onSaved: (value) { _authData['username'] = value!; },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _passController,
            decoration: InputDecoration(
              labelText: 'Password', 
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _saveForm(),
            validator: (value) {
              if (value!.isEmpty || value.length < 5) { return 'Password minimal 5 karakter!'; }
              return null;
            },
            onSaved: (value) { _authData['password'] = value!; },
          ),
          
          // Tombol Bantuan Demo (Opsional untuk Portfolio)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _fillDemoAccount,
              child: const Text('Isi Akun Demo', style: TextStyle(fontSize: 12)),
            ),
          ),
          
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('MASUK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET UNTUK REGISTER (SIMULASI) ---
class _RegisterWidget extends StatelessWidget {
  const _RegisterWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Nama Lengkap', 
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          )
        ),
        const SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email', 
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ), 
          keyboardType: TextInputType.emailAddress
        ),
        const SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password Baru', 
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pendaftaran Berhasil! Silakan Login.'), 
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                )
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('DAFTAR SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// --- LAYAR OTENTIKASI UTAMA ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terjadi Kesalahan'),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: <Widget>[
          TextButton(child: const Text('OK'), onPressed: () { Navigator.of(ctx).pop(); }),
        ],
      ),
    );
  }

  Future<void> _submitAuth(String username, String password) async {
    setState(() { _isLoading = true; });

    try {
      await Provider.of<UserProvider>(context, listen: false).login(username, password);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainTabsScreen()),
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        _showErrorDialog(error.toString().replaceFirst('Exception: ', ''));
      }
    } catch (error) {
       if (mounted) {
         _showErrorDialog('Terjadi kesalahan yang tidak terduga. Coba lagi.');
       }
    }

    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Header Logo Section
                Container(
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    children: [
                       Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ]
                        ),
                        child: const Icon(Icons.coffee, size: 50, color: Colors.white),
                       ),
                       const SizedBox(height: 20),
                       Text(
                         'Kopi Kang Dafa', 
                         style: theme.textTheme.headlineMedium?.copyWith(
                           color: theme.colorScheme.primary, 
                           fontWeight: FontWeight.bold
                         )
                       ),
                       const SizedBox(height: 8),
                       Text(
                         'Nikmati kopi terbaik hari ini',
                         style: TextStyle(color: Colors.grey.shade600),
                       ),
                    ],
                  ),
                ),
                
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    width: deviceSize.width,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey.shade600,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: theme.colorScheme.primary,
                            ),
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: 'MASUK'),
                              Tab(text: 'DAFTAR'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        SizedBox(
                          height: 360, // Adjusted height
                          child: TabBarView(
                            children: [
                              _isLoading 
                                ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                                : _LoginWidget(onSubmit: _submitAuth),
                              
                              const _RegisterWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                Text(
                  'v1.0.0 © 2024 Dafa Yunidar',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
