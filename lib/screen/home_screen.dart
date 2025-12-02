import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/widget/customAppBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'search_screen.dart';
//import 'store_list_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
  title: 'Pesan',
),
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bienvenido de nuevo",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "Juan Pérez",
                        style: TextStyle(
                          fontFamily: "Varela",
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF545D68),
                        ),
                      ),
                    ],
                  ),

                  /// Foto de perfil
                  CircleAvatar(
                    radius: 26.r,
                    backgroundImage: const AssetImage("assets/profile.jpg"),
                  )
                ],
              ),

              SizedBox(height: 20.h),

              /// 🔹 BARRA DE BÚSQUEDA
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SearchScreen(title: '',)));
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          size: 28.sp, color: const Color(0xFFC88D67)),
                      SizedBox(width: 12.w),
                      Text(
                        "Buscar productos o tiendas...",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[500],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 22.h),

              /// 🔹 NOVEDADES
              Text(
                "Novedades",
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              SizedBox(
                height: 160.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPromoCard(
                      img: "assets/store1.jpg",
                      title: "Nueva tienda: Abarrotes Ana",
                    ),
                    _buildPromoCard(
                      img: "assets/store2.jpg",
                      title: "Pastelería Sweet abrió hoy",
                    ),
                    _buildPromoCard(
                      img: "assets/store3.jpg",
                      title: "Ferretería del Centro renovada",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              /// 🔹 OFERTAS DESTACADAS
              Text(
                "Ofertas destacadas",
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              _buildOfferBanner(),

              SizedBox(height: 25.h),

              /// 🔹 CONTINÚA TU COMPRA
              Text(
                "Continúa con tu compra",
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen()));
                },
                child: _buildContinueCart(),
              ),

              SizedBox(height: 25.h),

              /// 🔹 CATEGORÍAS
              Text(
                "Categorías",
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 0.78,
                children: [
                  _buildCategory("Abarrotes", Icons.storefront, context),
                  _buildCategory("Pastelería", Icons.cake, context),
                  _buildCategory("Ferretería", Icons.build, context),
                  _buildCategory("Farmacia", Icons.medical_services, context),
                  _buildCategory("Mascotas", Icons.pets, context),
                  _buildCategory("Belleza", Icons.brush, context),
                ],
              ),

              SizedBox(height: 25.h),

              /// 🔹 TIENDAS RECOMENDADAS
              Text(
                "Tiendas recomendadas",
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              _buildRecommendedStore(
                img: "assets/store1.jpg",
                name: "Abarrotes La Esquina",
                category: "Abarrotes",
              ),
              _buildRecommendedStore(
                img: "assets/store2.jpg",
                name: "Pastelería Sweet",
                category: "Repostería",
              ),
              _buildRecommendedStore(
                img: "assets/store3.jpg",
                name: "Ferretería del Centro",
                category: "Ferretería",
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 🔹 Tarjeta de novedades
  Widget _buildPromoCard({required String img, required String title}) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Container(
        width: 240.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(12.w),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 🔹 Banner de ofertas
  Widget _buildOfferBanner() {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD3A5),
            Color(0xFFF5A36C),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                "¡Hasta 30% OFF\nesta semana!",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Image.asset("assets/offer.png"),
          )
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 🔹 Continue Cart
  Widget _buildContinueCart() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: const DecorationImage(
                image: AssetImage("assets/product1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pan dulce",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF545D68)),
              ),
              Text(
                "Desde Sweet Bakery",
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 18.sp, color: const Color(0xFFC88D67)),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 🔹 Categoría
  Widget _buildCategory(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => CategoryScreen(title: title)));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(icon, size: 28.sp, color: const Color(0xFFD17E50)),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF545D68)),
          )
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 🔹 Tienda recomendada
  Widget _buildRecommendedStore(
      {required String img,
      required String name,
      required String category}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Row(
        children: [
          Container(
            width: 68.w,
            height: 68.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: const Color(0xFF545D68)),
              ),
              Text(
                category,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
