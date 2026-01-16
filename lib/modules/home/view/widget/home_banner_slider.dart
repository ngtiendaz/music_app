import 'package:flutter/material.dart';
import 'package:music_app/data/models/home_model.dart';

class HomeBannerSlider extends StatelessWidget {
  final List<BannerItem> banners;

  const HomeBannerSlider({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return SizedBox.shrink();

    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: 20),
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                banners[index].banner ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Container(color: Colors.grey[800], child: Icon(Icons.error)),
              ),
            ),
          );
        },
      ),
    );
  }
}