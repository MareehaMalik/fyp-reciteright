// import 'package:flutter/material.dart';

// class ReciteRightScreen1 extends StatelessWidget {
//   const ReciteRightScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "ReciteRight",
//                     style: TextStyle(
//                       color: Color(0xFF1E4976),
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Icon(Icons.notifications_none, color: Color(0xFF1E4976)),
//                 ],
//               ),
//             ),

//             // Book image
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Image.asset(
//                 "assets/Book.png",

//                 width: mq.width * 0.25,
//                 height: mq.height * 0.13,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             // Search bar
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 18.0,
//                 vertical: 12,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search Tajweed Rules here",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     prefixIcon: Icon(Icons.search, color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//             ),

//             // Scrollable rules
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: const [
//                     TajweedCard(
//                       title: "Madd",
//                       description:
//                           "Madd (مدّ) means 'to lengthen' and refers to the extension of specific vowel sounds",
//                       iconPath: "assets/madd.png",
//                     ),
//                     TajweedCard(
//                       title: "Ikhfa",
//                       description:
//                           "Occurs when a Nun Sakinah or Tanween is followed by one of 15 specific letters that are not throat letters (used in Izhar).",
//                       iconPath: "assets/ikhfa.png",
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       bottomNavigationBar: Container(
//         height: mq.height * 0.09,
//         decoration: const BoxDecoration(
//           color: Color(0xFFF4F7EC),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _bottomIcon(Icons.home_outlined),
//             _bottomIcon(Icons.menu_book_outlined),
//             _bottomIcon(Icons.mic_none),
//             _bottomIcon(Icons.bar_chart_outlined),
//             _bottomIcon(Icons.person_outline),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _bottomIcon(IconData icon) {
//     return IconButton(
//       onPressed: () {},
//       icon: Icon(icon, color: const Color(0xFF1E4976), size: 28),
//     );
//   }
// }

// class TajweedCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String iconPath;

//   const TajweedCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.iconPath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFDFF3DA),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: mq.height * 0.07,
//             width: mq.width * 0.15,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(iconPath, fit: BoxFit.contain),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Color(0xFF1E4976),
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 13.5,
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1E4976),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       "Practice",

//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tajweed_corrector/home/home2.dart';

class ReciteRightScreen1 extends StatelessWidget {
  const ReciteRightScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "ReciteRight",
                    style: TextStyle(
                      color: Color(0xFF1E4976),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.notifications_none, color: Color(0xFF1E4976)),
                ],
              ),
            ),

            // 🔹 Book image
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                "assets/Book.png",
                width: mq.width * 0.25,
                height: mq.height * 0.13,
                fit: BoxFit.contain,
              ),
            ),

            // 🔹 Search bar + Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search Tajweed Rules here",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔹 Button to go to Progress screen
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4976),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReciteRightScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bar_chart, color: Colors.white),
                      label: const Text(
                        "View Progress",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Scrollable Rules (Four Tajweed sections)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    TajweedCard(
                      title: "Madd",
                      description:
                          "Madd (مدّ) means 'to lengthen' and refers to the extension of specific vowel sounds.",
                      iconPath: "assets/madd.png",
                    ),
                    TajweedCard(
                      title: "Ikhfa",
                      description:
                          "Occurs when a Nun Sakinah or Tanween is followed by one of 15 specific letters that are not throat letters (used in Izhar).",
                      iconPath: "assets/ikhfa.png",
                    ),
                    TajweedCard(
                      title: "Idgham",
                      description:
                          "Idgham occurs when a Nun Sakinah or Tanween is merged into the following letter, resulting in a nasal sound.",
                      iconPath: "assets/madd.png",
                    ),
                    TajweedCard(
                      title: "Iqlab",
                      description:
                          "Iqlab happens when a Nun Sakinah or Tanween is followed by a 'Baa' and is pronounced with a 'Meem'-like sound.",
                      iconPath: "assets/ikhfa.png",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔹 Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: mq.height * 0.09,
        decoration: const BoxDecoration(
          color: Color(0xFFF4F7EC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomIcon(Icons.home_outlined),
            _bottomIcon(Icons.menu_book_outlined),
            _bottomIcon(Icons.mic_none),
            _bottomIcon(Icons.bar_chart_outlined),
            _bottomIcon(Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: const Color(0xFF1E4976), size: 28),
    );
  }
}

// 🔸 TajweedCard widget
class TajweedCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;

  const TajweedCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF3DA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: mq.height * 0.07,
            width: mq.width * 0.15,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E4976),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E4976),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Practice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

