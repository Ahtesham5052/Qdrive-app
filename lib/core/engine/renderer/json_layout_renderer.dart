// ==========================================
// JSON LAYOUT RENDERER
// Core rendering engine for fully dynamic UI
// ==========================================

import 'dart:convert';

import 'package:Qdrive/core/engine/action_handler/providers/visual_search.dart';
import 'package:Qdrive/core/engine/providers/inspection_provider.dart.dart';
import 'package:Qdrive/core/engine/style/dashed_border.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_mileage_provider.dart';
import 'package:Qdrive/app/form/form_value_store.dart';
import 'package:Qdrive/core/shared/providers/ai_chat_provider.dart';
import 'package:Qdrive/core/shared/providers/flight_detail_provider.dart';
import 'package:Qdrive/core/shared/providers/remember_me_provider.dart';
import 'package:Qdrive/core/shared/providers/toggle_provider.dart';
import 'package:Qdrive/core/shared/providers/virtual_tour_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_extras_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_option_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_payment_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_protection_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_qdrive_pass_provider.dart';
import 'package:Qdrive/core/shared/widgets/image_slider.dart';
import 'package:Qdrive/core/shared/widgets/radio_dot.dart';
import 'package:Qdrive/core/utils/currency.dart';

class JsonLayoutRenderer extends ConsumerWidget {
  // ==========================================
  // Current node being rendered
  // ==========================================

  final Map<dynamic, dynamic> node;

  // ==========================================
  // Main data object
  // Example:
  // vehicle, blog post, checkout section, option data
  // ==========================================

  final Map<dynamic, dynamic> data;

  // ==========================================
  // Shared theme object
  // ==========================================

  final Map<dynamic, dynamic> theme;

  // ==========================================
  // Shared config object
  // ==========================================

  final Map<dynamic, dynamic> config;

  // ==========================================
  // Shared currency
  // ==========================================

  final String currency;

  // ==========================================
  // Local loop variables
  // Example:
  // option.title
  // tag.label
  // slot.time
  // ==========================================

  final Map<dynamic, dynamic> locals;

  const JsonLayoutRenderer({
    super.key,
    required this.node,
    required this.data,
    required this.theme,
    required this.config,
    required this.currency,
    this.locals = const {},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================
    // Visibility condition support
    // ========================================

    if (!_isVisible(ref)) {
      return const SizedBox.shrink();
    }

    // ========================================
    // Positioned must return directly.
    // Wrapping it breaks Stack parent data.
    // ========================================

    if (node['type'] == 'positioned') {
      return _positioned(context);
    }

    // ========================================
    // Build actual node
    // ========================================

    final child = _buildNode(context, ref);

    // ========================================
    // Apply node spacing utility classes
    // ========================================

    return _applyNodeClasses(context, child);
  }

  // ==========================================
  // Main node router
  // ==========================================

  Widget _buildNode(BuildContext context, WidgetRef ref) {
    final type = node['type'];

    final builders = <String, Widget Function()>{
      // ======================================
      // Layout primitives
      // ======================================
      'container': () => _container(context),
      'row': () => _row(context),
      'column': () => _column(context),
      'wrap': () => _wrap(context),
      'stack': () => _stack(context),
      'align': () => _align(context),
      'for_each': () => _forEach(context, ref),
      'horizontal_scroll': () => _horizontalScroll(context),
      'expanded': () => _expanded(context),
      'checkbox_toggle': () => _checkboxToggle(context, ref),
      'switch_button': () => _switchButton(context, ref),

      'visual_search_upload_status': () =>
    _visualSearchUploadStatus(context, ref),

      'support_chat_box': () => _supportChatBox(context, ref),

      'ai_chat_suggestions': () => _aiChatSuggestions(context, ref),
      'ai_chat_messages': () => _aiChatMessages(context, ref),
      'ai_chat_input': () => _aiChatInput(context, ref),

      // ======================================
      // Content primitives
      // ======================================
      'text': () => _text(context),
      'icon': () => _icon(context),
      'chip': () => _chip(context),
      'image_slider': () => _imageSlider(context),
      'image': () => _image(context),
      'divider': () => _divider(context),

      'rating': () => _rating(context),
      'price_box': () => _priceBox(context),

      // ======================================
      // Checkout option helpers
      // These keep action/state logic inside renderer
      // while the visual layout stays JSON-driven.
      // ======================================
      'option_tile': () => _optionTile(context, ref),
      'option_radio': () => _optionRadio(context),
      'calculate_distance_button': () => _calculateDistanceButton(context, ref),
      'time_slot': () => _timeSlot(context, ref),

      'protection_tile': () => _protectionTile(context, ref),
      'protection_radio': () => _protectionRadio(context),
      'protection_toggle_coverage': () =>
          _protectionToggleCoverage(context, ref),
      'protection_expand_icon': () => _protectionExpandIcon(context),

      'extra_quantity_button': () => _extraQuantityButton(context, ref),

      'qdrive_pass_plan_tile': () => _qdrivePassPlanTile(context, ref),
      'qdrive_pass_coverage_toggle': () =>
          _qdrivePassCoverageToggle(context, ref),
      'qdrive_pass_coverage_panel': () =>
          _qdrivePassCoveragePanel(context, ref),
      'qdrive_pass_expand_icon': () => _qdrivePassExpandIcon(context),
      'qdrive_pass_remove_button': () => _qdrivePassRemoveButton(context, ref),

      'payment_option_list': () => _paymentOptionList(context, ref),
      'payment_method_tile': () => _paymentMethodTile(context, ref),
      'payment_radio': () => _paymentRadio(context),
      'payment_provider_pills': () => _paymentProviderPills(context),
      'payment_card_brands': () => _paymentCardBrands(context),
      'payment_badge': () => _paymentBadge(context),
      'bnpl_panel': () => _bnplPanel(context, ref),
      'bnpl_provider_cards': () => _bnplProviderCards(context, ref),
      'payment_schedule_card': () => _paymentScheduleCard(context),
      'payment_benefit_box': () => _paymentBenefitBox(context),

      'form_fields': () => _formFields(context, ref),
      'form_field': () => _formField(context, ref),

      'virtual_tour_view': () => _virtualTourView(context, ref),

      'virtual_tour_mode_tabs': () => _virtualTourModeTabs(context, ref),
      'virtual_tour_label': () => _virtualTourLabel(context, ref),
      'virtual_tour_angle_buttons': () =>
          _virtualTourAngleButtons(context, ref),
    };

    return builders[type]?.call() ?? const SizedBox.shrink();
  }

  Widget _visualSearchUploadStatus(
  BuildContext context,
  WidgetRef ref,
) {
  final media = ref.watch(visualSearchMediaProvider);

  final hasMedia = media.hasMedia;

  final icon = hasMedia
      ? node['selectedIcon']?.toString() ?? 'check_circle'
      : node['emptyIcon']?.toString() ?? 'upload';

  final title = hasMedia
      ? node['selectedTitle']?.toString() ?? 'Media selected'
      : node['emptyTitle']?.toString() ?? 'Upload Photo or Video';

  final subtitle = hasMedia
      ? media.fileName ?? 'Selected file'
      : node['emptySubtitle']?.toString() ?? 'PNG, JPG, MP4 up to 50MB';

  final helper = hasMedia
      ? node['selectedSubtitle']?.toString() ?? 'Tap to replace this file'
      : null;

  final iconClasses = ElementSettings.classList(
    theme[hasMedia
        ? node['selectedIconThemeKey'] ?? 'uploadSelectedIcon'
        : node['iconThemeKey'] ?? 'uploadIcon'],
  );

  final titleClasses = ElementSettings.classList(
    theme[hasMedia
        ? node['selectedTitleThemeKey'] ?? 'uploadSelectedTitle'
        : node['titleThemeKey'] ?? 'uploadTitle'],
  );

  final subtitleClasses = ElementSettings.classList(
    theme[hasMedia
        ? node['selectedSubtitleThemeKey'] ?? 'uploadSelectedSubtitle'
        : node['subtitleThemeKey'] ?? 'uploadSubtitle'],
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElementIcons.show(
        context,
        icon,
        size: _iconSize(node['size'] ?? 'xl'),
        color: ElementSettings.textColor(context, iconClasses),
      ),

      const SizedBox(height: 12),

      Text(
        title,
        textAlign: TextAlign.center,
        style: ElementSettings.textStyle(context, titleClasses),
      ),

      const SizedBox(height: 6),

      Text(
        subtitle,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ElementSettings.textStyle(context, subtitleClasses),
      ),

      if (helper != null && helper.trim().isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(
          helper,
          textAlign: TextAlign.center,
          style: ElementSettings.textStyle(context, subtitleClasses),
        ),
      ],
    ],
  );
}

  bool _boolValue(dynamic value) {
    if (value == true) return true;
    if (value == false) return false;

    if (value is num) {
      return value != 0;
    }

    final text = value?.toString().trim().toLowerCase() ?? '';

    return text == 'true' || text == '1' || text == 'yes' || text == 'on';
  }

  String _safeSwitchKeyPart(dynamic value) {
    return value
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String _resolveSwitchFieldId(String valueKey) {
    final explicitKey =
        node['idKey'] ??
        node['formKey'] ??
        node['stateKey'] ??
        node['id'] ??
        node['key'];

    if (explicitKey != null) {
      final keyText = explicitKey.toString().trim();

      if (keyText.isNotEmpty) {
        final resolved = _read(keyText);

        if (resolved != null && resolved.toString().trim().isNotEmpty) {
          return _safeSwitchKeyPart(resolved);
        }

        return _safeSwitchKeyPart(keyText);
      }
    }

    for (final entry in locals.entries) {
      final localName = entry.key.toString();
      final localValue = entry.value;

      if (localValue is Map) {
        for (final identityKey in [
          'id',
          'actionType',
          'key',
          'title',
          'name',
        ]) {
          final identityValue = localValue[identityKey];

          if (identityValue != null &&
              identityValue.toString().trim().isNotEmpty) {
            return '${_safeSwitchKeyPart(valueKey)}__'
                '${_safeSwitchKeyPart(localName)}_'
                '${_safeSwitchKeyPart(identityKey)}_'
                '${_safeSwitchKeyPart(identityValue)}';
          }
        }
      }
    }

    return _safeSwitchKeyPart(valueKey);
  }

  Widget _switchButton(BuildContext context, WidgetRef ref) {
    final valueKey = node['valueKey']?.toString() ?? '';

    final fieldId = _resolveSwitchFieldId(valueKey);

    final formState = ref.watch(checkoutFormProvider);

    final formValue = fieldId.isNotEmpty ? formState[fieldId] : null;
    final storedValue = fieldId.isNotEmpty
        ? JsonFormValueStore.getValue(fieldId)
        : null;

    final rawValue =
        formValue ??
        storedValue ??
        (valueKey.isNotEmpty ? _read(valueKey) : null) ??
        node['defaultValue'];

    final isOn = _boolValue(rawValue);

    final trackClasses = ElementSettings.classList(
      isOn
          ? theme[node['onTrackThemeKey'] ?? 'switchTrackOn']
          : theme[node['offTrackThemeKey'] ?? 'switchTrackOff'],
    );

    final thumbClasses = ElementSettings.classList(
      isOn
          ? theme[node['onThumbThemeKey'] ?? 'switchThumbOn']
          : theme[node['offThumbThemeKey'] ?? 'switchThumbOff'],
    );

    final width = _doubleValue(node['width'], 42);
    final height = _doubleValue(node['height'], 24);
    final thumbSize = _doubleValue(node['thumbSize'], 20);
    final padding = _doubleValue(node['padding'], 2);

    final onTap = _resolveOnTap(context);

    void handleTap() {
      final nextValue = !isOn;
      final stringValue = nextValue.toString();

      if (fieldId.isNotEmpty) {
        JsonFormValueStore.setValue(fieldId, stringValue);

        ref.read(checkoutFormProvider.notifier).setValue(fieldId, stringValue);
      }

      onTap?.call();
    }

    final switchWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: ElementSettings.decoration(context, trackClasses),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: thumbSize,
          height: thumbSize,
          decoration: ElementSettings.decoration(context, thumbClasses),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: handleTap,
      child: switchWidget,
    );
  }

  Widget _checkboxToggle(BuildContext context, WidgetRef ref) {
    final id = node['id']?.toString() ?? node['key']?.toString() ?? 'checkbox';

    final checkboxState = ref.watch(jsonCheckboxProvider);
    final isChecked = checkboxState[id] ?? (node['defaultValue'] == true);

    final checkedClasses = ElementSettings.classList(
      theme[node['checkedThemeKey'] ?? 'checkboxChecked'],
    );

    final uncheckedClasses = ElementSettings.classList(
      theme[node['uncheckedThemeKey'] ?? 'checkboxUnchecked'],
    );

    final iconClasses = ElementSettings.classList(
      theme[node['iconThemeKey'] ?? 'checkboxIcon'],
    );

    final currentClasses = isChecked ? checkedClasses : uncheckedClasses;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(jsonCheckboxProvider.notifier).state = {
          ...checkboxState,
          id: !isChecked,
        };
      },
      child: Container(
        width: _doubleOrNull(node['width']) ?? 18,
        height: _doubleOrNull(node['height']) ?? 18,
        alignment: Alignment.center,
        decoration: ElementSettings.decoration(context, currentClasses),
        child: isChecked
            ? Icon(
                Icons.check,
                size: 14,
                color: ElementSettings.textColor(context, iconClasses),
              )
            : null,
      ),
    );
  }

  Widget _formFields(BuildContext context, WidgetRef ref) {
    final rawFields = _read(node['itemsKey'] ?? 'fields');

    if (rawFields is! List) {
      return const SizedBox.shrink();
    }

    final fields = rawFields
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();

    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final isHalf = field['width'] == 'half';

      if (isHalf && i + 1 < fields.length && fields[i + 1]['width'] == 'half') {
        children.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _formFieldItem(context: context, ref: ref, field: field),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _formFieldItem(
                  context: context,
                  ref: ref,
                  field: fields[i + 1],
                ),
              ),
            ],
          ),
        );

        i++;
      } else {
        children.add(_formFieldItem(context: context, ref: ref, field: field));
      }

      if (i != fields.length - 1) {
        children.add(const SizedBox(height: 14));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _formField(BuildContext context, WidgetRef ref) {
    final rawField = _read(node['key'] ?? 'field');

    if (rawField is! Map) {
      return const SizedBox.shrink();
    }

    return _formFieldItem(
      context: context,
      ref: ref,
      field: Map<dynamic, dynamic>.from(rawField),
    );
  }

  Widget _formFieldItem({
    required BuildContext context,
    required WidgetRef ref,
    required Map<dynamic, dynamic> field,
  }) {
    final labelClasses = ElementSettings.classList(theme['label']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field['label'] != null) ...[
          Text(
            field['label'].toString(),
            style: ElementSettings.textStyle(context, labelClasses),
          ),
          const SizedBox(height: 6),
        ],

        _JsonFormField(field: field, theme: theme),
      ],
    );
  }

  Widget _supportChatBox(BuildContext context, WidgetRef ref) {
    print("building support chat ");
    final controller = TextEditingController();

    final titleClasses = ElementSettings.classList(theme['title']);
    final cardClasses = ElementSettings.classList(theme['card']);
    final bubbleClasses = ElementSettings.classList(theme['bubble']);
    final messageClasses = ElementSettings.classList(theme['message']);
    final timeClasses = ElementSettings.classList(theme['time']);
    final inputClasses = ElementSettings.classList(theme['input']);
    final placeholderClasses = ElementSettings.classList(theme['placeholder']);
    final sendButtonClasses = ElementSettings.classList(theme['sendButton']);
    final sendIconClasses = ElementSettings.classList(theme['sendIcon']);

    final title = _read('title')?.toString() ?? 'Support Chat';
    final message = _read('message')?.toString() ?? '';
    final time = _read('time')?.toString() ?? '';
    final placeholder =
        _read('placeholder')?.toString() ?? 'Type your message...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: ElementSettings.textStyle(context, titleClasses)),
        const SizedBox(height: 12),

        Container(
          padding: ElementSettings.padding(cardClasses),
          decoration: ElementSettings.decoration(context, cardClasses),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: ElementSettings.padding(bubbleClasses),
                  decoration: ElementSettings.decoration(
                    context,
                    bubbleClasses,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: ElementSettings.textStyle(
                          context,
                          messageClasses,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: ElementSettings.textStyle(context, timeClasses),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: ElementSettings.decoration(
                        context,
                        inputClasses,
                      ),
                      child: TextField(
                        controller: controller,
                        style: ElementSettings.textStyle(context, [
                          'text-body',
                          'text-sm',
                        ]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: placeholder,
                          hintStyle: ElementSettings.textStyle(
                            context,
                            placeholderClasses,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;

                      ActionHandler.handle(context, {
                        "type": "send_support_message",
                        "params": {"message": text},
                      });

                      controller.clear();
                    },
                    child: Container(
                      padding: ElementSettings.padding(sendButtonClasses),
                      decoration: ElementSettings.decoration(
                        context,
                        sendButtonClasses,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 18,
                        color: ElementSettings.textColor(
                          context,
                          sendIconClasses,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _aiChatSuggestions(BuildContext context, WidgetRef ref) {
    final suggestions = _read(node['itemsKey'] ?? 'suggestions');

    if (suggestions is! List) return const SizedBox.shrink();

    final classes = ElementSettings.classList(theme['suggestionChip']);
    final textClasses = ElementSettings.classList(theme['suggestionText']);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: suggestions.asMap().entries.map((entry) {
          final index = entry.key;
          final suggestion = entry.value.toString();

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 12 : 8, right: 0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(aiChatProvider.notifier).send(suggestion);
              },
              child: Container(
                padding: ElementSettings.padding(classes),
                decoration: ElementSettings.decoration(context, classes),
                child: Text(
                  suggestion,
                  style: ElementSettings.textStyle(context, textClasses),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _aiChatMessages(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(aiChatProvider);

    final assistantCard = ElementSettings.classList(theme['messageCard']);
    final userCard = ElementSettings.classList(
      theme['userMessageCard'] ?? theme['messageCard'],
    );

    final userLabel = ElementSettings.classList(
      theme['userMessageLabel'] ?? theme['messageLabel'],
    );

    final userTime = ElementSettings.classList(
      theme['userMessageTime'] ?? theme['messageTime'],
    );

    final assistantText = ElementSettings.classList(theme['messageText']);
    final userText = ElementSettings.classList(
      theme['userMessageText'] ?? theme['messageText'],
    );

    final labelClasses = ElementSettings.classList(theme['messageLabel']);
    final timeClasses = ElementSettings.classList(theme['messageTime']);

    final list = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: chat.messages.length + (chat.loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= chat.messages.length) {
          return _chatBubble(
            context: context,
            alignRight: false,
            label: 'AI Assistant',
            text: 'Typing...',
            time: '',
            cardClasses: assistantCard,
            textClasses: assistantText,
            labelClasses: labelClasses,
            timeClasses: timeClasses,
          );
        }

        final message = chat.messages[index];
        final isUser = message.role == 'user';

        return _chatBubble(
          context: context,
          alignRight: isUser,
          label: isUser ? 'You' : 'AI Assistant',
          text: message.text,
          time: message.time,
          cardClasses: isUser ? userCard : assistantCard,
          textClasses: isUser ? userText : assistantText,
          labelClasses: isUser ? userLabel : labelClasses,
          timeClasses: isUser ? userTime : timeClasses,
        );
      },
    );

    if (node['fill'] == true) {
      return list;
    }

    return SizedBox(
      height:
          _doubleOrNull(node['height']) ??
          MediaQuery.of(context).size.height * 0.55,
      child: list,
    );
  }

  Widget _chatBubble({
    required BuildContext context,
    required bool alignRight,
    required String label,
    required String text,
    required String time,
    required List<String> cardClasses,
    required List<String> textClasses,
    required List<String> labelClasses,
    required List<String> timeClasses,
  }) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.72,
        margin: const EdgeInsets.only(bottom: 12),
        padding: ElementSettings.padding(cardClasses),
        decoration: ElementSettings.decoration(context, cardClasses),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: ElementSettings.textStyle(context, labelClasses),
            ),
            const SizedBox(height: 8),
            Text(text, style: ElementSettings.textStyle(context, textClasses)),
            if (time.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                DateTime.now().toString(),
                style: ElementSettings.textStyle(context, timeClasses),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _aiChatInput(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    final inputWrap = ElementSettings.classList(theme['inputWrap']);
    final inputBox = ElementSettings.classList(theme['inputBox']);
    final placeholderClasses = ElementSettings.classList(theme['placeholder']);
    final sendButton = ElementSettings.classList(theme['sendButton']);
    final sendIcon = ElementSettings.classList(theme['sendIcon']);

    final placeholder =
        _read(node['placeholderKey'] ?? 'placeholder')?.toString() ??
        'Ask me anything...';

    return Container(
      padding: ElementSettings.padding(inputWrap),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: ElementSettings.textStyle(context, [
                'text-primary',
                'text-sm',
              ]),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: placeholder,
                hintStyle: ElementSettings.textStyle(
                  context,
                  placeholderClasses,
                ),
              ),
              onSubmitted: (value) {
                ref.read(aiChatProvider.notifier).send(value);
                controller.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              ref.read(aiChatProvider.notifier).send(controller.text);
              controller.clear();
            },
            child: Container(
              padding: ElementSettings.padding(sendButton),
              decoration: ElementSettings.decoration(context, sendButton),
              child: Icon(
                Icons.send,
                size: 18,
                color: ElementSettings.textColor(context, sendIcon),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalScroll(BuildContext context) {
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});
    final classes = ElementSettings.classList(node['classes']);

    return Container(
      margin: ElementSettings.margin(classes),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  Widget _expanded(BuildContext context) {
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return Expanded(
      child: JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: locals,
      ),
    );
  }

  Widget _virtualTourView(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(virtualTourProvider);
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return AnimatedScale(
      scale: tourState.scale,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedRotation(
        turns: tourState.angle,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  Widget _virtualTourModeTabs(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(virtualTourProvider);

    final wrapClasses = ElementSettings.classList(theme['segmentWrap']);
    final activeClasses = ElementSettings.classList(theme['segmentActive']);
    final inactiveClasses = ElementSettings.classList(theme['segmentInactive']);

    final activeTextClasses = ElementSettings.classList(
      theme['segmentTextActive'],
    );
    final inactiveTextClasses = ElementSettings.classList(
      theme['segmentTextInactive'],
    );

    Widget tab(String label) {
      final selected = tourState.mode == label;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(virtualTourProvider.notifier).setMode(label);
        },
        child: Container(
          padding: ElementSettings.padding(
            selected ? activeClasses : inactiveClasses,
          ),
          decoration: ElementSettings.decoration(
            context,
            selected ? activeClasses : inactiveClasses,
          ),
          child: Text(
            label,
            style: ElementSettings.textStyle(
              context,
              selected ? activeTextClasses : inactiveTextClasses,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: ElementSettings.padding(wrapClasses),
      decoration: ElementSettings.decoration(context, wrapClasses),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [tab('Exterior'), tab('Interior')],
      ),
    );
  }

  Widget _virtualTourLabel(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(virtualTourProvider);

    final labelType = node['labelType']?.toString();

    final text = labelType == 'subtitle'
        ? tourState.view
        : '${tourState.mode} View';

    final classes = ElementSettings.classList(theme[node['themeKey']]);

    return Text(
      text,
      textAlign: TextAlign.center,
      style: ElementSettings.textStyle(context, classes),
    );
  }

  Widget _virtualTourAngleButtons(BuildContext context, WidgetRef ref) {
    final tourState = ref.watch(virtualTourProvider);

    final items = tourState.mode == 'Interior'
        ? const ['Dashboard', 'Front Seats', 'Back Seats', 'Trunk']
        : const ['Front', 'Right Side', 'Rear', 'Left Side'];

    final activeClasses = ElementSettings.classList(theme['angleActive']);
    final inactiveClasses = ElementSettings.classList(theme['angleInactive']);

    final activeTextClasses = ElementSettings.classList(
      theme['angleTextActive'] ?? theme['angleText'],
    );
    final inactiveTextClasses = ElementSettings.classList(
      theme['angleTextInactive'] ?? theme['angleText'],
    );

    return Container(
      margin: ElementSettings.margin(
        ElementSettings.classList(node['classes']),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final selected = tourState.view == label;

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(virtualTourProvider.notifier).setView(label);
              },
              child: Container(
                padding: ElementSettings.padding(
                  selected ? activeClasses : inactiveClasses,
                ),
                decoration: ElementSettings.decoration(
                  context,
                  selected ? activeClasses : inactiveClasses,
                ),
                child: Text(
                  label,
                  style: ElementSettings.textStyle(
                    context,
                    selected ? activeTextClasses : inactiveTextClasses,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Form max length helper
  // ==========================================

  int? _formMaxLength(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // ==========================================
  // Form keyboard type helper
  // ==========================================

  TextInputType _formKeyboardType(dynamic type) {
    switch (type?.toString()) {
      case 'number':
        return TextInputType.number;

      case 'datetime':
        return TextInputType.datetime;

      case 'email':
        return TextInputType.emailAddress;

      case 'phone':
        return TextInputType.phone;

      case 'multiline':
        return TextInputType.multiline;

      default:
        return TextInputType.text;
    }
  }

  // ==========================================
  // Form input formatters
  // ==========================================

  List<TextInputFormatter> _formInputFormatters(Map<dynamic, dynamic> field) {
    final format = field['inputFormat']?.toString();

    switch (format) {
      case 'card_number':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          const _GroupedInputFormatter(groupSize: 4, separator: ' '),
        ];

      case 'expiry_date':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          const _GroupedInputFormatter(groupSize: 2, separator: '/'),
        ];

      case 'cvv':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ];

      case 'letters_spaces':
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];

      default:
        return [];
    }
  }

  // ==========================================
  // Form validator
  // ==========================================

  String? _formValidator(Map<dynamic, dynamic> field, String? value) {
    final text = value?.trim() ?? '';

    final required = field['required'] == true;
    final format = field['inputFormat']?.toString();
    final label = field['label']?.toString() ?? 'This field';

    if (required && text.isEmpty) {
      return '$label is required';
    }

    if (text.isEmpty) {
      return null;
    }

    if (format == 'card_number') {
      final digits = text.replaceAll(' ', '');

      if (digits.length != 16) {
        return 'Enter a valid 16-digit card number';
      }
    }

    if (format == 'expiry_date') {
      final digits = text.replaceAll('/', '');

      if (digits.length != 4) {
        return 'Enter expiry as MM/YY';
      }

      final month = int.tryParse(digits.substring(0, 2)) ?? 0;

      if (month < 1 || month > 12) {
        return 'Enter a valid month';
      }
    }

    if (format == 'cvv') {
      if (text.length < 3 || text.length > 4) {
        return 'Enter a valid CVV';
      }
    }

    return null;
  }

  // ==========================================
  // Payment option list
  //
  // Renders all payment method options.
  // Keeps looping logic inside JsonLayoutRenderer.
  // ==========================================

  Widget _paymentOptionList(BuildContext context, WidgetRef ref) {
    final rawItems = _read(node['itemsKey'] ?? 'options');

    if (rawItems is! List) {
      return const SizedBox.shrink();
    }

    final itemName = node['itemName']?.toString() ?? 'option';

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : {"type": "payment_method_tile", "key": itemName};

    final items = rawItems
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        final nextLocals = Map<dynamic, dynamic>.from(locals);
        nextLocals[itemName] = option;

        return Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
          child: JsonLayoutRenderer(
            node: childNode,
            data: data,
            theme: theme,
            config: config,
            currency: currency,
            locals: nextLocals,
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // Payment method tile
  //
  // Makes a payment method option selectable.
  // Visual content can be fully controlled by JSON child.
  // ==========================================

  Widget _paymentMethodTile(BuildContext context, WidgetRef ref) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final optionMap = Map<dynamic, dynamic>.from(option);

    final paymentSectionId = _read('paymentSectionId')?.toString() ?? '';
    final optionId = optionMap['id']?.toString() ?? '';
    final selectedPaymentId = _read('selectedPaymentId')?.toString();

    final selected =
        optionMap['selected'] == true || optionId == selectedPaymentId;

    final classes = ElementSettings.classList(
      selected
          ? optionMap['selectedOptionClasses'] ??
                theme[node['selectedThemeKey'] ?? 'selectedOption']
          : theme[node['themeKey'] ?? 'option'],
    );

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : _defaultPaymentTileChild();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final selectedMap = ref.read(selectedPaymentMethodProvider);

        ref.read(selectedPaymentMethodProvider.notifier).state = {
          ...selectedMap,
          paymentSectionId: optionId,
        };
      },
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(classes),
        decoration: ElementSettings.decoration(context, classes),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  // ==========================================
  // Default payment tile layout
  //
  // Used only when payment_method_tile has no custom child.
  // ==========================================

  Map<dynamic, dynamic> _defaultPaymentTileChild() {
    return {
      "type": "row",
      "crossAxis": "start",
      "children": [
        {"type": "payment_radio", "key": "option"},
        {
          "type": "column",
          "flex": 1,
          "classes": ["ml-md"],
          "children": [
            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "icon",
                  "key": "option.icon",
                  "themeKey": "icon",
                  "size": "md",
                  "visibleWhen": "option.icon != null",
                },
                {
                  "type": "text",
                  "key": "option.title",
                  "themeKey": "optionTitle",
                  "classes": ["ml-sm"],
                  "flex": 1,
                },
                {
                  "type": "payment_badge",
                  "key": "option.badge",
                  "themeKey": "badge",
                  "textThemeKey": "badgeText",
                  "visibleWhen": "option.badge != null",
                },
              ],
            },
            {
              "type": "text",
              "key": "option.description",
              "themeKey": "description",
              "classes": ["mt-xs"],
              "visibleWhen": "option.description != null",
            },
            {
              "type": "payment_provider_pills",
              "itemsKey": "option.providers",
              "classes": ["mt-sm"],
              "visibleWhen": "option.providers != null",
            },
          ],
        },
        {
          "type": "payment_card_brands",
          "itemsKey": "option.brands",
          "classes": ["ml-md"],
          "visibleWhen": "option.brands != null",
        },
      ],
    };
  }

  // ==========================================
  // Payment radio
  // ==========================================

  Widget _paymentRadio(BuildContext context) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final optionId = option['id']?.toString() ?? '';
    final selectedPaymentId = _read('selectedPaymentId')?.toString();

    final selected =
        option['selected'] == true || optionId == selectedPaymentId;

    final classes = ElementSettings.classList(
      selected
          ? option['selectedRadioClasses'] ??
                theme[node['selectedThemeKey'] ?? 'selectedRadio']
          : theme[node['themeKey'] ?? 'radio'],
    );

    return RadioDot(selected: selected, classes: classes);
  }

  // ==========================================
  // Provider pills
  //
  // Inline Klarna / or / Clearpay style pills.
  // ==========================================

  Widget _paymentProviderPills(BuildContext context) {
    final rawProviders = _read(node['itemsKey'] ?? 'option.providers');

    if (rawProviders is! List || rawProviders.isEmpty) {
      return const SizedBox.shrink();
    }

    final providers = rawProviders
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();

    return Wrap(
      spacing: _doubleValue(node['spacing'], 8),
      runSpacing: _doubleValue(node['runSpacing'], 8),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: providers.map((provider) {
        final variant = provider['variant']?.toString();
        final label = provider['label']?.toString() ?? '';

        if (label.isEmpty) {
          return const SizedBox.shrink();
        }

        if (variant == 'plain') {
          return Text(
            label,
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['providerInlineText']),
              size: 10,
            ),
          );
        }

        final classes = ElementSettings.classList(
          variant == 'success' ? theme['successPill'] : theme['paymentPill'],
        );

        final textClasses = ElementSettings.classList(
          variant == 'success'
              ? theme['successPillText']
              : theme['paymentPillText'],
        );

        return _paymentSmallBadge(
          context: context,
          label: label,
          classes: classes,
          textClasses: textClasses,
        );
      }).toList(),
    );
  }

  // ==========================================
  // Card brand badges
  //
  // VISA / Mastercard badges.
  // ==========================================

  Widget _paymentCardBrands(BuildContext context) {
    final rawBrands = _read(node['itemsKey'] ?? 'option.brands');

    if (rawBrands is! List || rawBrands.isEmpty) {
      return const SizedBox.shrink();
    }

    final brands = rawBrands
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: brands.asMap().entries.map((entry) {
        final index = entry.key;
        final brand = entry.value;

        final variant = brand['variant']?.toString();
        final label = brand['label']?.toString() ?? '';

        if (label.isEmpty) {
          return const SizedBox.shrink();
        }

        final classes = ElementSettings.classList(
          variant == 'mastercard'
              ? theme['cardBrandMastercard']
              : theme['cardBrandVisa'],
        );

        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
          child: _paymentSmallBadge(
            context: context,
            label: label,
            classes: classes,
            textClasses: ElementSettings.classList(theme['cardBrandText']),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // Generic payment badge
  // ==========================================

  Widget _paymentBadge(BuildContext context) {
    final label = _read(node['key'] ?? '') ?? node['label'];

    if (label == null || label.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    final classes = ElementSettings.classList(
      theme[node['themeKey'] ?? 'badge'],
    );

    final textClasses = ElementSettings.classList(
      theme[node['textThemeKey'] ?? 'badgeText'],
    );

    return _paymentSmallBadge(
      context: context,
      label: label.toString(),
      classes: classes,
      textClasses: textClasses.isNotEmpty ? textClasses : classes,
    );
  }

  // ==========================================
  // BNPL panel
  //
  // Renders only when selected payment method has buyNowPayLater data.
  // ==========================================

  Widget _bnplPanel(BuildContext context, WidgetRef ref) {
    final show = _read('showBuyNowPayLater') == true;

    if (!show) {
      return const SizedBox.shrink();
    }

    final rawPanel = _read(node['key'] ?? 'buyNowPayLater');

    if (rawPanel is! Map) {
      return const SizedBox.shrink();
    }

    final panel = Map<dynamic, dynamic>.from(rawPanel);

    final nextLocals = Map<dynamic, dynamic>.from(locals);
    nextLocals['bnpl'] = panel;

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : _defaultBnplPanelChild();

    return JsonLayoutRenderer(
      node: childNode,
      data: data,
      theme: theme,
      config: config,
      currency: currency,
      locals: nextLocals,
    );
  }

  // ==========================================
  // Default BNPL panel layout
  // ==========================================

  Map<dynamic, dynamic> _defaultBnplPanelChild() {
    return {
      "type": "column",
      "crossAxis": "stretch",
      "children": [
        {"type": "text", "key": "bnpl.title", "themeKey": "sectionTitle"},
        {
          "type": "text",
          "key": "bnpl.subtitle",
          "themeKey": "sectionSubtitle",
          "classes": ["mt-xs"],
          "visibleWhen": "bnpl.subtitle != null",
        },
        {
          "type": "bnpl_provider_cards",
          "itemsKey": "bnpl.providers",
          "classes": ["mt-md"],
          "visibleWhen": "bnpl.providers != null",
        },
        {
          "type": "payment_schedule_card",
          "key": "bnpl.schedule",
          "classes": ["mt-md"],
          "visibleWhen": "bnpl.schedule != null",
        },
        {
          "type": "payment_benefit_box",
          "key": "bnpl.benefits",
          "classes": ["mt-md"],
          "visibleWhen": "bnpl.benefits != null",
        },
      ],
    };
  }

  // ==========================================
  // BNPL provider cards
  //
  // Selectable Klarna / Clearpay provider cards.
  // ==========================================

  Widget _bnplProviderCards(BuildContext context, WidgetRef ref) {
    final rawProviders = _read(node['itemsKey'] ?? 'bnpl.providers');

    if (rawProviders is! List || rawProviders.isEmpty) {
      return const SizedBox.shrink();
    }

    final providers = rawProviders
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();

    final paymentSectionId = _read('paymentSectionId')?.toString() ?? '';

    final selectedMap = ref.watch(selectedBnplProvider);

    final selectedProviderId =
        selectedMap[paymentSectionId]?.toString() ??
        _read('bnpl.selectedProviderId')?.toString();

    return Row(
      children: providers.asMap().entries.map((entry) {
        final index = entry.key;
        final provider = entry.value;

        final providerId = provider['id']?.toString() ?? '';
        final selected = providerId == selectedProviderId;

        final cardClasses = ElementSettings.classList(
          selected
              ? provider['selectedCardClasses'] ?? theme['selectedProviderCard']
              : theme['providerCard'],
        );

        final titleClasses = ElementSettings.classList(
          selected
              ? provider['selectedTitleClasses'] ??
                    theme['selectedProviderTitle']
              : provider['titleClasses'] ?? theme['providerTitle'],
        );

        final subtitleClasses = ElementSettings.classList(
          theme['providerSubtitle'],
        );

        final childNode = node['child'] is Map
            ? Map<dynamic, dynamic>.from(node['child'])
            : null;

        final nextLocals = Map<dynamic, dynamic>.from(locals);
        nextLocals['provider'] = provider;
        nextLocals['providerSelected'] = selected;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == providers.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(selectedBnplProvider.notifier).state = {
                  ...selectedMap,
                  paymentSectionId: providerId,
                };
              },
              child: Container(
                padding: ElementSettings.padding(cardClasses),
                decoration: ElementSettings.decoration(context, cardClasses),
                child: childNode != null
                    ? JsonLayoutRenderer(
                        node: childNode,
                        data: data,
                        theme: theme,
                        config: config,
                        currency: currency,
                        locals: nextLocals,
                      )
                    : Column(
                        children: [
                          Text(
                            provider['title']?.toString() ?? '',
                            textAlign: TextAlign.center,
                            style: ElementSettings.textStyle(
                              context,
                              titleClasses,
                            ),
                          ),
                          if ((provider['subtitle'] ?? '')
                              .toString()
                              .isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              provider['subtitle'].toString(),
                              textAlign: TextAlign.center,
                              style: ElementSettings.textStyle(
                                context,
                                subtitleClasses,
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // Payment schedule card
  //
  // Includes the schedule note inside the same card.
  // ==========================================

  Widget _paymentScheduleCard(BuildContext context) {
    final rawSchedule = _read(node['key'] ?? 'bnpl.schedule');

    if (rawSchedule is! Map) {
      return const SizedBox.shrink();
    }

    final schedule = Map<dynamic, dynamic>.from(rawSchedule);
    final rows = _paymentMapList(schedule['items']);
    final noteRaw = schedule['note'];

    final note = noteRaw is Map ? Map<dynamic, dynamic>.from(noteRaw) : null;

    final cardClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'scheduleCard'],
    );

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if ((schedule['icon'] ?? '').toString().isNotEmpty) ...[
                ElementIcons.show(
                  context,
                  schedule['icon'],
                  size: 16,
                  color: ElementSettings.textColor(
                    context,
                    ElementSettings.classList(theme['scheduleIcon']),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  schedule['title']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['scheduleTitle']),
                  ),
                ),
              ),
            ],
          ),
          if (rows.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _paymentScheduleRowWidget(context: context, row: row),
              );
            }),
          ],
          if (note != null && note.isNotEmpty) ...[
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: ElementSettings.borderColor(context, ['border-primary']),
            ),
            const SizedBox(height: 6),
            _paymentNoteWidget(context: context, note: note),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // Payment schedule row widget
  // ==========================================

  Widget _paymentScheduleRowWidget({
    required BuildContext context,
    required Map<dynamic, dynamic> row,
  }) {
    final rowClasses = ElementSettings.classList(theme['scheduleRow']);
    final numberClasses = ElementSettings.classList(theme['scheduleNumber']);

    return Container(
      padding: ElementSettings.padding(rowClasses),
      decoration: ElementSettings.decoration(context, rowClasses),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: ElementSettings.decoration(context, numberClasses),
            child: Text(
              row['number']?.toString() ?? '',
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['scheduleNumberText']),
                size: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row['label']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['scheduleLabel']),
                  ),
                ),
                if ((row['subtitle'] ?? '').toString().isNotEmpty)
                  Text(
                    row['subtitle'].toString(),
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['scheduleSubLabel']),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            row['value']?.toString() ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['scheduleValue']),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Payment note widget
  // ==========================================

  Widget _paymentNoteWidget({
    required BuildContext context,
    required Map<dynamic, dynamic> note,
  }) {
    final icon = note['icon']?.toString() ?? '';
    final text = note['text']?.toString() ?? '';

    if (icon.isEmpty && text.isEmpty) {
      return const SizedBox.shrink();
    }

    final classes = ElementSettings.classList(theme['noteBox']);

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon.isNotEmpty) ...[
            ElementIcons.show(
              context,
              icon,
              size: 14,
              color: ElementSettings.textColor(
                context,
                ElementSettings.classList(theme['noteIcon']),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['noteText']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Payment benefit box
  //
  // Pay in 3 benefit card.
  // Supports title, text, icon and items.
  // ==========================================

  Widget _paymentBenefitBox(BuildContext context) {
    final rawBenefits = _read(node['key'] ?? 'bnpl.benefits');

    if (rawBenefits is! Map) {
      return const SizedBox.shrink();
    }

    final benefits = Map<dynamic, dynamic>.from(rawBenefits);
    final items = _paymentStringList(benefits['items']);

    final icon = benefits['icon']?.toString() ?? '';
    final title = benefits['title']?.toString() ?? '';
    final text =
        benefits['text']?.toString() ??
        benefits['description']?.toString() ??
        '';

    final cardClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'benefitBox'],
    );

    final iconBoxClasses = ElementSettings.classList(theme['benefitIconBox']);

    final iconClasses = ElementSettings.classList(theme['benefitIcon']);

    final titleClasses = ElementSettings.classList(theme['benefitTitle']);

    final textClasses = ElementSettings.classList(theme['benefitText']);

    final itemTextClasses = ElementSettings.classList(
      theme['benefitItemText'] ?? theme['benefitText'],
    );

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon.isNotEmpty) ...[
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              padding: ElementSettings.padding(iconBoxClasses),
              decoration: ElementSettings.decoration(context, iconBoxClasses),
              child: ElementIcons.show(
                context,
                icon,
                size: 16,
                color: ElementSettings.textColor(context, iconClasses),
              ),
            ),
            const SizedBox(width: 10),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: ElementSettings.textStyle(context, titleClasses),
                  ),

                if (text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: ElementSettings.textStyle(context, textClasses),
                  ),
                ],

                if (items.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: ElementIcons.show(
                              context,
                              'dot',
                              size: 10,
                              color: ElementSettings.textColor(
                                context,
                                iconClasses,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item,
                              style: ElementSettings.textStyle(
                                context,
                                itemTextClasses,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ==========================================
  // Small payment badge helper
  // ==========================================

  Widget _paymentSmallBadge({
    required BuildContext context,
    required String label,
    required List<String> classes,
    required List<String> textClasses,
  }) {
    return Container(
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
      child: Text(
        label,
        style: ElementSettings.textStyle(
          context,
          textClasses.isNotEmpty ? textClasses : classes,
          size: 10,
        ),
      ),
    );
  }

  // ==========================================
  // Payment local helpers
  // ==========================================

  List<Map<dynamic, dynamic>> _paymentMapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  List<String> _paymentStringList(dynamic value) {
    if (value is! List) return [];

    return value.map((item) => item.toString()).toList();
  }

  // ==========================================
  // QDrive Pass plan tile
  //
  // Makes a JSON-rendered plan selectable.
  // Reads the current local `plan` from for_each.
  // ==========================================

Widget _qdrivePassPlanTile(BuildContext context, WidgetRef ref) {
  final plan = _read(node['key'] ?? 'plan');

  if (plan is! Map) {
    return const SizedBox.shrink();
  }

  final planMap = Map<dynamic, dynamic>.from(plan);
  final planId = planMap['id']?.toString() ?? '';

  final selectedPlanId = ref.watch(selectedQdrivePassPlanProvider);
  final selected = selectedPlanId == planId;

  final classes = ElementSettings.classList(
    selected
        ? theme[node['selectedThemeKey'] ?? 'selectedPlan']
        : theme[node['themeKey'] ?? 'plan'],
  );

  final childNode = node['child'] is Map
      ? Map<dynamic, dynamic>.from(node['child'])
      : <String, dynamic>{};

  final nextLocals = Map<dynamic, dynamic>.from(locals);
  nextLocals['plan'] = planMap;
  nextLocals['planSelected'] = selected;

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      final isAlreadySelected =
          ref.read(selectedQdrivePassPlanProvider) == planId;

      if (isAlreadySelected) {
        ref.read(selectedQdrivePassPlanProvider.notifier).state = null;
        ref.read(selectedQdrivePassPlanOptionProvider.notifier).state = null;
        ref.read(expandedQdrivePassCoverageProvider.notifier).state = null;

        JsonFormValueStore.setValue('selectedQdrivePass', '');

        ref.read(checkoutFormProvider.notifier).setValue(
              'selectedQdrivePass',
              '',
            );

        return;
      }

      ref.read(selectedQdrivePassPlanProvider.notifier).state = planId;
      ref.read(selectedQdrivePassPlanOptionProvider.notifier).state = planMap;

      JsonFormValueStore.setValue('selectedQdrivePass', planId);

      ref.read(checkoutFormProvider.notifier).setValue(
            'selectedQdrivePass',
            planId,
          );
    },
    child: Container(
      width: double.infinity,
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
      child: JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: nextLocals,
      ),
    ),
  );
}
 
 
 
 
 
 
  // ==========================================
  // QDrive Pass coverage toggle
  //
  // Opens/closes the coverage area for the current plan.
  // Use this around the "View coverage" row/text.
  // ==========================================

  Widget _qdrivePassCoverageToggle(BuildContext context, WidgetRef ref) {
    final plan = _read(node['key'] ?? 'plan');

    if (plan is! Map) {
      return const SizedBox.shrink();
    }

    final planId = plan['id']?.toString() ?? '';
    if (planId.isEmpty) {
      return const SizedBox.shrink();
    }

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : <String, dynamic>{};

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final current = ref.read(expandedQdrivePassCoverageProvider);

        ref.read(expandedQdrivePassCoverageProvider.notifier).state =
            current == planId ? null : planId;
      },
      child: JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: locals,
      ),
    );
  }

  // ==========================================
  // QDrive Pass coverage panel
  //
  // Only renders the child when the current plan coverage is expanded.
  // ==========================================

  Widget _qdrivePassCoveragePanel(BuildContext context, WidgetRef ref) {
    final plan = _read(node['key'] ?? 'plan');

    if (plan is! Map) {
      return const SizedBox.shrink();
    }

    final planId = plan['id']?.toString() ?? '';
    final expandedPlanId = ref.watch(expandedQdrivePassCoverageProvider);

    if (expandedPlanId != planId) {
      return const SizedBox.shrink();
    }

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : <String, dynamic>{};

    return JsonLayoutRenderer(
      node: childNode,
      data: data,
      theme: theme,
      config: config,
      currency: currency,
      locals: locals,
    );
  }

  // ==========================================
  // QDrive Pass expand icon
  //
  // Shows up/down arrow based on expanded coverage state.
  // ==========================================

  Widget _qdrivePassExpandIcon(BuildContext context) {
    final plan = _read(node['key'] ?? 'plan');

    if (plan is! Map) {
      return const SizedBox.shrink();
    }

    final planId = plan['id']?.toString() ?? '';
    final expandedPlanId = _read('expandedCoveragePlanId')?.toString();

    final expanded = expandedPlanId == planId;

    final classes = ElementSettings.classList(
      theme[node['themeKey'] ?? 'link'],
    );

    return Icon(
      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      size: _iconSize(node['size'] ?? 'sm'),
      color: ElementSettings.textColor(context, classes),
    );
  }

  // ==========================================
  // QDrive Pass remove button
  //
  // Optional JSON wrapper for removing selected pass.
  // Useful if you later move the selected membership card fully into JSON.
  // ==========================================

  Widget _qdrivePassRemoveButton(BuildContext context, WidgetRef ref) {
    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : <String, dynamic>{};

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(selectedQdrivePassPlanProvider.notifier).state = null;
        ref.read(selectedQdrivePassPlanOptionProvider.notifier).state = null;
        ref.read(expandedQdrivePassCoverageProvider.notifier).state = null;
      },
      child: JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: locals,
      ),
    );
  }

  // ==========================================
  // Extra quantity button
  //
  // Supports:
  // - increase extra quantity
  // - decrease extra quantity
  // - fully custom child layout
  // ==========================================

  Widget _extraQuantityButton(BuildContext context, WidgetRef ref) {
    final extra = _read(node['extraKey'] ?? node['key'] ?? 'extra');

    if (extra is! Map) {
      return const SizedBox.shrink();
    }

    final action = node['action']?.toString() ?? 'increase';
    final extraId = extra['id']?.toString() ?? '';

    final buttonClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'button'],
    );

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : {
            "type": "icon",
            "icon": action == "decrease" ? "minus" : "plus",
            "themeKey": node['iconThemeKey'] ?? "buttonIcon",
            "size": "sm",
          };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (action == 'decrease') {
          ref.read(checkoutExtrasProvider.notifier).decrease(extraId);
          return;
        }

        ref
            .read(checkoutExtrasProvider.notifier)
            .increase(Map<dynamic, dynamic>.from(extra));
      },
      child: Container(
        width: node['width'] is num ? (node['width'] as num).toDouble() : 34,
        height: node['height'] is num ? (node['height'] as num).toDouble() : 34,
        alignment: Alignment.center,
        padding: ElementSettings.padding(buttonClasses),
        decoration: ElementSettings.decoration(context, buttonClasses),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  // ==========================================
  // Protection tile wrapper
  // Makes a fully custom JSON protection tile selectable.
  // ==========================================

  Widget _protectionTile(BuildContext context, WidgetRef ref) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final selected = option['selected'] == true;

    final optionClasses = ElementSettings.classList(
      selected
          ? theme[node['selectedThemeKey'] ?? 'selectedOption']
          : theme[node['themeKey'] ?? 'option'],
    );

    final optionId = option['id']?.toString() ?? '';
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(selectedProtectionProvider.notifier).state = optionId;
        ref.read(selectedProtectionOptionProvider.notifier).state =
            Map<dynamic, dynamic>.from(option);
      },
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(optionClasses),
        decoration: ElementSettings.decoration(context, optionClasses),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  // ==========================================
  // Protection radio
  // Reads selected state from current option.
  // ==========================================

  Widget _protectionRadio(BuildContext context) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final selected = option['selected'] == true;

    final radioClasses = ElementSettings.classList(
      selected
          ? theme[node['selectedThemeKey'] ?? 'selectedRadio']
          : theme[node['themeKey'] ?? 'radio'],
    );

    return RadioDot(selected: selected, classes: radioClasses);
  }

  // ==========================================
  // Protection coverage toggle
  // Expands/collapses coverage details.
  // ==========================================

  Widget _protectionToggleCoverage(BuildContext context, WidgetRef ref) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final optionId = option['id']?.toString() ?? '';
    final expanded = option['expanded'] == true;
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(expandedProtectionProvider.notifier).state = expanded
            ? null
            : optionId;
      },
      child: JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: locals,
      ),
    );
  }

  // ==========================================
  // Protection expand / collapse icon
  // ==========================================

  Widget _protectionExpandIcon(BuildContext context) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final expanded = option['expanded'] == true;

    final classes = ElementSettings.classList(
      theme[node['themeKey'] ?? 'link'],
    );

    return Icon(
      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      size: _iconSize(node['size'] ?? 'md'),
      color: ElementSettings.textColor(context, classes),
    );
  }

  // ==========================================
  // Apply utility spacing classes
  // ==========================================

  Widget _applyNodeClasses(BuildContext context, Widget child) {
    final classes = ElementSettings.classList(node['classes']);

    if (classes.isEmpty) return child;

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      child: child,
    );
  }

  Widget _applyDashedBorderIfNeeded({
    required Widget child,
    required List<String> classes,
  }) {
    if (!ElementSettings.hasDashedBorder(classes)) {
      return child;
    }

    return QDriveDashedBorder(classes: classes, child: child);
  }

  // ==========================================
  // Generic container
  // ==========================================

  Widget _container(BuildContext context) {
    final themeClasses = ElementSettings.classList(theme[node['themeKey']]);
    final childNode = node['child'];

    final children = _children();

    // Progress width support
    final progressKey = node['progressKey'];
    final progressValue = progressKey is String ? _read(progressKey) : null;
    final progress = progressValue is num
        ? progressValue.toDouble().clamp(0.0, 1.0)
        : null;

    final nodeClasses = ElementSettings.classList(node['classes']);
    final classes = [...themeClasses, ...nodeClasses];

    final height =
        _doubleOrNull(node['height']) ??
        ElementSettings.height(context, classes);

    // Use parent width, not screen width, for progress fill.
    if (progress != null) {
      final progressBuilt = FractionallySizedBox(
        widthFactor: progress,
        alignment: Alignment.centerLeft,
        child: Container(
          height: height,
          padding: ElementSettings.padding(themeClasses),
          decoration: ElementSettings.decoration(context, classes),
          alignment: _alignmentOrNull(node['alignment']),
          child: childNode != null
              ? _child(Map<dynamic, dynamic>.from(childNode))
              : children.isNotEmpty
              ? Column(
                  crossAxisAlignment: _crossAxis(node['crossAxis']),
                  mainAxisAlignment: _mainAxis(node['mainAxis']),
                  children: children.map(_child).toList(),
                )
              : null,
        ),
      );

      final VoidCallback? onTap = _resolveOnTap(context);

      if (onTap == null) {
        return progressBuilt;
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: progressBuilt,
      );
    }

    Widget built = Container(
      width: node['fullWidth'] == true
          ? double.infinity
          : _doubleOrNull(node['width']) ??
                ElementSettings.width(context, classes),
      height: height,
      padding: ElementSettings.padding(themeClasses),
      decoration: ElementSettings.decoration(context, classes),
      alignment: _alignmentOrNull(node['alignment']),
      child: childNode != null
          ? _child(Map<dynamic, dynamic>.from(childNode))
          : Column(
              crossAxisAlignment: _crossAxis(node['crossAxis']),
              mainAxisAlignment: _mainAxis(node['mainAxis']),
              children: children.map(_child).toList(),
            ),
    );

    built = _applyDashedBorderIfNeeded(child: built, classes: classes);
    final VoidCallback? onTap = _resolveOnTap(context);

    if (onTap == null) {
      return built;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: built,
    );
  }

  VoidCallback? _resolveOnTap(BuildContext context) {
    final action = node['action'];

    if (action is Map) {
      return () {
        //  final actionMap = Map<dynamic, dynamic>.from(action);
        final actionMap = _resolveActionKeys(
          Map<dynamic, dynamic>.from(action),
        );
        final type = actionMap['type']?.toString();

        final params = actionMap['params'] is Map
            ? Map<dynamic, dynamic>.from(actionMap['params'])
            : <String, dynamic>{};

        _printCurrentDataForDebug();

        final container = ProviderScope.containerOf(context);

        switch (type) {
          case 'tour_previous':
            container.read(virtualTourProvider.notifier).rotateLeft();
            return;

          case 'tour_next':
            container.read(virtualTourProvider.notifier).rotateRight();
            return;

          case 'tour_zoom_in':
            container.read(virtualTourProvider.notifier).zoomIn();
            return;

          case 'tour_zoom_out':
            container.read(virtualTourProvider.notifier).zoomOut();
            return;

          case 'tour_exterior':
            container.read(virtualTourProvider.notifier).setMode('Exterior');
            return;

          case 'tour_interior':
            container.read(virtualTourProvider.notifier).setMode('Interior');
            return;

          case 'tour_dashboard':
            container.read(virtualTourProvider.notifier).dashboardView();
            return;

          case 'tour_front_seats':
            container.read(virtualTourProvider.notifier).frontSeatsView();
            return;

          case 'tour_back_seats':
            container.read(virtualTourProvider.notifier).backSeatsView();
            return;

          case 'tour_trunk':
            container.read(virtualTourProvider.notifier).trunkView();
            return;

          case 'tour_reset':
            container.read(virtualTourProvider.notifier).reset();
            return;

          case 'dynamic_action':
            final paramKey = actionMap['paramKey']?.toString();
            final resolvedType = paramKey == null ? null : _read(paramKey);

            if (resolvedType != null) {
              ActionHandler.handle(context, {
                "type": resolvedType.toString(),
                "params": {},
              });
            }
            return;
        }

        ActionHandler.handle(context, actionMap);
      };
    }

    final onTapKey = node['onTapKey'];

    if (onTapKey is! String || onTapKey.isEmpty) {
      return null;
    }

    final resolved = _read(onTapKey);

    if (resolved is VoidCallback) return resolved;

    if (resolved is String) {
      final callback = data[resolved];
      if (callback is VoidCallback) return callback;
    }

    final directCallback = data[onTapKey];
    if (directCallback is VoidCallback) return directCallback;

    return null;
  }

  Map<dynamic, dynamic> _resolveActionKeys(Map<dynamic, dynamic> action) {
    const literalKeyParams = {
      'trayKey',
      'dialogKey',
      'screenKey',
      'cacheKey',
      'routeKey',
    };

    dynamic resolveValue(dynamic value) {
      if (value is List) {
        return value.map(resolveValue).toList();
      }

      if (value is Map) {
        final output = <String, dynamic>{};

        value.forEach((rawKey, rawValue) {
          final key = rawKey.toString();

          if (key.endsWith('Key') && rawValue is String) {
            if (literalKeyParams.contains(key)) {
              output[key] = rawValue;
              return;
            }

            final outputKey = key.substring(0, key.length - 3);
            final resolvedValue = _read(rawValue);

            if (resolvedValue != null) {
              output[outputKey] = resolvedValue;
            } else {
              output[key] = rawValue;
            }

            return;
          }

          output[key] = resolveValue(rawValue);
        });

        return output;
      }

      return value;
    }

    return Map<dynamic, dynamic>.from(resolveValue(action));
  }

  dynamic _jsonSafe(dynamic value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is List) {
      return value.map(_jsonSafe).toList();
    }

    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _jsonSafe(val)));
    }

    return value.toString();
  }

  void _printCurrentDataForDebug() {
    const encoder = JsonEncoder.withIndent('  ');

    // debugPrint('================ TAPPED CONTAINER DATA ================');
    // debugPrint(encoder.convert(_jsonSafe(data)));
    // debugPrint('=======================================================');
  }

  // ==========================================
  // Row layout
  // ==========================================

  Widget _row(BuildContext context) {
    final children = _children();

    return Row(
      mainAxisAlignment: _mainAxis(node['mainAxis']),
      crossAxisAlignment: _crossAxis(node['crossAxis']),
      mainAxisSize: _mainAxisSize(node['mainAxisSize']),
      children: children.map((childNode) {
        return _withFlex(childNode, _child(childNode));
      }).toList(),
    );
  }

  // ==========================================
  // Column layout
  // ==========================================

  Widget _column(BuildContext context) {
    final children = _children();

    return Column(
      mainAxisAlignment: _mainAxis(node['mainAxis']),
      crossAxisAlignment: _crossAxis(node['crossAxis']),
      mainAxisSize: _mainAxisSize(node['mainAxisSize']),
      children: children.map((childNode) {
        return _withFlex(childNode, _child(childNode));
      }).toList(),
    );
  }

  // ==========================================
  // Wrap layout
  // ==========================================

  Widget _wrap(BuildContext context) {
    final children = _children();

    return Wrap(
      spacing: _doubleValue(node['spacing'], 8),
      runSpacing: _doubleValue(node['runSpacing'], 0),
      alignment: _wrapAlignment(node['alignment']),
      crossAxisAlignment: _wrapCrossAxis(node['crossAxis']),
      children: children.map(_child).toList(),
    );
  }

  // ==========================================
  // Stack layout
  // ==========================================

  Widget _stack(BuildContext context) {
    final children = _children();

    final fit = node['fit']?.toString() == 'expand'
        ? StackFit.expand
        : StackFit.loose;

    return Stack(
      fit: fit,
      clipBehavior: Clip.none,
      children: children.map(_child).toList(),
    );
  }

  Widget _positioned(BuildContext context) {
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});
    final classes = ElementSettings.classList(node['classes']);

    final left = _doubleOrNull(node['left']);
    final right = _doubleOrNull(node['right']);
    final top = _doubleOrNull(node['top']);
    final bottom = _doubleOrNull(node['bottom']);
    final width = _doubleOrNull(node['width']);
    final height = _doubleOrNull(node['height']);

    final hasPositionValue =
        left != null ||
        right != null ||
        top != null ||
        bottom != null ||
        width != null ||
        height != null;

    // Previous behaviour:
    // If no left/right/top/bottom/width/height is provided,
    // use Positioned.fill and align the child inside it.
    if (!hasPositionValue) {
      return Positioned.fill(
        child: Container(
          margin: ElementSettings.margin(classes),
          padding: ElementSettings.padding(classes),
          child: Align(
            alignment: _alignment(node['alignment']),
            child: _child(childNode),
          ),
        ),
      );
    }

    // New behaviour:
    // Supports JSON values like:
    // { "type": "positioned", "bottom": 0, "left": 0, "right": 0 }
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      width: width,
      height: height,
      child: Container(
        margin: ElementSettings.margin(classes),
        padding: ElementSettings.padding(classes),
        child: node['alignment'] != null
            ? Align(
                alignment: _alignment(node['alignment']),
                child: _child(childNode),
              )
            : _child(childNode),
      ),
    );
  }
  // ==========================================
  // Align layout
  // ==========================================

  Widget _align(BuildContext context) {
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return Align(
      alignment: _alignment(node['alignment']),
      child: _child(childNode),
    );
  }

  // ==========================================
  // Text primitive
  //
  // Supports:
  // - themeKey
  // - classListKey for dynamic row classes
  // - key
  // - value
  // - textAlign
  // - maxLines
  // - ellipsis
  // ==========================================

  Widget _text(BuildContext context) {
    final classListKey = node['classListKey'];
    final dynamicClasses = classListKey is String ? _read(classListKey) : null;

    final classes = ElementSettings.classList(
      dynamicClasses ?? theme[node['themeKey']],
    );

    final value = _read(node['key'] ?? '') ?? node['value'] ?? '';

    return Text(
      value.toString(),
      maxLines: node['maxLines'],
      overflow: node['overflow'] == 'ellipsis' ? TextOverflow.ellipsis : null,

      textAlign: _textAlign(node['textAlign']),
      style: ElementSettings.textStyle(context, classes),
    );
  }

  // ==========================================
  // Icon primitive
  // ==========================================

  Widget _icon(BuildContext context) {
    final classes = ElementSettings.classList(theme[node['themeKey']]);
    final icon = _read(node['key'] ?? '') ?? node['icon'];

    if (icon == null) {
      return const SizedBox.shrink();
    }

    final Color? color = classes.isEmpty
        ? null
        : ElementSettings.textColor(context, classes);

    return ElementIcons.show(
      context,
      icon,
      size: _iconSize(node['size']),
      color: color,
    );
  }
  // ==========================================
  // Chip primitive
  // ==========================================

  Widget _chip(BuildContext context) {
    final classes = ElementSettings.classList(theme[node['themeKey']]);
    final iconClasses = ElementSettings.classList(theme[node['iconThemeKey']]);

    final label = _read(node['labelKey'] ?? '') ?? node['label'];
    final icon = _read(node['iconKey'] ?? '') ?? node['icon'];

    if (label == null && icon == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            ElementIcons.show(
              context,
              icon,
              size: _iconSize(node['iconSize']),
              color: ElementSettings.textColor(
                context,
                iconClasses.isNotEmpty ? iconClasses : classes,
              ),
            ),
            if (label != null) const SizedBox(width: 4),
          ],
          if (label != null)
            Text(
              label.toString(),
              style: ElementSettings.textStyle(context, classes),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // Rating primitive
  // ==========================================

  Widget _rating(BuildContext context) {
    final rating = _read(node['key'] ?? 'rating');

    if (rating is! Map) {
      return const SizedBox.shrink();
    }

    final iconClasses = ElementSettings.classList(
      theme[node['iconThemeKey'] ?? 'ratingIcon'],
    );

    final valueClasses = ElementSettings.classList(
      theme[node['valueThemeKey'] ?? 'ratingValue'],
    );

    final reviewsClasses = ElementSettings.classList(
      theme[node['reviewsThemeKey'] ?? 'ratingReviews'],
    );

    final icon = rating['icon'] ?? 'star';
    final value = rating['value']?.toString() ?? '';
    final reviews = rating['reviews'];

    final showReviews = node['showReviews'] != false && reviews != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElementIcons.show(
              context,
              icon,
              size: _iconSize(node['iconSize'] ?? 'lg'),
              color: ElementSettings.textColor(context, iconClasses),
            ),

            const SizedBox(width: 6),

            Text(
              value,
              style: ElementSettings.textStyle(context, valueClasses),
            ),
          ],
        ),

        if (showReviews) ...[
          const SizedBox(height: 8),
          Text(
            '$reviews reviews',
            textAlign: TextAlign.right,
            style: ElementSettings.textStyle(context, reviewsClasses),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // Price box primitive
  // ==========================================

  Widget _priceBox(BuildContext context) {
    final price = _read(node['key'] ?? '');

    if (price is! Map) {
      return const SizedBox.shrink();
    }

    final boxClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'priceBox'],
    );

    final labelClasses = ElementSettings.classList(
      theme[node['labelThemeKey'] ?? 'priceLabel'],
    );

    final valueClasses = ElementSettings.classList(
      theme[node['valueThemeKey'] ?? 'priceValue'],
    );

    final suffixClasses = ElementSettings.classList(
      theme[node['suffixThemeKey'] ?? 'priceSuffix'],
    );

    final label = node['label'] ?? '';
    final value = price['value'] ?? 0;
    final suffix = _suffix(price);

    return Container(
      padding: ElementSettings.padding(boxClasses),
      decoration: ElementSettings.decoration(context, boxClasses),
      child: Column(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        children: [
          if (label.toString().isNotEmpty)
            Text(
              label.toString(),
              style: ElementSettings.textStyle(context, labelClasses),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  '${currencySymbol(currency)}$value',
                  overflow: TextOverflow.ellipsis,
                  style: ElementSettings.textStyle(context, valueClasses),
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    suffix,
                    overflow: TextOverflow.ellipsis,
                    style: ElementSettings.textStyle(context, suffixClasses),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Image slider primitive
  // ==========================================

  Widget _imageSlider(BuildContext context) {
    final themeKey = node['themeKey'] ?? 'imageSlider';

    final sliderTheme = Map<dynamic, dynamic>.from(theme[themeKey] ?? {});
    final sliderConfig = Map<dynamic, dynamic>.from(
      config['imageSlider'] ?? {},
    );

    final sliderData = {
      ...sliderTheme,
      ...sliderConfig,
      "images": _read(node['key'] ?? 'images') ?? [],
      "currentIndex":
          _read(node['currentIndexKey'] ?? 'currentImageIndex') ?? 0,
    };

    final slider = ImageSlider(data: sliderData, fallbackHeight: 220);

    final fullBleed =
        node['fullBleed'] == true ||
        sliderData['fullBleed'] == true ||
        ElementSettings.classList(sliderData['classes']).contains('w-screen');

    if (!fullBleed) return slider;

    return OverflowBox(
      alignment: Alignment.topCenter,
      minWidth: MediaQuery.of(context).size.width,
      maxWidth: MediaQuery.of(context).size.width,
      child: SizedBox(width: MediaQuery.of(context).size.width, child: slider),
    );
  }
  // ==========================================
  // Image primitive
  //
  // Supports:
  // - network images
  // - asset images
  // - rounded corners from theme classes
  // - width / height from JSON
  // - safe fallback when image fails
  // ==========================================

  Widget _image(BuildContext context) {
    final themeClasses = ElementSettings.classList(theme[node['themeKey']]);
    final nodeClasses = ElementSettings.classList(node['classes']);

    final classes = [...themeClasses, ...nodeClasses];

    final imageValue = _read(node['key'] ?? '') ?? node['url'];
    final imageUrl = imageValue?.toString() ?? '';

    final width = _safeImageDimension(
      _doubleOrNull(node['width']) ?? ElementSettings.width(context, classes),
    );

    final height = _safeImageDimension(
      _doubleOrNull(node['height']) ?? ElementSettings.height(context, classes),
    );

    final useFullWidth = classes.contains('w-full');

    if (imageUrl.isEmpty) {
      return SizedBox(
        width: useFullWidth ? double.infinity : width,
        height: height,
        child: _imageFallback(
          context,
          classes: classes,
          width: width,
          height: height,
        ),
      );
    }

    final borderRadius = ElementSettings.radius(classes);
    final fit = _boxFit(node['fit'] ?? _fitFromClasses(classes));

    final imageWidget =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://')
        ? Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) {
              return _imageFallback(
                context,
                classes: classes,
                width: width,
                height: height,
              );
            },
          )
        : Image.asset(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) {
              return _imageFallback(
                context,
                classes: classes,
                width: width,
                height: height,
              );
            },
          );

    return SizedBox(
      width: useFullWidth ? double.infinity : width,
      height: height,
      child: ClipRRect(borderRadius: borderRadius, child: imageWidget),
    );
  }

  double? _safeImageDimension(double? value) {
    if (value == null) return null;
    if (value.isInfinite || value.isNaN) return null;
    return value;
  }

  // ==========================================
  // Image fallback
  // ==========================================

  Widget _imageFallback(
    BuildContext context, {
    required List<String> classes,
    double? width,
    double? height,
  }) {
    return ClipRRect(
      borderRadius: ElementSettings.radius(classes),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        color: ElementSettings.background(context, ['bg-muted']),
        child: const Icon(Icons.image_not_supported_outlined, size: 22),
      ),
    );
  }

  // ==========================================
  // Divider primitive
  // ==========================================

  Widget _divider(BuildContext context) {
    final themeKey = node['themeKey'];

    final classes = ElementSettings.classList(
      themeKey != null ? theme[themeKey] : node['classes'],
    );

    return Container(
      height: _doubleValue(node['height'], 1),
      width: double.infinity,
      color: ElementSettings.borderColor(
        context,
        classes.isNotEmpty ? classes : ['border-muted'],
      ),
    );
  }

  // ==========================================
  // Dynamic loop renderer
  // ==========================================

  Widget _forEach(BuildContext context, WidgetRef ref) {
    final items = _read(node['itemsKey'] ?? '');

    if (items is! List) {
      return const SizedBox.shrink();
    }

    final itemName = node['itemName'] ?? 'item';
    final layout = node['layout'] ?? 'wrap';
    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});
    final expanded = node['expanded'] == true;

    final itemClasses = ElementSettings.classList(
      node['itemClasses'] ?? node['classes'],
    );

    final selectedBilling = itemName == 'plan'
        ? ref.watch(qdrivePassBillingProvider)
        : null;

    final renderedChildren = items.asMap().entries.map((entry) {
      final index = entry.key;
      final rawItem = entry.value;

      final newLocals = Map<dynamic, dynamic>.from(locals);

      dynamic itemValue = rawItem;

      if (itemName == 'plan' && rawItem is Map && selectedBilling != null) {
        itemValue = _applyQdrivePassBilling(
          Map<dynamic, dynamic>.from(rawItem),
          selectedBilling,
        );
      }

      newLocals[itemName] = itemValue;

      Widget child = JsonLayoutRenderer(
        node: childNode,
        data: data,
        theme: theme,
        config: config,
        currency: currency,
        locals: newLocals,
      );

      if (itemClasses.isNotEmpty) {
        child = Container(
          padding: ElementSettings.padding(itemClasses),
          child: child,
        );
      }

      if (expanded) {
        child = Expanded(child: child);
      }

      return child;
    }).toList();

    if (layout == 'row') {
      return Row(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        children: renderedChildren,
      );
    }

    if (layout == 'column') {
      return Column(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        children: renderedChildren,
      );
    }

    return Wrap(
      spacing: _doubleValue(node['spacing'], 8),
      runSpacing: _doubleValue(node['runSpacing'], 0),
      children: renderedChildren,
    );
  }

  Map<dynamic, dynamic> _applyQdrivePassBilling(
    Map<dynamic, dynamic> plan,
    String selectedBilling,
  ) {
    final billing = plan['billing'];

    if (billing is! Map) {
      return plan;
    }

    final selectedBillingData = billing[selectedBilling];

    if (selectedBillingData is! Map) {
      return plan;
    }

    return {
      ...plan,
      ...Map<dynamic, dynamic>.from(selectedBillingData),
      "selectedBilling": selectedBilling,
    };
  }

  // ==========================================
  // Option tile wrapper
  //
  // Makes a fully custom JSON tile selectable.
  //
  // Expected JSON:
  // {
  //   "type": "option_tile",
  //   "key": "option",
  //   "sectionIdKey": "sectionId",
  //   "themeKey": "option",
  //   "selectedThemeKey": "selectedOption",
  //   "child": {...}
  // }
  // ==========================================

  Widget _optionTile(BuildContext context, WidgetRef ref) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final selected = option['selected'] == true;

    final optionClasses = ElementSettings.classList(
      selected
          ? theme[node['selectedThemeKey'] ?? 'selectedOption']
          : theme[node['themeKey'] ?? 'option'],
    );

    final sectionId =
        _read(node['sectionIdKey'] ?? 'sectionId')?.toString() ?? '';

    final optionId = option['id']?.toString() ?? '';

    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref
            .read(checkoutOptionProvider.notifier)
            .selectOption(sectionId: sectionId, optionId: optionId);

        if (sectionId == 'mileage') {
          ref.read(selectedMileageOptionProvider.notifier).state =
              Map<dynamic, dynamic>.from(option);
        }
      },
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(optionClasses),
        decoration: ElementSettings.decoration(context, optionClasses),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  // ==========================================
  // Option radio
  //
  // Reads selected state from the current option.
  // ==========================================

  Widget _optionRadio(BuildContext context) {
    final option = _read(node['key'] ?? 'option');

    if (option is! Map) {
      return const SizedBox.shrink();
    }

    final selected = option['selected'] == true;

    final radioClasses = ElementSettings.classList(
      selected
          ? theme[node['selectedThemeKey'] ?? 'selectedRadio']
          : theme[node['themeKey'] ?? 'radio'],
    );

    return RadioDot(selected: selected, classes: radioClasses);
  }

  // ==========================================
  // Calculate distance button
  //
  // Keeps the action in the renderer.
  // Visual content stays custom through child.
  // ==========================================

  Widget _calculateDistanceButton(BuildContext context, WidgetRef ref) {
    final sectionId =
        _read(node['sectionIdKey'] ?? 'sectionId')?.toString() ?? '';

    final selectedOption = _read(node['optionKey'] ?? 'selectedOption');

    if (selectedOption is! Map) {
      return const SizedBox.shrink();
    }

    final calculation = Map<dynamic, dynamic>.from(
      selectedOption['calculation'] ?? {},
    );

    final buttonClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'calculateButton'],
    );

    final childNode = node['child'] is Map
        ? Map<dynamic, dynamic>.from(node['child'])
        : {
            "type": "text",
            "key": "calculation.buttonLabel",
            "themeKey": "calculateButtonLabel",
            "textAlign": "center",
          };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref
            .read(checkoutOptionProvider.notifier)
            .calculateDistance(
              sectionId: sectionId,
              option: Map<dynamic, dynamic>.from(selectedOption),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              calculation['successMessage']?.toString() ??
                  'Distance calculated successfully.',
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: _doubleValue(node['height'], 34),
        alignment: Alignment.center,
        padding: ElementSettings.padding(buttonClasses),
        decoration: ElementSettings.decoration(context, buttonClasses),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }

  // ==========================================
  // Selectable time slot
  //
  // Keeps time selection action in renderer.
  // ==========================================

  Widget _timeSlot(BuildContext context, WidgetRef ref) {
    final slot = _read(node['key'] ?? 'slot');

    if (slot is! Map) {
      return const SizedBox.shrink();
    }

    final sectionId =
        _read(node['sectionIdKey'] ?? 'sectionId')?.toString() ?? '';

    final slotId = slot['id']?.toString() ?? '';

    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    final isActive =
        slot['active'] == true ||
        slot['selected'] == true ||
        slot['isSelected'] == true;

    final dynamicClasses = slot['slotClasses'];

    final slotClasses = ElementSettings.classList(
      isActive
          ? dynamicClasses ?? theme[node['themeKey']]
          : ["bg-surface", "border-muted", "rounded-lg", "p-sm"],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref
            .read(checkoutOptionProvider.notifier)
            .selectTime(sectionId: sectionId, timeId: slotId);
      },
      child: Container(
        width: node['fullWidth'] == true ? double.infinity : null,
        height: _doubleValue(node['height'], 42),
        alignment: Alignment.center,
        padding: ElementSettings.padding(slotClasses),
        decoration: ElementSettings.decoration(context, slotClasses),
        child: JsonLayoutRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          currency: currency,
          locals: locals,
        ),
      ),
    );
  }
  // ==========================================
  // Render child helper
  // ==========================================

  Widget _child(Map<dynamic, dynamic> childNode) {
    return JsonLayoutRenderer(
      node: childNode,
      data: data,
      theme: theme,
      config: config,
      currency: currency,
      locals: locals,
    );
  }

  // ==========================================
  // Expanded helper
  // ==========================================

  Widget _withFlex(Map<dynamic, dynamic> childNode, Widget child) {
    final flex = childNode['flex'];

    if (flex is int && flex > 0) {
      return Expanded(flex: flex, child: child);
    }

    return child;
  }

  // ==========================================
  // Children helper
  // ==========================================

  List<Map<dynamic, dynamic>> _children() {
    return List<Map<dynamic, dynamic>>.from(node['children'] ?? []);
  }

  // ==========================================
  // Suffix helper
  // ==========================================

  String _suffix(Map price) {
    final template = node['suffixTemplate'];

    if (template is String) {
      var result = template;

      price.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });

      return result;
    }

    return node['suffix']?.toString() ?? '';
  }

  // ==========================================
  // Deep object reader
  //
  // Supports:
  // - title
  // - rating.value
  // - option.title
  // - calculation.timeSlots
  // - slot.textClasses
  // ==========================================

  dynamic _read(String path) {
    if (path.isEmpty) return null;

    dynamic current;

    final firstKey = path.split('.').first;

    if (locals.containsKey(firstKey)) {
      current = locals;
    } else {
      current = data;
    }

    for (final key in path.split('.')) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  // ==========================================
  // Visibility helper
  //
  // Supported:
  // - option.description != null
  // - option.price == null
  // - showCalculationPanel == true
  // - calculation.calculated == true
  // ==========================================

  bool _isVisible(WidgetRef ref) {
    final condition = node['visibleWhen'];

    if (condition == null) return true;

    if (condition is bool) return condition;

    if (condition is String) {
      final trimmedCondition = condition.trim();

      if (trimmedCondition.endsWith('!= null')) {
        final path = trimmedCondition.replaceAll('!= null', '').trim();
        final actual = _readVisibilityValue(ref, path);
        return _hasVisibleValue(actual);
      }

      if (trimmedCondition.endsWith('== null')) {
        final path = trimmedCondition.replaceAll('== null', '').trim();
        final actual = _readVisibilityValue(ref, path);
        return !_hasVisibleValue(actual);
      }

      if (trimmedCondition.contains('==')) {
        final parts = trimmedCondition.split('==');

        if (parts.length == 2) {
          final path = parts[0].trim();

          final expected = parts[1]
              .trim()
              .replaceAll('"', '')
              .replaceAll("'", '');

          final actual = _readVisibilityValue(ref, path);

          return actual.toString() == expected;
        }
      }

      if (trimmedCondition.contains('!=')) {
        final parts = trimmedCondition.split('!=');

        if (parts.length == 2) {
          final path = parts[0].trim();

          final expected = parts[1]
              .trim()
              .replaceAll('"', '')
              .replaceAll("'", '');

          final actual = _readVisibilityValue(ref, path);

          return actual.toString() != expected;
        }
      }
    }

    return true;
  }

  dynamic _readVisibilityValue(WidgetRef ref, String path) {
    final returnState = ref.watch(returnVehicleUiProvider);

    switch (path) {
      case 'returnUi.photosUploaded':
        return returnState.photosUploaded;

      case 'returnUi.inspectionComplete':
        return returnState.inspectionComplete;

      case 'returnUi.showReturnLaterBar':
        return !(returnState.photosUploaded && returnState.inspectionComplete);

      default:
        return _read(path);
    }
  }

  bool _hasVisibleValue(dynamic value) {
    if (value == null) return false;

    if (value is String) {
      return value.trim().isNotEmpty;
    }

    if (value is List) {
      return value.isNotEmpty;
    }

    if (value is Map) {
      return value.isNotEmpty;
    }

    return true;
  }

  // ==========================================
  // Main axis helper
  // ==========================================

  MainAxisAlignment _mainAxis(dynamic value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;

      case 'end':
        return MainAxisAlignment.end;

      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;

      case 'spaceAround':
        return MainAxisAlignment.spaceAround;

      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;

      default:
        return MainAxisAlignment.start;
    }
  }

  // ==========================================
  // Main axis size helper
  // ==========================================

  MainAxisSize _mainAxisSize(dynamic value) {
    switch (value) {
      case 'min':
        return MainAxisSize.min;

      case 'max':
      default:
        return MainAxisSize.max;
    }
  }

  // ==========================================
  // Cross axis helper
  // ==========================================

  CrossAxisAlignment _crossAxis(dynamic value) {
    switch (value) {
      case 'center':
        return CrossAxisAlignment.center;

      case 'end':
        return CrossAxisAlignment.end;

      case 'stretch':
        return CrossAxisAlignment.stretch;

      default:
        return CrossAxisAlignment.start;
    }
  }

  // ==========================================
  // Wrap alignment helper
  // ==========================================

  WrapAlignment _wrapAlignment(dynamic value) {
    switch (value) {
      case 'center':
        return WrapAlignment.center;

      case 'end':
        return WrapAlignment.end;

      case 'spaceBetween':
        return WrapAlignment.spaceBetween;

      case 'spaceAround':
        return WrapAlignment.spaceAround;

      case 'spaceEvenly':
        return WrapAlignment.spaceEvenly;

      default:
        return WrapAlignment.start;
    }
  }

  // ==========================================
  // Wrap cross axis helper
  // ==========================================

  WrapCrossAlignment _wrapCrossAxis(dynamic value) {
    switch (value) {
      case 'center':
        return WrapCrossAlignment.center;

      case 'end':
        return WrapCrossAlignment.end;

      default:
        return WrapCrossAlignment.start;
    }
  }

  // ==========================================
  // Alignment helper
  // ==========================================

  Alignment _alignment(dynamic value) {
    switch (value) {
      case 'topRight':
        return Alignment.topRight;

      case 'topLeft':
        return Alignment.topLeft;

      case 'bottomRight':
        return Alignment.bottomRight;

      case 'bottomLeft':
        return Alignment.bottomLeft;

      case 'centerRight':
        return Alignment.centerRight;

      case 'centerLeft':
        return Alignment.centerLeft;

      case 'bottomCenter':
        return Alignment.bottomCenter;

      case 'topCenter':
        return Alignment.topCenter;

      case 'center':
        return Alignment.center;

      default:
        return Alignment.topLeft;
    }
  }

  // ==========================================
  // Nullable alignment helper for Container
  // ==========================================

  Alignment? _alignmentOrNull(dynamic value) {
    if (value == null) return null;

    return _alignment(value);
  }

  // ==========================================
  // Text align helper
  // ==========================================

  TextAlign? _textAlign(dynamic value) {
    switch (value) {
      case 'center':
        return TextAlign.center;

      case 'right':
        return TextAlign.right;

      case 'left':
        return TextAlign.left;

      default:
        return null;
    }
  }

  // ==========================================
  // Icon size helper
  // ==========================================

  double _iconSize(dynamic value) {
    switch (value) {
      case 'sm':
        return 12;

      case 'md':
        return 16;

      case 'lg':
        return 20;

      case 'xl':
        return 22;
      case '2xl':
        return 28;
      case '3xl':
        return 32;
      case '4xl':
        return 36;

      default:
        return 16;
    }
  }

  // ==========================================
  // BoxFit helper
  // ==========================================

  BoxFit _boxFit(dynamic value) {
    switch (value) {
      case 'contain':
        return BoxFit.contain;

      case 'fill':
        return BoxFit.fill;

      case 'fitWidth':
        return BoxFit.fitWidth;

      case 'fitHeight':
        return BoxFit.fitHeight;

      case 'none':
        return BoxFit.none;

      case 'cover':
      default:
        return BoxFit.cover;
    }
  }

  // ==========================================
  // Reads object-fit classes
  // ==========================================

  String _fitFromClasses(List<String> classes) {
    if (classes.contains('object-contain')) {
      return 'contain';
    }

    if (classes.contains('object-fill')) {
      return 'fill';
    }

    if (classes.contains('object-fit-width')) {
      return 'fitWidth';
    }

    if (classes.contains('object-fit-height')) {
      return 'fitHeight';
    }

    return 'cover';
  }

  // ==========================================
  // Safe double helper
  // ==========================================

  double _doubleValue(dynamic value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;

    return fallback;
  }

  // ==========================================
  // Nullable double helper
  // ==========================================

  double? _doubleOrNull(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);

    return null;
  }
}

class _GroupedInputFormatter extends TextInputFormatter {
  final int groupSize;
  final String separator;

  const _GroupedInputFormatter({
    required this.groupSize,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % groupSize == 0) {
        buffer.write(separator);
      }

      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _JsonFormField extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> field;
  final Map<dynamic, dynamic> theme;

  const _JsonFormField({required this.field, required this.theme});

  @override
  ConsumerState<_JsonFormField> createState() => _JsonFormFieldState();
}

class _JsonFormFieldState extends ConsumerState<_JsonFormField> {
  late final TextEditingController _controller;
  final LayerLink _dropdownLayerLink = LayerLink();
  final GlobalKey _dropdownFieldKey = GlobalKey();

  OverlayEntry? _dropdownOverlayEntry;
  bool _dropdownOpen = false;

  void _storeValue(dynamic value) {
    JsonFormValueStore.setValue(_fieldId, value?.toString().trim() ?? '');
  }

  String get _fieldId {
    return (widget.field['id'] ??
            widget.field['key'] ??
            widget.field['label'] ??
            '')
        .toString();
  }

  bool get _isDropdown {
    final type = widget.field['type']?.toString();
    return type == 'dropdown' || type == 'select';
  }

  bool get _isDate {
    return widget.field['type']?.toString() == 'date';
  }

  bool get _isTextarea {
    return widget.field['type']?.toString() == 'textarea' ||
        widget.field['keyboardType']?.toString() == 'multiline';
  }

  bool get _isObscure {
    return widget.field['obscureText'] == true;
  }

  int get _resolvedMinLines {
    if (_isObscure) return 1;

    if (_isTextarea) {
      return _intValue(widget.field['minLines'], 5);
    }

    return _intValue(widget.field['minLines'], 1);
  }

  int get _resolvedMaxLines {
    if (_isObscure) return 1;

    final minLines = _resolvedMinLines;

    final maxLines = _isTextarea
        ? _intValue(widget.field['maxLines'], 7)
        : _intValue(widget.field['maxLines'], 1);

    return maxLines < minLines ? minLines : maxLines;
  }

  @override
  void initState() {
    super.initState();

    final storedProviderValue = ref.read(checkoutFormProvider)[_fieldId];
    final storedLocalValue = JsonFormValueStore.getValue(_fieldId);
    final initialValue = widget.field['value']?.toString() ?? '';

    final resolvedValue =
        storedProviderValue?.toString() ??
        storedLocalValue?.toString() ??
        initialValue;

    _controller = TextEditingController(text: resolvedValue);

    if (resolvedValue.trim().isNotEmpty) {
      _storeValue(resolvedValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _closeDropdownOverlay();
    super.dispose();
  }

  void _closeDropdownOverlay() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;

    if (mounted && _dropdownOpen) {
      setState(() {
        _dropdownOpen = false;
      });
    }
  }

  void _openDropdownOverlay({
    required List<Map<String, String>> options,
    required String? selectedValue,
    required FormFieldState<String> fieldState,
    required List<String> textClasses,
  }) {
    _closeDropdownOverlay();

    final renderBox =
        _dropdownFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final fieldWidth = renderBox.size.width;
    final dark = Theme.of(context).brightness == Brightness.dark;

    final menuBg = dark ? const Color(0xFF1C1C1C) : Colors.white;
    final menuBorder = dark ? const Color(0xFF5C5C5C) : const Color(0xFFD7DADF);
    final itemText = dark ? Colors.white : const Color(0xFF111111);
    const selectedBg = Color(0xFF2878D0);

    setState(() {
      _dropdownOpen = true;
    });

    _dropdownOverlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDropdownOverlay,
                child: const SizedBox.expand(),
              ),
            ),

            CompositedTransformFollower(
              link: _dropdownLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 6),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: fieldWidth,
                    minWidth: fieldWidth,
                    maxHeight: 280,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: menuBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: menuBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(dark ? 0.35 : 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final value = option['value'] ?? '';
                          final label = option['label'] ?? value;
                          final selected = value == selectedValue;

                          return InkWell(
                            onTap: () {
                              _controller.text = value;

                              _storeValue(value);

                              ref
                                  .read(checkoutFormProvider.notifier)
                                  .setValue(_fieldId, value);

                              fieldState.didChange(value);

                              _closeDropdownOverlay();

                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              color: selected ? selectedBg : Colors.transparent,
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selected ? Colors.white : itemText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_dropdownOverlayEntry!);
  }

  String _dropdownLabelForValue(
    List<Map<String, String>> options,
    String? selectedValue,
  ) {
    if (selectedValue == null || selectedValue.trim().isEmpty) {
      return widget.field['placeholder']?.toString() ?? '';
    }

    for (final option in options) {
      if (option['value'] == selectedValue) {
        return option['label'] ?? selectedValue;
      }
    }

    return selectedValue;
  }

  List<Map<String, String>> _dropdownOptions() {
    final rawOptions = widget.field['options'];

    if (rawOptions is! List) return [];

    return rawOptions
        .map((item) {
          if (item is Map) {
            final label = item['label']?.toString() ?? '';
            final value = item['value']?.toString() ?? label;

            return {"label": label, "value": value};
          }

          final text = item.toString();

          return {"label": text, "value": text};
        })
        .where((item) => (item['value'] ?? '').isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final fieldClasses = ElementSettings.classList(widget.theme['field']);
    final textClasses = ElementSettings.classList(widget.theme['fieldText']);

    final placeholderClasses = ElementSettings.classList(
      widget.theme['placeholderText'] ?? widget.theme['fieldText'],
    );

    if (_isDropdown) {
      final options = _dropdownOptions();

      String? selectedValue;

      final currentValue = _controller.text.trim();

      for (final option in options) {
        if (option['value'] == currentValue ||
            option['label'] == currentValue) {
          selectedValue = option['value'];
          break;
        }
      }

      return FormField<String>(
        initialValue: selectedValue,
        validator: (value) => _validator(widget.field, value),
        onSaved: (value) {
          _storeValue(value ?? '');
        },
        builder: (fieldState) {
          final resolvedValue = fieldState.value ?? selectedValue;
          final label = _dropdownLabelForValue(options, resolvedValue);
          final hasValue =
              resolvedValue != null && resolvedValue.trim().isNotEmpty;
          final dark = Theme.of(context).brightness == Brightness.dark;

          final borderColor = fieldState.hasError
              ? Colors.red
              : _dropdownOpen
              ? ElementSettings.borderColor(
                  context,
                  widget.field['focusedBorderClasses'] ?? ['border-primary'],
                )
              : ElementSettings.borderColor(context, fieldClasses);

          final iconColor = ElementSettings.textColor(
            context,
            ElementSettings.classList(
              widget.theme['fieldIcon'] ?? widget.theme['icon'],
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompositedTransformTarget(
                link: _dropdownLayerLink,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: _dropdownFieldKey,
                    borderRadius: ElementSettings.radius(fieldClasses),
                    onTap: () {
                      if (_dropdownOpen) {
                        _closeDropdownOverlay();
                        return;
                      }

                      _openDropdownOverlay(
                        options: options,
                        selectedValue: resolvedValue,
                        fieldState: fieldState,
                        textClasses: textClasses,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: ElementSettings.padding(fieldClasses),
                      decoration: BoxDecoration(
                        color: ElementSettings.background(
                          context,
                          fieldClasses,
                        ),
                        borderRadius: ElementSettings.radius(fieldClasses),
                        border: Border.all(
                          color: borderColor,
                          width: _dropdownOpen ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hasValue
                                  ? ElementSettings.textStyle(
                                      context,
                                      textClasses,
                                    )
                                  : ElementSettings.textStyle(
                                      context,
                                      placeholderClasses,
                                    ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          AnimatedRotation(
                            turns: _dropdownOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 160),
                            child: ElementIcons.show(
                              context,
                              widget.field['icon'] ?? 'chevron_down',
                              size: 16,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (fieldState.hasError) ...[
                const SizedBox(height: 6),
                Text(
                  fieldState.errorText ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          );
        },
      );
    }
    final hasFieldIcon =
        widget.field['icon'] != null &&
        widget.field['icon'].toString().trim().isNotEmpty;

    final showLeadingIcon = hasFieldIcon && !_isDate && !_isDropdown;

    final showTrailingIcon = _isDate;

    return TextFormField(
      controller: _controller,

      readOnly: _isDate || widget.field['readOnly'] == true,
      obscureText: _isObscure,

      minLines: _resolvedMinLines,
      maxLines: _resolvedMaxLines,

      maxLength: _maxLength(widget.field['maxLength']),

      keyboardType: _isTextarea
          ? TextInputType.multiline
          : _isDate
          ? TextInputType.datetime
          : _keyboardType(widget.field['keyboardType']),

      textInputAction: _isTextarea
          ? TextInputAction.newline
          : TextInputAction.next,

      textCapitalization: _textCapitalization(
        widget.field['textCapitalization'],
      ),

      textAlignVertical: _isTextarea
          ? TextAlignVertical.top
          : TextAlignVertical.center,

      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),

      inputFormatters: _inputFormatters(widget.field),
      validator: (value) => _validator(widget.field, value),
      onSaved: (value) {
        _storeValue(value ?? '');
      },
      style: ElementSettings.textStyle(context, textClasses),

      decoration: InputDecoration(
        counterText: '',
        hintText: widget.field['placeholder']?.toString(),
        hintStyle: ElementSettings.textStyle(context, placeholderClasses),

        filled: true,
        fillColor: ElementSettings.background(context, fieldClasses),

        contentPadding: ElementSettings.padding(fieldClasses),

        prefixIcon: showLeadingIcon
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 10),
                child: ElementIcons.show(
                  context,
                  widget.field['icon'],
                  size: 16,
                  color: ElementSettings.textColor(
                    context,
                    ElementSettings.classList(
                      widget.theme['fieldIcon'] ?? widget.theme['icon'],
                    ),
                  ),
                ),
              )
            : null,

        prefixIconConstraints: showLeadingIcon
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,

        suffixIcon: showTrailingIcon
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElementIcons.show(
                  context,
                  widget.field['icon'] ?? 'calendar',
                  size: 16,
                  color: ElementSettings.textColor(
                    context,
                    ElementSettings.classList(
                      widget.theme['fieldIcon'] ?? widget.theme['icon'],
                    ),
                  ),
                ),
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: ElementSettings.radius(fieldClasses),
          borderSide: BorderSide(
            color: ElementSettings.borderColor(context, fieldClasses),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: ElementSettings.radius(fieldClasses),
          borderSide: BorderSide(
            color: ElementSettings.borderColor(
              context,
              widget.field['focusedBorderClasses'] ?? ['border-primary'],
            ),
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: ElementSettings.radius(fieldClasses),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: ElementSettings.radius(fieldClasses),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),

      onTap: _isDate
          ? () async {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final bgColor = isDark
                  ? const Color(0xFF151515)
                  : const Color(0xFFFFFFFF);
              final textColor = isDark ? Colors.white : const Color(0xFF111111);
              final mutedColor = isDark
                  ? const Color(0xFFA1A1AA)
                  : const Color(0xFF6B7280);
              final borderColor = isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFE5E7EB);
              final selectedColor = isDark ? Colors.white : Colors.black;
              final selectedTextColor = isDark ? Colors.black : Colors.white;

              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
                initialDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme(
                        brightness: isDark ? Brightness.dark : Brightness.light,
                        primary: selectedColor,
                        onPrimary: selectedTextColor,
                        secondary: selectedColor,
                        onSecondary: selectedTextColor,
                        error: Colors.red,
                        onError: Colors.white,
                        surface: bgColor,
                        onSurface: textColor,
                      ),
                      dialogBackgroundColor: bgColor,
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: bgColor,
                        surfaceTintColor: Colors.transparent,
                        headerBackgroundColor: bgColor,
                        headerForegroundColor: textColor,
                        dividerColor: borderColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: borderColor),
                        ),
                        dayStyle: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        weekdayStyle: TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        yearStyle: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked == null) return;

              final formatted =
                  '${picked.month.toString().padLeft(2, '0')}/'
                  '${picked.day.toString().padLeft(2, '0')}/'
                  '${picked.year}';

              _controller.text = formatted;

              _storeValue(formatted);

              ref
                  .read(checkoutFormProvider.notifier)
                  .setValue(_fieldId, formatted);
            }
          : null,

      onChanged: _isDate
          ? null
          : (value) {
              _storeValue(value);

              ref.read(checkoutFormProvider.notifier).setValue(_fieldId, value);
            },
    );
  }

  int? _maxLength(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  int _intValue(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  TextInputType _keyboardType(dynamic type) {
    switch (type?.toString()) {
      case 'number':
        return TextInputType.number;

      case 'datetime':
        return TextInputType.datetime;

      case 'email':
        return TextInputType.emailAddress;

      case 'phone':
        return TextInputType.phone;

      case 'multiline':
        return TextInputType.multiline;

      default:
        return TextInputType.text;
    }
  }

  TextCapitalization _textCapitalization(dynamic value) {
    switch (value?.toString()) {
      case 'words':
        return TextCapitalization.words;

      case 'sentences':
        return TextCapitalization.sentences;

      case 'characters':
        return TextCapitalization.characters;

      case 'none':
        return TextCapitalization.none;

      default:
        return _isTextarea
            ? TextCapitalization.sentences
            : TextCapitalization.none;
    }
  }

  List<TextInputFormatter> _inputFormatters(Map<dynamic, dynamic> field) {
    final format = field['inputFormat']?.toString();

    switch (format) {
      case 'card_number':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          const _GroupedInputFormatter(groupSize: 4, separator: ' '),
        ];

      case 'expiry_date':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          const _GroupedInputFormatter(groupSize: 2, separator: '/'),
        ];

      case 'cvv':
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ];

      case 'letters_spaces':
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];

      default:
        return [];
    }
  }

  String? _validator(Map<dynamic, dynamic> field, String? value) {
    final text = value?.trim() ?? '';

    final required = field['required'] == true;
    final format = field['inputFormat']?.toString();
    final label = field['label']?.toString() ?? 'This field';
    final keyboardType = field['keyboardType']?.toString();

    if (required && text.isEmpty) {
      return '$label is required';
    }

    final minLength = field['minLength'];
    if (minLength is int && text.length < minLength) {
      return '$label must be at least $minLength characters';
    }

    final matchFieldId = field['matchFieldId']?.toString();
    if (matchFieldId != null && matchFieldId.isNotEmpty) {
      final otherValue = ref
          .read(checkoutFormProvider)[matchFieldId]
          ?.toString();

      if (otherValue != null && text != otherValue) {
        return field['matchMessage']?.toString() ?? '$label does not match';
      }
    }

    final shouldValidateEmail =
        format == 'email' ||
        keyboardType == 'email' ||
        field['type']?.toString() == 'email';

    if (shouldValidateEmail) {
      final emailRegex = RegExp(
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
      );

      if (!emailRegex.hasMatch(text)) {
        return 'Enter a valid email address';
      }
    }

    if (text.isEmpty) return null;

    if (format == 'card_number') {
      final digits = text.replaceAll(' ', '');

      if (digits.length != 16) {
        return 'Enter a valid 16-digit card number';
      }
    }

    if (format == 'expiry_date') {
      final digits = text.replaceAll('/', '');

      if (digits.length != 4) {
        return 'Enter expiry as MM/YY';
      }

      final month = int.tryParse(digits.substring(0, 2)) ?? 0;

      if (month < 1 || month > 12) {
        return 'Enter a valid month';
      }
    }

    if (format == 'cvv') {
      if (text.length < 3 || text.length > 4) {
        return 'Enter a valid CVV';
      }
    }

    return null;
  }
}
