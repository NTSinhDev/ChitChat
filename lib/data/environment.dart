const ip = '101';
class Environment {
  // String baseURL = 'http://192.168.1.$ip:5000/';
  // String urlServer = 'http://192.168.1.$ip:5000';
  String baseURL = 'https://appsocketonline2.herokuapp.com/';
  String urlServer = 'https://appsocketonline2.herokuapp.com';
  Environment({required bool isServerDev}) {
    if (isServerDev) {
      baseURL = '${baseURL}api/';
    } else {
      baseURL = '${baseURL}public/api/';
    }
  }
}
