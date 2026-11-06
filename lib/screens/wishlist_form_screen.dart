
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wishlist.dart';
import '../providers/wishlist_provider.dart';

class WishlistFormScreen extends StatefulWidget {
  final Wishlist? wishlist;

  const WishlistFormScreen({
    super.key,
    this.wishlist,
  });

  @override
  State<WishlistFormScreen> createState() =>
      _WishlistFormScreenState();
}

class _WishlistFormScreenState extends State<WishlistFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _cafeIdController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  bool _isSaving = false;

  bool get _isEditing => widget.wishlist != null;

  @override
  void initState() {
    super.initState();

    final item = widget.wishlist;

    _cafeIdController = TextEditingController(
      text: item?.cafeId ?? '',
    );
    _nameController = TextEditingController(
      text: item?.cafeName ?? '',
    );
    _addressController = TextEditingController(
      text: item?.address ?? '',
    );
    _latitudeController = TextEditingController(
      text: item?.latitude.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: item?.longitude.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _cafeIdController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi.';
    }
    return null;
  }

  String? _coordinateValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Koordinat wajib diisi.';
    }

    final number = double.tryParse(value.trim().replaceAll(',', '.'));

    if (number == null) {
      return 'Masukkan angka yang valid.';
    }

    return null;
  }

  Future<void> _saveWishlist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final oldItem = widget.wishlist;

    final wishlist = Wishlist(
      id: oldItem?.id,
      cafeId: _cafeIdController.text.trim(),
      cafeName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      latitude: double.parse(
        _latitudeController.text.trim().replaceAll(',', '.'),
      ),
      longitude: double.parse(
        _longitudeController.text.trim().replaceAll(',', '.'),
      ),
      createdAt: oldItem?.createdAt ?? DateTime.now(),
    );

    final provider = context.read<WishlistProvider>();

    final success = _isEditing
        ? await provider.updateWishlist(wishlist)
        : await provider.addWishlist(wishlist);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Wishlist berhasil diperbarui.'
                : 'Wishlist berhasil ditambahkan.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Gagal menyimpan wishlist.',
          ),
        ),
      );
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator ?? _requiredValidator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Wishlist' : 'Tambah Wishlist'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Cafe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _buildField(
                  label: 'ID Cafe',
                  controller: _cafeIdController,
                ),
                _buildField(
                  label: 'Nama Cafe',
                  controller: _nameController,
                ),
                _buildField(
                  label: 'Alamat',
                  controller: _addressController,
                  maxLines: 2,
                ),
                _buildField(
                  label: 'Latitude',
                  controller: _latitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: _coordinateValidator,
                ),
                _buildField(
                  label: 'Longitude',
                  controller: _longitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: _coordinateValidator,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveWishlist,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving ? 'Menyimpan...' : 'Simpan Wishlist',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6F4E37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
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
