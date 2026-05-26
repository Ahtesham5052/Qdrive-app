import 'package:Qdrive/core/features/browse/presentation/widgets/filter_sheet.dart';
import 'package:Qdrive/core/shared/widgets/accordion_section.dart';
import 'package:Qdrive/core/shared/widgets/change_trip_notice.dart';
import 'package:Qdrive/core/shared/widgets/customer_review.dart';
import 'package:Qdrive/core/shared/widgets/previous_booking_section.dart';
import 'package:Qdrive/core/shared/widgets/support_chat_box.dart';
import 'package:Qdrive/core/shared/widgets/toggle_button.dart';
import 'package:Qdrive/core/shared/widgets/travel_policy.dart';
import 'package:flutter/material.dart';
import 'package:Qdrive/core/features/blog/presentation/widgets/blog_article.dart';
import 'package:Qdrive/core/features/blog/presentation/widgets/blog_post_list.dart';
import 'package:Qdrive/core/features/blog/presentation/widgets/related_post_list.dart';
import 'package:Qdrive/core/shared/widgets/home_hero.dart';
import 'package:Qdrive/core/features/browse/presentation/widgets/search_panel.dart';

import 'package:Qdrive/core/features/browse/presentation/widgets/list_cards.dart';
import 'package:Qdrive/core/features/browse/presentation/widgets/ai_search_prompt.dart';
import 'package:Qdrive/core/features/browse/presentation/widgets/location_date_selector.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/checkout_flow.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/checkout_header.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/extras_selector_section.dart';
import 'package:Qdrive/core/shared/widgets/option_section.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/payment_method_section.dart';
import 'package:Qdrive/core/features/browse/presentation/widgets/featured_cards.dart';
import 'package:Qdrive/core/shared/widgets/price_breakdown_card.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/protection_package_section.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/qdrive_pass_section.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/rental_period_section.dart';
import 'package:Qdrive/core/shared/widgets/benefit_cards.dart';
import 'package:Qdrive/core/shared/widgets/button_group.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/document_compliance_card.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/document_upload_card.dart';
import 'package:Qdrive/core/shared/widgets/extras_list_section.dart';
import 'package:Qdrive/core/shared/widgets/floating_chat_button.dart';
import 'package:Qdrive/core/shared/widgets/form_sections.dart';
import 'package:Qdrive/core/shared/widgets/info_cards.dart';
import 'package:Qdrive/core/shared/widgets/list_header.dart';
import 'package:Qdrive/core/shared/widgets/active_card.dart';
import 'package:Qdrive/core/shared/widgets/detail_gallery.dart';
import 'package:Qdrive/core/shared/widgets/detail_summary.dart';
import 'package:Qdrive/core/shared/widgets/insight_card.dart';
import 'package:Qdrive/core/shared/widgets/check_list_section.dart';
import 'package:Qdrive/core/features/browse/presentation/widgets/location_card_section.dart';
import 'package:Qdrive/core/shared/widgets/bottom_bar.dart';
import 'package:Qdrive/core/shared/widgets/policy_section.dart';
import 'package:Qdrive/core/shared/widgets/progress_section.dart';
import 'package:Qdrive/core/shared/widgets/tag_chips.dart';
import 'package:Qdrive/core/shared/widgets/text_block.dart';

class ElementRenderer extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const ElementRenderer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    switch (data['type']) {
      case 'active_card':
        return ActiveCard(data: data);

      case 'search_prompt':
        return AiSearchPrompt(data: data);

      case 'support_chat_box':
        return SupportChatBox(data: data);

      case 'location_date_selector':
        return LocationDateSelector(data: data);

      case 'list_header':
        return ListHeader(data: data);

      case 'list_cards':
        return ListCards(data: data);

      case 'floating_action_button':
        return FloatingActionButtonElement(data: data);

      case 'detail_gallery':
        return DetailGallery(data: data);

      case 'detail_summary':
        return DetailSummary(data: data);

      case 'insight_card':
        return InsightCard(data: data);

      case 'document_compliance_card':
        return DocumentComplianceCard(data: data);

      case 'return_review_section':
        return ReturnReviewSection(data: data);

      case 'car_travel_policy_sheet':
        return CarTravelPolicySheet(data: data);

      case 'change_trip_notice':
        return ChangeTripNotice(data: data);

      case 'accordion_section':
        return AccordionSection(data: data);

      case 'qdrive_billing_toggle':
        return QDriveBillingToggle(data: data);

      case 'home_hero':
        return HomeHero(data: data);

      case 'vehicle_filter_sheet':
        return VehicleFilterSheet(data: data);

      case 'home_search_panel':
        return HomeSearchPanel(data: data);

      case 'featured_card':
        return FeaturedCard(data: data);

      case 'blog_post_list':
        return BlogPostList(data: data);

      case 'blog_article':
        return BlogArticle(data: data);

      case 'related_post_list':
        return RelatedPostList(data: data);

      case 'check_list_section':
        return CheckListSection(data: data);

      case 'previous_bookings_section':
        return PreviousBookingsSection(data: data);

      case 'extras_list_section':
        return ExtrasListSection(data: data);

      case 'policy_section':
        return PolicySection(data: data);

      case 'location_card_section':
        return LocationCardSection(data: data);

      case 'bottom_bar':
        return BottomBar(data: data);

      case 'form_section':
        return FormSection(data: data);

      case 'info_card':
        return InfoCard(data: data);

      case 'progress_section':
        return ProgressSection(data: data);

      case 'document_upload_card':
        return DocumentUploadCard(data: data);

      case 'checkout_flow':
        return CheckoutFlow(data: data);

      case 'checkout_header':
        return CheckoutHeader(data: data);

      case 'rental_period_section':
        return RentalPeriodSection(data: data);

      case 'option_section':
        return OptionSection(data: data);

      case 'protection_package_section':
        return ProtectionPackageSection(data: data);

      case 'extras_selector_section':
        return ExtrasSelectorSection(data: data);

      case 'qdrive_pass_section':
        return QdrivePassSection(data: data);

      case 'price_breakdown_card':
        return PriceBreakdownCard(data: data);

      case 'booking_bar':
        return BottomBar(data: data);

      case 'tag_chip':
        return TagChip(data: data);

      case 'text_block':
        return TextBlock(data: data);

      case 'button_group':
        return ButtonGroup(data: data);

      case 'benefit_cards':
        return BenefitCards(data: data);

      case 'payment_method_section':
        return PaymentMethodSection(data: data);

      default:
        return const SizedBox.shrink();
    }
  }
}
