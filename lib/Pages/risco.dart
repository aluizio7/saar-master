

import 'package:flutter/material.dart';
import 'package:saar/embrapa_api/models.dart';

class Risco extends StatefulWidget {
  final Cultura cultura;
  final Future<List<Solo>> solosFuture;

  const Risco({super.key, required this.cultura, required this.solosFuture});

  @override
  _RiscoState createState() => _RiscoState();
}

class _RiscoState extends State<Risco> {
  late Cultura _cultura;
  late List<Map<String, String>> _cardAttributes;
  late int _selectedCardIndex; // Índice do card selecionado
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;
  late Future<List<Solo>> _solosFuture;

  @override
  void initState() {
    super.initState();
    _cultura = widget.cultura;
    _solosFuture = widget.solosFuture;
    _cardAttributes = [
      {"title": "Solo Tipo 1", "subtitle": "Arenoso", "imagePath": "assets/Solos/SoloTipo1.png"},
      {"title": "Solo Tipo 2", "subtitle": "Arenoargiloso", "imagePath": "assets/Solos/SoloTipo2.png"},
      {"title": "Solo Tipo 3", "subtitle": "Argiloso", "imagePath": "assets/Solos/SoloTipo3.png"},
    ];
    _selectedCardIndex = -1; // Nenhum card selecionado inicialmente
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedCard(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cardWidth = 160; // Largura do card
    final offset = index * cardWidth - (screenWidth / 2 - cardWidth / 2);
    _horizontalScrollController.animateTo(offset, duration: const Duration(seconds: 1), curve: Curves.ease);
  }

  void _scrollVertically() {
    _verticalScrollController.animateTo(
      _verticalScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Risco Climático', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        controller: _verticalScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Image.asset(
                _cultura.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _cultura.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Solo>>(
                future: _solosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Exibir um indicador de carregamento enquanto os dados estão sendo carregados.
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    final solos = snapshot.data;
                    return ListView.builder(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: solos!.length,
                      itemBuilder: (context, index) {
                        final solo = solos[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedCardIndex == index) {
                                  _scrollVertically(); // Scroll vertical ao desselecionar
                                } else {
                                  _selectedCardIndex = index;
                                  _scrollToSelectedCard(index);
                                  _scrollVertically(); // Scroll vertical ao selecionar
                                }
                              });
                            },
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                color: _selectedCardIndex == index ? Colors.green : Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      solo.title,
                                      style: TextStyle(
                                        color: _selectedCardIndex == index ? Colors.white : Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      solo.subtitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(solo.imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 340), // Espaço para o novo widget
          ],
        ),
      ),
    );
  }
}
