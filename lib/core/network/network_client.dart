abstract class NetworkClient {
  Future<Map<String, dynamic>> get(String path);
}

class MockNetworkClient implements NetworkClient {
  @override
  Future<Map<String, dynamic>> get(String path) async {
    return {'path': path, 'status': 'ok'};
  }
}
