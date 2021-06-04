import 'package:flutter/material.dart';
import 'package:diginotes_app/src/utils/details.dart';
import 'package:diginotes_app/src/utils/content_model.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: scrwid * 0.01),
              Text(
                info_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
              SizedBox(height: scrwid * 0.03),
              Expanded(
                child: Container(
                  width: scrwid,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.fromLTRB(25, 30, 22, 20),
                  decoration: BoxDecoration(
                    color: blue.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          info_content,
                          style: TextStyle(
                            color: white,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          info_credits,
                          style: TextStyle(
                            color: white,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
