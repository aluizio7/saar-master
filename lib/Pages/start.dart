import 'package:flutter/material.dart';
import 'package:saar/Pages/homepage.dart';
class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                ),
                SizedBox(height: 20), // Espaço entre o logotipo e os botões
                // Botões TextButton
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green, // Defina a cor de fundo desejada
                    borderRadius: BorderRadius.circular(15), // Defina o raio da borda
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      // Navegar para a HomePage quando o botão for pressionado
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green, // Defina a cor de fundo desejada
                    borderRadius: BorderRadius.circular(15), // Defina o raio da borda
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      // Adicione a lógica para o segundo botão aqui
                    },
                    child: const Text(
                      'Tutorial',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}