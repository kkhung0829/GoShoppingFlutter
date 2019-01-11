import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

typedef DropBoxLoginInAppBrowser_onLoadStart = void Function(String url);
typedef DropBoxLoginInAppBrowser_onExit = void Function();

class _DropBoxLoginInAppBrowser extends InAppBrowser {
  final DropBoxLoginInAppBrowser_onLoadStart onLoadStartCB;
  final DropBoxLoginInAppBrowser_onExit onExitCB;

  _DropBoxLoginInAppBrowser({
    this.onLoadStartCB,
    this.onExitCB
  });

  @override
    void onLoadStart(String url) {
      super.onLoadStart(url);

      this.onLoadStartCB(url);
    }

  @override
    void onExit() {
      super.onExit();

      this.onExitCB();
    }
}

class DropboxHelper {
  static Future<String> login(String appKey) async {
    const REDIRECT_URI = 'http://localhost';
    const ACCESS_TOKEN = 'access_token';

    Completer<String> _completer = new Completer<String>();
    String url =
        'https://www.dropbox.com/1/oauth2/authorize?'
      + 'client_id=' + appKey
      + '&redirect_uri=' + REDIRECT_URI
      + '&response_type=token';
    String accessToken;
    _DropBoxLoginInAppBrowser inAppBrowser;

    inAppBrowser = new _DropBoxLoginInAppBrowser(
      onLoadStartCB: (String url) {
        if (url.indexOf('oauth2/authorize') > -1) {
          return;
        }

        if ((url.indexOf(REDIRECT_URI) > -1) && (url.indexOf(ACCESS_TOKEN) > -1)) {
          accessToken = url.split('=')[1].split('&')[0];
        }
        inAppBrowser.close();
      },
      onExitCB: () {
        _completer.complete(accessToken);
      }
    );
    await inAppBrowser.open(url: url);
    
    return _completer.future;
  }

  static Future<Map<String, dynamic>> downloadJSON(String accessToken, String path) {
    return http.post(
      'https://content.dropboxapi.com/2/files/download',
      headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Dropbox-API-Arg': json.encode({
          'path': path,
        }),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to download JSON');
      }
    });
  }

  // The default http package will add the 'charset=UTF-8' to the end of Content-Type header,
  // which will be rejected by Dropbox API.
  // https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
  //
  // static Future<void> uploadJSON(String accessToken, String path, Map<String, dynamic> data) {
  //   var headers = {
  //       'Authorization': 'Bearer ' + accessToken,
  //       'Dropbox-API-Arg': json.encode({
  //         'path': path,
  //         'mode': {
  //           '.tag': 'overwrite',
  //         },
  //       }),
  //       'Content-Type': 'application/octet-stream',
  //     };
  //   var body = base64.encode(utf8.encode(json.encode(data)));

  //   print('====== DropboxHelper.uploadJSON headers: $headers');
  //   print('====== DropboxHelper.uploadJSON body: $body');

  //   return http.post(
  //     'https://content.dropboxapi.com/2/files/upload',
  //     headers: headers,
  //     body: body,
  //   ).then((response) {
  //     print('====== DropboxHelper.uploadJSON statusCode: ${response.statusCode} reasonPhase: ${response.reasonPhrase} body: ${response.body}');
  //     if (response.statusCode == 200) {
  //       return;
  //     } else {
  //       // If that response was not OK, throw an error.
  //       throw Exception('Failed to upload JSON');
  //     }
  //   });

  // }

  static Future<void> uploadJSON(String accessToken, String path, Map<String, dynamic> data) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse('https://content.dropboxapi.com/2/files/upload'));

    request.headers.set('Authorization', 'Bearer ' + accessToken);
    request.headers.set('Dropbox-API-Arg', json.encode({
      'path': path,
      'mode': {
        '.tag': 'overwrite',
      },
    }));
    request.headers.set('Content-Type', 'application/octet-stream');
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    httpClient.close();

    if (response.statusCode == 200) {
      return;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to upload JSON');
    }
  }
}
