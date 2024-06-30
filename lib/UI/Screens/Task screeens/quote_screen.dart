import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

class QuotesView extends StatefulWidget {
  @override
  _QuotesViewState createState() => _QuotesViewState();
}

class _QuotesViewState extends State<QuotesView> {
  List<String> selectedCategories = [];
  List<Quote> quotes = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSelectedCategories();
  }

  Future<void> fetchSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategories = prefs.getStringList('selectedCategories') ?? [];
    print('Selected Categories: $selectedCategories'); // Debug line
    fetchQuotes();
  }

  void fetchQuotes() {
    if (selectedCategories.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('quotes')
          .where('category', whereIn: selectedCategories)
          .get()
          .then((querySnapshot) {
        setState(() {
          quotes =
              querySnapshot.docs.map((doc) => Quote.fromSnapshot(doc)).toList();
        });
      }).catchError((error) {
        print('Error fetching quotes: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: quotes.isNotEmpty ? 155 : 130,
        width: Get.width / 1.0,
        child: quotes.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: CarouselSlider.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index, realIndex) {
                        return buildQuoteItem(quotes[index]);
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        aspectRatio: 2.7,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  quotes.length == 1
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: quotes.map((quote) {
                            int index = quotes.indexOf(quote);
                            return Container(
                              width: 6.0,
                              height: 6.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                                    : const Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              )
            : Container(
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: kWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('You don\'t have to be great to start,',
                        style: GoogleFonts.eduTasBeginner(fontSize: 18)),
                    Text('but you have to start to be great',
                        style: GoogleFonts.eduTasBeginner(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('- Zig Ziglar',
                        style: GoogleFonts.nanumMyeongjo(fontSize: 12)),
                    const SizedBox(height: 15),
                  ],
                ),
              ));
  }

  Widget buildQuoteItem(Quote quote) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: quote.text));
        BaseHelper.showSnackBar('Copied!');
      },
      child: Container(
        width: Get.width / 1.4,
        margin: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            quote.text,
            style: GoogleFonts.eduTasBeginner(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class Quote {
  final String category;
  final String text;

  Quote({required this.category, required this.text});

  Quote.fromSnapshot(DocumentSnapshot snapshot)
      : category = snapshot['category'],
        text = snapshot['text'];
}

class CategoryPreferences {
  static const String _key = 'selectedCategories';

  static Future<void> saveSelectedCategories(List<String> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, categories);
  }

  static Future<List<String>> getSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
