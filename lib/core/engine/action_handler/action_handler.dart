import 'dart:convert';
import 'package:Qdrive/app/configurations/base_api_url.dart';
import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:Qdrive/app/provider/app_settings_provider.dart';
import 'package:Qdrive/app/theme/provider/app_theme_provider.dart';
import 'package:Qdrive/app/configurations/app_config.dart';
import 'package:Qdrive/core/engine/action_handler/providers/visual_search.dart';
import 'package:Qdrive/core/engine/providers/inspection_provider.dart.dart';
import 'package:Qdrive/core/engine/renderer/element_renderer.dart';
import 'package:Qdrive/core/engine/resolver/json_resolver.dart';
import 'package:Qdrive/core/features/checkout/presentation/widgets/checkout_price_detail_sheet.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_step_provider.dart';
import 'package:Qdrive/app/form/form_value_store.dart';
import 'package:Qdrive/core/shared/widgets/bottom_sheet.dart';
import 'package:Qdrive/core/utils/int_value.dart';
import 'package:Qdrive/mock/3d_view_json.dart';
import 'package:Qdrive/mock/account_settings_inner_jsons.dart';
import 'package:Qdrive/mock/active_rental.dart';
import 'package:Qdrive/mock/ai_chat.dart';
import 'package:Qdrive/mock/help_support_json.dart';
import 'package:Qdrive/mock/pre_rental_inspection_dialogs_json.dart';
import 'package:Qdrive/mock/pre_rental_inspection_json.dart';
import 'package:Qdrive/mock/previous_bookings_detail_json.dart';
import 'package:Qdrive/mock/return_vehicle_json.dart';
import 'package:Qdrive/mock/sign_in_json.dart';
import 'package:Qdrive/mock/travel_policy_json.dart';
import 'package:Qdrive/mock/vehicle_list_json.dart';
import 'package:flutter/material.dart';
import 'package:Qdrive/core/engine/screen/screen_builder.dart';
import 'package:Qdrive/mock/blog_detail_json.dart';
import 'package:Qdrive/mock/booking_complete_json.dart';
import 'package:Qdrive/mock/checkout_json.dart';
import 'package:Qdrive/mock/payment_json.dart';
import 'package:Qdrive/mock/upload_document_json.dart';
import 'package:Qdrive/mock/vehicle_detail_json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart' as fp;

/// Handles JSON-driven actions.
///
/// This keeps behaviour outside widgets.
/// Widgets only pass `props['action']` or `item['action']` here.
class ActionHandler {
  static void handle(
    BuildContext context,
    Map<dynamic, dynamic>? action,
  ) async {
    if (action == null) return;

    final type = action['type'];

    print(
      "Handling action of type: $action $type with params: ${action['params']}",
    );

    final aiChatScreen = AppRuntimeConfig.getConfigScreen('aiConciergeChat');
    final aiCameraSearchDialog = AppRuntimeConfig.getConfigDialog(
      'visualSearch',
    );

    final params = Map<dynamic, dynamic>.from(action['params'] ?? {});
    final apiPath = action['api_path'] ?? "";

   
    switch (type) {
      case 'upload_visual_search_media':
  await _uploadVisualSearchMedia(context, params);
  return;

case 'take_visual_search_photo':
  await _takeVisualSearchPhoto(context, params);
  return;
      
      case 'active_rental_tray':
        final trayJson =
            currentScreenJson['content']?['trays']?['activeRentalTray'] ?? {};

        QDriveBottomSheet.openScreen(
          context: context,
          json: trayJson,
          currentScreenJson: currentScreenJson,
        );
        break;

      case 'open_bottom_sheet':
        _openConfigFilterSheet(context, params, currentScreenJson);
        break;


      case 'sign_in_google':
        break;

      case 'navigate':
        _handleNavigate(context, apiPath);
        break;

      case 'api_call':
        _handleApiCall(
          context: context,
          apiPath: params['apiPath'] ?? params['api_path'],
          apiPathType:
              params['apiPathType'] ??
              params['api_path_type'] ??
              params['method'],
          apiPathData:
              params['apiPathData'] ??
              params['api_path_data'] ??
              params['body'] ??
              params['data'],
          apiAction: params['apiAction'] ?? 'navigate',
        );
        break;

      case 'save_form':
        final message =
            action['message']?.toString() ?? 'Form saved successfully.';

        final formState = Form.maybeOf(context);

        if (formState != null) {
          final isValid = formState.validate();

          if (!isValid) {
            _showToast(
              context,
              'Please complete all required account details.',
            );
            return;
          }

          formState.save();
        }

        final values = JsonFormValueStore.values;

        debugPrint(
          '================ PERSONAL INFORMATION FORM VALUES ================',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(values));
        debugPrint(
          '=================================================================',
        );
        final baseApiPathData =
            params['apiPathData'] ??
            params['api_path_data'] ??
            params['body'] ??
            params['data'] ??
            <String, dynamic>{};

        final apiPathData = <String, dynamic>{
          if (baseApiPathData is Map)
            ...Map<dynamic, dynamic>.from(baseApiPathData),
          ...values,
        };
        // ADD THIS
        await _applyAppPreferenceChangesIfNeeded(
          context: context,
          decoded: apiPathData,
        );
        await _handleApiCall(
          context: context,
          apiPath: params['apiPath'] ?? params['api_path'],
          apiPathType:
              params['apiPathType'] ??
              params['api_path_type'] ??
              params['method'],
          apiPathData: apiPathData,
          apiAction: params['apiAction'] ?? 'navigate',
        );
        formState?.reset();
        JsonFormValueStore.clear();
        _showToast(context, message);

        break;

      case 'sign_in':
        final formState = Form.maybeOf(context);

        if (formState != null) {
          final isValid = formState.validate();

          if (!isValid) {
            _showToast(
              context,
              'Please complete all required account details.',
            );
            return;
          }

          formState.save();
        }

        final values = JsonFormValueStore.values;

        debugPrint(
          '================ PERSONAL INFORMATION FORM VALUES ================',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(values));
        debugPrint(
          '=================================================================',
        );
        final baseApiPathData =
            params['apiPathData'] ??
            params['api_path_data'] ??
            params['body'] ??
            params['data'] ??
            <String, dynamic>{};

        final apiPathData = <String, dynamic>{
          if (baseApiPathData is Map)
            ...Map<dynamic, dynamic>.from(baseApiPathData),
          ...values,
        };
        //  await _handleApiCall(
        //   context: context,
        //   apiPath: params['apiPath'] ?? params['api_path'],
        //   apiPathType:
        //       params['apiPathType'] ??
        //       params['api_path_type'] ??
        //       params['method'],
        //   apiPathData: apiPathData,
        //   apiAction: params['apiAction'] ?? 'navigate',
        // );
        formState?.reset();
        JsonFormValueStore.clear();

        break;

      case 'continue_create_account':
        final formState = Form.maybeOf(context);

        if (formState != null) {
          final isValid = formState.validate();

          if (!isValid) {
            _showToast(
              context,
              'Please complete all required account details.',
            );
            return;
          }

          formState.save();
        }

        final values = JsonFormValueStore.values;

        debugPrint(
          '================ PERSONAL INFORMATION FORM VALUES ================',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(values));
        debugPrint(
          '=================================================================',
        );
        final baseApiPathData =
            params['apiPathData'] ??
            params['api_path_data'] ??
            params['body'] ??
            params['data'] ??
            <String, dynamic>{};

        final apiPathData = <String, dynamic>{
          if (baseApiPathData is Map)
            ...Map<dynamic, dynamic>.from(baseApiPathData),
          ...values,
        };
        //  await _handleApiCall(
        //   context: context,
        //   apiPath: params['apiPath'] ?? params['api_path'],
        //   apiPathType:
        //       params['apiPathType'] ??
        //       params['api_path_type'] ??
        //       params['method'],
        //   apiPathData: apiPathData,
        //   apiAction: params['apiAction'] ?? 'navigate',
        // );
        _continueCreateAccount(context, params);
        formState?.reset();
        JsonFormValueStore.clear();
        break;

      case 'go_back':
        Navigator.of(context).maybePop();
        break;

      case 'open_booking_complete':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: bookingCompleteJson),
          ),
        );
        break;

      // ActionHandler switch
      case 'open_vehicle_filter_sheet':
        _openConfigFilterSheet(context, params, currentScreenJson);
        break;

      case 'apply_vehicle_filters':
        print("Applying vehicle filters with params: $params");
        await _handleApiCall(
          context: context,
          apiPath: params['apiPath'],
          apiPathType: params['apiPathType'],
          apiPathData: params['apiPathData'],
          apiAction: params['apiAction'],
        );
        Navigator.of(context).maybePop();
        break;

      case 'open_upload_documents':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: uploadDocumentsJson),
          ),
        );
        break;

      case 'open_vehicle_list':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: vehicleListJson),
          ),
        );
        return;

      case 'open_vehicle_detail_v2':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: vehicleDetailJsonV2),
          ),
        );
        return;

      case 'open_confirmation_tray':
        QDriveBottomSheet.openScreen(
          context: context,
          json: preRentalConfirmationDialogJson,
        );
        break;

      case 'open_condition_tray':
      case 'open_conditions_tray':
        QDriveBottomSheet.openScreen(
          context: context,
          json: preRentalConditionsDialogJson,
        );
        break;

      case 'open_receipt_tray':
        QDriveBottomSheet.openScreen(
          context: context,
          json: preRentalReceiptDialogJson,
        );
        break;

      case 'ai_camera_search':
        _openJsonDialog(context, aiCameraSearchDialog ?? {});
        break;

      case 'open_cancellation_tray':
        QDriveBottomSheet.openScreen(
          context: context,
          json: preRentalCancellationDialogJson,
        );
        break;

      case 'print_booking_confirmation':
        _showToast(context, 'Print action ready for booking voucher.');
        return;

      case 'download_booking_confirmation_pdf':
        _showToast(context, 'Booking confirmation PDF download started.');
        return;

      case 'keep_pre_rental_booking':
        Navigator.of(context, rootNavigator: true).maybePop();
        return;

      case 'confirm_pre_rental_cancellation':
        final navigator = Navigator.of(context, rootNavigator: true);
        final overlay = navigator.overlay;

        navigator.maybePop();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (overlay == null || !overlay.mounted) return;

          _showToastOnOverlay(
            overlay,
            'Cancellation submitted. Refund will follow supplier rules (demo).',
          );
        });

        return;

      case 'blog_reading':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: qdriveBlogDetailJson),
          ),
        );
        break;

      case 'related_posts_reading':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: qdriveBlogDetailJson),
          ),
        );
        break;

      case 'open_home':
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: AppRuntimeConfig.homeApiResponse),
          ),
          (route) => false,
        );
        break;

      case 'open_payment':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ScreenBuilder(json: paymentJson)),
        );
        break;

      case 'open_checkout':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ScreenBuilder(json: checkoutJson)),
        );
        break;

      case '3D_view':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: vehicleVirtualTourJson),
          ),
        );
        break;

      case 'ai_chat':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: aiConciergeChatJson),
          ),
        );
        break;

      case 'open_active_rental':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: activeRentalPageJson),
          ),
        );
        break;

      case 'open_vehicle_list_tray':
        QDriveBottomSheet.openScreen(context: context, json: vehicleListJson);

        break;

      case 'open_vehicle_detail':
        debugPrint('Open vehicle detail: ${params['vehicleId']}');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: vehicleDetailJson),
          ),
        );
        break;

      case 'prepare_return':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: returnVehicleJson),
          ),
        );
        break;

      case 'take_return_photos':
        final container = ProviderScope.containerOf(context, listen: false);
        final current = container.read(returnVehicleUiProvider);

        container.read(returnVehicleUiProvider.notifier).state = current
            .copyWith(photosUploaded: true);

        return;

      case 'submit_return_review':
        final rating = params['rating'];
        final reviewText = params['reviewText'];

        debugPrint('Return review submitted');
        debugPrint('Rating: $rating');
        debugPrint('Review: $reviewText');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Review submitted')));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: AppRuntimeConfig.homeApiResponse),
          ),
        );
        return;

      case 'mark_return_inspected_demo':
        final container = ProviderScope.containerOf(context, listen: false);
        final current = container.read(returnVehicleUiProvider);

        container.read(returnVehicleUiProvider.notifier).state = current
            .copyWith(photosUploaded: true, inspectionComplete: true);

        return;

      case 'go_home':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: AppRuntimeConfig.homeApiResponse),
          ),
        );
        break;

      case 'close':
        debugPrint('closing');
        Navigator.of(context).maybePop();
        break;
      case 'close_menu':
        debugPrint('closing');
        Navigator.of(context).maybePop();
        break;

      case 'open_ai_search':
      case 'open_ai_screen':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: aiChatScreen ?? {}),
          ),
        );
        break;

      case 'open_date_picker':
        _openDatePicker(context, params);
        break;

      case 'open_sort_sheet':
        _openSortSheet(context, params);
        break;

      case 'sort_button':
        _handleSortButton(context, action);
        break;

      case 'checkout_next_step':
        final params = Map<dynamic, dynamic>.from(action['params'] ?? {});
        final totalSteps = intValue(params['totalSteps'], 6);
        final finalRoute = params['finalRoute']?.toString();

        final container = ProviderScope.containerOf(context, listen: false);
        final currentStep = container.read(checkoutStepProvider);

        if (currentStep >= totalSteps) {
          if (finalRoute == 'payment' || finalRoute == 'open_payment') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ScreenBuilder(json: paymentJson),
              ),
            );
            return;
          }

          if (finalRoute != null && finalRoute.isNotEmpty) {
            Navigator.pushNamed(context, finalRoute);
          }

          return;
        }

        container.read(checkoutStepProvider.notifier).state = currentStep + 1;
        return;

      case 'checkout_previous_step':
        final container = ProviderScope.containerOf(context, listen: false);
        final currentStep = container.read(checkoutStepProvider);

        if (currentStep > 1) {
          container.read(checkoutStepProvider.notifier).state = currentStep - 1;
        } else {
          Navigator.maybePop(context);
        }
        return;

      case 'select_checkout_option':
        _selectCheckoutOption(context, params);
        break;

      case 'select_payment_method':
        _selectPaymentMethod(context, params);
        break;

      case 'select_payment_provider':
        _selectPaymentProvider(context, params);
        break;

      case 'confirm_payment':
        _confirmPayment(context, params);
        break;

      case 'increase_extra':
        _increaseExtra(context, params);
        break;

      case 'decrease_extra':
        _decreaseExtra(context, params);
        break;

      case 'open_chat':
        _openChat(context, params);
        break;

      case 'open_3d_view':
        _open3DView(context, params);
        break;

      case 'dismiss_widget':
        _dismissWidget(params);
        break;

      case 'take_document_photo':
        _takeDocumentPhoto(context, params);
        break;

      case 'upload_document':
        _uploadDocument(context, params);
        break;

      case 'call_support':
      case 'call_phone':
        _callSupport(context, params);
        break;

      case 'find_station':
        _findStation(context, params);
        break;

      case 'report_issue':
        _reportIssue(context, params);
        break;

      case 'extend_rental':
        _extendRental(context, params);
        break;

      case 'call_ai_agent':
        _callAiAgent(context, params);
        break;

      case 'request_callback':
        _requestCallback(context, params);
        break;

      case 'send_support_message':
        _sendSupportMessage(context, params);
        break;

      case 'open_sign_in':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ScreenBuilder(json: signInJson)),
        );
        break;

      case 'prepare_return':
        _prepareReturn(context, params);
        break;

      case 'open_checkout_price_details':
        final params = Map<dynamic, dynamic>.from(action['params'] ?? {});

        final sheetData = params['data'] is Map
            ? Map<dynamic, dynamic>.from(params['data'])
            : <String, dynamic>{
                "title": "Price details",
                "subtitle": "Summary by step and line-item amounts.",
                "summary": [],
                "amounts": [],
                "totalLabel": "Total",
                "total": 0,
                "currency": "GBP",
              };

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return CheckoutPriceDetailsSheet(data: sheetData);
          },
        );
        return;

      case 'open_car_travel_policy':
        _openCarTravelPolicySheet(context, params);
        break;

      case 'show_policy_detail_snackbar':
        _showPolicyDetailSnackBar(context, params);
        break;

      case 'view_booking':
        _openJsonDialog(context, previousBookingDetailDialogJson);

        //  Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => ScreenBuilder(json: previousBookingDetailDialogJson),
        //   ),
        // );
        break;

      case 'open_pre_rental':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: preRentalInspectionJson),
          ),
        );
        break;

      case 'book_again':
        debugPrint('Book again: ${params['bookingId']}');
        break;

      case 'download_receipt':
        _showToast(context, "Receipt downloaded successfully.");
        break;

      case 'open_personal_information':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: personalInformationJson),
          ),
        );
        break;

      case 'open_contact_details':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: contactDetailsJson),
          ),
        );
        break;

      case 'open_identity_verification':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: identityVerificationJson),
          ),
        );
        break;

      case 'open_password_devices':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: passwordDevicesJson),
          ),
        );
        break;

      case 'toggle_dark_mode':
        _toggleDarkMode(context, params);
        break;

      case 'open_language_region':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: preferencesJson),
          ),
        );
        break;

      case 'open_notifications':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: preferencesJson),
          ),
        );
        break;

      case 'open_payments':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: paymentsSettingsJson),
          ),
        );
        break;

      case 'open_help_centre':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: helpSupportJson),
          ),
        );
        break;

      case 'open_delete_account':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScreenBuilder(json: accountControlsJson),
          ),
        );
        break;

      case 'sign_out':
        _showToast(context, 'Signing out');

        break;

      case 'save_personal_information':
        final formState = Form.maybeOf(context);

        if (formState != null) {
          final isValid = formState.validate();

          if (!isValid) {
            _showToast(
              context,
              'Please complete all required account details.',
            );
            return;
          }

          formState.save();
        }

        final values = JsonFormValueStore.values;

        debugPrint(
          '================ PERSONAL INFORMATION FORM VALUES ================',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(values));
        debugPrint(
          '=================================================================',
        );

        _handleApiCall(
          context: context,

          apiPath: params['apiPath'] ?? params['api_path'],
          apiPathType:
              params['apiPathType'] ??
              params['api_path_type'] ??
              params['method'],
          apiPathData:
              params['apiPathData'] ??
              params['api_path_data'] ??
              params['body'] ??
              params['data'],
          apiAction: params['apiAction'] ?? 'navigate',
        );

        _showToast(context, 'Personal information saved.');
        break;

      case 'change_profile_photo':
        _showToast(context, 'Photo picker opened.');
        break;

      case 'save_contact_details':
        _showToast(context, 'Contact details saved.');
        break;

      case 'open_government_id':
        _showToast(context, 'Government ID opened.');
        break;

      case 'open_selfie_verification':
        _showToast(context, 'Selfie verification opened.');
        break;

      case 'open_driving_license':
        _showToast(context, 'Driving license opened.');
        break;

      case 'open_change_password':
        _showToast(context, 'Change password opened.');
        break;

      case 'toggle_two_factor':
        _showToast(context, 'Two-factor authentication updated.');
        break;

      case 'open_connected_accounts':
        _showToast(context, 'Connected accounts opened.');
        break;

      case 'open_active_devices':
        _showToast(context, 'Active devices opened.');
        break;

      case 'open_language_selector':
        _showToast(context, 'Language selector opened.');
        break;

      case 'open_currency_selector':
        _showToast(context, 'Currency selector opened.');
        break;

      case 'toggle_theme':
        _toggleDarkMode(context, params);
        break;

      case 'toggle_mobile_preview':
        _showToast(context, 'Mobile preview updated.');
        break;

      case 'toggle_email_notifications':
        _showToast(context, 'Email notifications updated.');
        break;

      case 'toggle_sms_notifications':
        _showToast(context, 'SMS notifications updated.');
        break;

      case 'open_privacy_preferences':
        _showToast(context, 'Privacy preferences opened.');
        break;

      case 'save_preferences':
        _showToast(context, 'Preferences saved.');
        break;

      case 'open_payment_card':
        _showToast(context, 'Payment card opened.');
        break;

      case 'add_payment_method':
        _showToast(context, 'Add payment method opened.');
        break;

      case 'edit_billing_address':
        _showToast(context, 'Billing address opened.');
        break;

      case 'deactivate_account':
        _showToast(context, 'Deactivate account selected.');
        break;

      case 'delete_account':
        _showToast(context, 'Delete account selected.');
        break;

      case 'send_email':
        await _sendEmail(context, params);
        return;

      default:
        debugPrint('Unhandled action type: $type');
    }
  }

  static Future<void> _sendEmail(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) async {
    debugPrint('Send email $params');

    final email =
        (params['email'] ??
                params['to'] ??
                params['recipient'] ??
                params['mail'])
            ?.toString()
            .trim() ??
        '';

    final subject = params['subject']?.toString() ?? '';
    final body = params['body']?.toString() ?? '';

    if (email.isEmpty) {
      _showToast(context, 'Email address is missing.');
      return;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showToast(context, 'Could not open email app.');
      }
    } catch (e) {
      debugPrint('SEND EMAIL ERROR: $e');

      if (context.mounted) {
        _showToast(context, 'Could not open email app.');
      }
    }
  }


static Future<void> _uploadVisualSearchMedia(
  BuildContext context,
  Map<dynamic, dynamic> params,
) async {
  try {
    final result = await fp.FilePicker.pickFiles(
      type: fp.FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'mp4',
      ],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      debugPrint('VISUAL SEARCH MEDIA CANCELLED');
      return;
    }

    final file = result.files.single;

    debugPrint('================ VISUAL SEARCH MEDIA ================');
    debugPrint('File name: ${file.name}');
    debugPrint('File path: ${file.path}');
    debugPrint('File size: ${file.size}');
    debugPrint('=====================================================');

    final container = ProviderScope.containerOf(
      context,
      listen: false,
    );

    container.read(visualSearchMediaProvider.notifier).state =
        VisualSearchMediaState(
      fileName: file.name,
      filePath: file.path,
      mediaType: file.extension,
      fromCamera: false,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${file.name}'),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('VISUAL SEARCH MEDIA ERROR: $e');
    debugPrint('STACKTRACE: $stackTrace');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open media picker'),
      ),
    );
  }
}


static Future<void> _takeVisualSearchPhoto(
  BuildContext context,
  Map<dynamic, dynamic> params,
) async {
  try {
    final picker = ImagePicker();

    final photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (photo == null) {
      debugPrint('VISUAL SEARCH CAMERA CANCELLED');
      return;
    }

    debugPrint('================ VISUAL SEARCH PHOTO ================');
    debugPrint('Photo name: ${photo.name}');
    debugPrint('Photo path: ${photo.path}');
    debugPrint('=====================================================');

    final container = ProviderScope.containerOf(
      context,
      listen: false,
    );

    container.read(visualSearchMediaProvider.notifier).state =
        VisualSearchMediaState(
      fileName: photo.name,
      filePath: photo.path,
      mediaType: 'image',
      fromCamera: true,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo captured for visual search'),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('VISUAL SEARCH CAMERA ERROR: $e');
    debugPrint('STACKTRACE: $stackTrace');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open camera'),
      ),
    );
  }
}

  static void _openConfigFilterSheet(
    BuildContext context,
    Map<dynamic, dynamic> params,
    Map<dynamic, dynamic> currentScreenJson, [
    Map<dynamic, dynamic>? apiResponse,
  ]) {
    debugPrint('Open bottom sheet with params: $params');

    Map<dynamic, dynamic>? trayJson;

    // 1. API response wins.
    // If decoded API response is a tray/sheet JSON, use it directly.
    if (apiResponse != null && apiResponse.isNotEmpty) {
      trayJson = Map<dynamic, dynamic>.from(apiResponse);
    }

    // 2. Previous logic still works.
    // If no API response was given, resolve tray from current screen or app config.
    if (trayJson == null) {
      final trayKey = params['trayKey']?.toString() ?? 'vehicleFilterSheet';

      final screenTray = currentScreenJson['content']?['trays']?[trayKey];

      if (screenTray is Map) {
        trayJson = Map<dynamic, dynamic>.from(screenTray);
      } else {
        final configTray = AppRuntimeConfig.getConfigTray(trayKey);

        print("configurations:: $configTray");

        if (configTray is Map) {
          trayJson = Map<dynamic, dynamic>.from(configTray);
        }
      }

      if (trayJson == null) {
        debugPrint('BOTTOM SHEET ERROR: tray not found: $trayKey');
        return;
      }
    }

    if (trayJson.isEmpty) {
      debugPrint('BOTTOM SHEET ERROR: empty tray json');
      return;
    }

    // Dialog-style trays have title/body/maxHeightFactor.
    if (trayJson['body'] is Map) {
      QDriveBottomSheet.openScreen(
        context: context,
        json: trayJson,
        currentScreenJson: currentScreenJson,
      );
      return;
    }

    final resolvedJson = JsonResolver.resolve(context,
      Map<dynamic, dynamic>.from(trayJson),
    );

    final ui = Map<dynamic, dynamic>.from(resolvedJson['ui'] ?? {});
    final layout = List<Map<dynamic, dynamic>>.from(ui['layout'] ?? []);

    if (layout.isEmpty) {
      debugPrint('BOTTOM SHEET ERROR: empty layout');
      return;
    }

    final sheetItem = layout.first;

    final fullscreen =
        trayJson?['fullscreen'] == true ||
        trayJson?['fullscreen']?.toString() == 'true' ||
        ui['fullscreen'] == true ||
        ui['fullscreen']?.toString() == 'true';

    debugPrint('BOTTOM SHEET FULLSCREEN: $fullscreen');
    debugPrint('TRAY KEYS: ${trayJson?.keys.toList()}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (sheetContext) {
        final hasFixedHeight = trayJson?['maxHeightFactor'] is num;
        final scrollable = trayJson?['scrollable'] == true;

        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;

        final sheetBackground = isDark
            ? const Color(0xFF151515)
            : const Color(0xFFFFFFFF);

        final sheetContent = ElementRenderer(data: sheetItem);

        final isVehicleFilterSheet =
            sheetItem['type'] == 'vehicle_filter_sheet';
        if (fullscreen) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(sheetContext).size.height,
            child: Container(
              color: sheetBackground,
              child: SafeArea(top: true, bottom: false, child: sheetContent),
            ),
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.95,
              ),
              color: sheetBackground,
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  mainAxisSize: hasFixedHeight
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Column(
                        children: [
                          Container(
                            width: 54,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trayJson?['title']?.toString() ?? '',
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.of(sheetContext).pop(),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey.withOpacity(0.45)
                                        : const Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? Colors.white.withOpacity(0.10)
                          : Colors.black.withOpacity(0.08),
                    ),
                    if (hasFixedHeight)
                      Expanded(
                        child: scrollable
                            ? SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                child: sheetContent,
                              )
                            : sheetContent,
                      )
                    else
                      Flexible(
                        child: scrollable
                            ? SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                child: sheetContent,
                              )
                            : sheetContent,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _toggleDarkMode(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    final container = ProviderScope.containerOf(context, listen: false);
    final currentMode = container.read(appThemeModeProvider);

    container.read(appThemeModeProvider.notifier).state =
        currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    _showToast(
      context,
      currentMode == ThemeMode.dark
          ? 'Light mode enabled.'
          : 'Dark mode enabled.',
    );
  }

  static void _continueCreateAccount(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Continue create account');

    final formState = Form.maybeOf(context);

    if (formState != null) {
      final isValid = formState.validate();

      if (!isValid) {
        _showToast(context, 'Please complete all required account details.');
        return;
      }

      formState.save();
    }

    _showToast(context, 'Account details accepted.');
  }

  static void _signIn(BuildContext context, Map<dynamic, dynamic> params) {
    debugPrint('Sign in');

    final formState = Form.maybeOf(context);

    if (formState != null) {
      final isValid = formState.validate();

      if (!isValid) {
        _showToast(context, 'Please enter your email and password.');
        return;
      }

      formState.save();
    }

    _showToast(context, 'Signing in...');
  }

  static void _openCheckoutPriceDetails(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    final priceDetails = Map<dynamic, dynamic>.from(
      checkoutJson['dynamicData']?['checkout']?['fallback']?['priceDetails'] ??
          {},
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return CheckoutPriceDetailsSheet(data: priceDetails);
      },
    );
  }

  static void _openJsonDialog(
    BuildContext context,
    Map<dynamic, dynamic> dialogJson,
  ) {
    final title = dialogJson['title']?.toString() ?? '';

    final body = dialogJson['body'] is Map
        ? Map<dynamic, dynamic>.from(dialogJson['body'])
        : <String, dynamic>{};

    showDialog(
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        final backgroundColor = isDark
            ? const Color(0xFF050505)
            : const Color(0xFFFFFFFF);

        final borderColor = isDark
            ? const Color(0xFF242424)
            : const Color(0xFFE5E5E5);

        final titleColor = isDark
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF111111);

        final mutedColor = isDark
            ? const Color(0xFF9CA3AF)
            : const Color(0xFF6B7280);

        final buttonBackground = isDark
            ? const Color(0xFF171717)
            : const Color(0xFFF3F4F6);

        final bodyWidget = body.isEmpty
            ? const SizedBox.shrink()
            : ElementRenderer(data: body);

        return Material(
          color: backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(bottom: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).maybePop();
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: buttonBackground,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: titleColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dialogJson['subtitle']?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                    child: bodyWidget,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showToast(BuildContext context, String message) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);

    if (overlay == null || !overlay.mounted) return;

    _showToastOnOverlay(overlay, message);
  }

  static void _showToastOnOverlay(OverlayState overlay, String message) {
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(overlayContext).padding.bottom + 26,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 18, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  static void _openCarTravelPolicySheet(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    final resolvedJson = JsonResolver.resolve(context,carTravelPolicySheetJson);

    final ui = Map<dynamic, dynamic>.from(resolvedJson['ui'] ?? {});
    final layout = List<Map<dynamic, dynamic>>.from(ui['layout'] ?? []);

    if (layout.isEmpty) return;

    final sheetItem = layout.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return ElementRenderer(data: sheetItem);
      },
    );
  }

  static void _showPolicyDetailSnackBar(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    final message =
        params['message']?.toString() ??
        'This rule is set in your company travel policy.';

    final overlay = Overlay.of(context, rootOverlay: true);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(overlayContext).padding.bottom + 16,
          child: Material(
            color: Colors.transparent,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  static Future<void> _callSupport(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) async {
    debugPrint('Call support $params');

    final rawPhone =
        params['phone'] ??
        params['phoneNumber'] ??
        params['mobile'] ??
        params['number'];

    final phone = rawPhone?.toString().trim() ?? '';

    if (phone.isEmpty) {
      _showToast(context, 'Support phone number is missing.');
      return;
    }

    // Keep international + sign, remove spaces, brackets and hyphens.
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final uri = Uri.parse('tel:$cleanPhone');

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showToast(context, 'Could not open phone dialer.');
      }
    } catch (e) {
      debugPrint('CALL SUPPORT ERROR: $e');

      if (context.mounted) {
        _showToast(context, 'Could not open phone dialer.');
      }
    }
  }

  static Future<void> _findStation(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) async {
    debugPrint('Find nearest station');

    final query = params['query']?.toString().trim();

    final mapsQuery = query == null || query.isEmpty
        ? 'nearest station'
        : query;

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': mapsQuery,
    });

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      debugPrint('GOOGLE MAPS ERROR: Could not launch $uri');
    }
  }

  static void _reportIssue(BuildContext context, Map<dynamic, dynamic> params) {
    debugPrint('Report rental issue');

    Navigator.of(context).pushNamed('report_issue', arguments: params);
  }

  static void _extendRental(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Extend rental');

    Navigator.of(context).pushNamed('extend_rental', arguments: params);
  }

  static void _callAiAgent(BuildContext context, Map<dynamic, dynamic> params) {
    debugPrint('Call AI Agent');
    // Later: start AI voice call / tel link
  }

  static void _requestCallback(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Request callback');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Callback requested')));
  }

  static void _sendSupportMessage(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Send support message');

    final formState = Form.maybeOf(context);

    if (formState != null) {
      final isValid = formState.validate();

      if (!isValid) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF343434)),
            ),
            duration: const Duration(seconds: 3),
            content: const Row(
              children: [
                Icon(Icons.error_outline, size: 18, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Please complete the required fields before sending.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return;
      }

      formState.save();
    }

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF343434)),
        ),
        duration: const Duration(seconds: 3),
        content: const Row(
          children: [
            Icon(Icons.check_circle, size: 18, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Message sent! Our support team will contact you within 24 hours.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _prepareReturn(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Prepare for return');

    Navigator.of(context).pushNamed('prepare_return', arguments: params);
  }

  static void _handleNavigate(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    final route = params['route'];

    if (route is! String) return;

    Navigator.of(context).pushNamed(route, arguments: params);
  }

  static void _openAiSearch(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Open AI Search');
  }

  static void _openDatePicker(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Open date picker: ${params['mode']}');
  }

  static void _openSortSheet(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Open sort sheet');
  }

  static void _handleSortButton(
    BuildContext context,
    Map<dynamic, dynamic> action,
  ) {
    final label = action['label'];
    final options = List<String>.from(action['options'] ?? []);
    final nestedAction = action['action'];

    debugPrint('Sort button: $label');
    debugPrint('Sort options: $options');

    if (nestedAction is Map<dynamic, dynamic>) {
      handle(context, nestedAction);
    }
  }

  static void _takeDocumentPhoto(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Take document photo: ${params['documentType']}');
  }

  static void _uploadDocument(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Upload document: ${params['documentType']}');
  }

  static void _openChat(BuildContext context, Map<dynamic, dynamic> params) {
    debugPrint('Open chat');
  }

  static void _open3DView(BuildContext context, Map<dynamic, dynamic> params) {
    debugPrint('Open 3D view for vehicle: ${params['vehicleId']}');
  }

  static void _dismissWidget(Map<dynamic, dynamic> params) {
    final target = params['target'];

    if (target is String) {
      debugPrint('Dismiss widget: $target');
    }
  }

  static void _checkoutNextStep(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Checkout next step');
    debugPrint('Params: $params');

    // Later connect with Riverpod:
    // ref.read(checkoutProvider.notifier).nextStep();
  }

  static void _checkoutPreviousStep(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Checkout previous step');
    debugPrint('Params: $params');

    // Later connect with Riverpod:
    // ref.read(checkoutProvider.notifier).previousStep();
  }

  static void _selectCheckoutOption(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Select checkout option');
    debugPrint('Key: ${params['key']}');
    debugPrint('Value: ${params['value']}');

    // Later connect with Riverpod:
    // ref.read(checkoutProvider.notifier).setValue(params['key'], params['value']);
  }

  static void _selectPaymentMethod(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Select payment method: ${params['paymentId']}');
  }

  static void _selectPaymentProvider(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Select payment provider: ${params['providerId']}');
  }

  static void _confirmPayment(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Confirm payment');
    debugPrint('Booking ID: ${params['bookingId']}');
    debugPrint('Amount: ${params['amount']} ${params['currency']}');
  }

  static void _increaseExtra(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Increase extra: ${params['extraId']}');
  }

  static void _decreaseExtra(
    BuildContext context,
    Map<dynamic, dynamic> params,
  ) {
    debugPrint('Decrease extra: ${params['extraId']}');
  }

  static final Set<String> _runningApiKeys = {};
  static int _apiRequestVersion = 0;

  static Future<void> _handleApiCall({
    required BuildContext context,
    required dynamic apiPath,
    required dynamic apiPathType,
    required dynamic apiPathData,
    required dynamic apiAction,
  }) async {
    final url = _resolveApiUrl(apiPath);
    final method = _resolveApiMethod(apiPathType);
    final data = _resolveApiData(apiPathData);

    final requestKey = '$method:$url:${jsonEncode(data)}';

    if (_runningApiKeys.contains(requestKey)) {
      debugPrint('API SKIPPED: Same API call is already running.');
      return;
    }

    _runningApiKeys.add(requestKey);

    final int currentVersion = ++_apiRequestVersion;

    try {
      debugPrint('================ API CALL START ================');
      debugPrint('RAW apiPath: $apiPath');
      debugPrint('RAW apiPathType: $apiPathType');
      debugPrint('RAW apiPathData: $apiPathData');
      debugPrint('RAW apiAction: $apiAction');

      debugPrint('RESOLVED url: $url');
      debugPrint('RESOLVED method: $method');
      debugPrint('RESOLVED data: ${jsonEncode(data)}');
      debugPrint('REQUEST KEY: $requestKey');
      debugPrint('REQUEST VERSION: $currentVersion');

      if (url.isEmpty) {
        debugPrint('API ERROR: Missing api url. Raw apiPath=$apiPath');
        debugPrint('================ API CALL END WITH ERROR ================');
        return;
      }

      final uri = Uri.parse(baseApiUrl + url);

      debugPrint('FINAL URI: $uri');

      late final http.Response response;

      if (method == 'POST') {
        debugPrint('HTTP METHOD: POST');
        debugPrint('POST BODY: ${data.isEmpty ? 'null' : jsonEncode(data)}');

        response = await http.post(
          uri,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: data.isEmpty ? null : jsonEncode(data),
        );
      } else {
        debugPrint('HTTP METHOD: GET');

        response = await http.get(
          uri,
          headers: const {'Accept': 'application/json'},
        );
      }

      debugPrint('================ API RESPONSE ================');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('BODY LENGTH: ${response.body.length}');
      debugPrint('BODY: ${response.body}');
      debugPrint('=============================================');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          'API ERROR: Request failed with status ${response.statusCode}',
        );
        debugPrint('================ API CALL END WITH ERROR ================');
        return;
      }

      if (response.body.trim().isEmpty) {
        debugPrint('HIVE SKIPPED: empty api response');
        debugPrint('================ API CALL END ================');
        return;
      }

      debugPrint('DECODING API RESPONSE...');

      final decoded = jsonDecode(response.body);

      debugPrint('DECODED TYPE: ${decoded.runtimeType}');

      if (currentVersion != _apiRequestVersion) {
        debugPrint(
          'API RESPONSE IGNORED: newer API call already started. '
          'currentVersion=$currentVersion latestVersion=$_apiRequestVersion',
        );
        return;
      }

      await AppRuntimeConfig.cacheApiJsonWithMeta(decoded);

      await _handleApiActionAfterSuccess(
        context: context,
        apiAction: apiAction,
        decoded: decoded,
      );

      debugPrint('================ API CALL END SUCCESS ================');
    } catch (e, stackTrace) {
      debugPrint('================ API ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('===========================================');
    } finally {
      _runningApiKeys.remove(requestKey);
    }
  }

  static Future<void> _handleApiActionAfterSuccess({
    required BuildContext context,
    required dynamic apiAction,
    required dynamic decoded,
  }) async {
    final actionType = _resolveApiActionType(apiAction);

    debugPrint('RESOLVED apiAction type: $actionType $decoded');

    if (actionType == 'open_bottom_sheet') {
      final params = apiAction is Map
          ? Map<dynamic, dynamic>.from(apiAction['params'] ?? {})
          : <dynamic, dynamic>{};

      _openConfigFilterSheet(
        context,
        params,
        currentScreenJson,
        decoded is Map ? Map<dynamic, dynamic>.from(decoded) : null,
      );

      return;
    }

    if (actionType != 'navigate' && actionType != 'navigate_replace') {
      debugPrint('API ACTION SKIPPED: not navigate or navigate_replace');
      return;
    }

    final newScreenJson = _resolveApiActionScreenJson(
      apiAction: apiAction,
      decoded: decoded,
    );

    if (newScreenJson == null) {
      debugPrint(
        'NAVIGATION SKIPPED: API response does not contain valid screen json',
      );
      return;
    }

    if (!context.mounted) {
      debugPrint('NAVIGATION SKIPPED: context is no longer mounted');
      return;
    }

    debugPrint('NAVIGATING TO API SCREEN: ${newScreenJson['screen']}');

    final route = MaterialPageRoute(
      builder: (_) => ScreenBuilder(json: newScreenJson),
    );

    if (actionType == 'navigate_replace') {
      await Navigator.of(context).pushReplacement(route);
      return;
    }

    await Navigator.of(context).push(route);
  }

  static String _resolveApiActionType(dynamic apiAction) {
    if (apiAction == null) return '';

    if (apiAction is String) {
      return apiAction.trim();
    }

    if (apiAction is Map) {
      final map = Map<String, dynamic>.from(apiAction);
      return map['type']?.toString().trim() ?? '';
    }

    return '';
  }

  static Map<String, dynamic>? _resolveApiActionScreenJson({
    required dynamic apiAction,
    required dynamic decoded,
  }) {
    if (decoded is! Map) return null;

    final decodedMap = Map<String, dynamic>.from(decoded);

    final actionMap = apiAction is Map
        ? Map<String, dynamic>.from(apiAction)
        : <String, dynamic>{};

    final screenJsonKey = actionMap['screenJsonKey']?.toString();

    if (screenJsonKey != null &&
        screenJsonKey.isNotEmpty &&
        decodedMap[screenJsonKey] is Map) {
      final nestedJson = Map<String, dynamic>.from(decodedMap[screenJsonKey]);

      if (_isScreenJson(nestedJson)) {
        return nestedJson;
      }
    }

    if (_isScreenJson(decodedMap)) {
      return decodedMap;
    }

    if (decodedMap['data'] is Map) {
      final dataJson = Map<String, dynamic>.from(decodedMap['data']);

      if (_isScreenJson(dataJson)) {
        return dataJson;
      }
    }

    if (decodedMap['json'] is Map) {
      final json = Map<String, dynamic>.from(decodedMap['json']);

      if (_isScreenJson(json)) {
        return json;
      }
    }

    if (decodedMap['screenJson'] is Map) {
      final screenJson = Map<String, dynamic>.from(decodedMap['screenJson']);

      if (_isScreenJson(screenJson)) {
        return screenJson;
      }
    }

    return null;
  }

  static bool _isScreenJson(Map<String, dynamic> json) {
    return json['screen'] != null && json['ui'] is Map;
  }

  static String _resolveApiUrl(dynamic apiPath) {
    if (apiPath is String) {
      return apiPath;
    }

    if (apiPath is Map) {
      return apiPath['url']?.toString() ??
          apiPath['path']?.toString() ??
          apiPath['endpoint']?.toString() ??
          '';
    }

    return '';
  }

  static String _resolveApiMethod(dynamic apiPathType) {
    if (apiPathType is String) {
      return apiPathType.toUpperCase();
    }

    if (apiPathType is Map) {
      return apiPathType['method']?.toString().toUpperCase() ??
          apiPathType['type']?.toString().toUpperCase() ??
          'GET';
    }

    return 'GET';
  }

  static Map<dynamic, dynamic> _resolveApiData(dynamic apiPathData) {
    if (apiPathData is Map<dynamic, dynamic>) {
      return apiPathData;
    }

    if (apiPathData is Map) {
      return Map<dynamic, dynamic>.from(apiPathData);
    }

    return {};
  }

  static Future<void> _applyAppPreferenceChangesIfNeeded({
    required BuildContext context,
    required dynamic decoded,
  }) async {
    if (decoded is! Map) return;

    final decodedMap = Map<dynamic, dynamic>.from(decoded);

    final formData = decodedMap['data'] is Map
        ? Map<dynamic, dynamic>.from(decodedMap['data'])
        : decodedMap;

    final hasLanguage = formData.containsKey('language');
    final hasCurrency = formData.containsKey('currency');

    if (!hasLanguage && !hasCurrency) return;

    final container = ProviderScope.containerOf(context, listen: false);

    await container
        .read(appSettingsProvider.notifier)
        .updateFromSavedForm(formData);

    debugPrint('APP SETTINGS UPDATED: $formData');
  }
}
