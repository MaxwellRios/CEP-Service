import 'dart:developer';

import '../models/endereco_model.dart';
import 'cep_repository.dart';
import 'package:dio/dio.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return EnderecoModel.fromMap(result.data);
    } on DioError catch (e) {
      log('Erro ao Buscar Cep', error: e);
      throw Exception('Erro ao buscar CEP');
    }
  }
}
