import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchProfile();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
  }

  void _setControllers() {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _nameController.text = user?.name ?? '';
    _bioController.text = user?.bio ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<UserProvider>(context, listen: false);
    final success = await provider.updateProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim().isNotEmpty ? _bioController.text.trim() : null,
    );
    if (success) {
      setState(() => _isEdit = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
    if (provider.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      provider.clearError();
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.routeName,
              (route) => false
      );
    }
  }

  Future<void> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final user = provider.user;
    final loading = provider.status == UserStatus.loading;

    if (user != null && !_isEdit) {
      _setControllers(); // refresh with new data if coming back from save
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEdit)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: loading ? null : provider.fetchProfile,
            ),
          !_isEdit
              ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: loading ? null : () => setState(() => _isEdit = true),
          )
              : IconButton(
            icon: const Icon(Icons.save),
            onPressed: loading ? null : _saveProfile,
          ),
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: loading
                  ? null
                  : () {
                _setControllers();
                setState(() => _isEdit = false);
              },
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text('No profile available'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: user.email ?? '',
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      enabled: _isEdit,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        if (value.length > 100) {
                          return 'Name must be less than 100 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      enabled: _isEdit,
                      decoration: const InputDecoration(
                        labelText: "Bio",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 500,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    if (!_isEdit)
                      Card(
                        child: ListTile(
                          title: const Text('User Role'),
                          subtitle: Text(
                            user.role.toString().split('.').last,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (!_isEdit)
                      Card(
                        child: ListTile(
                          title: const Text('Account Created'),
                          subtitle: Text(
                            user.createdAt != null
                                ? '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                                : 'Unknown',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!_isEdit)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    onPressed: _confirmLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
