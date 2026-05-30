import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/rupiah_input_formatter.dart';
import '../../domain/constants/loan_amount_options.dart';
import '../providers/loan_draft_provider.dart';

enum _DocumentType { ktp, selfie, agunan }

class LoanFormPage extends ConsumerStatefulWidget {
  const LoanFormPage({super.key});

  @override
  ConsumerState<LoanFormPage> createState() => _LoanFormPageState();
}

class _LoanFormPageState extends ConsumerState<LoanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _pendapatanController = TextEditingController();
  final _agunanController = TextEditingController();

  double _selectedNominal = kLoanAmountOptions.first;
  int _tenorBulan = 6;
  File? _ktpImage;
  File? _selfieImage;
  File? _agunanImage;

  bool get _isAgunanRequired => _selectedNominal >= kLoanAgunanThreshold;

  @override
  void dispose() {
    _alamatController.dispose();
    _pekerjaanController.dispose();
    _pendapatanController.dispose();
    _agunanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(_DocumentType type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case _DocumentType.ktp:
            _ktpImage = File(pickedFile.path);
          case _DocumentType.selfie:
            _selfieImage = File(pickedFile.path);
          case _DocumentType.agunan:
            _agunanImage = File(pickedFile.path);
        }
      });
    }
  }

  void _lanjutkanKeReview() {
    if (!_formKey.currentState!.validate()) return;

    if (_ktpImage == null || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah foto KTP dan Selfie'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isAgunanRequired && _agunanImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah foto agunan (mis. BPKB)'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final pendapatan = CurrencyFormatter.parse(_pendapatanController.text);
    if (pendapatan == null) return;

    final draftData = {
      'nominal': _selectedNominal,
      'tenor': _tenorBulan,
      'agunan': _isAgunanRequired ? _agunanController.text : null,
      'agunanPath': _isAgunanRequired ? _agunanImage!.path : null,
      'alamat': _alamatController.text,
      'pekerjaan': _pekerjaanController.text,
      'pendapatan': pendapatan,
      'ktpPath': _ktpImage!.path,
      'selfiePath': _selfieImage!.path,
    };

    ref.read(loanDraftProvider.notifier).state = draftData;
    context.push('/loan-review');
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
            const Text('Data Pinjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _selectedNominal,
              decoration: const InputDecoration(
                labelText: 'Nominal Pinjaman',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              items: kLoanAmountOptions.map((amount) {
                return DropdownMenuItem(
                  value: amount,
                  child: Text(CurrencyFormatter.format(amount)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedNominal = value;
                    if (!_isAgunanRequired) {
                      _agunanImage = null;
                      _agunanController.clear();
                    }
                  });
                }
              },
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

            if (_isAgunanRequired) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _agunanController,
                decoration: InputDecoration(
                  labelText:
                      'Detail Agunan (Wajib mulai ${CurrencyFormatter.format(kLoanAgunanThreshold)})',
                  border: const OutlineInputBorder(),
                  helperText: 'Contoh: BPKB Motor Vario 2022',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Agunan wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Foto Agunan (BPKB / dokumen jaminan)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              _buildImagePicker(
                'Foto Agunan',
                _agunanImage,
                () => _pickImage(_DocumentType.agunan),
              ),
            ],

            const SizedBox(height: 32),
            const Text('Data Pribadi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Alamat Tinggal Sekarang',
                border: OutlineInputBorder(),
              ),
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
              inputFormatters: [RupiahInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Total Pendapatan per Bulan',
                hintText: 'Contoh: 5.000.000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Wajib diisi';
                if (CurrencyFormatter.parse(value) == null) return 'Nominal tidak valid';
                return null;
              },
            ),

            const SizedBox(height: 32),
            const Text('Dokumen Identitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildImagePicker('Foto KTP', _ktpImage, () => _pickImage(_DocumentType.ktp)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImagePicker(
                    'Selfie + KTP',
                    _selfieImage,
                    () => _pickImage(_DocumentType.selfie),
                  ),
                ),
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
              child: const Text(
                'Lanjutkan ke Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                  Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }
}
