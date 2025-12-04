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
  
  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit(_authData['username']!, _authData['password']!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username (Coba: admin@kopi.com)', border: OutlineInputBorder()),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) { return 'Masukkan Username!'; }
              return null;
            },
            onSaved: (value) { _authData['username'] = value!; },
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password (Coba: admin123)', border: OutlineInputBorder()),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty || value.length < 5) { return 'Password minimal 5 karakter!'; }
              return null;
            },
            onSaved: (value) { _authData['password'] = value!; },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 16)),
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
    // Kita buat tampilan sederhana untuk Register
    return Column(
      children: [
        const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder())),
        const SizedBox(height: 15),
        const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 15),
        const TextField(
          decoration: InputDecoration(labelText: 'Password Baru', border: OutlineInputBorder()),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Simulasikan pendaftaran berhasil dan redirect ke login
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pendaftaran Berhasil! Silakan Login.'), backgroundColor: Colors.green.shade700));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('DAFTAR SEKARANG', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

// --- LAYAR OTENTIKASI UTAMA (MENGGUNAKAN TAB BAR) ---
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
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.brown.shade50,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 30.0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade700,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 2))],
                  ),
                  child: const Text('Kopi Kang Dafa', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                
                Container(
                  width: deviceSize.width * 0.9,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.brown.shade800,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green.shade700,
                        tabs: const [
                          Tab(text: 'LOGIN'),
                          Tab(text: 'DAFTAR'),
                        ],
                      ),
                      const Divider(height: 30),
                      
                      SizedBox(
                        height: 350,
                        child: TabBarView(
                          children: [
                            _isLoading 
                              ? const Center(child: CircularProgressIndicator())
                              : _LoginWidget(onSubmit: _submitAuth),
                            
                            const _RegisterWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}