import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class MedicineDetailScreen extends StatefulWidget {
  final Map<String, dynamic> medication;

  const MedicineDetailScreen({super.key, required this.medication});

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  late final Map<String, dynamic> _medication;
  final Map<int, bool> _processingDoses = {};
  late final DateFormat _dateFormat;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
    _dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
  }

  Future<void> _markDoseAsTaken(int doseId) async {
    setState(() {
      _processingDoses[doseId] = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final token = await user.getIdToken();
      final response = await http.put(
        Uri.parse('https://minorproject-yytm.onrender.com/reminder/mark-taken/${_medication['id']}/$doseId'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 100) {
        setState(() {
          final doseIndex = _medication['doses'].indexWhere((d) => d['id'] == doseId);
          if (doseIndex != -1) {
            _medication['doses'][doseIndex]['isTaken'] = true;
            _medication['remaining_doses'] = (_medication['remaining_doses'] ?? 0) - 1;
          }
        });
      } else {
        throw Exception(responseData['message'] ?? 'Failed to mark dose');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = 'Authentication error: ${e.message}');
    } on http.ClientException catch (e) {
      setState(() => _errorMessage = 'Network error: ${e.message}');
    } on TimeoutException {
      setState(() => _errorMessage = 'Request timed out');
    } on FormatException {
      setState(() => _errorMessage = 'Invalid server response');
    } on Exception catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _processingDoses.remove(doseId));
    }
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red[100],
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(_errorMessage!)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _errorMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseItem(dynamic dose) {
    final isTaken = dose['isTaken'] == true;
    final time = dose['doseTime'];
    final timeStr = time is String ? _formatTimeString(time) :
    '${time['hour'].toString().padLeft(2, '0')}:${time['minute'].toString().padLeft(2, '0')}';

    return ListTile(
      leading: Icon(
        isTaken ? Icons.check_circle : Icons.access_time,
        color: isTaken ? Colors.green : Colors.blue,
      ),
      title: Text(timeStr),
      trailing: (_processingDoses[dose['id']] ?? false)
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 3),
      )
          : IconButton(
        icon: Icon(
          isTaken ? Icons.undo : Icons.check,
          color: isTaken ? Colors.grey : Colors.green,
        ),
        onPressed: isTaken ? null : () => _markDoseAsTaken(dose['id']),
      ),
    );
  }

  String _formatTimeString(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_medication['r_name'] ?? 'Medication Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildErrorBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Type', _medication['r_type'] ?? 'Unknown'),
                          _buildDetailRow('Category', _medication['category'] ?? 'Unknown'),
                          _buildDetailRow('Frequency', _medication['frequency'] ?? 'Unknown'),
                          _buildDetailRow(
                            'Start Date',
                            _dateFormat.format(DateTime.parse(_medication['start_date_time'])),
                          ),
                          _buildDetailRow(
                            'End Date',
                            _dateFormat.format(DateTime.parse(_medication['end_date_time'])),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dose Schedule Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dose Schedule',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Chip(
                                label: Text(
                                    '${_medication['remaining_doses']} doses remaining'),
                                backgroundColor: Colors.blue.shade100,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _medication['doses'].length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) =>
                                _buildDoseItem(_medication['doses'][index]),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Notes Section
                  if (_medication['notes'] != null && _medication['notes'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Additional Notes',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(_medication['notes']),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}