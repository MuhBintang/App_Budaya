import 'package:flutter/material.dart';

class PageLegal extends StatefulWidget {
  const PageLegal({Key? key}) : super(key: key);

  @override
  State<PageLegal> createState() => _PageLegalState();
}

class _PageLegalState extends State<PageLegal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 80, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome to Budaya Application. By accessing our website, you agree to comply with the following terms and conditions. Use of Cookie: We use cookies to enhance user experience. By using our website, you consent to our use of cookies as outlined in our privacy policy. License: Unless otherwise stated, we own the intellectual property rights for all content on our website. You may access this content from Budaya Application for personal use, subject to the restrictions outlined in these terms and conditions. \n\nModification: You are prohibited from modifying, copying, distributing, transmitting, displaying, publishing, selling, licensing, creating derivative works, or using any content or materials from Budaya Application for any other purpose without our prior written consent. We reserve the right to monitor and remove any content that violates these terms without notice. \n\nThird Party Websites: Our website may contain links to third-party websites or services that are not owned or controlled by us. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You further acknowledge and agree that we shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Change To The Service and or terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Disclaimer To the fullest extent permitted by law, we exclude all warranties and representations related to our website and its use. This disclaimer does not limit or exclude liability for death or personal injury caused by negligence, fraud, or fraudulent misrepresentation. Changes to TermsWe may revise these terms at any time. By using this website, you agree to the current version of these terms and conditions.or more details, please refer to our full Terms and Conditions ",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: 
              Text(
                'Legacy & Policy',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Color(0xFFF4B5A4),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40,
            right: 15,
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Define action for more_vert button here
              },
            ),
          ),
        ],
      ),
    );
  }
}
