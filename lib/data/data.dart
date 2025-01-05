import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'icon': FaIcon(FontAwesomeIcons.burger, color: Colors.white,),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$45.00',
    'date': 'Today',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'color': Colors.purple,
    'name': 'Shopping',
    'totalAmount': '-\$230.00',
    'date': 'Today',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.white),
    'color': Colors.red,
    'name': 'Health',
    'totalAmount': '-\$800.00',
    'date': 'Yesterday',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.plane, color: Colors.white),
    'color': Colors.blue,
    'name': 'Travel',
    'totalAmount': '-\$300.00',
    'date': '5 days ago',
  },
];

List<Map<String, dynamic>> transactionsCategory = [
  {
    'icon': FaIcon(FontAwesomeIcons.burger, color: Colors.white,),
    'color': Colors.yellow[700],
    'name': 'Food',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'color': Colors.purple,
    'name': 'Shopping',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.white),
    'color': Colors.red,
    'name': 'Health',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.plane, color: Colors.white),
    'color': Colors.blue,
    'name': 'Travel',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.gamepad, color: Colors.white),
    'color': Colors.green,
    'name': 'Entertainment',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.buildingCircleCheck, color: Colors.white),
    'color': Colors.brown,
    'name': 'Governmental Fees',
  },
  {
    'icon': FaIcon(FontAwesomeIcons.paperclip, color: Colors.white),
    'color': Colors.blueAccent,
    'name': 'Others',
  },
];