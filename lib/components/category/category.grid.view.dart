import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_application_3/models/category.dart';
import 'package:flutter_application_3/pages/category/category.edit.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/pages/category/category.product.list.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryPreview extends StatelessWidget {
  final Category category;

  const CategoryPreview({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onDoubleTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => EditCategoryPage(category: category)),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  CategoryProductList(category: category.order)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                File(
                    '${API.path}/${ImageLocation.category}/${category.image.split('.').first}.jpg'),
                errorBuilder: (context, error, stackTrace) => Image.network(
                  Supabase.instance.client.storage
                      .from('category_image')
                      .getPublicUrl('${category.userId}/${category.image}.jpg'),
                  // width: 600,
                  // height: 600,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
            Positioned.directional(
              bottom:
                  Directionality.of(context) == TextDirection.ltr ? 0 : null,
              textDirection: Directionality.of(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
