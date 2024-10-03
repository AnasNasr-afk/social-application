import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../network/local/cacheHelper.dart';

Widget buildArticleItem(article) => Padding(
  padding: EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
              article["urlToImage"] ?? 'https://via.placeholder.com/150', // Use a placeholder if urlToImage is null
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          height: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  article['title'] ?? 'No title', // Use a fallback if title is null
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Text(
                article['publishedAt'] ?? 'No date', // Use a fallback if publishedAt is null
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false,
  );
}

void showToast({
  required String text,
  required Color color,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  double radius = 3.0,
  required VoidCallback function,
  required String text,
}) => Container(
  width: width,
  height: 50,
  decoration: BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(radius),
  ),
  child: MaterialButton(
    onPressed: function,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

void signOut(BuildContext context, Widget widget) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value == true) {
      navigateAndFinish(context, widget);
    } else {
      showToast(text: "Error signing out", color: Colors.red);
    }
  }).catchError((error) {
    showToast(text: "Error: $error", color: Colors.red);
  });
}

