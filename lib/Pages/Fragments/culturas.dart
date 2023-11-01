import 'package:flutter/material.dart';
import 'package:saar/embrapa_api/models.dart';
import 'package:saar/Pages/risco.dart';

class CultureWidget extends StatefulWidget {
  final Future<List<Cultura>> culturasFuture;
  final Future<List<Solo>> solosFuture;

  const CultureWidget({super.key, required this.culturasFuture, required this.solosFuture});

  @override
  _CultureWidgetState createState() => _CultureWidgetState();
}

class _CultureWidgetState extends State<CultureWidget> {
  late Future<List<Cultura>> _culturasFuture;
  late Future<List<Solo>> _solosFuture;

  @override
  void initState() {
    super.initState();
    _culturasFuture = widget.culturasFuture;
    _solosFuture = widget.solosFuture;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Cultura>>(
        future: _culturasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            final List<Cultura> cultureItems = snapshot.data ?? [];
            return ListView.builder(
              itemCount: cultureItems.length,
              itemBuilder: (context, index) {
                final culture = cultureItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Risco(cultura: culture, solosFuture: _solosFuture),
                      ),
                    );
                  },
                  child: CultureItemWidget(
                    imagePath: culture.imagePath,
                    name: culture.nome,
                    description: culture.type,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CultureItemWidget extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;

  CultureItemWidget({
    required this.imagePath,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
