import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/user/update_favorite_genres.dart';
import 'package:spotify_clone/presentation/home/pages/home_navigation.dart';

class GenrePicks extends StatefulWidget {
  GenrePicks({Key? key}) : super(key: key);

  @override
  State<GenrePicks> createState() => _GenrePicksState();
}

class _GenrePicksState extends State<GenrePicks> {
  List genres = [
    'Blues',
    'Classical',
    'Country',
    'Electronic',
    'Folk',
    'Hip Hop',
    'Jazz',
    'K-Pop',
    'Latin',
    'Pop',
    'R&B',
    'Reggae',
    'Rock',
    'Soul',
    'World'
  ];

  List selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(child: Container()),
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return RadialGradient(
                        center: Alignment.center,
                        radius: 0.7,
                        colors: const [
                          Colors.transparent,
                          AppColors.medDarkBackground,
                        ],
                        stops: [0.6 - (100 / bounds.shortestSide), 1],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcOver,
                    child: const Padding(
                      padding: EdgeInsets.all(0),
                      child: Image(
                        image: AssetImage(
                          AppImages.genrePicks,
                        ),
                        opacity: AlwaysStoppedAnimation(0.4),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.medDarkBackground.withOpacity(0), AppColors.medDarkBackground.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Welcome ',
                                  style: TextStyle(fontSize: 30.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Sekaizel',
                                  style: TextStyle(fontSize: 30.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'mind to pick your favorite music genre\'s ?',
                              style: TextStyle(fontSize: 17.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 12.h,
                          children: genres.map(
                            (genre) {
                              final isSelected = selectedGenres.contains(genre); // Check if THIS genre is selected
                              final isEnabled = selectedGenres.length < 3 || isSelected; // Enable if less than 3 OR already selected

                              return GenreChip(
                                genre: genre,
                                enabled: isEnabled, // Use calculated enabled state
                                isSelected: isSelected, // Pass the isSelected state
                                onSelectionChanged: (selectedGenre) {
                                  setState(() {
                                    if (selectedGenre != null) {
                                      if (selectedGenres.length < 3) {
                                        // Only add if less than 3
                                        selectedGenres.add(selectedGenre);
                                      }
                                    } else {
                                      selectedGenres.remove(genre); // Remove the specific genre
                                    }
                                    print('Current Selected Genres: $selectedGenres');
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('you can select up to 3 genres'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 40.w),
                child: MaterialButton(
                  onPressed: () async {
                    if (selectedGenres.isNotEmpty) {
                      var result = await sl<UpdateFavoriteGenresUseCase>().call(params: selectedGenres);

                      result.fold(
                        (l) {},
                        (r) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setBool('onboarding_complete', true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(r),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeNavigation(),
                      ),
                    );
                  },
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.sp)),
                  color: selectedGenres.isEmpty ? Colors.grey.shade600 : AppColors.primary,
                  child: Text(
                    selectedGenres.isEmpty
                        ? 'Skip for now'
                        : selectedGenres.length < 3
                            ? 'Finish'
                            : 'Done',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

class GenreChip extends StatefulWidget {
  final String genre;
  final bool isSelected;
  final bool enabled;
  final Function(String?) onSelectionChanged;
  const GenreChip({Key? key, required this.genre, this.enabled = true, this.isSelected = false, required this.onSelectionChanged}) : super(key: key);

  @override
  State<GenreChip> createState() => _GenreChipState();
}

class _GenreChipState extends State<GenreChip> {
  late bool isSelected;
  late double horizontalPadding;

  @override
  void initState() {
    super.initState();
    horizontalPadding = getRandomSpacing();
    isSelected = widget.isSelected; // Initialize here
  }

  @override
  void didUpdateWidget(covariant GenreChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      isSelected = widget.isSelected;
    }
  }

  void toggleSelected() {
    if (widget.enabled) {
      // Check enabled here too
      setState(() {
        isSelected = !isSelected;
        widget.onSelectionChanged(isSelected ? widget.genre : null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: MaterialButton(
          onPressed: () {
            toggleSelected();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.sp),
            side: BorderSide(color: isSelected ? Colors.white : Colors.white, width: 1.5),
          ),
          color: isSelected ? const Color.fromARGB(255, 74, 211, 67) : const Color.fromARGB(235, 32, 32, 32),
          padding: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
            child: Text(
              widget.genre,
              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.w500, fontSize: 17.sp),
            ),
          ),
        ),
      ),
    );
  }

  double getRandomSpacing() {
    final random = Random();
    return random.nextInt(7) + 7;
  }
}
