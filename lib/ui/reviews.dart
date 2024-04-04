import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Reviews extends StatefulWidget {
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  TextEditingController controller = TextEditingController();

  String car =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE',
            style: Global.style(
              size: 22,
              bold: true,
              caps: true,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: ListView.separated(
//              physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                          child: Image.network(
                            car,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '20 km away',
                          style: Global.style(
                            size: 9,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: width - 118,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '4.5',
                                  style: Global.style(
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Car Repair Workshop',
                            style: Global.style(
                              size: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lorem ipsum. ' * 5,
                            style: Global.style(
                              size: 10,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                width: double.infinity,
                color: Colors.white,
              );
            },
            itemCount: 8,
          ),
        ),
      ),
    );
  }

  void leaveReviewDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController reviewController = TextEditingController();

    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 390,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Leave Review',
                        textAlign: TextAlign.center,
                        style: Global.style(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          MyTextField(
                            hint: 'Your Name',
                            controller: nameController,
                          ),
                          SizedBox(height: 24),
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          SizedBox(height: 12),
                          MyTextField(
                            hint: 'Review',
                            controller: reviewController,
                            lines: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.black,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: Global.style(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }
}
