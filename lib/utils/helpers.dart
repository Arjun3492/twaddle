import 'package:flutter/material.dart';

final ValueNotifier<bool> searchable = ValueNotifier<bool>(false);
final TextEditingController searchController = TextEditingController();
final ValueNotifier<bool> shouldSearch = ValueNotifier<bool>(false);
final ValueNotifier<bool> messageSearch = ValueNotifier<bool>(false);
