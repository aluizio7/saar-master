class Municipio {
  final String nome;
  final double latitude;
  final double longitude;
  final List<bool> viabilidades;

  const Municipio({
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.viabilidades,
  });

  factory Municipio.fromJson(Map<String, dynamic> municipioData) {
    final String nome = municipioData["municipio"]["nome"];
    final double latitude = municipioData["municipio"]["latitude"];
    final double longitude = municipioData["municipio"]["longitude"];
    final List<bool> viabilidades = List.generate(36, (index) => municipioData["municipio"]["d${index + 1}"] == "S");

    return Municipio(nome: nome, latitude: latitude, longitude: longitude, viabilidades: viabilidades);
  }
}

class Cultura {
  final int id;
  final String nome;
  final String imagePath;
  final String type;

  static const Map<int, dynamic> categorias = {
    2: {
      "imagePath": "assets/Culturas/girassol.png",
      "categoria": "Fruta",
    },
    3: {
      "imagePath": "assets/Culturas/algodao.png",
      "categoria": "Raíz",
    },
    4: {
      "imagePath": "assets/Culturas/milhoS.png",
      "categoria": "Verdura"
    },
    5: {
      "imagePath":  "assets/Culturas/feijaoV.png",
      "categoria": "Verdura",
    },
    6: {
      "imagePath": "assets/Culturas/feijaoS.png",
      "categoria": "Leguminosa",
    },
    7: {
      "imagePath": "assets/Culturas/milhoV.png",
      "categoria": "Verdura",
    },
    8: {
      "imagePath": "assets/Culturas/sorgo.png",
      "categoria": "Verdura",
    },
    9: {
      "imagePath": "assets/Culturas/batataDoce.png",
      "categoria": "Raíz",
    },
    10: {
      "imagePath": "assets/Culturas/mandioca.png",
      "categoria": "Raíz",
    },
    11: {
      "imagePath": "assets/Culturas/gergelim.png",
      "categoria": "Leguminosa",
    },
    12: {
      "imagePath": "assets/Culturas/cebola.png",
      "categoria": "Verdura",
    },
  };

  const Cultura({
    required this.id,
    required this.nome,
    required this.imagePath,
    required this.type,
  });

  factory Cultura.fromJson(Map<String, dynamic> culturaData) {
    return Cultura(
        id: culturaData["id"],
        nome: culturaData["nome"],
        imagePath: categorias[culturaData["id"]]["imagePath"],
        type: categorias[culturaData["id"]]["categoria"]
    );
  }

  factory Cultura.fromJsonStorage(Map<String, dynamic> culturaData) {
    return Cultura(
        id: culturaData["id"],
        nome: culturaData["nome"],
        imagePath: culturaData["imagePath"],
        type: culturaData["categoria"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "imagePath": imagePath,
      "type": type,
    };
  }
}

class Solo {
  final int id;
  final String nome;
  final String title;
  final String subtitle;
  final String imagePath;

  static const Map<int, dynamic> soloInfo = {
    1: {"title": "Solo Tipo 1", "subtitle": "Arenoso", "imagePath": "assets/Solos/SoloTipo1.png"},
    2: {"title": "Solo Tipo 2", "subtitle": "Arenoargiloso", "imagePath": "assets/Solos/SoloTipo2.png"},
    3: {"title": "Solo Tipo 3", "subtitle": "Argiloso", "imagePath": "assets/Solos/SoloTipo3.png"},
  };

  const Solo({
    required this.id,
    required this.nome,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  factory Solo.fromJson(Map<String, dynamic> soloData) {
    final int id = soloData["id"];

    return Solo(
      id: id,
      nome: soloData["nome"],
      title: soloInfo[id]["title"],
      subtitle: soloInfo[id]["subtitle"],
      imagePath: soloInfo[id]["imagePath"],
    );
  }
}
