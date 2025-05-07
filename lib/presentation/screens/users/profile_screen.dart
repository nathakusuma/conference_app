import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

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
    if (provider.user == null) {
      provider.fetchProfile();
    }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: user.email ?? '',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                enabled: _isEdit,
                decoration: const InputDecoration(labelText: 'Name'),
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
                ),
                maxLength: 500,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
