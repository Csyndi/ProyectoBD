import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditStoreScreen extends StatefulWidget {
  final Map<String, dynamic> store;

  const EditStoreScreen({super.key, required this.store});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController hoursCtrl;
  late TextEditingController facebookCtrl;
  late TextEditingController instagramCtrl;

  File? _imageFile;

  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();

    // Cargamos el contenido de la tienda
    nameCtrl = TextEditingController(text: widget.store["name"]);
    descCtrl = TextEditingController(text: widget.store["description"]);
    addressCtrl = TextEditingController(text: widget.store["address"]);
    phoneCtrl = TextEditingController(text: widget.store["phone"]);
    categoryCtrl = TextEditingController(text: widget.store["category"]);
    hoursCtrl = TextEditingController(text: widget.store["hours"]);
    facebookCtrl = TextEditingController(text: widget.store["facebook"]);
    instagramCtrl = TextEditingController(text: widget.store["instagram"]);

    products = List<Map<String, dynamic>>.from(widget.store["products"]);
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void saveStore() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(context, {
      "name": nameCtrl.text,
      "description": descCtrl.text,
      "address": addressCtrl.text,
      "phone": phoneCtrl.text,
      "category": categoryCtrl.text,
      "hours": hoursCtrl.text,
      "facebook": facebookCtrl.text,
      "instagram": instagramCtrl.text,
      "image": _imageFile?.path ?? widget.store["image"],
      "products": products,
    });
  }

  void openAddProduct() async {
    final result = await Navigator.pushNamed(context, "/addProduct");

    if (result != null) {
      setState(() => products.add(result as Map<String, dynamic>));
    }
  }

  void openEditProduct(Map product, int index) async {
    final result = await Navigator.pushNamed(
      context,
      "/productDetail",
      arguments: product,
    );

    if (result != null) {
      setState(() => products[index] = result as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar tienda"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: ElevatedButton(
          onPressed: saveStore,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Text(
            "Guardar cambios",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // Imagen de la tienda
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage(widget.store["image"]) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Campos
              buildField("Nombre", nameCtrl),
              buildField("Descripción", descCtrl, maxLines: 3),
              buildField("Dirección", addressCtrl),
              buildField("Teléfono", phoneCtrl),
              buildField("Categoría", categoryCtrl),
              buildField("Horario", hoursCtrl),
              buildField("Facebook", facebookCtrl),
              buildField("Instagram", instagramCtrl),

              SizedBox(height: 25.h),

              // Sección de productos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Productos", style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  )),
                  IconButton(
                    onPressed: openAddProduct,
                    icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                  )
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        product["image"],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product["name"]),
                      subtitle: Text("\$${product["price"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openEditProduct(product, index),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        validator: (v) => v!.isEmpty ? "Este campo es obligatorio" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
