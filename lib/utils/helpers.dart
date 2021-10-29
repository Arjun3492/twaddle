import 'package:flutter/material.dart';

final TextEditingController searchController = TextEditingController();
final TextEditingController messageController = TextEditingController();
final ValueNotifier<bool> searchable = ValueNotifier<bool>(false);
final ValueNotifier<bool> shouldSearch = ValueNotifier<bool>(false);
final ValueNotifier<bool> messageSearch = ValueNotifier<bool>(false);
