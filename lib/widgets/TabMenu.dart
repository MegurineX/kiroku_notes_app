import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabMenu extends StatelessWidget {
  const TabMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Get.back(); // Tutup TabMenu
              // TODO: Navigasi ke halaman Home
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Get.back(); // Tutup TabMenu
              // TODO: Navigasi ke halaman Search
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Get.back(); // Tutup TabMenu
              // TODO: Navigasi ke halaman Chat
            },
          ),
          IconButton(
            icon: Icon(Icons.feed),
            onPressed: () {
              Get.back(); // Tutup TabMenu
              // TODO: Navigasi ke halaman Feed
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Get.back(); // Tutup TabMenu
              // TODO: Navigasi ke halaman Personal
            },
          ),
        ],
      ),
    );
  }
}
