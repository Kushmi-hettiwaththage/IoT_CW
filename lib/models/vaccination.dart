class Vaccination {
  String id;
  String name;
  String vaccinatedDate;
  int durationMonths;
  String nextVaccinationDate;

  Vaccination({
    required this.id,
    required this.name,
    required this.vaccinatedDate,
    required this.durationMonths,
    required this.nextVaccinationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'vaccinatedDate': vaccinatedDate,
      'durationMonths': durationMonths,
      'nextVaccinationDate': nextVaccinationDate,
    };
  }

  factory Vaccination.fromDoc(String id, Map<String, dynamic> data) {
    return Vaccination(
      id: id,
      name: data['name'] ?? '',
      vaccinatedDate: data['vaccinatedDate'] ?? '',
      durationMonths: data['durationMonths'] ?? 0,
      nextVaccinationDate: data['nextVaccinationDate'] ?? '',
    );
  }
}
