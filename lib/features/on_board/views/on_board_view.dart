import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/config/app_color.dart';

import '../../../core/config/app_images.dart';
import '../../../core/config/app_padding.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/custom_text.dart';
import '../../auth/views/login_view.dart';
import '../data/on_board_model.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  int currentPage = 0;
  final List<OnBoardModel> onBoardList = [
    OnBoardModel(
      image: AppImages.onBoardOne,
      title: 'Qr Code Check-In',
      description: 'Students can scan a QR code to check in to class',
    ),
    OnBoardModel(
      image: AppImages.onBoardTwo,
      title: 'Track Attendance',
      description: 'Easily monitor attendance and generate reports',
    ),
    OnBoardModel(
      image: AppImages.onBoardThree,
      title: 'View Reports',
      description: 'Generate and view detailed attendance reports',
    ),
  ];
  final _pageController = PageController();


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Get.offAll(() => const LoginView()),
            child: const CustomText(
              title: 'Skip',
              fontSize: AppFontSize.f16,
              txtColor: AppColor.kPrimary,
              fontWeight: AppFontWeight.w600,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) => _buildItem(onBoardList[index]),
        itemCount: onBoardList.length,
        onPageChanged: (index) {
          if (mounted)
            setState(() {
              currentPage = index;
            });
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppPadding.kPadding * 2,horizontal: AppPadding.kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(currentPage == onBoardList.length - 1)...[
              TextButton(
                onPressed: () {},
                child:const CustomText(
                  title: 'Get Started',
                  fontSize: AppFontSize.f16,
                  txtColor: Colors.transparent,
                  fontWeight: AppFontWeight.w600,
                ),
              ),
            const  Spacer(),
            ],

            SmoothPageIndicator(
              controller: _pageController,
              count: onBoardList.length,
              effect: const WormEffect(activeDotColor: AppColor.kPrimary),
            ),
            if (currentPage == onBoardList.length - 1)...[
              const Spacer(),
              TextButton(
                onPressed: ()=>Get.offAll(() => const LoginView()),
                child:const CustomText(
                  title: 'Get Started',
                  fontSize: AppFontSize.f16,
                  txtColor: AppColor.kPrimary,
                  fontWeight: AppFontWeight.w600,
                ),
              ),
            ]

          ],
        ),
      ),
    );
  }

  Widget _buildItem(OnBoardModel model) => Padding(
    padding: const EdgeInsetsDirectional.all(AppPadding.kPadding),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppPadding.kPadding,
      children: [
        const Spacer(),
        Center(
          child: Image.asset(
            model.image,
            width: MediaQuery.sizeOf(context).width / 1.5,
          ),
        ),
        const Spacer(),
        CustomText(
          title: model.title,
          fontSize: AppFontSize.f22,
          txtColor: AppColor.kPrimary,
          fontWeight: AppFontWeight.w600,
        ),
        CustomText(title: model.description, fontSize: AppFontSize.f18),
      ],
    ),
  );
}
