import 'package:Qdrive/core/engine/localization/json_translator.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/shared/providers/flight_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves screen JSON into widget-ready JSON.
///
/// Keeps the raw JSON structure clean:
/// - `content` = static text/content
/// - `dynamicData` = API/cache-driven data
/// - `actions` = reusable behaviour map
/// - `ui` = layout and presentation
///
/// Important:
/// - `value` is preferred over `fallback`.
/// - Old JSON with root-level `layout` still works.
class JsonResolver {
static Map<dynamic, dynamic> resolve(
  BuildContext context,
  Map<dynamic, dynamic> json,
) {
  final resolvedJson = Map<dynamic, dynamic>.from(json);

  final actions = Map<dynamic, dynamic>.from(
    json['actions'] ?? {},
  );

  final ui = Map<dynamic, dynamic>.from(
    json['ui'] ??
        {
          "showAppBar": json['showAppBar'] != false,
          "layout": json['layout'] ?? [],
        },
  );

  final rawLayout = List<Map<dynamic, dynamic>>.from(
    ui['layout'] ?? [],
  );

  final resolvedLayout = rawLayout
      .where((item) {
        return _isVisible(json, item);
      })
      .map((item) {
        final resolvedItem = _resolveElement(
          context,
          json,
          item,
        );

        return Map<dynamic, dynamic>.from(
          _resolveActionRefsDeep(
            resolvedItem,
            actions,
          ),
        );
      })
      .toList();

  resolvedJson['ui'] = {
    ...ui,
    "layout": resolvedLayout,
  };

  return resolvedJson;
}
  static dynamic _resolveActionRefsDeep(
    dynamic value,
    Map<dynamic, dynamic> actions,
  ) {
    if (value is List) {
      return value.map((item) {
        return _resolveActionRefsDeep(item, actions);
      }).toList();
    }

    if (value is Map) {
      final map = Map<dynamic, dynamic>.from(value);

      final actionRef = map['actionRef'];

      if (actionRef is String &&
          actionRef.isNotEmpty &&
          actions[actionRef] != null &&
          map['action'] == null) {
        map['action'] = _copyAction(actions[actionRef]);
        map.remove('actionRef');
      }

      return map.map((key, child) {
        return MapEntry(key.toString(), _resolveActionRefsDeep(child, actions));
      });
    }

    return value;
  }

  /// Resolves one layout element.
  ///
  /// This method keeps the original widget structure but injects:
  /// - bound data from `bind`
  /// - resolved `...Key` props
  /// - resolved `actionRef`
  /// - item-level actions
 static Map<dynamic, dynamic> _resolveElement(
  BuildContext context,
  Map<dynamic, dynamic> rootJson,
  Map<dynamic, dynamic> item,
) {
  final resolved = Map<dynamic, dynamic>.from(item);

  final props = Map<dynamic, dynamic>.from(
    item['props'] ?? {},
  );

  final actions = Map<dynamic, dynamic>.from(
    rootJson['actions'] ?? {},
  );

  final bindPath = item['bind'];

  final boundData = bindPath is String
      ? _resolveBind(rootJson, bindPath)
      : null;

  if (boundData is Map<dynamic, dynamic>) {
    props.addAll(boundData);
  }

  dynamic readBound(String? key) {
    if (key == null) return null;

    if (boundData is Map<dynamic, dynamic>) {
      return _readPath(boundData, key);
    }

    return null;
  }

  dynamic readPath(String path) {
    return _readPath(rootJson, path);
  }

  void resolveActionRef(Map<dynamic, dynamic> map) {
    final ref = map['actionRef'];

    if (ref is String && actions[ref] != null) {
      map['action'] = _copyAction(actions[ref]);
      map.remove('actionRef');
    }
  }

  _resolveBasicKeys(
    context,
    rootJson,
    props,
    readBound,
  );

  if (item['type'] == 'payment_method_section') {
    resolved['props'] = props;

    _resolvePaymentMethod(
      resolved,
      actions,
    );

    return resolved;
  }

  if (item['type'] == 'checkout_flow') {
    resolved['props'] = props;

    _resolveCheckoutFlow(
      context,
      resolved,
      rootJson,
      actions,
    );

    return resolved;
  }

  if (item['type'] == 'active_card' ||
      item['type'] == 'active_rental_tray') {
    _resolveActiveCard(
      props,
      actions,
      readBound,
    );
  }

  if (item['type'] == 'detail_gallery') {
    _resolveGalleryActions(
      props,
      actions,
      boundData,
    );
  }

  if (item['type'] == 'bottom_bar') {
    _resolveBottomBar(
      props,
      actions,
      boundData,
    );
  }

  if (item['type'] == 'blog_post_list') {
    _resolveBlogPostActions(
      props,
      actions,
    );
  }

  if (item['type'] == 'document_upload_card') {
    _resolveDocumentUploadCard(
      context,
      rootJson,
      resolved,
      props,
      boundData,
      actions,
    );

    return resolved;
  }

  if (item['type'] == 'related_post_list') {
    _resolveBlogPostActions(
      props,
      actions,
    );
  }

  _resolveItemActions(
    props,
    actions,
  );

  _resolveButtonGroupActions(
    props,
    actions,
  );

  _resolveSort(
    props,
    actions,
    readPath,
  );

  if (item['type'] == 'list_cards') {
    _resolveListCardActions(
      props,
      actions,
    );
  }

  if (item['type'] == 'featured_card') {
    _resolveFeaturedVehicleActions(
      props,
      actions,
    );
  }

  resolveActionRef(props);

  resolved['props'] = props;

  return resolved;
}
  static void _resolveBlogPostActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
  ) {
    if (props['items'] is! List) return;

    final actionRef = props['actionRef'];

    props['items'] = List<Map<dynamic, dynamic>>.from(
      (props['items'] as List).map((rawItem) {
        final item = Map<dynamic, dynamic>.from(rawItem);

        if (actionRef is String && actions[actionRef] != null) {
          item['action'] = _injectBoundParams(actions[actionRef], item);
        }

        return item;
      }),
    );
  }

  static void _resolveFeaturedVehicleActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
  ) {
    if (props['items'] is! List) return;

    final actionRef = props['actionRef'];

    props['items'] = List<Map<dynamic, dynamic>>.from(
      (props['items'] as List).map((rawItem) {
        final item = Map<dynamic, dynamic>.from(rawItem);

        if (actionRef is String && actions[actionRef] != null) {
          item['action'] = _injectBoundParams(actions[actionRef], item);
        }

        return item;
      }),
    );
  }

  static void _resolveDocumentUploadCard(
  BuildContext context,
  Map<dynamic, dynamic> rootJson,
  Map<dynamic, dynamic> resolved,
  Map<dynamic, dynamic> props,
  dynamic boundData,
  Map<dynamic, dynamic> actions,
) {
  final documentBind = resolved['documentBind'];

  if (documentBind is String &&
      boundData is Map<dynamic, dynamic>) {
    final documentData = _readPath(
      boundData,
      documentBind,
    );

    if (documentData is Map<dynamic, dynamic>) {
      dynamic readDocument(String? key) {
        if (key == null) return null;

        return _readPath(documentData, key);
      }

      _resolveBasicKeys(
        context,
        rootJson,
        props,
        readDocument,
      );
    }
  }

  final button = props['button'];

  if (button is Map<dynamic, dynamic>) {
    final resolvedButton = Map<dynamic, dynamic>.from(button);

    final actionRef = resolvedButton['actionRef'];

    if (actionRef is String &&
        actions[actionRef] != null) {
      final action = _copyAction(actions[actionRef]);

      action['params'] = {
        ...Map<dynamic, dynamic>.from(
          action['params'] ?? {},
        ),
        "documentType": props['documentType'],
      };

      resolvedButton['action'] = action;

      resolvedButton.remove('actionRef');
    }

    props['button'] = resolvedButton;
  }

  resolved['props'] = props;
}
  static void _resolvePaymentMethod(
    Map<dynamic, dynamic> resolved,
    Map<dynamic, dynamic> actions,
  ) {
    final props = Map<dynamic, dynamic>.from(resolved['props'] ?? {});

    final paymentMethod = props['paymentMethod'];
    if (paymentMethod is Map<dynamic, dynamic>) {
      props['title'] = paymentMethod['title'];
      props['options'] = paymentMethod['options'] ?? [];
    }

    final selectedPaymentId = props['selectedPaymentId'];
    final selectedProviderId = props['selectedProviderId'];

    if (props['options'] is List) {
      props['options'] = List<Map<dynamic, dynamic>>.from(
        (props['options'] as List).map((rawOption) {
          final option = Map<dynamic, dynamic>.from(rawOption);
          option['selected'] = option['id'] == selectedPaymentId;

          final paymentActionRef = props['paymentActionRef'];
          if (paymentActionRef is String && actions[paymentActionRef] != null) {
            final action = _copyAction(actions[paymentActionRef]);
            action['params'] = {
              ...Map<dynamic, dynamic>.from(action['params'] ?? {}),
              "paymentId": option['id'],
            };
            option['action'] = action;
          }

          final bnplRaw = option['buyNowPayLater'];
          if (bnplRaw is Map) {
            final bnpl = Map<dynamic, dynamic>.from(bnplRaw);
            bnpl['selectedProviderId'] = selectedProviderId;

            if (bnpl['providers'] is List) {
              bnpl['providers'] = List<Map<dynamic, dynamic>>.from(
                (bnpl['providers'] as List).map((rawProvider) {
                  final provider = Map<dynamic, dynamic>.from(rawProvider);
                  provider['selected'] = provider['id'] == selectedProviderId;

                  final providerActionRef = props['providerActionRef'];
                  if (providerActionRef is String &&
                      actions[providerActionRef] != null) {
                    final action = _copyAction(actions[providerActionRef]);
                    action['params'] = {
                      ...Map<dynamic, dynamic>.from(action['params'] ?? {}),
                      "providerId": provider['id'],
                    };
                    provider['action'] = action;
                  }

                  return provider;
                }),
              );
            }

            option['buyNowPayLater'] = bnpl;
          }

          return option;
        }),
      );
    }

    resolved['props'] = props;
  }

 static void _resolveCheckoutFlow(
  BuildContext context,
  Map<dynamic, dynamic> resolved,
    Map<dynamic, dynamic> rootJson,
    Map<dynamic, dynamic> actions,
  ) {
    if (resolved['type'] != 'checkout_flow') return;

    final props = Map<dynamic, dynamic>.from(resolved['props'] ?? {});
    final config = Map<dynamic, dynamic>.from(resolved['config'] ?? {});

    final header = Map<dynamic, dynamic>.from(config['header'] ?? {});

    // ==========================================
    // Header back action
    // ==========================================

    final backActionRef = header['backActionRef'];

    if (backActionRef is String && actions[backActionRef] != null) {
      header['backAction'] = _copyAction(actions[backActionRef]);
      header.remove('backActionRef');
    }

    // ==========================================
    // Header price details action
    // ==========================================

    final priceActionRef = header['priceActionRef'];

    if (priceActionRef is String && actions[priceActionRef] != null) {
      final action = _copyAction(actions[priceActionRef]);
      final params = Map<dynamic, dynamic>.from(action['params'] ?? {});

      final bind = params['bind'];

      if (bind is String) {
        final resolvedData = _resolveBind(rootJson, bind);

        if (resolvedData is Map) {
          params['data'] = Map<dynamic, dynamic>.from(resolvedData);
        }
      }

      action['params'] = params;
      header['priceAction'] = action;
      header.remove('priceActionRef');
    }

    config['header'] = header;

    final boundData = resolved['bind'] is String
        ? _resolveBind(rootJson, resolved['bind'])
        : null;

    final contentData = resolved['contentBind'] is String
        ? _resolveBind(rootJson, resolved['contentBind'])
        : null;

    if (backActionRef is String && actions[backActionRef] != null) {
      header['backAction'] = _copyAction(actions[backActionRef]);
      header.remove('backActionRef');
    }

    config['header'] = header;

    if (contentData is Map<dynamic, dynamic>) {
      final stepsKey = props['stepsKey'];

      if (stepsKey is String) {
        props['steps'] = _readPath(contentData, stepsKey) ?? [];
      }
    }

    if (boundData is Map<dynamic, dynamic>) {
      final currentStepKey = props['currentStepKey'];
      final totalStepsKey = props['totalStepsKey'];
      final totalPriceKey = props['totalPriceKey'];

      if (currentStepKey is String) {
        props['currentStep'] = _readPath(boundData, currentStepKey) ?? 1;
      }

      if (totalStepsKey is String) {
        props['totalSteps'] = _readPath(boundData, totalStepsKey) ?? 1;
      }

      if (totalPriceKey is String) {
        props['totalPrice'] = _readPath(boundData, totalPriceKey);
      }
    }

    if (props['sections'] is List) {
      props['sections'] = List<Map<dynamic, dynamic>>.from(
        (props['sections'] as List).map((rawSection) {
          final section = Map<dynamic, dynamic>.from(rawSection);
          final sectionProps = Map<dynamic, dynamic>.from(
            section['props'] ?? {},
          );

          sectionProps['sectionId'] = section['id'];
          final sectionBind = section['bind'];
          dynamic sectionData;

          if (sectionBind is String) {
            if (boundData is Map<dynamic, dynamic> &&
                boundData.containsKey(sectionBind)) {
              sectionData = boundData[sectionBind];
            } else {
              sectionData = _resolveBind(rootJson, sectionBind);
            }
          }

          dynamic readSection(String? key) {
            if (key == null) return null;

            if (sectionData is Map<dynamic, dynamic>) {
              return _readPath(sectionData, key);
            }

            return null;
          }

          _resolveBasicKeys(
  context,
  rootJson,
  sectionProps,
  readSection,
);

          final selectionKey =
              section['selectionKey'] ?? sectionProps['selectionKey'];

          if (selectionKey is String && boundData is Map<dynamic, dynamic>) {
            final selectedValue = _readPath(boundData, selectionKey);
            sectionProps['selectedValue'] = selectedValue;

            if (sectionProps['options'] is List) {
              sectionProps['options'] = List<Map<dynamic, dynamic>>.from(
                (sectionProps['options'] as List).map((rawOption) {
                  final option = Map<dynamic, dynamic>.from(rawOption);
                  option['selected'] = option['id'] == selectedValue;

                  final optionActionRef = sectionProps['optionActionRef'];

                  if (optionActionRef is String &&
                      actions[optionActionRef] != null) {
                    final action = _copyAction(actions[optionActionRef]);

                    action['params'] = {
                      ...Map<dynamic, dynamic>.from(action['params'] ?? {}),
                      "key": selectionKey,
                      "value": option['id'],
                    };

                    option['action'] = action;
                  }

                  return option;
                }),
              );
            }
          }

          final increaseActionRef = sectionProps['increaseActionRef'];
          final decreaseActionRef = sectionProps['decreaseActionRef'];

          if (section['type'] == 'extras_selector_section' &&
              sectionProps['items'] is List) {
            sectionProps['items'] = List<Map<dynamic, dynamic>>.from(
              (sectionProps['items'] as List).map((rawItem) {
                final item = Map<dynamic, dynamic>.from(rawItem);
                final extraId = item['id'];

                if (extraId is String) {
                  if (increaseActionRef is String &&
                      actions[increaseActionRef] != null) {
                    final action = _copyAction(actions[increaseActionRef]);
                    action['params'] = {
                      ...Map<dynamic, dynamic>.from(action['params'] ?? {}),
                      "extraId": extraId,
                    };
                    item['increaseAction'] = action;
                  }

                  if (decreaseActionRef is String &&
                      actions[decreaseActionRef] != null) {
                    final action = _copyAction(actions[decreaseActionRef]);
                    action['params'] = {
                      ...Map<dynamic, dynamic>.from(action['params'] ?? {}),
                      "extraId": extraId,
                    };
                    item['decreaseAction'] = action;
                  }
                }

                return item;
              }),
            );
          }

          section['props'] = sectionProps;
          return section;
        }),
      );
    }

    final steps = props['steps'];
    final sections = props['sections'];
    final currentStep = props['currentStep'] ?? 1;

    if (steps is List && sections is List && steps.isNotEmpty) {
      final mergedSteps = steps.map((rawStep) {
        final step = Map<dynamic, dynamic>.from(rawStep);
        final stepNumber = step['step'];

        step['sections'] = sections
            .where((section) => section is Map && section['step'] == stepNumber)
            .map((section) => Map<dynamic, dynamic>.from(section as Map))
            .toList();

        return step;
      }).toList();

      props['steps'] = mergedSteps;
      props['activeStep'] = mergedSteps.firstWhere(
        (step) => step['step'] == currentStep,
        orElse: () => mergedSteps.first,
      );
    }

    resolved['props'] = props;
    resolved['config'] = config;
  }

  /// Resolves action refs inside button groups.
  ///
  /// Example:
  /// `"actionRef": "goToVehicleSearch"`
  ///
  /// becomes:
  /// `"action": {"type": "navigate", ...}`
  static void _resolveButtonGroupActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
  ) {
    if (props['buttons'] is! List) return;

    props['buttons'] = List<Map<dynamic, dynamic>>.from(
      (props['buttons'] as List).map((rawButton) {
        final button = Map<dynamic, dynamic>.from(rawButton);
        final actionRef = button['actionRef'];

        if (actionRef is String && actions[actionRef] != null) {
          button['action'] = _copyAction(actions[actionRef]);
          button.remove('actionRef');
        }

        return button;
      }),
    );
  }

  /// Resolves basic `xxxKey` props into actual values.
  ///
  /// Example:
  /// `"titleKey": "title"` becomes `"title": boundData["title"]`.
  ///
  /// Supports nested keys too:
  /// `"priceKey": "price.total.value"`.
 static void _resolveBasicKeys(
  BuildContext context,
  Map<dynamic, dynamic> rootJson,
  Map<dynamic, dynamic> props,
  dynamic Function(String? key) readBound,
) {
  final keyMappings = {
    "placeholderKey": "placeholder",
    "titleKey": "title",
    "subtitleKey": "subtitle",
    "labelKey": "label",
    "tagKey": "tag",
    "currencyKey": "currency",

    "vehicleNameKey": "vehicleName",
    "viewTitleKey": "viewTitle",
    "viewSubtitleKey": "viewSubtitle",
    "viewHintKey": "viewHint",
    "selectedModeKey": "selectedMode",
    "selectedAngleKey": "selectedAngle",
    "modesKey": "modes",
    "anglesKey": "angles",

    "statusKey": "status",
    "suggestionsKey": "suggestions",
    "messagesKey": "messages",
    "footerTextKey": "footerText",
    "bottomTextKey": "bottomText",

    "suffixKey": "suffix",
    "iconKey": "icon",
    "titleIconKey": "titleIcon",
    "textKey": "text",
    "itemIconKey": "itemIcon",

    "vehicleIdKey": "vehicleId",
    "ratingKey": "rating",
    "specsKey": "specs",
    "imagesKey": "images",
    "currentImageIndexKey": "currentImageIndex",

    "locationTitleKey": "locationTitle",
    "addressKey": "address",
    "hoursKey": "hours",

    "bookingIdKey": "bookingId",
    "endDateKey": "endDate",
    "showCloseKey": "showClose",

    "priceKey": "price",

    "durationKey": "duration",
    "descriptionKey": "description",
    "optionsKey": "options",
    "selectedStateKey": "selectedState",

    "valueKey": "value",
    "progressKey": "progress",
    "progressLabelKey": "progressLabel",
    "messageKey": "message",
    "timeKey": "time",
    "phoneKey": "phone",
    "licenseKey": "license",
    "nameKey": "name",

    "currentStepKey": "currentStep",
    "totalStepsKey": "totalSteps",
    "stepsKey": "steps",

    "fieldsKey": "fields",
    "totalKey": "total",
    "noteKey": "note",
    "highlightTextKey": "highlightText",
    "paymentMethodKey": "paymentMethod",
    "selectedPaymentIdKey": "selectedPaymentId",
    "selectedProviderIdKey": "selectedProviderId",
    "buttonLabelKey": "buttonLabel",
    "layoutKey": "layout",
    "sectionTitleKey": "sectionTitle",
    "linkLabelKey": "linkLabel",

    "totalRequiredKey": "totalRequired",
    "uploadedCountKey": "uploadedCount",
    "showWhenUploadedCountAtLeastKey":
        "showWhenUploadedCountAtLeast",
    "checksByDocumentTypeKey": "checksByDocumentType",
    "fieldsByDocumentTypeKey": "fieldsByDocumentType",
    "documentTypeKey": "documentType",
    "uploadedKey": "uploaded",
    "fileNameKey": "fileName",
    "missingLabelKey": "missingLabel",
    "uploadedLabelKey": "uploadedLabel",

    "brandKey": "brand",
    "taglineKey": "tagline",
    "menuIconKey": "menuIcon",
    "locationIconKey": "locationIcon",
    "locationKey": "location",
    "searchHintKey": "searchHint",
    "cameraIconKey": "cameraIcon",
    "departureLabelKey": "departureLabel",
    "departurePlaceholderKey": "departurePlaceholder",
    "deliverLabelKey": "deliverLabel",
    "deliverPlaceholderKey": "deliverPlaceholder",
    "collectLabelKey": "collectLabel",
    "collectPlaceholderKey": "collectPlaceholder",
    "returnElsewhereKey": "returnElsewhere",
    "withDriverKey": "withDriver",
    "promoKey": "promo",
    "moreFiltersKey": "moreFilters",
    "eyebrowKey": "eyebrow",
    "eyebrowIconKey": "eyebrowIcon",
    "tagsKey": "tags",
    "categoryKey": "category",
    "backgroundImageKey": "backgroundImage",
    "seatsKey": "seats",
    "transmissionKey": "transmission",
    "profileKey": "profile",
    "sectionsKey": "sections",
    "featureCardKey": "featureCard",
    "fuelKey": "fuel",
    "backLabelKey": "backLabel",
    "bodyKey": "body",
    "categoryIconKey": "categoryIcon",
    "imageKey": "image",
    "checkIconKey": "checkIcon",
  };

  // ==========================================
  // Dynamic translation resolver
  // Supports:
  // title_key
  // subtitle_key
  // label_key
  // saveButton_key
  // etc
  // ==========================================

   final translationKeys = props.keys
      .where(
        (key) =>
            key.toString().endsWith('_key'),
      )
      .toList();

  for (final key in translationKeys) {
    final value = props[key];

    if (value is String) {
      final outputKey = key
          .toString()
          .replaceAll('_key', '');

      props[outputKey] =
          JsonTranslator.translate(
        context: context,
        rootJson: rootJson,
        key: value,
      );
    }
  }

  
    // ==========================================
  // Translate nested list items
  // Example:
  // notificationItems[]
  // sections[]
  // options[]
  // ==========================================

  for (final entry in props.entries.toList()) {
    final value = entry.value;

    if (value is List) {
      for (final item in value) {
        if (item is Map<dynamic, dynamic>) {
          final itemTranslationKeys = item.keys
              .where(
                (key) =>
                    key.toString().endsWith('_key'),
              )
              .toList();

          for (final key in itemTranslationKeys) {
            final translationValue = item[key];

            if (translationValue is String) {
              final outputKey = key
                  .toString()
                  .replaceAll('_key', '');

              item[outputKey] =
                  JsonTranslator.translate(
                context: context,
                rootJson: rootJson,
                key: translationValue,
              );
            }
          }
        }
      }
    }
  }
  
  
  // ==========================================
  // Existing dynamic bind resolver
  // ==========================================

  keyMappings.forEach((keyName, outputName) {
    final sourceKey = props[keyName];

    if (sourceKey is String) {
      final value = readBound(sourceKey);

      if (value != null) {
        props[outputName] = value;
      }
    }
  });

  // ==========================================
  // Special handling
  // ==========================================

  if (props['titleCountKey'] is String) {
    props['titleCount'] =
        '${readBound(props['titleCountKey']) ?? ''}';
  }

  if (props['itemsKey'] is String) {
    props['items'] =
        readBound(props['itemsKey']) ?? [];
  }
}
  /// Resolves active rental card dynamic props.
  static void _resolveActiveCard(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
    dynamic Function(String? key) readBound,
  ) {
    props['subtitle'] = readBound(props['vehicleNameKey'] ?? 'vehicleName');

    final bookingId = readBound(props['bookingIdKey'] ?? 'bookingId');
    props['bookingId'] = bookingId == null ? null : 'Booking $bookingId';

    props['endDate'] = readBound(props['endDateKey'] ?? 'endDate');
    props['showClose'] = readBound(props['showCloseKey'] ?? 'canClose') == true;

    final closeActionRef = props['closeActionRef'];
    if (closeActionRef is String && actions[closeActionRef] != null) {
      props['closeAction'] = _copyAction(actions[closeActionRef]);
    }
  }

  /// Resolves gallery-specific actions such as back and 3D view.
  static void _resolveGalleryActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
    dynamic boundData,
  ) {
    final backActionRef = props['backActionRef'];
    if (backActionRef is String && actions[backActionRef] != null) {
      props['backAction'] = _copyAction(actions[backActionRef]);
    }

    final viewActionRef = props['viewActionRef'];
    if (viewActionRef is String && actions[viewActionRef] != null) {
      props['viewAction'] = _injectBoundParams(
        actions[viewActionRef],
        boundData,
      );
    }
  }

  /// Resolves bottom bar nested button action.
  ///
  /// Example:
  /// `"button": {"label": "Continue", "actionRef": "continueCheckout"}`
  static void _resolveBottomBar(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
    dynamic boundData,
  ) {
    final backActionRef = props['backActionRef'];

    if (backActionRef is String && actions[backActionRef] != null) {
      props['backAction'] = _copyAction(actions[backActionRef]);
      props.remove('backActionRef');
    }

    final button = props['button'];

    if (button is Map<dynamic, dynamic>) {
      final resolvedButton = Map<dynamic, dynamic>.from(button);

      final labelKey = resolvedButton['labelKey'];
      if (labelKey is String && boundData is Map<dynamic, dynamic>) {
        resolvedButton['label'] = _readPath(boundData, labelKey);
        resolvedButton.remove('labelKey');
      }

      final actionRef = resolvedButton['actionRef'];

      if (actionRef is String && actions[actionRef] != null) {
        resolvedButton['action'] = _injectBoundParams(
          actions[actionRef],
          boundData,
        );
        resolvedButton.remove('actionRef');
      }

      props['button'] = resolvedButton;
    }
  }

  /// Resolves actions for repeated content items.
  ///
  /// Used by components such as location/date selector.
  static void _resolveItemActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
  ) {
    final itemActionRefs = props['itemActionRefs'];

    if (itemActionRefs is! Map || props['items'] is! List) return;

    props['items'] = List<Map<dynamic, dynamic>>.from(
      (props['items'] as List).map((rawItem) {
        final row = Map<dynamic, dynamic>.from(rawItem);
        final key = row['key'];
        final actionRef = itemActionRefs[key];

        if (actionRef is String && actions[actionRef] != null) {
          row['action'] = _copyAction(actions[actionRef]);
        }

        return row;
      }),
    );
  }

  /// Resolves sort button data from a separate content bind.
  static void _resolveSort(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
    dynamic Function(String path) readPath,
  ) {
    final sortBind = props['sortBind'];
    if (sortBind is! String) return;

    final sortData = readPath(sortBind);

    if (sortData is Map<dynamic, dynamic>) {
      props['action'] = {
        "type": "sort_button",
        "label": sortData['label'],
        "icon": sortData['icon'],
        "options": sortData['options'] ?? [],
        "action": actions[props['sortActionRef']],
      };
    }
  }

  /// Resolves list card item action.
  ///
  /// Example:
  /// Uses `vehicleIdParamKey` to inject the clicked vehicle id into action params.
  static void _resolveListCardActions(
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> actions,
  ) {
    if (props['items'] is! List) return;

    final itemActionRef = props['itemActionRef'];

    props['items'] = List<Map<dynamic, dynamic>>.from(
      (props['items'] as List).map((rawItem) {
        final row = Map<dynamic, dynamic>.from(rawItem);

        if (itemActionRef is String && actions[itemActionRef] != null) {
          row['action'] = _injectBoundParams(actions[itemActionRef], row);
        }

        return row;
      }),
    );
  }

  /// Resolves visibility rules.
  ///
  /// Supported:
  /// - true / false
  /// - `"dynamicData.activeRental != null"`
  /// - `"dynamicData.activeRental == null"`
  /// Resolves visibility rules.
  ///
  /// Supported:
  /// - true / false
  /// - "dynamicData.activeRental != null"
  /// - "dynamicData.activeRental == null"
  /// - "dynamicData.documents.uploadedCount == 2"
  /// - object conditions using all / any
  static bool _isVisible(
    Map<dynamic, dynamic> rootJson,
    Map<dynamic, dynamic> item,
  ) {
    final visibleWhen = item['visibleWhen'];

    if (visibleWhen == null) return true;
    if (visibleWhen is bool) return visibleWhen;

    /// String condition support.
    ///
    /// Example:
    /// "visibleWhen": "dynamicData.documents.uploadedCount == 2"
    if (visibleWhen is String) {
      final trimmedCondition = visibleWhen.trim();

      if (trimmedCondition.startsWith('returnUi.')) {
        return true;
      }
      if (visibleWhen.contains('==') && !visibleWhen.endsWith('== null')) {
        final parts = visibleWhen.split('==');

        if (parts.length != 2) return true;

        final path = parts[0].trim();
        final expectedRaw = parts[1].trim();

        final actual = _unwrapDynamicDataValue(_resolveBind(rootJson, path));

        /// Supports true / false / numbers / strings.
        final expected = _parseExpectedValue(expectedRaw);

        return actual == expected || '$actual' == '$expected';
      }

      if (visibleWhen.endsWith('!= null')) {
        final path = visibleWhen.replaceAll('!= null', '').trim();
        final actual = _unwrapDynamicDataValue(_resolveBind(rootJson, path));
        return actual != null;
      }

      if (visibleWhen.endsWith('== null')) {
        final path = visibleWhen.replaceAll('== null', '').trim();
        final actual = _unwrapDynamicDataValue(_resolveBind(rootJson, path));
        return actual == null;
      }
    }

    /// Object condition support.
    ///
    /// Example:
    /// "visibleWhen": {
    ///   "source": "dynamicData.documents",
    ///   "all": [
    ///     {"path": "uploads.driving_license.uploaded", "equals": true},
    ///     {"path": "uploads.identity_document.uploaded", "equals": true}
    ///   ]
    /// }
    if (visibleWhen is Map) {
      final sourcePath = visibleWhen['source']?.toString();

      dynamic source = sourcePath == null || sourcePath.isEmpty
          ? rootJson
          : _resolveBind(rootJson, sourcePath);

      /// IMPORTANT:
      /// This unwraps dynamicData objects like:
      /// {
      ///   "value": null,
      ///   "fallback": {...}
      /// }
      source = _unwrapDynamicDataValue(source);

      final allConditions = visibleWhen['all'];

      if (allConditions is List) {
        return allConditions.every((condition) {
          if (condition is! Map) return true;

          final path = condition['path']?.toString();
          final expected = condition['equals'];

          if (path == null || path.isEmpty) return true;

          final actual = _readPath(source, path);

          return actual == expected;
        });
      }

      final anyConditions = visibleWhen['any'];

      if (anyConditions is List) {
        return anyConditions.any((condition) {
          if (condition is! Map) return false;

          final path = condition['path']?.toString();
          final expected = condition['equals'];

          if (path == null || path.isEmpty) return false;

          final actual = _readPath(source, path);

          return actual == expected;
        });
      }

      final path = visibleWhen['path']?.toString();

      if (path != null && path.isNotEmpty) {
        final expected = visibleWhen['equals'];
        final actual = _readPath(source, path);

        return actual == expected;
      }
    }

    return true;
  }

  /// Unwraps API-backed dynamicData.
  ///
  /// Handles:
  /// {
  ///   "value": {...}
  /// }
  ///
  /// or:
  ///
  /// {
  ///   "value": null,
  ///   "fallback": {...}
  /// }
  static dynamic _unwrapDynamicDataValue(dynamic data) {
    if (data is Map) {
      if (data.containsKey('value') && data['value'] != null) {
        return data['value'];
      }

      if (data.containsKey('fallback') && data['fallback'] != null) {
        return data['fallback'];
      }
    }

    return data;
  }

  /// Converts expected values from string conditions.
  ///
  /// Example:
  /// "true" -> true
  /// "false" -> false
  /// "2" -> 2
  /// "hello" -> hello
  static dynamic _parseExpectedValue(String value) {
    final cleaned = value.replaceAll('"', '').replaceAll("'", '').trim();

    if (cleaned == 'true') return true;
    if (cleaned == 'false') return false;
    if (cleaned == 'null') return null;

    final intValue = int.tryParse(cleaned);
    if (intValue != null) return intValue;

    final doubleValue = double.tryParse(cleaned);
    if (doubleValue != null) return doubleValue;

    return cleaned;
  }

  /// Resolves a bind path.
  ///
  /// If the target contains:
  /// - `value`, use it first
  /// - otherwise use `fallback`
  ///
  /// This supports the cache/refresh strategy.
  static dynamic _resolveBind(Map<dynamic, dynamic> rootJson, String path) {
    final value = _readPath(rootJson, path);

    if (value is Map<dynamic, dynamic>) {
      if (value.containsKey('value') && value['value'] != null) {
        return value['value'];
      }

      if (value.containsKey('fallback')) {
        return value['fallback'];
      }
    }

    return value;
  }

  /// Injects values from bound data into action params.
  ///
  /// Example:
  /// `"vehicleIdParamKey": "vehicleId"`
  ///
  /// becomes:
  /// `"vehicleId": "range_rover_vogue_001"`
  static Map<dynamic, dynamic> _injectBoundParams(
    dynamic actionData,
    dynamic boundData,
  ) {
    final action = _copyAction(actionData);

    final originalParams = Map<dynamic, dynamic>.from(action['params'] ?? {});
    final resolvedParams = <dynamic, dynamic>{};

    for (final entry in originalParams.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is String && key.endsWith('ParamKey')) {
        final outputKey = key.replaceAll('ParamKey', '');
        final outputValue = boundData is Map
            ? _readPath(boundData, value)
            : null;

        if (outputValue != null) {
          resolvedParams[outputKey] = outputValue;
        } else {
          resolvedParams[key] = value;
        }

        continue;
      }

      if (value is String && key.endsWith('Key')) {
        const reservedLiteralKeys = {
          'trayKey',
          'screenKey',
          'dialogKey',
          'cacheKey',
          'routeKey',
        };

        if (reservedLiteralKeys.contains(key)) {
          resolvedParams[key] = value;
          continue;
        }

        final outputKey = key.substring(0, key.length - 3);
        final outputValue = boundData is Map
            ? _readPath(boundData, value)
            : null;

        if (outputValue != null) {
          resolvedParams[outputKey] = outputValue;
        }

        continue;
      }

      resolvedParams[key] = value;
    }

    action['params'] = resolvedParams;

    return action;
  }

  /// Safely copies an action map so the source JSON is not mutated.
  static Map<dynamic, dynamic> _copyAction(dynamic actionData) {
    if (actionData is Map<dynamic, dynamic>) {
      return Map<dynamic, dynamic>.from(actionData);
    }

    if (actionData is Map) {
      return Map<dynamic, dynamic>.from(actionData);
    }

    return {};
  }

  /// Reads dot paths from maps.
  ///
  /// Example:
  /// `_readPath(data, "price.total.value")`
  static dynamic _readPath(dynamic source, String path) {
    dynamic current = source;

    for (final key in path.split('.')) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }
}
