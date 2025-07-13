import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

import '../../domain/entities/home_item_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/home_main_item.dart';
import 'header_top.dart';

class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey2,
              offset: Offset(0, 1),
            )
          ]),
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              HeaderTop(cubit: cubit),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // context.read<HomeCubit>().getReport();
              // context.read<HomeCubit>().getHome();
              // context.read<HomeCubit>().loadCachedFaces();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CustomText(
                          text: "لوحة التحكم الرئيسية",
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                        SizedBox(height: 5),
                        CustomText(
                          text: "اختر العملية المطلوبة من الخيارات أدناه",
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      return LayoutHeaderBody(cubit: cubit);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LayoutHeaderBody extends StatefulWidget {
  const LayoutHeaderBody({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<LayoutHeaderBody> createState() => _LayoutHeaderBodyState();
}

class _LayoutHeaderBodyState extends State<LayoutHeaderBody> {
  @override
  void initState() {
    super.initState();
    String role = Caching.get(key: 'role') ?? "";

    if (role != "admin") {
      requestPermissions();
    }
  }

  List<Beacon> beacons = [];
  StreamSubscription<RangingResult>? _streamRanging;

  @override
  void dispose() {
    _streamRanging?.cancel();
    flutterBeacon.close;
    super.dispose();
  }

  Future<void> requestPermissions() async {
    // Request required permissions
    final status = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.bluetoothAdvertise,
    ].request();

    // Check if permissions are granted
    if (status.values.every((element) => element.isGranted)) {
      checkBluetooth();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
              'Bluetooth and Location permissions are required to scan for beacons.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                requestPermissions();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> checkBluetooth() async {
    final bluetoothState = await flutterBeacon.bluetoothState;

    if (bluetoothState != BluetoothState.stateOn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Bluetooth'),
          content: const Text(
              'Bluetooth is required to scan for beacons. Please enable Bluetooth.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                checkBluetooth();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      initializeBeacon();
    }
  }

  Future<void> initializeBeacon() async {
    try {
      await flutterBeacon.initializeScanning;

      // Ensure Bluetooth is on
      final bluetoothState = await flutterBeacon.bluetoothState;
      if (bluetoothState != BluetoothState.stateOn) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Bluetooth is off. Please enable Bluetooth.'),
        ));
        return;
      }

      // Define regions to scan
      final regions = <Region>[Region(identifier: 'AllBeacons')];

      // Start ranging for beacons
      _streamRanging =
          flutterBeacon.ranging(regions).listen((RangingResult result) {
        log('Beacons found: ${result.beacons.length}');
        setState(() {
          beacons = result.beacons;
        });
      });
    } catch (e) {
      print('Error initializing beacon: $e');
    }
  }

  num calculateDistance(int rssi, int txPower, {double n = 2.0}) {
    // Using the basic distance calculation formula
    if (rssi == 0) {
      return -1.0; // Invalid distance
    }
    double ratio = rssi * 1.0 / txPower;
    if (ratio < 1.0) {
      return math.pow(ratio, n);
    } else {
      double distance = (0.89976) * math.pow(ratio, 7.7095) + 0.111;
      return distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    String role = Caching.get(key: 'role') ?? "";

    final List<HomeItemEntity> items = [
      HomeItemEntity(
        icon: ImageManager.peoplesOutlined,
        text: "إدارة الطلاب",
        subTitle: "عرض وإدارة بيانات الطلاب المسجلين",
        tabTitle: "انقر للدخول",
        route: Routes.employees,
        iconColor: AppColors.primary,
        iconBgColor: AppColors.primary.withOpacity(0.1),
      ),
      if (!kIsWeb)
        if (Platform.isAndroid || Platform.isIOS)
          HomeItemEntity(
            icon: ImageManager.cameraAdd,
            text: "تسجيل حضور جماعي",
            subTitle: "فتح الكاميرا وبدء عملية تسجيل الحضور للجلسة",
            tabTitle: "انقر للبدء",
            route: "faceId",
            iconColor: AppColors.green,
            iconBgColor: AppColors.green.withOpacity(0.1),
          ),
      HomeItemEntity(
        icon: ImageManager.active,
        text: "حضور عن طريق الاستاذ",
        subTitle: "تحديد هوية الأستاذ وتسجيل حضور الطلاب يدويا",
        tabTitle: "انقر للبدء",
        route: "manualAttendance",
        iconColor: AppColors.purple,
        iconBgColor: AppColors.purple.withOpacity(0.1),
      ),
    ];

    final List<HomeItemEntity> employeeItems = [
      HomeItemEntity(
        icon: ImageManager.qrCode,
        text: "حضور فردي بالباكود",
        subTitle: "تسجيل حضور طالب واحد عبر قراءة الباركود",
        tabTitle: "انقر للبدء",
        route: "qrCodeAttendance",
        iconColor: Colors.orange,
        iconBgColor: Colors.orange.withOpacity(0.1),
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(right: 100.w, left: 100.w, bottom: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (context.screenWidth >= 1000) {
            crossAxisCount = 4;
          } else if (context.screenWidth >= 750) {
            crossAxisCount = 3;
          } else if (context.screenWidth >= 500) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 1;
          }
          return GridView.builder(
            itemCount: role == "admin" ? items.length : employeeItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 16.w,
              mainAxisExtent: 190,
            ),
            itemBuilder: (context, index) {
              return HomeMainItem(
                item: role == "admin" ? items[index] : employeeItems[index],
                beacons: beacons,
              );
            },
          );
        },
      ),
    );
  }
}
