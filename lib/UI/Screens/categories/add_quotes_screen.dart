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

class AddQuoteScreen extends StatefulWidget {
  @override
  _AddQuoteScreenState createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final TextEditingController _quoteController = TextEditingController();
  String _selectedCategory = '';

  void _addQuote(BuildContext context) async {
    String quoteText = _quoteController.text.trim();
    if (quoteText.isNotEmpty && _selectedCategory.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('quotes').add({
          'text': quoteText,
          'category': _selectedCategory,
        });
        BaseHelper.showSnackBar('Quote added successfully');
        _quoteController.clear();
        setState(() {
          _selectedCategory = '';
        });
      } catch (e) {
        print('Error adding quote: $e');
        BaseHelper.showErrorSnackBar('Failed to add quote. Please try again.');
      }
    } else {
      BaseHelper.showErrorSnackBar(
          'Please enter a quote and select a category');
    }
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
          'Add Quote',
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
              maxline: 3,
              prefixIcon: const Icon(
                Icons.format_quote,
                size: 20,
                color: kPrimaryColor,
              ),
              controller: _quoteController,
              hintText: 'enter quote text',
            ),
            const SizedBox(height: 16.0),
            StreamBuilder<QuerySnapshot>(
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
                  List categoryNames =
                      categories.map((doc) => doc['name']).toList();
                  return DropdownButtonFormField<String>(
                    value:
                        _selectedCategory.isNotEmpty ? _selectedCategory : null,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    items:
                        categoryNames.map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'select category',
                      prefixIcon: Icon(Icons.category, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  );
                }

                return const Text('No categories found.');
              },
            ),
            const SizedBox(height: 16.0),
            MyButtonLong(
              name: 'Add Quote',
              onTap: () => _addQuote(context),
            ),
            40.heightBox,
            const Text(
              'Quotes List',
              style: TextStyle(color: kPrimaryColor, fontSize: 18),
            ),
            10.heightBox,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('quotes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    final quotes = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        final quote = quotes[index];
                        // return ListTile(
                        //   title: Text(quote['text']),
                        //   subtitle: Text('Category: ${quote['category']}'),
                        //   trailing: SizedBox(
                        //     width: 100,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         IconButton(
                        //           onPressed: () async {
                        //             await FirebaseFirestore.instance
                        //                 .collection('quotes')
                        //                 .doc(quote.id)
                        //                 .delete();
                        //             BaseHelper.showSnackBar(
                        //                 'Quote deleted successfully');
                        //           },
                        //           icon: Image.asset(
                        //             Assets.deleteIcon,
                        //             height: 20,
                        //             width: 20,
                        //           ),
                        //         ),
                        //         IconButton(
                        //           onPressed: () {
                        //             _quoteController.text = quote['text'];
                        //             setState(() {
                        //               _selectedCategory = quote['category'];
                        //             });
                        //           },
                        //           icon: Image.asset(
                        //             Assets.editIcon,
                        //             height: 18,
                        //             width: 18,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   // Additional customization for each quote tile
                        // );
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Category: ${quote['category']}'),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('quotes')
                                              .doc(quote.id)
                                              .delete();
                                          BaseHelper.showSnackBar(
                                              'Quote deleted successfully');
                                        },
                                        icon: Image.asset(
                                          Assets.deleteIcon,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  _quoteController =
                                                  TextEditingController(
                                                      text: quote['text']);
                                              return AlertDialog(
                                                title: const Text('Edit Quote'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _quoteController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Enter edited quote text',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // Update the quote in Firestore
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('quotes')
                                                          .doc(quote.id)
                                                          .update({
                                                        'text': _quoteController
                                                            .text
                                                            .trim(),
                                                      });
                                                      BaseHelper.showSnackBar(
                                                          'Quote edited successfully');
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Save'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Image.asset(
                                          Assets.editIcon,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              20.heightBox,
                              Text(quote['text']),
                              20.heightBox
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const Text('No quotes found.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
