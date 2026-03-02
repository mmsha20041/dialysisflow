import 'package:dialysisflow/features/patients/data/datasources/mock_patient_detail_data_source.dart';
import 'package:dialysisflow/features/patients/data/datasources/mock_patient_list_data_source.dart';
import 'package:dialysisflow/features/patients/domain/repositories/patient_repository.dart';

class MockPatientRepository implements PatientRepository {
  MockPatientRepository({
    required MockPatientListDataSource listDataSource,
    required MockPatientDetailDataSource detailDataSource,
  })  : _listDataSource = listDataSource,
        _detailDataSource = detailDataSource;

  final MockPatientListDataSource _listDataSource;
  final MockPatientDetailDataSource _detailDataSource;

  @override
  Future<Map<String, dynamic>> getPatientDetail(String patientId) async {
    return _detailDataSource.fetchPatientDetail(patientId);
  }

  @override
  Future<List<Map<String, dynamic>>> getPatientFilters() async {
    return _listDataSource.fetchFilters();
  }

  @override
  Future<List<Map<String, dynamic>>> getPatients() async {
    return _listDataSource.fetchPatients();
  }
}
