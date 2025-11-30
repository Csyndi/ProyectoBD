import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/screen/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Importamos la pantalla de destino

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({Key? key}) : super(key: key);

  // Función para manejar la navegación a la pantalla de inicio
  void _navigateToHome(BuildContext context) {
    // Usamos Navigator.push para agregar la nueva pantalla (HomeScreen) a la pila.
    // Esto te permite volver a la pantalla anterior con el botón 'atrás'.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.transparent,
      elevation: 10,
      child: Container(
        height: 50.0.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0.r),
            topRight: Radius.circular(25.0.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50.0.h,
              width: MediaQuery.of(context).size.width / 2 - 40.0.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // --- ELEMENTO CLAVE: Usamos GestureDetector o InkWell para el ícono de la casa ---
                  GestureDetector(
                    onTap: () => _navigateToHome(context), // <--- LLAMADA A LA FUNCIÓN DE NAVEGACIÓN
                    child: const Icon(
                      Icons.home,
                      color: Color(0xFFEF7532), // Color de acento
                    ),
                  ),
                  const Icon( // Este sigue siendo solo un ícono
                    Icons.search,
                    color: Color(0xFF676E79),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50.0.h,
              width: MediaQuery.of(context).size.width / 2 - 40.0.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: Color(0xFF676E79),
                  ),
                  Icon(
                    Icons.person_outline,
                    color: Color(0xFF676E79),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}