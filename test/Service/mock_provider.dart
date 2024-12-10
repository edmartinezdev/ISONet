
import 'package:dio/dio.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';




class MockDio extends Mock implements Dio {}

@GenerateMocks([RemoteServices])
void main() {}
