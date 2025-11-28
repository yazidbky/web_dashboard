import 'package:flutter/material.dart';
import 'package:web_dashboard/core/widgets/custom_text.dart';
import 'package:web_dashboard/core/widgets/size_config.dart';
import 'package:web_dashboard/core/theme/app_colors.dart';
import 'package:web_dashboard/features/Weather/Presentation/widgets/forecast_card.dart';

class ForecastSection extends StatefulWidget {
  final List<ForecastData> forecasts;
  final List<String> lands;
  final String selectedLand;
  final Function(String)? onLandChanged;

  const ForecastSection({
    super.key,
    required this.forecasts,
    required this.lands,
    required this.selectedLand,
    this.onLandChanged,
  });

  @override
  State<ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<ForecastSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      padding: SizeConfig.scalePadding(
        all: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig.getResponsiveBorderRadius(
            mobile: 1,
            tablet: 1.2,
            desktop: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            '7-Day Forecast Cards',
            fontSize: SizeConfig.responsive(mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: SizeConfig.scaleHeight(1.5)),
          _buildTabs(),
          SizedBox(height: SizeConfig.scaleHeight(1.5)),
          _buildForecastCards(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    if (SizeConfig.isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.lands.map((land) {
            final isSelected = land == widget.selectedLand;
            return GestureDetector(
              onTap: () {
                if (widget.onLandChanged != null) {
                  widget.onLandChanged!(land);
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: SizeConfig.scaleWidth(1)),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                  vertical: SizeConfig.responsive(mobile: 0.8, tablet: 1, desktop: 1.2),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.lightPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.getResponsiveBorderRadius(mobile: 0.8),
                  ),
                ),
                child: CustomText(
                  land,
                  fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.grey600,
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Row(
        children: widget.lands.map((land) {
          final isSelected = land == widget.selectedLand;
          return GestureDetector(
            onTap: () {
              if (widget.onLandChanged != null) {
                widget.onLandChanged!(land);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.scaleWidth(1)),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
                vertical: SizeConfig.responsive(mobile: 0.8, tablet: 1, desktop: 1.2),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  SizeConfig.getResponsiveBorderRadius(mobile: 0.8),
                ),
              ),
              child: CustomText(
                land,
                fontSize: SizeConfig.responsive(mobile: 12, tablet: 14, desktop: 16),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.grey600,
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildForecastCards() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.scaleHeight(50),
      ),
      child: RawScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        interactive: true,
        thickness: SizeConfig.responsive(mobile: 4, tablet: 5, desktop: 6),
        radius: Radius.circular(
          SizeConfig.responsive(mobile: 2, tablet: 2.5, desktop: 3),
        ),
        thumbColor: AppColors.grey400,
        trackColor: AppColors.grey200.withOpacity(0.3),
        minThumbLength: 50,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Row(
            children: widget.forecasts.map((forecast) {
              return Container(
                width: SizeConfig.isMobile 
                    ? SizeConfig.scaleWidth(35)
                    : SizeConfig.isTablet
                        ? SizeConfig.scaleWidth(20)
                        : SizeConfig.scaleWidth(18),
                margin: EdgeInsets.only(
                  right: forecast != widget.forecasts.last 
                      ? SizeConfig.scaleWidth(1.5) 
                      : 0,
                ),
                child: ForecastCard(forecast: forecast),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

