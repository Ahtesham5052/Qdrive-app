const Map<dynamic, dynamic> bookingCompleteJson = {
  "version": "1.0",
  "screen": "booking_complete",

  "meta": {
    "generatedAt": "2026-04-15T10:00:00Z",
    "cacheKey": "booking_complete_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "successHeader": {
      "icon": "check_circle",
      "title": "Booking Confirmed!",
      "subtitle": "Your rental has been successfully booked",
    },

    "nextSteps": {
      "title": "Next Steps",
      "items": [
        {
          "number": "1",
          "text": "Check your email for booking confirmation and receipt",
        },
        {"number": "2", "text": "Upload your driving license within 48 hours"},
        {
          "number": "3",
          "text": "We'll send you a ready notification 24 hours before pickup",
        },
      ],
    },

    "aiSuggestions": {
      "sectionTitle": "AI Booking Suggestions",
      "icon": "trend_up",
      "title": "Based on your travel pattern",
      "text":
          "You typically book again in 2-3 months. We predict you might need a car around June 15-20, 2026.",
      "linkLabel": "Get notified when prices drop →",
    },
  },

  "dynamicData": {
    "bookingComplete": {
      "source": "api",
      "endpoint": "/bookings/complete",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,
      "fallback": {
        "bookingReference": "QD-7X9K2M",

        "bookingDetails": {
          "title": "Booking Details",
          "layout": "vertical",
          "items": [
            {"icon": "car", "title": "Vehicle", "description": "Premium Sedan"},
            {
              "icon": "calendar",
              "title": "Rental Period",
              "description": "Apr 20 - Apr 25, 2026",
              "subDescription": "5 days",
            },
            {
              "icon": "location",
              "title": "Pickup Location",
              "description": "123 Main Street, City Center",
            },
          ],
        },

        "confirmationSentTo": {
          "title": "Confirmation Sent To",
          "layout": "vertical",
          "items": [
            {
              "icon": "email",
              "title": "Email",
              "description": "john.doe@email.com",
            },
            {"icon": "sms", "title": "SMS", "description": "+1 (555) 123-4567"},
            {
              "icon": "phone",
              "title": "WhatsApp",
              "description": "+1 (555) 123-4567",
            },
          ],
        },
      },
    },
  },

  "actions": {
    "uploadDocuments": {
      "type": "navigate",
      "params": {"route": "upload_documents"},
    },

    "backHome": {
      "type": "navigate",
      "params": {"route": "home"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "booking_success_header",
        "type": "text_block",
        "bind": "content.successHeader",
        "classes": ["mt-lg", "mb-lg"],
        "theme": {
          "iconBox": ["bg-success-dark", "rounded-full", "p-lg"],
          "icon": ["text-success"],
          "title": ["text-body", "text-xl", "font-bold", "text-center"],
          "subtitle": ["text-muted", "text-sm", "text-center"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "center",
              "classes": ["mt-md"],
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconBox",
                  "child": {
                    "type": "icon",
                    "key": "icon",
                    "themeKey": "icon",
                    "size": "xl",
                  },
                },
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mt-md"],
                  "textAlign": "center",
                },
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-xs"],
                  "textAlign": "center",
                },
              ],
            },
          ],
        },
        "props": {
          "align": "center",
          "iconKey": "icon",
          "titleKey": "title",
          "subtitleKey": "subtitle",
        },
      },

      {
        "id": "booking_reference",
        "type": "info_card",
        "bind": "dynamicData.bookingComplete",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-inverse-card", "border-muted", "rounded-lg", "p-lg"],
          "title": ["text-inverse-muted", "text-sm"],
          "highlightText": ["text-inverse-body", "text-xl", "font-medium"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "container",
                  "themeKey": "card",
                  "child": {
                    "type": "column",
                    "crossAxis": "start",
                    "children": [
                      {"type": "text", "key": "title", "themeKey": "title"},
                      {
                        "type": "text",
                        "key": "highlightText",
                        "themeKey": "highlightText",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleInsideCard": true,
          "title": "Booking Reference",
          "highlightTextKey": "bookingReference",
        },
      },

      {
        "id": "booking_details",
        "type": "benefit_cards",
        "bind": "dynamicData.bookingComplete",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "itemLayout": "row",
          "card": ["bg-card-soft", "rounded-lg", "p-md", "mb-sm"],
          "iconBox": ["bg-transparent", "rounded-md"],
          "icon": ["text-muted"],
          "titleText": ["text-muted", "text-xs"],
          "description": ["text-body", "text-sm", "font-bold"],
          "subDescription": ["text-muted", "text-xs"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "item",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "classes": ["mb-sm"],

                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "iconBox",
                          "child": {
                            "type": "icon",
                            "key": "item.icon",
                            "themeKey": "icon",
                            "size": "md",
                          },
                        },
                        {
                          "type": "column",
                          "flex": 1,
                          "classes": ["ml-md"],
                          "children": [
                            {
                              "type": "text",
                              "key": "item.title",
                              "themeKey": "titleText",
                            },
                            {
                              "type": "text",
                              "key": "item.description",
                              "themeKey": "description",
                              "classes": ["mt-xs"],
                            },
                            {
                              "type": "text",
                              "key": "item.subDescription",
                              "themeKey": "subDescription",
                              "classes": ["mt-xs"],
                              "visibleWhen": "item.subDescription != null",
                            },
                          ],
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleKey": "bookingDetails.title",
          "layoutKey": "bookingDetails.layout",
          "itemsKey": "bookingDetails.items",
        },
      },

      {
        "id": "next_steps",
        "type": "check_list_section",
        "bind": "content.nextSteps",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],

          "content": ["bg-info-soft", "border-info", "rounded-lg", "p-lg"],

          "itemIconBox": ["bg-info", "rounded-full"],

          "itemNumber": ["text-white", "text-sm", "font-bold", "text-center"],

          "itemText": ["text-info", "text-sm", "font-medium"],
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
                  "themeKey": "content",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "for_each",
                    "itemsKey": "items",
                    "itemName": "step",
                    "layout": "column",
                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "classes": ["mb-md"],
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "itemIconBox",
                          "width": 28,
                          "height": 28,
                          "alignment": "center",
                          "child": {
                            "type": "text",
                            "key": "step.number",
                            "themeKey": "itemNumber",
                            "textAlign": "center",
                          },
                        },
                        {
                          "type": "text",
                          "key": "step.text",
                          "themeKey": "itemText",
                          "classes": ["ml-md"],
                          "flex": 1,
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
        "props": {"titleKey": "title", "numbered": true, "itemsKey": "items"},
      },
      {
        "id": "confirmation_sent_to",
        "type": "benefit_cards",
        "bind": "dynamicData.bookingComplete",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "itemLayout": "row",
          "card": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "p-md",
            "mb-sm",
          ],
          "iconBox": ["bg-transparent", "rounded-md"],
          "icon": ["text-muted"],
          "titleText": ["text-muted", "text-xs"],
          "description": ["text-body", "text-sm", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "item",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "classes": ["mb-sm"],

                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "iconBox",
                          "child": {
                            "type": "icon",
                            "key": "item.icon",
                            "themeKey": "icon",
                            "size": "md",
                          },
                        },
                        {
                          "type": "column",
                          "flex": 1,
                          "classes": ["ml-md"],
                          "children": [
                            {
                              "type": "text",
                              "key": "item.title",
                              "themeKey": "titleText",
                            },
                            {
                              "type": "text",
                              "key": "item.description",
                              "themeKey": "description",
                              "classes": ["mt-xs"],
                            },
                          ],
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleKey": "confirmationSentTo.title",
          "layoutKey": "confirmationSentTo.layout",
          "itemsKey": "confirmationSentTo.items",
        },
      },

      {
        "id": "ai_booking_suggestions",
        "type": "insight_card",
        "bind": "content.aiSuggestions",
        "classes": ["mb-lg"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "card": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],
          "iconBox": ["bg-info-dark", "rounded-md", "p-md"],
          "icon": ["text-info"],
          "title": ["text-info", "text-sm", "font-bold"],
          "text": ["text-info", "text-sm"],
          "link": ["text-info", "text-sm", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {
                  "type": "text",
                  "key": "sectionTitle",
                  "themeKey": "sectionTitle",
                },
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "child": {
                          "type": "icon",
                          "key": "icon",
                          "themeKey": "icon",
                          "size": "md",
                        },
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
                            "classes": ["mt-sm"],
                          },
                          {
                            "type": "text",
                            "key": "linkLabel",
                            "themeKey": "link",
                            "classes": ["mt-sm"],
                          },
                        ],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "sectionTitleKey": "sectionTitle",
          "iconKey": "icon",
          "titleKey": "title",
          "textKey": "text",
          "linkLabelKey": "linkLabel",
        },
      },

      {
        "id": "booking_complete_actions",
        "type": "button_group",
        "classes": ["mb-xl"],
        "theme": {
          "primaryButton": ["bg-inverse-card", "rounded-md", "px-lg", "py-md"],
          "primaryLabel": ["text-inverse-body", "text-sm", "font-bold"],
          "secondaryButton": ["bg-card-soft", "rounded-md", "px-lg", "py-md"],
          "secondaryLabel": ["text-body", "text-sm", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "container",
                  "themeKey": "primaryButton",
                  "action": {"type": "open_upload_documents"},

                  "child": {
                    "type": "text",
                    "value": "Upload Documents Now",
                    "themeKey": "primaryLabel",
                    "textAlign": "center",
                  },
                },
                {
                  "type": "container",
                  "themeKey": "secondaryButton",
                  "action": {"type": "open_home"},

                  "classes": ["mt-md"],
                  "child": {
                    "type": "text",
                    "value": "Back to Home",
                    "themeKey": "secondaryLabel",
                    "textAlign": "center",
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "direction": "vertical",
          "buttons": [
            {
              "label": "Upload Documents Now",
              "variant": "primary",
              "action": {"type": "open_upload_documents"},
            },
            {
              "label": "Back to Home",
              "variant": "secondary",
              "action": {"type": "open_home"},
            },
          ],
        },
      },
    ],
  },
};
