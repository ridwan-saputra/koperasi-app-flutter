import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../providers/loan_draft_provider.dart';

class LoanFormPage extends ConsumerStatefulWidget {
  const LoanFormPage({super.key});

  @override
  ConsumerState<LoanFormPage> createState() => _LoanFormPageState();
}

class _LoanFormPageState extends ConsumerState<LoanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  final _alamatController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _pendapatanController = TextEditingController();
  final _agunanController = TextEditingController();
  
  int _tenorBulan = 6; // Default tenor
  File? _ktpImage;
  File? _selfieImage;
  bool _isAgunanRequired = false;

  @override
  void initState() {
    super.initState();
    // Memantau input nominal untuk memunculkan kolom agunan secara otomatis
    _nominalController.addListener(_checkAgunanRequirement);
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _alamatController.dispose();
    _pekerjaanController.dispose();
    _pendapatanController.dispose();
    _agunanController.dispose();
    super.dispose();
  }

  void _checkAgunanRequirement() {
    final text = _nominalController.text;
    if (text.isNotEmpty) {
      final nominal = double.tryParse(text) ?? 0;
      final isRequired = nominal > 5000000;
      if (_isAgunanRequired != isRequired) {
        setState(() {
          _isAgunanRequired = isRequired;
        });
      }
    } else if (_isAgunanRequired) {
      setState(() {
        _isAgunanRequired = false;
      });
    }
  }

  Future<void> _pickImage(bool isKtp) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    
    if (pickedFile != null) {
      setState(() {
        if (isKtp) {
          _ktpImage = File(pickedFile.path);
        } else {
          _selfieImage = File(pickedFile.path);
        }
      });
    }
  }

  void _lanjutkanKeReview() {
    if (_formKey.currentState!.validate()) {
      if (_ktpImage == null || _selfieImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap unggah foto KTP dan Selfie'), backgroundColor: Colors.redAccent),
        );
        return;
      }

      // 1. Kumpulkan data dari form (Rekening tujuan sudah dihapus)
      final draftData = {
        'nominal': double.parse(_nominalController.text),
        'tenor': _tenorBulan,
        'agunan': _isAgunanRequired ? _agunanController.text : null,
        'alamat': _alamatController.text,
        'pekerjaan': _pekerjaanController.text,
        'pendapatan': double.parse(_pendapatanController.text),
        'ktpPath': _ktpImage!.path,
        'selfiePath': _selfieImage!.path,
      };

      // 2. Simpan ke State Riverpod sementara
      ref.read(loanDraftProvider.notifier).state = draftData;

      // 3. Pindah ke Halaman Review
      context.push('/loan-review');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Pinjaman')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // --- 1. DATA PINJAMAN ---
            const Text('Data Pinjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal Pinjaman (Rp)', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _tenorBulan,
              decoration: const InputDecoration(labelText: 'Tenor (Bulan)', border: OutlineInputBorder()),
              items: [3, 6, 12, 24].map((tenor) {
                return DropdownMenuItem(value: tenor, child: Text('$tenor Bulan'));
              }).toList(),
              onChanged: (value) => setState(() => _tenorBulan = value!),
            ),
            
            // Kolom Agunan Dinamis
            if (_isAgunanRequired) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _agunanController,
                decoration: const InputDecoration(
                  labelText: 'Detail Agunan (Wajib > Rp 5 Juta)', 
                  border: OutlineInputBorder(),
                  helperText: 'Contoh: BPKB Motor Vario 2022',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Agunan wajib diisi' : null,
              ),
            ],

            const SizedBox(height: 32),

            // --- 2. DATA PRIBADI & PEKERJAAN ---
            const Text('Data Pribadi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Alamat Tinggal Sekarang', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pekerjaanController,
              decoration: const InputDecoration(labelText: 'Pekerjaan', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pendapatanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Pendapatan per Bulan (Rp)', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),

            const SizedBox(height: 32),

            // --- 3. DOKUMEN ---
            const Text('Dokumen (Foto)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildImagePicker('Foto KTP', _ktpImage, () => _pickImage(true))),
                const SizedBox(width: 16),
                Expanded(child: _buildImagePicker('Selfie + KTP', _selfieImage, () => _pickImage(false))),
              ],
            ),

            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: _lanjutkanKeReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lanjutkan ke Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, File? image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.grey, size: 32),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }
}