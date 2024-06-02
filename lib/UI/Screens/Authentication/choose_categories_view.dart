import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/tasks_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final String name;
  bool isSelected;

  Category({
    required this.name,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isSelected': isSelected,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        isSelected: json['isSelected'],
      );
}

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_outlined, color: kPrimaryColor),
        ),
        title: const Text(
          'Choose Categories',
          style: TextStyle(
              color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.offAll(const TasksScreen());
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: kPrimaryColor),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            10.heightBox,
            Expanded(child: CategoryList()),
            const Spacer(),
            MyButtonLong(
                name: 'Next',
                onTap: () async {
                  await (context as Element)
                      .findAncestorStateOfType<_CategoryListState>()
                      ?.saveSelectedCategories();
                  Get.offAll(const TasksScreen());
                }),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categories = [];
  List<bool> isSelectedList = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCategories = prefs.getStringList('selectedCategories') ?? [];

    FirebaseFirestore.instance.collection('categories').get().then((snapshot) {
      List categoryNames = snapshot.docs.map((doc) {
        return doc['name'];
      }).toList();

      setState(() {
        categories = categoryNames.map((name) {
          return Category(
            name: name,
            isSelected: selectedCategories.contains(name),
          );
        }).toList();

        isSelectedList = categories.map((category) {
          return category.isSelected;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2.5),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    categories[index].isSelected =
                        !categories[index].isSelected;
                  });
                  saveSelectedCategories();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: categories[index].isSelected
                        ? kPrimaryColor
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    categories[index].name,
                    style: TextStyle(
                        color: categories[index].isSelected
                            ? kWhite
                            : Colors.black),
                  )),
                ),
              );
            },
          );
  }

  Future<void> saveSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCategories = categories
        .where((category) => category.isSelected)
        .map((category) => category.name)
        .toList();
    await prefs.setStringList('selectedCategories', selectedCategories);
  }
}
