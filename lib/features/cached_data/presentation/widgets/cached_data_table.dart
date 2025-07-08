import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_data_table.dart';
import 'package:time_attend_recognition/core/widget/emit_no_data.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';

class CachedDataTable extends StatelessWidget {
  const CachedDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: context.screenWidth > 900
          ? CachedDataTableBody(width: 1.sw)
          : const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CachedDataTableBody(),
            ),
    );
  }
}

class CachedDataTableBody extends StatelessWidget {
  const CachedDataTableBody({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = context.read<HomeCubit>();

      final dataList = cubit.searchController.text.isEmpty && cubit.facesDateController.text.isEmpty ? cubit.cachedFacesList : cubit.filteredCachedFacesList;

      if (dataList.isEmpty) {
        return const EmitNoData();
      }

      return dataList.isNotEmpty
          ? SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DataTable(
                    dividerThickness: 0.6,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: double.infinity,
                    headingRowColor: WidgetStateProperty.all(AppColors.grey2.withOpacity(0.5)),
                    dataRowColor: WidgetStateProperty.all(AppColors.white),
                    border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(12)),
                    columns: [
                      customDataColumn("#"),
                      customDataColumn("اسم الموظف"),
                      customDataColumn("التاريخ والوقت"),
                      customDataColumn("اسم المشروع"),
                      customDataColumn("حالة السيرفر"),
                      customDataColumn("رد السيرفر"),
                    ],
                    rows: List.generate(
                      dataList.length,
                      (index) {
                        return DataRow(
                          // color: dataList[index].uploadedToServer && dataList[index].serverReplay.isEmpty ? WidgetStateProperty.all(AppColors.green.withOpacity(0.1)) : null,
                          color: cubit.getCachedDataColor(
                            uploadedToServer: dataList[index].uploadedToServer,
                            serverReplay: dataList[index].serverReplay,
                          ),

                          cells: [
                            customDataCell("${index + 1}"),
                            customDataCell(dataList[index].memberName),
                            customDataCell(dataList[index].createdAt.isEmpty ? "" : "${AppConstance.dateFormat.format(DateTime.parse(dataList[index].createdAt))} - ${AppConstance.timeFormat.format(DateTime.parse(dataList[index].createdAt))}"),
                            customDataCell(dataList[index].projectName),
                            customDataCell(
                              "",
                              isWidget: true,
                              widget: SvgPicture.asset(
                                dataList[index].uploadedToServer ? ImageManager.yes : ImageManager.no,
                                height: 20,
                              ),
                            ),
                            customDataCell(dataList[index].serverReplay),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          : const EmitNoData();
    });
  }
}
