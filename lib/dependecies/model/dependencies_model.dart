import 'package:muzhiki_core/dependecies/model/network_model.dart';
import 'package:muzhiki_core/dependecies/model/storage_model.dart';
import 'package:muzhiki_core/dependecies/model/service_model.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';

class DependenciesModel {
  final NetworkModel network;
  final StorageModel storage;
  final ServiceModel service;
  final NetworkMapErrorApp mapper;
  const DependenciesModel({
    required this.network,
    required this.storage,
    required this.service,
    required this.mapper,
  });
}
