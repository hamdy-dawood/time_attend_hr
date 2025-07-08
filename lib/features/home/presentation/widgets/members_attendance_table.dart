import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/core/widget/custom_cached_image.dart';
import 'package:time_attend_recognition/core/widget/custom_data_table.dart';
import 'package:time_attend_recognition/core/widget/emit_failed_item.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/emit_no_data.dart';
import 'package:time_attend_recognition/core/widget/pagination_table.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';

class MembersAttendanceTable extends StatelessWidget {
  const MembersAttendanceTable({super.key, required this.cubit, required this.status});

  final HomeCubit cubit;
  final int status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: context.screenWidth > 600
          ? MembersAttendanceTableBody(cubit: cubit, width: 1.sw, status: status)
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MembersAttendanceTableBody(cubit: cubit, status: status),
            ),
    );
  }
}

class MembersAttendanceTableBody extends StatelessWidget {
  const MembersAttendanceTableBody({super.key, required this.cubit, this.width, required this.status});

  final HomeCubit cubit;
  final double? width;
  final int status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        if (state is GetMembersAttendanceLoadingState) {
          return SizedBox(width: 1.sw, child: const EmitLoadingItem(size: 60));
        } else if (state is GetMembersAttendanceFailState) {
          return EmitFailedItem(text: state.message);
        } else if (state is GetMembersAttendanceNoDataState) {
          return const EmitNoData();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: context.screenWidth < 600 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DataTable(
                    dividerThickness: 0.6,
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: double.infinity,
                    headingRowColor: WidgetStateProperty.all(AppColors.grey2.withOpacity(0.5)),
                    dataRowColor: WidgetStateProperty.all(AppColors.white),
                    border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(12)),
                    columns: [
                      customDataColumn("#"),
                      customDataColumn("صورة الموظف"),
                      customDataColumn("اسم الموظف"),
                    ],
                    rows: List.generate(
                      cubit.membersAttendanceList.length,
                      (index) {
                        return DataRow(
                          cells: [
                            customDataCell("${index + 1}", width: 50),
                            customDataCell(
                              "",
                              isWidget: true,
                              widget: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(30),
                                    child: CustomCachedImage(
                                      image: cubit.membersAttendanceList[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            customDataCell(
                              cubit.membersAttendanceList[index].displayName,
                              width: width != null ? width! - 420 : 300,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              _BuildPagesCount(status: status),
            ],
          ),
        );
      },
    );
  }
}

class _BuildPagesCount extends StatelessWidget {
  const _BuildPagesCount({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        if (state is GetMembersAttendanceLoadingState) {
          return const EmitLoadingItem(size: 60);
        }
        return calculatePageNumber(context.read<HomeCubit>().count) > 1
            ? Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: CustomPaginationTable(
                  onTapNumber: (page) {
                    context.read<HomeCubit>().page = page;
                    context.read<HomeCubit>().membersAttendanceCount(resetPage: false, status: status);
                  },
                  pagesCount: calculatePageNumber(context.read<HomeCubit>().count),
                  currentPage: context.read<HomeCubit>().page,
                  onTapNext: () {
                    context.read<HomeCubit>().page++;
                    context.read<HomeCubit>().membersAttendanceCount(resetPage: false, status: status);
                  },
                  onTapPrevious: () {
                    context.read<HomeCubit>().page--;
                    context.read<HomeCubit>().membersAttendanceCount(resetPage: false, status: status);
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }
}
