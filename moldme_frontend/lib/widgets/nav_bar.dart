import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(227, 240, 250, 1), // Cor de fundo (227, 240, 250)
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Espaçamento interno
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo e Nome
          Row(
            children: [
              Image.asset(
                'lib/assets/moldme.png', // Substitua pelo caminho correto do logo
                height: 40,
              ),
              const SizedBox(width: 10),
              
            ],
          ),

          // Links de navegação
          const Row(
            children: [
              // Outros links de navegação
            ],
          ),

          // Barra de busca e ícones
          Row(
            children: [
              // Barra de busca
              Container(
                width: 250,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search job or company here...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Ícones de notificação e perfil
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF1D3557)),
                onPressed: () {
                  // Ação para notificações
                },
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF1D9BF0),
                child: Text(
                  "S",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
