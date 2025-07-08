import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/caching/shared_prefs.dart';
import 'core/dependancy_injection/dependancy_injection.dart';
import 'core/helper/extension.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'features/face_recognize/cubit/cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    Caching.getLocal().then((local) {
      return context.setLocale(local);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(context) {
    String token = Caching.get(key: 'access_token') ?? "";

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, Widget? child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => FaceRecognitionCubit()),
              BlocProvider(create: (context) => getIt<HomeCubit>()),
            ],
            child: BlocBuilder<FaceRecognitionCubit, FaceRecognitionStates>(
              builder: (context, state) {
                return MaterialApp(
                  title: "Time Attend Recognition",
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
                  ),
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  initialRoute: token.isNotEmpty ? Routes.home : Routes.login,
                  onGenerateRoute: AppRouter().generateRoute,
                  navigatorKey: navigatorKey,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
