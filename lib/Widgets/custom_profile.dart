import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  const CustomProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400.0,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => null,
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                            color: Color(0xFF114F5A),
                            letterSpacing: 1.0,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/280x280_RS/0c/59/d3/0c59d3e2b3a045c209c6517238df4e37.jpg'),
                      radius: 90.0,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Test Name',
                    style: TextStyle(
                        color: Color(0xFF114F5A),
                        letterSpacing: 2.0,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: const [
                          Text(
                            'Followers',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'Following',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'No. Events',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
