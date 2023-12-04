import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/news/news_details.dart';
import 'package:login_screen/note1/shared.dart';

class NewsScreen extends StatefulWidget {
  final String category;

  const NewsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    if(PreferenceUtils.getString(
        PrefKeys.newsCountry
    ).isEmpty){
      PreferenceUtils.setString(
          PrefKeys.newsCountry,
          'us'
      );

    }
    getNewsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          Article article = articles[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailsScreen(url: article.url),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  article.urlToImage.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 50),
                    ),
                  )
                      : ClipRRect(
                    child: Image.network(article.urlToImage),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Text(article.title),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getNewsByCategory(String category) async {
    final response = await Dio().get(
      'https://newsapi.org/v2/top-headlines',
      queryParameters: {
        "country": PreferenceUtils.getString(
        PrefKeys.newsCountry),
        "category": category, // Pass the category parameter
        "apiKey": "b0bf7c0e382f4a27b7df219617565a0f",
      },
    );
    final news = NewsResponse.fromJson(response.data);
    setState(() {
      articles = news.articles;
    });
  }
}
