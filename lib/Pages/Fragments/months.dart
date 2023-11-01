import 'package:flutter/material.dart';
import 'package:saar/embrapa_api/models.dart';

class MonthsList extends StatefulWidget {
  final Future<List<Cultura>> culturasFuture;

  MonthsList({required this.culturasFuture});

  @override
  _MonthsListState createState() => _MonthsListState();
}

class _MonthsListState extends State<MonthsList> {
  String _selectedMonth = 'Janeiro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedMonth,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _showMonthYearPicker(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cultura>>(
              future: widget.culturasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar as culturas.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhuma cultura disponível.'));
                } else {
                  final culturas = snapshot.data!;
                  return ListView(
                    children: [
                      _buildCarouselWithTitle('Frutas', culturas.where((cultura) => cultura.type == 'Fruta').toList()),
                      _buildCarouselWithTitle('Verduras', culturas.where((cultura) => cultura.type == 'Verdura').toList()),
                      _buildCarouselWithTitle('Leguminosas', culturas.where((cultura) => cultura.type == 'Leguminosa').toList()),
                      _buildCarouselWithTitle('Raízes', culturas.where((cultura) => cultura.type == 'Raíz').toList()),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione o Mês e o Ano'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Adicione widgets para selecionar o mês e o ano aqui
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselWithTitle(String title, List<Cultura> culturas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: culturas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 120.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(culturas[index].imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
