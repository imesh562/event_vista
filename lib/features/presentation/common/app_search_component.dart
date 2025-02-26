import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/app_images.dart';

class AppSearchCriteria {
  final Function(String) onSubmit;
  final Function(String)? onTapIcon;
  final String title;
  final Function(String) onQueryChanged;
  final List<String> dataset;
  bool shouldFocus;
  final TextEditingController? controller;

  AppSearchCriteria({
    required this.onSubmit,
    this.title = 'Search',
    this.controller,
    this.shouldFocus = true,
    this.onTapIcon,
    required this.onQueryChanged,
    required this.dataset,
  });
}

class AppSearchComponent extends StatefulWidget {
  final AppSearchCriteria searchCriteria;

  AppSearchComponent({
    required this.searchCriteria,
  });

  @override
  _AppSearchComponentState createState() => _AppSearchComponentState();
}

class _AppSearchComponentState extends State<AppSearchComponent> {
  TextEditingController? searchController;
  FocusNode searchFocusNode = FocusNode();
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    searchController = widget.searchCriteria.controller??TextEditingController();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        if(widget.searchCriteria.shouldFocus){
          widget.searchCriteria.onSubmit(searchController!.text);
        }
      }
    });
    _filteredList.addAll(widget.searchCriteria.dataset);
  }

  @override
  void dispose() {
    super.dispose();
    searchFocusNode.dispose();
    searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextField(
        textInputAction: TextInputAction.search,
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: (query) {
          setState(() {
            if (query.length >= 2) {
              _filterList(query);
            } else {
              _filteredList = List.from(widget.searchCriteria.dataset);
            }

            widget.searchCriteria.onQueryChanged(
                query); // Call the callback function and pass the query
          });
        },
        maxLength: 50,
        style: TextStyle(
          fontSize: AppDimensions.kFontSize14,
          fontWeight: FontWeight.w500,
          color: AppColors.initColors().matteBlack,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 9.w, top: 9.h, bottom: 9.h),
          isDense: true,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
            borderSide: BorderSide.none,
          ),
          suffixIconConstraints:
              BoxConstraints(minWidth: 21.96.h, maxHeight: 21.96.h),
          suffixIcon: Padding(
            padding: EdgeInsets.only(
              right: 9.w,
              left: 4.5.w,
            ),
            child: InkResponse(
              onTap: (){
                if(widget.searchCriteria.onTapIcon!=null){
                  widget.searchCriteria.onTapIcon!(searchController!.text);
                }
              },
              child: Image.asset(
                AppImages.icSearch,
                color: AppColors.initColors().searchHintColor,
              ),
            ),
          ),
          filled: true,
          hintText: widget.searchCriteria.title,
          hintStyle: TextStyle(
              color: AppColors.initColors().searchHintColor,
              fontSize: AppDimensions.kFontSize12,
              fontWeight: FontWeight.w400),
          fillColor: AppColors.initColors().searchBackground,
        ),
        onSubmitted: widget.searchCriteria.onSubmit,
      ),
    );
  }

  void _filterList(String query) {
    setState(() {
      _filteredList = widget.searchCriteria.dataset
          .where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
