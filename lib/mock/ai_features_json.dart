const Map<dynamic, dynamic> aiPoweredFeaturesJson = {
  "version": "1.0",
  "screen": "ai_powered_features",

  "meta": {
    "generatedAt": "2026-05-18T16:40:00Z",
    "cacheKey": "ai_powered_features_v2",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "icon": "sparkles",
      "title": "AI-Powered Features",
      "subtitle":
          "Advanced artificial intelligence features designed to enhance every step of your car rental journey",
    },

    "features": {
      "naturalLanguageSearch": {
        "icon": "sparkles",
        "title": "Natural Language Search",
        "text":
            "Search in plain English like “7-seater for Heathrow on Friday” - AI interprets your intent and finds perfect matches.",
      },
      "visualVideoSearch": {
        "icon": "camera",
        "title": "Visual & Video Search",
        "text":
            "Photograph or share a video of any vehicle - AI identifies make, model, trim and finds closest available matches.",
      },
      "aiConciergeAssistant": {
        "icon": "chat",
        "title": "AI Concierge Assistant",
        "text":
            "Always-on intelligent chat available on website, WhatsApp, and partner portals. Handles bookings, pricing, and support.",
      },
      "priceIntelligence": {
        "icon": "trend_down",
        "title": "Price Intelligence",
        "text":
            "Historical pricing analysis shows you when to book for best deals - save up to 18% by choosing optimal dates.",
      },
      "multilingualSupport": {
        "icon": "globe",
        "title": "Multilingual Support",
        "text":
            "Full conversation in your native language with automatic confirmation in local language - zero language barriers.",
      },
      "documentCompliance": {
        "icon": "security",
        "title": "Document Compliance",
        "text":
            "AI reads expiry dates, validates licences, cross-references bookings, and flags issues before rental starts.",
      },
      "personalizationEngine": {
        "icon": "users",
        "title": "Personalization Engine",
        "text":
            "Returning customers get personalized homepage ranked by booking history, preferences, and spend profile.",
      },
      "predictiveBooking": {
        "icon": "trend_down",
        "title": "Predictive Booking",
        "text":
            "AI analyzes patterns and proactively suggests bookings before your expected window opens - never miss a deal.",
      },
      "tripIntelligence": {
        "icon": "location",
        "title": "Trip Intelligence",
        "text":
            "Recommends optimal pickup points, chauffeur options, and extras based on destination, dates, and group size.",
      },
      "aiVoiceAgent": {
        "icon": "phone",
        "title": "AI Voice Agent",
        "text":
            "24/7 phone support with intelligent voice assistant - handles availability, pricing, quotes, and bookings by voice.",
      },
    },
    "footer": {
      "icon": "sparkles",
      "title": "Intelligent by Design",
      "text":
          "Every feature is powered by advanced AI to make your rental experience seamless, personalized, and hassle-free.",
    },
  },

  "actions": {
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "ai_features_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-xl"],
        "theme": {
          "iconBox": ["bg-info", "rounded-xl", "p-md"],
          "icon": ["text-white"],
          "title": ["text-body", "text-xl", "font-bold", "text-center"],
          "subtitle": ["text-muted", "text-sm", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "classes": ['mt-3xl'],
              "crossAxis": "center",
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconBox",
                  "width": 64,
                  "height": 64,
                  "alignment": "center",
                  "child": {
                    "type": "icon",
                    "key": "icon",
                    "themeKey": "icon",
                    "size": "lg",
                  },
                },
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mt-lg"],
                  "textAlign": "center",
                },
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-sm"],
                  "textAlign": "center",
                },
              ],
            },
          ],
        },
      },

      {
        "id": "feature_natural_language_search",
        "type": "text_block",
        "bind": "content.features.naturalLanguageSearch",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_visual_video_search",
        "type": "text_block",
        "bind": "content.features.visualVideoSearch",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_ai_concierge_assistant",
        "type": "text_block",
        "bind": "content.features.aiConciergeAssistant",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_price_intelligence",
        "type": "text_block",
        "bind": "content.features.priceIntelligence",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-success", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_multilingual_support",
        "type": "text_block",
        "bind": "content.features.multilingualSupport",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-warning", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_document_compliance",
        "type": "text_block",
        "bind": "content.features.documentCompliance",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-warning", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_personalization_engine",
        "type": "text_block",
        "bind": "content.features.personalizationEngine",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_predictive_booking",
        "type": "text_block",
        "bind": "content.features.predictiveBooking",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-success", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_trip_intelligence",
        "type": "text_block",
        "bind": "content.features.tripIntelligence",
        "classes": ["mb-sm"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },

      {
        "id": "feature_ai_voice_agent",
        "type": "text_block",
        "bind": "content.features.aiVoiceAgent",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-info", "rounded-lg", "p-sm"],
          "icon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
        },
        "props": {},
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
                    "type": "container",
                    "themeKey": "iconBox",
                    "width": 40,
                    "height": 40,
                    "alignment": "center",
                    "child": {
                      "type": "icon",
                      "key": "icon",
                      "themeKey": "icon",
                      "size": "sm",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
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
      },
      {
        "id": "ai_features_footer",
        "type": "text_block",
        "bind": "content.footer",
        "classes": ["mt-md", "mb-xl"],
        "theme": {
          "card": ["bg-info-soft", "border-info", "rounded-lg", "p-lg"],
          "icon": ["text-info"],
          "title": ["text-info", "text-xs", "font-bold", "text-center"],
          "text": ["text-muted", "text-xs", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "fullWidth": true,
              "child": {
                "type": "column",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "key": "icon",
                    "themeKey": "icon",
                    "size": "md",
                  },
                  {
                    "type": "text",
                    "key": "title",
                    "themeKey": "title",
                    "classes": ["mt-sm"],
                    "textAlign": "center",
                  },
                  {
                    "type": "text",
                    "key": "text",
                    "themeKey": "text",
                    "classes": ["mt-xs"],
                    "textAlign": "center",
                  },
                ],
              },
            },
          ],
        },
      },
    ],
  },
};
