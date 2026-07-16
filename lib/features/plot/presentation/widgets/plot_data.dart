part of '../pages/plot_directory_page.dart';

typedef _PlotData = ({
  String id,
  String title,
  String location,
  String area,
  String price,
  String status,
  String propertyType,
  String roadWidth,
  String electricity,
  String water,
  String registration,
  String description,
  String sellerName,
  String sellerPhone,
  List<String> images,
  List<String> amenities,
  bool isSaved,
});

typedef _VisitData = ({
  String id,
  String plotId,
  String propertyName,
  String date,
  String time,
  String status,
  String imageUrl,
});

