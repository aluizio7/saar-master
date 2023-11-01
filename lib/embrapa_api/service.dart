import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:saar/embrapa_api/models.dart';

class EmbrapAPI {

  static const String soloUri = "https://meteorologia.emparn.rn.gov.br/api/solo";
  static const String culturasUri = "https://meteorologia.emparn.rn.gov.br/api/culturas";
  static const String anosUri = "https://meteorologia.emparn.rn.gov.br/api/riscos-agricolas/anos-disponiveis";
  static const Map<String, String> porcentagens = {
    "60%": "PORCENTAGEM_40",
    "70%": "PORCENTAGEM_30",
    "80%": "PORCENTAGEM_20"
  };

  /// Obtém uma lista de dados de risco de municípios com base nos parâmetros especificados.
  ///
  /// Esta função faz uma solicitação HTTP GET à API da Emparn para recuperar dados de risco
  /// de municípios para um determinado ano, cultura, solo e valor de porcentagem.
  ///
  /// - [ano]: O ano para o qual os dados são solicitados.
  /// - [idCultura]: O ID da cultura para a qual os dados são solicitados.
  /// - [idSolo]: O ID do solo para o qual os dados são solicitados.
  /// - [porcentagem]: O valor de porcentagem para filtrar os dados. Deve ser um dos
  ///   valores predefinidos em [porcentagens].
  ///
  /// Retorna uma lista de objetos [Municipio] que representam os dados de risco dos municípios.
  ///
  /// Gera um [ArgumentError] se [porcentagem] não estiver entre os valores predefinidos
  /// em [porcentagens].
  static Future<List<Municipio>> fetchMunicipiosRiscos(int ano, int idCultura, int idSolo, String porcentagem) async {
    final Response response = await http.get(Uri.parse(
        "https://meteorologia.emparn.rn.gov.br/api/riscos-agricolas/exibicao?"
            "ano=$ano&idCultura=$idCultura&idSolo=$idSolo&porcentagem=${porcentagens[porcentagem]}"
    ));
    final Map<String, dynamic> responseBody = _processResponse(response);

    final List<dynamic> municipiosData = responseBody["riscosAgricolasMunicipio"];
    final List<Municipio> listaDeMunicipios = municipiosData.map((municipio) => Municipio.fromJson(municipio)).toList();

    return listaDeMunicipios;
  }

  /// Realiza uma requisição HTTP para obter a lista de culturas disponíveis.
  ///
  /// Esta função envia uma solicitação GET para a URL [culturasUri] e espera
  /// receber uma resposta contendo informações sobre as culturas disponíveis.
  ///
  /// Retorna uma lista de objetos [Cultura] representando as culturas disponíveis.
  /// Se a solicitação falhar ou o servidor retornar um código de status diferente
  /// de 200 (OK), uma exceção será lançada.
  ///
  /// Exemplo de uso:
  /// ```
  /// final culturas = await Fetch.fetchCulturas();
  /// for (var cultura in culturas) {
  ///   print('ID: ${cultura.id}, Nome: ${cultura.nome}');
  /// }
  /// ```
  ///
  /// [culturasUri]: A URL para a API que fornece informações sobre culturas.
  /// [Cultura]: Classe que representa uma cultura disponível.
  static Future<List<Cultura>> fetchCulturas() async {
    final Response response = await http.get(Uri.parse(culturasUri));
    final Map<String, dynamic> responseBody = _processResponse(response);

    final List<dynamic> culturas = responseBody["_embedded"]["culturas"];
    final List<Cultura> listaDeCulturas = culturas.map((cultura) => Cultura.fromJson(cultura)).toList();

    return listaDeCulturas;
  }

  /// Realiza uma requisição HTTP para obter a lista de tipos de solo disponíveis.
  ///
  /// Esta função envia uma solicitação GET para a URL [soloUri] e espera receber
  /// uma resposta contendo informações sobre os tipos de solo disponíveis.
  ///
  /// Retorna uma lista de objetos [Solo] representando os tipos de solo disponíveis.
  /// Se a solicitação falhar ou o servidor retornar um código de status diferente
  /// de 200 (OK), uma exceção será lançada com a mensagem 'Falha ao carregar dados do servidor'.
  ///
  /// Exemplo de uso:
  /// ```
  /// final solos = await Fetch.fetchSolos();
  /// for (var solo in solos) {
  ///   print('ID: ${solo.id}, Nome: ${solo.nome}');
  /// }
  /// ```
  ///
  /// [soloUri]: A URL para a API que fornece informações sobre tipos de solo disponíveis.
  static Future<List<Solo>> fetchSolos() async {
    final Response response = await http.get(Uri.parse(soloUri));
    final Map<String, dynamic> responseBody = _processResponse(response);

    final List<dynamic> solos = responseBody["_embedded"]["solo"];
    final List<Solo> listaDeSolos = solos.map((solo) => Solo.fromJson(solo)).toList();

    return listaDeSolos;
  }

  // Realiza uma requisição HTTP para obter uma lista de anos disponíveis.
  ///
  /// Esta função envia uma solicitação GET para a URL [anosUri] e espera receber
  /// uma resposta contendo uma lista de anos disponíveis em formato JSON.
  ///
  /// Retorna uma lista de anos disponíveis em formato JSON. Se a solicitação falhar
  /// ou o servidor retornar um código de status diferente de 200 (OK), uma exceção
  /// será lançada com a mensagem 'Falha ao carregar dados do servidor'.
  ///
  /// Exemplo de uso:
  /// ```
  /// final anos = await Fetch.fetchAnosDisponiveis();
  /// for (var ano in anos) {
  ///   print('Ano disponível: $ano');
  /// }
  /// ```
  ///
  /// [anosUri]: A URL para a API que fornece informações sobre anos disponíveis.
  static Future<List<dynamic>> fetchAnosDisponiveis() async {
    final Response response = await http.get(Uri.parse(anosUri));

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar dados do servidor');
    }
  }

  /// Processa a resposta HTTP recebida de uma solicitação e retorna os dados decodificados.
  ///
  /// Esta função é utilizada internamente para processar a resposta HTTP de solicitações
  /// feitas à API. Ela verifica o código de status da resposta e, se for igual a 200 (OK),
  /// decodifica o corpo da resposta JSON e o retorna como um mapa (Map) de strings (String)
  /// para dinâmicos (dynamic).
  ///
  /// Se o código de status da resposta for diferente de 200 (OK), uma exceção será lançada
  /// com a mensagem 'Falha ao carregar dados do servidor'.
  ///
  /// [response]: A resposta HTTP a ser processada.
  ///
  /// Retorna um mapa (Map) contendo os dados decodificados da resposta, ou lança uma exceção
  /// em caso de falha.
  ///
  /// Exemplo de uso:
  /// ``` dart
  /// final response = await http.get(Uri.parse("https://exemplo.com/api/dados"));
  /// final data = _processResponse(response);
  /// print(data['nome']); // Acesse os dados decodificados como desejar
  /// ```
  static Map<String, dynamic> _processResponse(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar dados do servidor');
    }
  }
}