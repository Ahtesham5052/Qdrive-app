const Map<dynamic, dynamic> helpSupportJson = {
  "version": "1.0",
  "screen": "help_support",

  "meta": {
    "generatedAt": "2026-05-18T16:55:00Z",
    "cacheKey": "help_support_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Help & Support"},

    "aiConcierge": {
      "title": "AI Concierge Available 24/7",
      "text":
          "Get instant answers to your questions with our AI-powered concierge",
      "buttonLabel": "Chat with AI Concierge",
    },

    "contact": {
      "title": "Contact Us",
      "phone": {
        "icon": "phone",
        "title": "Phone Support",
        "value": "+44 800 123 4567",
      },
      "email": {
        "icon": "email",
        "title": "Email Support",
        "value": "support@carrentals.com",
      },
      "hours": {
        "icon": "clock",
        "title": "Support Hours",
        "value": "24/7 Available",
      },
    },

    "faqs": {
      "title": "Frequently Asked Questions",
      "items": [
        {
          "question": "How do I modify or cancel my booking?",
          "answer":
              "Visit Previous Bookings from the menu and select your booking to view modification options.",
          "expanded": true,
        },
        {
          "question": "What documents do I need to rent a vehicle?",
          "answer":
              "You will usually need a valid driving licence, proof of ID and any booking documents requested for your rental.",
          "expanded": false,
        },
        {
          "question": "How does the AI concierge work?",
          "answer":
              "The AI concierge helps answer common rental questions, guide you through your booking and connect you with support when needed.",
          "expanded": false,
        },
        {
          "question": "What's the fuel policy?",
          "answer":
              "Most vehicles should be returned with the same fuel level shown at collection. Your booking details will confirm the exact policy.",
          "expanded": false,
        },
        {
          "question": "Can I add an additional driver?",
          "answer":
              "Yes, you can add an additional driver if they meet the rental requirements and provide the required documents.",
          "expanded": false,
        },
        {
          "question": "What if I return the vehicle late?",
          "answer":
              "Late returns may create extra charges. Contact support as soon as possible if you think your return will be delayed.",
          "expanded": false,
        },
      ],
    },

    "messageForm": {
      "title": "Send us a message",
      "buttonLabel": "Send Message",
      "note":
          "We typically respond within 24 hours. For urgent matters, please call our support team.",
      "fields": [
        {
          "id": "support_email",
          "type": "text",
          "label": "Email Address",
          "placeholder": "your@email.com",
          "keyboardType": "email",
          "required": true,
          "width": "full",
        },
        {
          "id": "support_subject",
          "type": "text",
          "label": "Subject",
          "placeholder": "How can we help?",
          "keyboardType": "text",
          "required": true,
          "width": "full",
        },
        {
          "id": "support_message",
          "type": "textarea",
          "label": "Message",
          "placeholder": "Tell us more about your question or issue...",
          "keyboardType": "multiline",
          "required": true,
          "width": "full",
          "minLines": 5,
          "maxLines": 7,
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openAiConcierge": {"type": "open_chat", "params": {}},
    "phoneSupport": {
      "type": "call_phone",
      "params": {"phone": "+448001234567"},
    },
    "emailSupport": {
      "type": "send_email",
      "params": {"email": "support@carrentals.com"},
    },
    "openSupportHours": {"type": "open_support_hours", "params": {}},
    "submitSupportMessage": {"type": "send_support_message", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "help_support_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-xl"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-lg", "font-bold", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "container",
                  "width": 42,
                  "height": 42,
                  "themeKey": "backButton",
                  "alignment": "center",
                  "action": {"type": "go_back"},
                  "child": {
                    "type": "icon",
                    "icon": "arrow_back",
                    "themeKey": "backIcon",
                    "size": "md",
                  },
                },
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "flex": 1,
                  "textAlign": "center",
                },
                {"type": "container", "width": 42, "height": 42},
              ],
            },
          ],
        },
      },

      {
        "id": "ai_concierge_card",
        "type": "text_block",
        "bind": "content.aiConcierge",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-xl", "p-lg"],
          "iconBox": ["bg-white", "rounded-lg"],
          "icon": ["text-black"],
          "title": ["text-body", "text-base", "font-bold"],
          "text": ["text-muted", "text-xs"],
          "button": ["bg-white", "rounded-lg", "px-md", "py-sm"],
          "buttonIcon": ["text-black"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "fullWidth": true,
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  {
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 48,
                    "height": 48,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "icon": "sparkles",
                      "themeKey": "icon",
                      "size": "md",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
                    "crossAxis": "start",
                    "children": [
                      {"type": "text", "key": "title", "themeKey": "title"},
                      {
                        "type": "text",
                        "key": "text",
                        "themeKey": "text",
                        "classes": ["mt-xs"],
                      },
                      {
                        "type": "container",
                        "themeKey": "button",
                        "classes": ["mt-md"],
                        "action": {"type": "open_chat"},
                        "child": {
                          "type": "row",
                          "mainAxisSize": "min",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "icon",
                              "icon": "chat",
                              "themeKey": "buttonIcon",
                              "size": "sm",
                            },
                            {
                              "type": "text",
                              "key": "buttonLabel",
                              "themeKey": "buttonLabel",
                              "classes": ["ml-sm"],
                            },
                          ],
                        },
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
        "id": "contact_us_section",
        "type": "text_block",
        "bind": "content.contact",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-card-soft", "rounded-lg"],
          "icon": ["text-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
          "value": ["text-muted", "text-xs", "font-bold"],
          "chevron": ["text-muted"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "sectionTitle"},

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "action": {"type": "call_phone"},
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 38,
                        "height": 38,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "phone.icon",
                          "themeKey": "icon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "phone.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "phone.value",
                            "themeKey": "value",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                      {
                        "type": "icon",
                        "icon": "chevron_right",
                        "themeKey": "chevron",
                        "size": "sm",
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "action": {"type": "send_email"},
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 38,
                        "height": 38,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "email.icon",
                          "themeKey": "icon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "email.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "email.value",
                            "themeKey": "value",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                      {
                        "type": "icon",
                        "icon": "chevron_right",
                        "themeKey": "chevron",
                        "size": "sm",
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "action": {"type": "open_support_hours"},
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 38,
                        "height": 38,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "hours.icon",
                          "themeKey": "icon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "hours.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "hours.value",
                            "themeKey": "value",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                      {
                        "type": "icon",
                        "icon": "chevron_right",
                        "themeKey": "chevron",
                        "size": "sm",
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
        "id": "faq_accordion",
        "type": "accordion_section",
        "bind": "content.faqs",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "titleIcon": ["text-muted"],

          "item": ["bg-transparent", "border-muted", "rounded-md", "p-md"],
          "expandedItem": [
            "bg-transparent",
            "border-muted",
            "rounded-xl",
            "p-md",
          ],

          "question": ["text-body", "text-sm", "font-bold"],
          "answer": ["text-muted", "text-xs"],
          "icon": ["text-muted"],
        },
        "props": {
          "titleKey": "title",
          "itemsKey": "items",
          "questionKey": "question",
          "answerKey": "answer",

          "variant": "card",
          "initialOpenIndex": 0,

          "titleAlign": "start",
          "titleIcon": "book",

          "showQuestionLeadingIcon": false,
          "showTrailingIcon": true,
          "trailingIcon": "help_outline",
          "expandedTrailingIcon": "help_outline",

          "itemSpacing": 10,
          "questionMaxLines": 2,
        },
      },
      {
        "id": "send_message_form",
        "type": "form_section",
        "bind": "content.messageForm",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],

          "label": ["text-body", "text-xs", "font-bold"],

          "field": [
            "bg-transparent",
            "border-muted",
            "rounded-xl",
            "px-md",
            "py-md",
          ],
          "fieldText": ["text-body", "text-sm"],
          "placeholderText": ["text-muted", "text-sm"],
          "fieldIcon": ["text-muted"],

          "button": ["bg-white", "rounded-xl", "px-lg", "py-md"],
          "buttonIcon": ["text-black"],
          "buttonLabel": ["text-black", "text-sm", "font-bold"],

          "note": ["text-muted", "text-xs", "text-center"],
        },
        "props": {
          "titleKey": "title",
          "fieldsKey": "fields",
          "submitMode": "manual",
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
                  "classes": ["mt-lg"],
                },

                {
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-lg"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "send_support_message"},
                  "child": {
                    "type": "row",
                    "mainAxis": "center",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "send",
                        "themeKey": "buttonIcon",
                        "size": "sm",
                      },
                      {
                        "type": "text",
                        "key": "buttonLabel",
                        "themeKey": "buttonLabel",
                        "classes": ["ml-sm"],
                      },
                    ],
                  },
                },

                {
                  "type": "text",
                  "key": "note",
                  "themeKey": "note",
                  "classes": ["mt-md"],
                  "textAlign": "center",
                },
              ],
            },
          ],
        },
      },
    ],
  },
};
