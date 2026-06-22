import 'package:muzhiki_core/dependecies/model/network_model.dart';
import 'package:muzhiki_core/dependecies/model/storage_model.dart';
import 'package:muzhiki_core/dependecies/model/service_model.dart';

class DependenciesModel {
  final NetworkModel network;
  final StorageModel storage;
  final ServiceModel service;
  const DependenciesModel({
    required this.network,
    required this.storage,
    required this.service,
  });
}
