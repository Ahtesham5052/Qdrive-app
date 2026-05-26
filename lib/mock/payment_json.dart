const Map<dynamic, dynamic> paymentJson = {
  "version": "1.0",
  "screen": "booking_payment",

  "meta": {
    "generatedAt": "2026-04-15T10:00:00Z",
    "cacheKey": "booking_payment_v2_dark_neutral",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "paymentHeader": {
      "title": "Payment",
      "subtitle": "Secure payment processing",
    },

    "securePaymentNotice": {
      "icon": "lock",
      "title": "Secure Payment",
      "text":
          "Your payment information is encrypted and secure. We use industry-standard SSL encryption.",
    },
  },

  "dynamicData": {
    "payment": {
      "source": "api",
      "endpoint": "/bookings/payment",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,
      "fallback": {
        "bookingId": "BK-2026-4521",
        "selectedPaymentId": "installments",
        "selectedProviderId": "clearpay",
        "amount": 489.50,
        "currency": "GBP",

        "paymentMethod": {
          "title": "Payment Method",
          "options": [
            {
              "id": "card",
              "title": "Credit/Debit Card",
              "icon": "credit_card",
              "brands": [
                {"label": "VISA", "variant": "visa"},
                {"label": "MC", "variant": "mastercard"},
              ],
            },
            {
              "id": "installments",
              "title": "Pay in 3 instalments",
              "badge": "0% interest",
              "description": "Split into 3 monthly payments of £163.17",
              "providers": [
                {"label": "Klarna", "variant": "info"},
                {"label": "or", "variant": "plain"},
                {"label": "Clearpay", "variant": "success"},
              ],
              "buyNowPayLater": {
                "title": "Buy Now Pay Later",
                "subtitle": "Select Provider",
                "providers": [
                  {
                    "id": "klarna",
                    "title": "Klarna",
                    "subtitle": "Instant approval",
                  },
                  {
                    "id": "clearpay",
                    "title": "Clearpay",
                    "subtitle": "Fast checkout",
                  },
                ],
                "schedule": {
                  "title": "Payment Schedule",
                  "icon": "calendar",
                  "items": [
                    {
                      "number": "1",
                      "label": "Today",
                      "subtitle": "First payment",
                      "value": "£163.17",
                    },
                    {
                      "number": "2",
                      "label": "In 30 days",
                      "subtitle": "Second payment",
                      "value": "£163.17",
                    },
                    {
                      "number": "3",
                      "label": "In 60 days",
                      "subtitle": "Final payment",
                      "value": "£163.17",
                    },
                  ],
                  "note": {
                    "icon": "sparkles",
                    "text":
                        "No interest, no fees. Pay the same total amount, just split over 3 months.",
                  },
                },
                "benefits": {
                  "icon": "trend_up",
                  "title": "Why choose Pay in 3?",
                  "items": [
                    "Instant approval with soft credit check",
                    "Manage payments easily through app",
                    "No hidden fees or interest charges",
                    "Perfect for high-value bookings",
                  ],
                },
              },
            },
          ],
        },
      },
    },

    "cardDetails": {
      "source": "static",
      "fallback": {
        "title": "Card Details",
        "fields": [
          {
            "id": "card_number",
            "type": "text",
            "label": "Card Number",
            "placeholder": "1234 5678 9012 3456",
            "keyboardType": "number",
            "inputFormat": "card_number",
            "required": true,
            "width": "full",
          },
          {
            "id": "cardholder_name",
            "type": "text",
            "label": "Cardholder Name",
            "placeholder": "John Doe",
            "keyboardType": "text",
            "textCapitalization": "words",
            "required": true,
            "width": "full",
          },
          {
            "id": "expiry_date",
            "type": "text",
            "label": "Expiry Date",
            "placeholder": "MM/YY",
            "keyboardType": "datetime",
            "inputFormat": "expiry_date",
            "required": true,
            "width": "half",
          },
          {
            "id": "cvv",
            "type": "text",
            "label": "CVV",
            "placeholder": "123",
            "keyboardType": "number",
            "obscureText": true,
            "maxLength": 4,
            "required": true,
            "width": "half",
          },
        ],
      },
    },

    "depositInformation": {
      "source": "static",
      "fallback": {
        "title": "Deposit Information",
        "highlightText":
            "A refundable deposit of £250 will be pre-authorized on your card.",
        "text":
            "This amount will be held and released within 7 days after your rental ends, provided there are no damages or violations.",
      },
    },

    "paymentSummary": {
      "source": "api",
      "endpoint": "/bookings/payment/summary",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,
      "fallback": {
        "title": "Payment Summary",
        "currency": "GBP",
        "items": [
          {"label": "Rental amount", "value": 489.50},
          {"label": "Deposit (refundable)", "value": 250},
        ],
        "total": {"label": "Total to be charged", "value": 489.50},
        "note": "Deposit hold: £250.00",
      },
    },

    "paymentBottomBar": {
      "source": "static",
      "fallback": {"buttonLabel": "Confirm & Pay £489.50"},
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "selectPaymentMethod": {"type": "select_payment_method", "params": {}},

    "selectPaymentProvider": {"type": "select_payment_provider", "params": {}},

    "confirmPayment": {
      "type": "confirm_payment",
      "params": {
        "bookingId": "BK-2026-4521",
        "amount": 489.50,
        "currency": "GBP",
      },
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "payment_top_back",
        "type": "button_group",
        "classes": ["mb-md"],
        "theme": {
          "iconButton": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "p-sm",
          ],
          "iconButtonIcon": ["text-body"],
        },
        "config": {
          "layout": [
            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "container",
                  "action": {"type": "go_back"},
                  "themeKey": "iconButton",
                  "child": {
                    "type": "icon",
                    "icon": "arrow_back",
                    "themeKey": "iconButtonIcon",
                    "size": "lg",
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "align": "start",
          "buttons": [
            {
              "icon": "arrow_back",
              "variant": "icon",
              "action": {"type": "go_back"},
            },
          ],
        },
      },

      {
        "id": "payment_header",
        "type": "text_block",
        "bind": "content.paymentHeader",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "start",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-xs"],
                },
              ],
            },
          ],
        },
        "props": {
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "align": "start",
        },
      },

      {
        "id": "payment_method",
        "type": "payment_method_section",
        "bind": "dynamicData.payment",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-base", "font-bold"],

          "option": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],

          "selectedOption": [
            "bg-white-opacity-soft",
            "border-white",
            "rounded-lg",
            "p-md",
          ],

          "radio": ["border-muted"],
          "selectedRadio": ["bg-white", "border-white"],

          "icon": ["text-muted"],
          "selectedIcon": ["text-white"],

          "optionTitle": ["text-body", "text-sm", "font-bold"],
          "description": ["text-body", "text-xs"],

          "badge": [
            "bg-transparent",
            "border-white",
            "rounded-full",
            "px-xs",
            "py-xs",
          ],

          "badgeText": ["text-body", "text-xs", "font-bold"],

          "cardBrandVisa": ["bg-muted", "rounded-sm", "px-xs", "py-xs"],
          "cardBrandMastercard": ["bg-muted", "rounded-sm", "px-xs", "py-xs"],
          "cardBrandText": ["text-body", "text-xs", "font-bold"],

          "paymentPill": [
            "bg-transparent",
            "border-muted",
            "rounded-sm",
            "px-sm",
            "py-xs",
          ],
          "paymentPillText": ["text-body", "text-xs", "font-bold"],

          "successPill": [
            "bg-transparent",
            "border-muted",
            "rounded-sm",
            "px-sm",
            "py-xs",
          ],
          "successPillText": ["text-body", "text-xs", "font-bold"],

          "providerInlineText": ["text-body", "text-xs", "font-bold"],

          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "sectionSubtitle": ["text-body", "text-xs"],

          "providerCard": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "p-md",
          ],

          "selectedProviderCard": [
            "bg-white-opacity-soft",

            "border-white",
            "rounded-lg",
            "p-md",
          ],

          "providerTitle": ["text-body", "text-sm", "font-bold"],
          "selectedProviderTitle": ["text-body", "text-sm", "font-bold"],
          "providerSubtitle": ["text-muted", "text-xs"],

          "scheduleCard": [
            "bg-card-soft",
            "border-muted",
            "rounded-lg",
            "p-md",
          ],

          "scheduleTitle": ["text-body", "text-sm", "font-bold"],
          "scheduleIcon": ["text-muted"],

          "scheduleRow": ["bg-black", "border-muted", "rounded-md", "p-sm"],

          "scheduleNumber": ["bg-white", "rounded-full", "p-xs"],

          "scheduleNumberText": ["text-black", "text-xs", "font-bold"],
          "scheduleLabel": ["text-body", "text-xs", "font-bold"],
          "scheduleSubLabel": ["text-muted", "text-xs"],
          "scheduleValue": ["text-body", "text-xs", "font-bold"],

          "noteBox": ["bg-transparent", "p-sm"],

          "noteIcon": ["text-muted"],
          "noteText": ["text-muted", "text-xs", "font-medium"],

          "benefitBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],

          "benefitIconBox": ["bg-muted", "rounded-md", "p-sm"],

          "benefitIcon": ["text-muted"],
          "benefitTitle": ["text-body", "text-sm", "font-bold"],
          "benefitText": ["text-muted", "text-xs"],
          "benefitItemText": ["text-muted", "text-xs"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},

                {
                  "type": "payment_option_list",
                  "itemsKey": "options",
                  "classes": ["mt-md"],
                },

                {
                  "type": "bnpl_panel",
                  "key": "buyNowPayLater",
                  "visibleWhen": "showBuyNowPayLater == true",
                  "classes": ["mt-sm"],
                },
              ],
            },
          ],
        },

        "props": {
          "paymentMethodKey": "paymentMethod",
          "selectedPaymentIdKey": "selectedPaymentId",
          "selectedProviderIdKey": "selectedProviderId",
        },
      },

      {
        "id": "card_details",
        "type": "form_section",
        "bind": "dynamicData.cardDetails",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "label": ["text-muted", "text-xs"],

          "field": ["bg-transparent", "border-muted", "rounded-lg", "p-lg"],

          "fieldText": ["text-body", "text-sm"],
          "placeholderText": ["text-muted", "text-sm"],

          "row": ["gap-md"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},

                {
                  "type": "form_fields",
                  "itemsKey": "fields",
                  "classes": ["mt-md"],
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "fieldsKey": "fields",
          "submitMode": "manual",
          "paymentSectionId": "payment_method",
          "showWhenPaymentId": "card",
        },
      },

      {
        "id": "deposit_information",
        "type": "info_card",
        "bind": "dynamicData.depositInformation",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "highlightText": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs", "font-medium"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "text",
                        "key": "highlightText",
                        "themeKey": "highlightText",
                      },
                      {
                        "type": "text",
                        "key": "text",
                        "themeKey": "text",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleKey": "title",
          "highlightTextKey": "highlightText",
          "textKey": "text",
        },
      },

      {
        "id": "payment_summary",
        "type": "price_breakdown_card",
        "bind": "dynamicData.paymentSummary",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "card": ["bg-card-soft", "rounded-lg", "p-md"],

          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-xs", "font-bold"],

          "highlightLabel": ["text-body", "text-xs", "font-bold"],
          "highlightValue": ["text-body", "text-xs", "font-bold"],

          "divider": ["bg-muted"],
          "totalLabel": ["text-body", "text-sm", "font-bold"],
          "totalValue": ["text-body", "text-lg", "font-extrabold"],
          "note": ["text-muted", "text-xs"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "crossAxis": "stretch",
                    "children": [
                      {
                        "type": "for_each",
                        "itemsKey": "items",
                        "itemName": "summaryItem",
                        "layout": "column",
                        "child": {
                          "type": "row",
                          "crossAxis": "center",
                          "classes": ["mb-sm"],
                          "children": [
                            {
                              "type": "text",
                              "key": "summaryItem.label",
                              "themeKey": "label",
                              "classListKey": "summaryItem.labelClasses",
                              "flex": 1,
                            },
                            {
                              "type": "row",
                              "crossAxis": "center",
                              "children": [
                                {
                                  "type": "text",
                                  "key": "summaryItem.value",
                                  "themeKey": "value",
                                  "classListKey": "summaryItem.valueClasses",
                                },
                              ],
                            },
                          ],
                        },
                      },
                      {
                        "type": "row",
                        "crossAxis": "center",
                        "classes": ["mt-sm"],
                        "children": [
                          {
                            "type": "text",
                            "key": "total.label",
                            "themeKey": "totalLabel",
                            "flex": 1,
                          },
                          {
                            "type": "row",
                            "crossAxis": "center",
                            "children": [
                              {
                                "type": "text",
                                "key": "total.value",
                                "themeKey": "totalValue",
                              },
                            ],
                          },
                        ],
                      },
                      {
                        "type": "text",
                        "key": "note",
                        "themeKey": "note",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleKey": "title",
          "currencyKey": "currency",
          "itemsKey": "items",
          "totalKey": "total",
          "noteKey": "note",
          "paymentMethodSectionId": "payment_method",
          "installmentPaymentId": "installments",
          "installmentPayments": 3,
          "selectedPaymentIdKey": "selectedPaymentId",
          "selectedProviderIdKey": "selectedProviderId",
        },
      },

      {
        "id": "secure_payment_notice",
        "type": "info_card",
        "bind": "content.securePaymentNotice",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-card-soft", "rounded-lg", "p-md"],
          "icon": ["text-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  {
                    "type": "icon",
                    "key": "icon",
                    "themeKey": "icon",
                    "size": "md",
                  },
                  {
                    "type": "column",
                    "flex": 1,
                    "classes": ["ml-md"],
                    "children": [
                      {"type": "text", "key": "title", "themeKey": "title"},
                      {
                        "type": "text",
                        "key": "text",
                        "themeKey": "text",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
        "props": {"iconKey": "icon", "titleKey": "title", "textKey": "text"},
      },

      {
        "id": "payment_bottom_bar",
        "type": "bottom_bar",
        "bind": "dynamicData.paymentBottomBar",
        "classes": ["bg-app", "border-muted", "p-md"],
        "theme": {
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-base", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "button",
              "child": {
                "type": "text",
                "key": "buttonLabel",
                "themeKey": "buttonLabel",
                "textAlign": "center",
              },
            },
          ],
        },
        "props": {
          "mode": "single_button",
          "button": {
            "labelKey": "buttonLabel",
            "action": {"type": "open_booking_complete"},
          },
        },
      },
    ],
  },
};
