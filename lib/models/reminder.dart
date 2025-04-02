class Medication {
  final String name;
  final String dosage;

  Medication({required this.name, required this.dosage});

  factory Medication.fromJson(Map json) {
    return Medication(
      name: json['name'] as String,
      dosage: json['dosage'] as String,
    );
  }
}
