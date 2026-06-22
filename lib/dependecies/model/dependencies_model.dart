import 'package:muzhiki_core/dependecies/exception/global_map_error.dart';
import 'package:muzhiki_core/dependecies/model/network_model.dart';
import 'package:muzhiki_core/dependecies/model/storage_model.dart';
import 'package:muzhiki_core/dependecies/model/service_model.dart';

class DependenciesModel {
  final NetworkModel network;
  final StorageModel storage;
  final ServiceModel service;
  final GlobalMapErrorApp mapper;
  const DependenciesModel({
    required this.network,
    required this.storage,
    required this.service,
    required this.mapper,
  });
}
