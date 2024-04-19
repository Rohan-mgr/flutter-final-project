import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
            margin: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            color: Colors.grey[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            color: Colors.grey[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            color: Colors.grey[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            color: Colors.grey[200],
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
        Card(
            margin: EdgeInsets.all(10),
            // color: Colors.grey,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Mingmar Gyal..."),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.date_range,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      Text(
                        "Apr 2",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'This is a very long title that should wrap to the next line if it is too long to fit on a single line',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.thumb_up_alt,
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }
}
