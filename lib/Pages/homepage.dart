import 'package:flutter/material.dart';
import 'package:saar/Pages/Fragments/culturas.dart';
import 'package:saar/Pages/Fragments/feed.dart';
import 'package:saar/Pages/Fragments/months.dart';
import 'package:saar/Pages/Fragments/settings.dart';
import 'package:saar/embrapa_api/models.dart';
import 'package:saar/embrapa_api/service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice da opção selecionada na BottomNavigationBar
  late Future<List<Cultura>> _culturasFuture;
  late Future<List<dynamic>> _anosDisponiveisFuture;
  late Future<List<Solo>> _solosFuture;

  // Páginas associadas às opções da BottomNavigationBar
  List<Widget> _pages = [];


  @override
  void initState() {
    super.initState();
    _culturasFuture = EmbrapAPI.fetchCulturas();
    _anosDisponiveisFuture = EmbrapAPI.fetchAnosDisponiveis();
    _solosFuture = EmbrapAPI.fetchSolos();

    _pages = [
      HomeFragment(),
      MonthsList(culturasFuture: _culturasFuture),
      CultureWidget(culturasFuture: _culturasFuture, solosFuture: _solosFuture),
      SettingsFragment(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Amigo Agricultor',
          style: TextStyle(
            fontFamily: 'Roboto', // Defina a fonte Roboto
            color: Colors.white, // Cor do texto como branco
          ),
        ),
        backgroundColor: const Color(0xFF00921D), // Cor de fundo da AppBar (hexadecimal)
        iconTheme: const IconThemeData(color: Colors.white), // Cor dos ícones da AppBar
      ),
      body: _pages[_selectedIndex], // Mostra a página correspondente à opção selecionada
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: const Color(0xFF00921D), // Cor de fundo da BottomNavigationBar (hexadecimal)
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white), // Ícone branco
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.white), // Ícone branco
              label: 'Calendário',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist, color: Colors.white), // Ícone branco
              label: 'Cultura',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.white), // Ícone branco
              label: 'Configurações',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white, // Cor do item selecionado (ícone)
          onTap: _onItemTapped, // Callback quando um item é pressionado
        ),
      ),
    );
  }

  // Função para atualizar a página quando um item da BottomNavigationBar é pressionado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class HomeFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomCardWidget(
          imagePath: 'assets/Culturas/mandioca.png',
          title: 'Mandioca',
          description:
          'Clima no Rio Grande do Norte tende a favorecer o plantio de mandioca nos meses de janeiro até março',
        ), // Adicione o widget personalizado aqui
        CustomCardWidget(
          imagePath: 'assets/Culturas/batataDoce.png',
          title: 'Batata Doce',
          description:
          'Batata Doce vem se mostrando muito eficaz quando falamos de colheita em períodos de seca, no Sul do Rio Grande do Norte, veja mais...',
        ),
        // Adicione mais instâncias do widget personalizado, se necessário
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}