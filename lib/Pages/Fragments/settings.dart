import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildSettingsItem(
          title: 'Sobre o app',
          icon: Icons.info,
        ),
        _buildSettingsItem(
          title: 'Favoritos',
          icon: Icons.favorite,
        ),
        _buildSettingsItem(
          title: 'Idioma',
          icon: Icons.language,
        ),
        // Adicione mais itens de configurações conforme necessário
      ],
    );
  }

  Widget _buildSettingsItem({required String title, required IconData icon}) {
    return ListTile(
      leading: Icon(icon), // Ícone à esquerda
      title: Text(
        title,
        textAlign: TextAlign.left, // Alinhe o texto à esquerda
      ),
      onTap: () {
        // Adicione a lógica a ser executada quando um item for pressionado
      },
    );
  }
}