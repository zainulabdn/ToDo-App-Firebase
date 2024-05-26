import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:haztech_task/Core/Constants/assets.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  void _addCategory(BuildContext context) async {
    String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('categories').add({
          'name': categoryName,
        });
        BaseHelper.showSnackBar('Category added successfully');
        _categoryController.clear();
      } catch (e) {
        print('Error adding category: $e');
        BaseHelper.showErrorSnackBar(
            'Failed to add category. Please try again.');
      }
    } else {
      BaseHelper.showErrorSnackBar('Please enter a category name');
    }
  }

  void _deleteCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      BaseHelper.showSnackBar('Category deleted successfully');
    } catch (e) {
      print('Error deleting category: $e');
      BaseHelper.showErrorSnackBar(
          'Failed to delete category. Please try again.');
    }
  }

  void _editCategory(
      BuildContext context, String categoryId, String categoryName) async {
    TextEditingController _editCategoryController =
        TextEditingController(text: categoryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: _editCategoryController,
            decoration:
                const InputDecoration(hintText: 'Enter new category name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newCategoryName = _editCategoryController.text.trim();
                if (newCategoryName.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(categoryId)
                        .update({
                      'name': newCategoryName,
                    });
                    BaseHelper.showSnackBar('Category updated successfully');
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating category: $e');
                    BaseHelper.showErrorSnackBar(
                        'Failed to update category. Please try again.');
                  }
                } else {
                  BaseHelper.showErrorSnackBar('Please enter a category name');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
          'Add Category',
          style: TextStyle(
              color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              prefixIcon: const Icon(
                Icons.category,
                size: 20,
                color: kPrimaryColor,
              ),
              controller: _categoryController,
              hintText: 'enter category name',
            ),
            const SizedBox(height: 16.0),
            MyButtonLong(
              name: 'Add Category',
              onTap: () => _addCategory(context),
            ),
            30.heightBox,
            const Text(
              'Category List',
              style: TextStyle(color: kPrimaryColor, fontSize: 18),
            ),
            10.heightBox,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    final categories = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        // return Card(
                        //   color: Colors.white,
                        //   child: ListTile(
                        //     title: Text(category['name']),
                        //     trailing: SizedBox(
                        //       width: 96,
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           IconButton(
                        //             onPressed: () => _deleteCategory(category
                        //                 .id), // Add delete functionality
                        //             icon: const Icon(Icons.delete, size: 20),
                        //           ),
                        //           IconButton(
                        //             onPressed: () => _editCategory(
                        //                 context,
                        //                 category.id,
                        //                 category[
                        //                     'name']), // Add edit functionality
                        //             icon: const Icon(Icons.edit, size: 20),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(category['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => _deleteCategory(category
                                          .id), // Add delete functionality
                                      icon: Image.asset(Assets.deleteIcon,
                                          height: 20, width: 20),
                                    ),
                                    IconButton(
                                      onPressed: () => _editCategory(
                                          context,
                                          category.id,
                                          category[
                                              'name']), // Add edit functionality
                                      icon: Image.asset(Assets.editIcon,
                                          height: 18, width: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Text('No categories found.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
