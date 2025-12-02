import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required String title});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentSearch = ["pastelería", "abarrotes", "tornillos", "ferretería Don Pepe"];
  List<String> categories = [
    "Abarrotes",
    "Ferretería",
    "Panaderías",
    "Pastelerías",
    "Electrónica",
    "Belleza",
    "Mascotas"
  ];

  List<String> dummyStores = [
    "Abarrotes Lupita",
    "Ferretería Don Pepe",
    "Bahri Cakery",
    "Panadería San Juan",
    "TecnoCenter",
    "Mundo Mascota"
  ];

  List<String> searchResults = [];

  void _performSearch(String query) {
    setState(() {
      searchResults = dummyStores
          .where((store) => store.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (query.isNotEmpty && !recentSearch.contains(query)) {
        recentSearch.insert(0, query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: _controller.text.isEmpty
            ? _buildInitialSearchView()
            : _buildSearchResults(),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      centerTitle: false,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFFC88D67)),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Buscar tiendas o productos...",
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialSearchView() {
    return ListView(
      children: [
        SizedBox(height: 16.h),
        Text(
          "Categorías",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, i) {
              return _buildCategoryCard(categories[i]);
            },
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Búsquedas recientes",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        ...recentSearch.map((item) => _buildRecentItem(item)).toList(),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          "No se encontraron resultados :(",
          style: TextStyle(fontSize: 18.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (_, i) {
        return _buildStoreTile(searchResults[i]);
      },
    );
  }

  Widget _buildCategoryCard(String category) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E9),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFEEC7A5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront, color: Color(0xFFC88D67), size: 40.sp),
          SizedBox(height: 8.h),
          Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6A4E3D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String text) {
    return ListTile(
      leading: const Icon(Icons.history, color: Color(0xFFC88D67)),
      title: Text(text),
      onTap: () {
        _controller.text = text;
        _performSearch(text);
      },
    );
  }

  Widget _buildStoreTile(String storeName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEEC7A5),
          child: const Icon(Icons.store, color: Color(0xFFC88D67)),
        ),
        title: Text(storeName),
        subtitle: const Text("Tienda verificada ⭐"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
