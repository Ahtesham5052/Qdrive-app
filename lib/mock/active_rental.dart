const Map<dynamic, dynamic> activeRentalPageJson = {
  "version": "1.0",
  "screen": "active_rental",

  "meta": {
    "generatedAt": "2026-05-15T17:25:00Z",
    "cacheKey": "active_rental_v3",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "active_rental_top_back",
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
        "props": {
          "buttons": [
            {
              "icon": "arrow_back",
              "variant": "icon",
              "action": {"type": "go_back"},
            },
          ],
        },
        "config": {
          "layout": [
            {
              "type": "row",
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconButton",
                  "action": {"type": "go_back"},
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
      },

      {
        "id": "active_rental_header",
        "type": "text_block",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
        },
        "props": {"title": "Active Rental", "subtitle": "Rental in progress"},
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
      },

      {
        "id": "rental_status_card",
        "type": "info_card",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-success-gradient", "rounded-xl", "p-lg"],

          "label": ["text-white", "text-xs", "font-medium"],

          "title": ["text-white", "text-base", "font-bold"],

          "dateLabel": ["text-white", "text-xs", "font-medium"],

          "dateValue": ["text-white", "text-sm", "font-extrabold"],

          "iconBox": ["bg-white-opacity-soft", "rounded-full", "p-md"],

          "icon": ["text-white"],
        },
        "props": {
          "status": {
            "label": "Status",
            "value": "Rental Active",
            "icon": "car",
            "pickupLabel": "Pickup Date",
            "pickupDate": "Apr 20, 2026",
            "returnLabel": "Return Date",
            "returnDate": "Apr 25, 2026",
          },
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "fullWidth": true,
              "height": 128,
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "mainAxis": "spaceBetween",
                "children": [
                  {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "column",
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "status.label",
                            "themeKey": "label",
                          },
                          {
                            "type": "text",
                            "key": "status.value",
                            "themeKey": "title",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 44,
                        "height": 44,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "status.icon",
                          "themeKey": "icon",
                          "size": "lg",
                        },
                      },
                    ],
                  },
                  {
                    "type": "row",
                    "crossAxis": "end",
                    "children": [
                      {
                        "type": "column",
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "status.pickupLabel",
                            "themeKey": "dateLabel",
                          },
                          {
                            "type": "text",
                            "key": "status.pickupDate",
                            "themeKey": "dateValue",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                      {
                        "type": "column",
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "status.returnLabel",
                            "themeKey": "dateLabel",
                          },
                          {
                            "type": "text",
                            "key": "status.returnDate",
                            "themeKey": "dateValue",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "time_remaining",
        "type": "progress_section",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-card-soft", "rounded-lg", "p-md"],
          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-xs", "font-bold"],
          "bigValue": ["text-body", "text-lg", "font-bold", "text-center"],
          "track": ["bg-muted", "rounded-full"],
          "fill": ["bg-info", "rounded-full"],
        },
        "props": {
          "title": "Time Remaining",
          "label": "Rental Period",
          "progressLabel": "60% Complete",
          "progress": 0.6,
          "value": "2 days left",
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "crossAxis": "center",

                    "children": [
                      {
                        "type": "row",
                        "mainAxis": "spaceBetween",
                        "children": [
                          {"type": "text", "key": "label", "themeKey": "label"},
                          {
                            "type": "text",
                            "key": "progressLabel",
                            "themeKey": "value",
                          },
                        ],
                      },
                      {
                        "type": "container",
                        "themeKey": "track",
                        "classes": ["mt-sm"],
                        "height": 6,
                        "fullWidth": true,
                        "child": {
                          "type": "container",
                          "themeKey": "fill",
                          "height": 6,
                          "progressKey": "progress",
                        },
                      },
                      {
                        "type": "text",
                        "key": "value",
                        "themeKey": "bigValue",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
      },

      {
        "id": "rental_vehicle",
        "type": "benefit_cards",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "iconBox": ["bg-card-soft", "rounded-md", "p-sm"],
          "icon": ["text-muted"],
          "titleText": ["text-body", "text-sm", "font-bold"],
          "description": ["text-muted", "text-xs"],
          "miniCard": ["bg-card-soft", "rounded-md", "p-sm"],
          "miniLabel": ["text-muted", "text-xs"],
          "miniValue": ["text-body", "text-xs", "font-bold"],
        },
        "props": {
          "title": "Your Vehicle",
          "name": "Premium Sedan",
          "license": "License: ABC-1234",
          "icon": "car",
          "details": [
            {"icon": "fuel", "label": "Fuel Policy", "value": "Return Full"},
            {
              "icon": "security",
              "label": "Insurance",
              "value": "Full Coverage",
            },
          ],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "children": [
                      {
                        "type": "row",
                        "children": [
                          {
                            "type": "container",
                            "themeKey": "iconBox",
                            "child": {
                              "type": "icon",
                              "key": "icon",
                              "themeKey": "icon",
                            },
                          },
                          {
                            "type": "column",
                            "classes": ["ml-md"],
                            "flex": 1,
                            "children": [
                              {
                                "type": "text",
                                "key": "name",
                                "themeKey": "titleText",
                              },
                              {
                                "type": "text",
                                "key": "license",
                                "themeKey": "description",
                                "classes": ["mt-xs"],
                              },
                            ],
                          },
                        ],
                      },
                      {
                        "type": "for_each",
                        "itemsKey": "details",
                        "itemName": "detail",
                        "layout": "row",
                        "expanded": true,
                        "classes": ["mt-md"],
                        "child": {
                          "type": "container",
                          "themeKey": "miniCard",
                          "classes": ["mr-sm"],
                          "child": {
                            "type": "row",
                            "children": [
                              {
                                "type": "icon",
                                "key": "detail.icon",
                                "themeKey": "icon",
                                "size": "sm",
                              },
                              {
                                "type": "column",
                                "classes": ["ml-sm"],
                                "flex": 1,
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "detail.label",
                                    "themeKey": "miniLabel",
                                  },
                                  {
                                    "type": "text",
                                    "key": "detail.value",
                                    "themeKey": "miniValue",
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
                },
              ],
            },
          ],
        },
      },

      {
        "id": "quick_actions",
        "type": "benefit_cards",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],

          "grid": ["mt-md"],

          "card": [
            "bg-card",
            "border-muted",
            "rounded-xl",
            "p-md",
            "w-action-half",
          ],

          "icon": ["text-muted"],

          "description": ["text-body", "text-xs", "font-bold", "text-center"],
        },
        "props": {
          "title": "Quick Actions",
          "items": [
            {
              "icon": "phone",
              "label": "Call Support",
              "action": {"type": "call_support"},
            },
            {
              "icon": "location",
              "label": "Find Station",
              "action": {"type": "find_station"},
            },
            {
              "icon": "warning",
              "label": "Report Issue",
              "action": {"type": "report_issue"},
            },
            {
              "icon": "calendar",
              "label": "Extend Rental",
              "action": {"type": "extend_rental"},
            },
          ],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},

                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "quick",
                  "layout": "wrap",
                  "spacing": 8,
                  "runSpacing": 8,
                  "classes": ["mt-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "height": 78,
                    "alignment": "center",
                    "action": {
                      "type": "dynamic_action",
                      "paramKey": "quick.action.type",
                    },
                    "child": {
                      "type": "column",
                      "mainAxis": "center",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "icon",
                          "key": "quick.icon",
                          "themeKey": "icon",
                          "size": "xl",
                        },
                        {
                          "type": "text",
                          "key": "quick.label",
                          "themeKey": "description",
                          "classes": ["mt-sm"],
                          "textAlign": "center",
                          "maxLines": 1,
                          "overflow": "ellipsis",
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
      },
      {
        "id": "ai_phone_agent",
        "type": "insight_card",
        "classes": ["mb-lg"],
        "theme": {
          "sectionTitle": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],
          "iconBox": ["bg-info-dark", "rounded-md", "p-sm"],
          "icon": ["text-info"],
          "title": ["text-info", "text-xs", "font-bold"],
          "text": ["text-info", "text-xs"],
          "primaryButton": ["bg-info", "rounded-md", "px-md", "py-sm"],
          "primaryLabel": ["text-white", "text-xs", "font-bold"],
          "secondaryButton": [
            "bg-transparent",
            "border-info",
            "rounded-md",
            "px-md",
            "py-sm",
          ],
          "secondaryLabel": ["text-info", "text-xs", "font-bold"],
        },
        "props": {
          "sectionTitle": "AI Phone Agent",
          "icon": "phone",
          "title": "24/7 AI Voice Assistant",
          "text":
              "Call our AI agent anytime for instant help with availability, pricing, quotes, and booking completion. Supports multiple languages.",
          "primaryButton": "Call AI Agent",
          "secondaryButton": "Request Callback",
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
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "child": {
                          "type": "icon",
                          "key": "icon",
                          "themeKey": "icon",
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
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "row",
                            "classes": ["mt-md"],
                            "children": [
                              {
                                "type": "container",
                                "themeKey": "primaryButton",
                                "action": {"type": "call_ai_agent"},
                                "child": {
                                  "type": "text",
                                  "key": "primaryButton",
                                  "themeKey": "primaryLabel",
                                },
                              },
                              {
                                "type": "container",
                                "themeKey": "secondaryButton",
                                "classes": ["ml-sm"],
                                "action": {"type": "request_callback"},
                                "child": {
                                  "type": "text",
                                  "key": "secondaryButton",
                                  "themeKey": "secondaryLabel",
                                },
                              },
                            ],
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
      },

      {
        "id": "support_chat",
        "type": "support_chat_box",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "bubble": ["bg-black", "border-muted", "rounded-md", "p-md"],
          "userBubble": ["bg-primary", "rounded-md", "p-md"],
          "message": ["text-white", "text-xs", "font-bold"],
          "userMessage": ["text-black", "text-xs", "font-bold"],
          "time": ["text-muted", "text-xs"],

          "placeholder": ["text-muted", "text-xs"],
          "sendButton": ["bg-white", "rounded-full", "p-sm"],
          "sendIcon": ["text-black"],
        },
        "props": {
          "title": "Support Chat",
          "message": "Welcome to your rental! How can we help you today?",
          "time": "10:30 AM",
          "placeholder": "Type your message...",
        },
      },

      {
        "id": "emergency_support",
        "type": "info_card",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-danger-soft", "border-danger", "rounded-lg", "p-md"],
          "icon": ["text-danger"],
          "title": ["text-danger", "text-sm", "font-bold"],
          "text": ["text-danger", "text-xs", "font-bold"],
          "phone": ["text-danger", "text-xs", "font-bold"],
        },
        "props": {
          "icon": "warning",
          "title": "24/7 Emergency Support",
          "text": "For accidents or breakdowns, call immediately",
          "phone": "+1 (555) 123-4567",
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "classes": ['mt-lg'],
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
                      {
                        "type": "text",
                        "key": "phone",
                        "themeKey": "phone",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "active_rental_bottom_bar",
        "type": "bottom_bar",
        "classes": ["bg-app", "border-muted", "p-md"],
        "theme": {
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-sm", "font-bold"],
        },
        "props": {
          "mode": "single_button",
          "buttonLabel": "Prepare for Return",
          "button": {
            "label": "Prepare for Return",
            "action": {"type": "prepare_return"},
          },
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "button",
              "action": {"type": "prepare_return"},
              "child": {
                "type": "text",
                "key": "buttonLabel",
                "themeKey": "buttonLabel",
                "textAlign": "center",
              },
            },
          ],
        },
      },
    ],
  },
};
