import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/tasks_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';

class Category {
  final String name;
  bool isSelected;

  Category({
    required this.name,
    this.isSelected = false,
  });
}

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({Key? key});

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
                onTap: () {
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
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List categoryNames = snapshot.data!.docs.map((doc) {
          return doc['name'];
        }).toList();

        // Update the local categories list with categories from Firebase
        categories = categoryNames.map((name) {
          return Category(name: name);
        }).toList();

        // Initialize isSelectedList if it's empty
        if (isSelectedList.isEmpty) {
          isSelectedList = List.filled(categories.length, false);
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 2.5),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  isSelectedList[index] = !isSelectedList[index];
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelectedList[index] ? kPrimaryColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  categories[index].name,
                  style: TextStyle(
                      color: isSelectedList[index] ? kWhite : Colors.black),
                )),
              ),
            );
          },
        );
      },
    );
  }
}
