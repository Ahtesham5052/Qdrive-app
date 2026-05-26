const Map<dynamic, dynamic> driverScoreJson = {
  "version": "1.0",
  "screen": "driver_score",

  "meta": {
    "generatedAt": "2026-05-18T17:55:00Z",
    "cacheKey": "driver_score_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "title": "Driver Score",
      "subtitle":
          "Your score affects your access to premium vehicles and special offers",
    },

    "scoreSummary": {
      "label": "Your Score",
      "score": "92",
      "rating": "Excellent",
      "progress": 0.92,
      "icon": "medal",
    },

    "breakdown": {
      "title": "Score Breakdown",
      "items": [
        {
          "icon": "security",
          "title": "Zero Damage Claims",
          "weight": "40%",
          "description": "No damage claims across 12 bookings",
          "score": "100",
          "total": "/100",
          "progress": 1.0,
        },
        {
          "icon": "calendar",
          "title": "Punctual Returns",
          "weight": "25%",
          "description": "11 of 12 vehicles returned on time",
          "score": "95",
          "total": "/100",
          "progress": 0.95,
        },
        {
          "icon": "chat",
          "title": "Supplier Feedback",
          "weight": "20%",
          "description": "Positive feedback from 10 suppliers",
          "score": "88",
          "total": "/100",
          "progress": 0.88,
        },
        {
          "icon": "document",
          "title": "Document History",
          "weight": "10%",
          "description": "Consistent valid documentation",
          "score": "90",
          "total": "/100",
          "progress": 0.90,
        },
        {
          "icon": "trend_up",
          "title": "Tenure & Activity",
          "weight": "5%",
          "description": "Member for 2.5 years, 12 bookings",
          "score": "85",
          "total": "/100",
          "progress": 0.85,
        },
      ],
    },

    "benefits": {
      "title": "Your Benefits",
      "items": [
        "Access to all vehicle categories",
        "Priority customer support",
        "Flexible cancellation policy",
        "Special discounts on long-term rentals",
      ],
    },

    "improve": {
      "title": "How to Improve",
      "text":
          "Continue returning vehicles on time and maintain your clean claims record to reach a perfect score!",
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "driver_score_top_back",
        "type": "button_group",
        "classes": ["mb-md"],
        "theme": {
          "iconButton": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "p-md",
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
                    "size": "md",
                  },
                },
              ],
            },
          ],
        },
      },

      {
        "id": "driver_score_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-xl", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
        },
        "props": {},
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
                  "classes": ["mt-sm"],
                  "maxLines": 2,
                  "softWrap": true,
                },
              ],
            },
          ],
        },
      },

      {
        "id": "driver_score_summary",
        "type": "text_block",
        "bind": "content.scoreSummary",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-card-soft", "rounded-xl", "p-lg"],
          "label": ["text-muted", "text-xs"],
          "score": ["text-body", "text-3xl", "font-extrabold"],
          "track": ["bg-muted", "rounded-full"],
          "fill": ["bg-white", "rounded-full"],
          "iconBox": ["bg-white", "rounded-full"],
          "icon": ["text-black"],
          "rating": ["text-body", "text-xs", "font-bold"],
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
                "crossAxis": "center",
                "children": [
                  {
                    "type": "column",
                    "flex": 1,
                    "crossAxis": "stretch",
                    "children": [
                      {"type": "text", "key": "label", "themeKey": "label"},
                      {
                        "type": "text",
                        "key": "score",
                        "themeKey": "score",
                        "classes": ["mt-xs"],
                      },
                      {
                        "type": "container",
                        "themeKey": "track",
                        "classes": ["mt-md"],
                        "height": 7,
                        "fullWidth": true,
                        "child": {
                          "type": "container",
                          "themeKey": "fill",
                          "height": 7,
                          "progressKey": "progress",
                        },
                      },
                    ],
                  },
                  {
                    "type": "column",
                    "classes": ["ml-lg"],
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
                        "key": "rating",
                        "themeKey": "rating",
                        "classes": ["mt-sm"],
                        "textAlign": "center",
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
        "id": "driver_score_breakdown",
        "type": "text_block",
        "bind": "content.breakdown",
        "classes": ["mb-lg"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],

          "card": ["bg-card-soft", "border-muted", "rounded-xl", "p-md"],
          "iconBox": ["bg-muted", "rounded-md", "p-sm"],
          "icon": ["text-muted"],

          "title": ["text-body", "text-xs", "font-bold"],
          "weight": ["text-muted", "text-xs"],
          "description": ["text-muted", "text-xs"],

          "score": ["text-body", "text-lg", "font-bold"],
          "total": ["text-muted", "text-xs"],

          "track": ["bg-muted", "rounded-full"],
          "fill": ["bg-white", "rounded-full"],
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
                      "type": "column",
                      "crossAxis": "stretch",
                      "children": [
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "container",
                              "themeKey": "iconBox",
                              "width": 34,
                              "height": 34,
                              "alignment": "center",
                              "child": {
                                "type": "icon",
                                "key": "item.icon",
                                "themeKey": "icon",
                                "size": "md",
                              },
                            },
                            {
                              "type": "column",
                              "classes": ["ml-md"],
                              "flex": 1,
                              "children": [
                                {
                                  "type": "row",
                                  "crossAxis": "center",
                                  "children": [
                                    {
                                      "type": "text",
                                      "key": "item.title",
                                      "themeKey": "title",
                                    },
                                    {
                                      "type": "text",
                                      "value": " (",
                                      "themeKey": "weight",
                                    },
                                    {
                                      "type": "text",
                                      "key": "item.weight",
                                      "themeKey": "weight",
                                    },
                                    {
                                      "type": "text",
                                      "value": ")",
                                      "themeKey": "weight",
                                    },
                                  ],
                                },
                                {
                                  "type": "text",
                                  "key": "item.description",
                                  "themeKey": "description",
                                  "classes": ["mt-xs"],
                                  "maxLines": 2,
                                  "softWrap": true,
                                },
                              ],
                            },
                            {
                              "type": "column",
                              "crossAxis": "end",
                              "classes": ["ml-md"],
                              "children": [
                                {
                                  "type": "text",
                                  "key": "item.score",
                                  "themeKey": "score",
                                },
                                {
                                  "type": "text",
                                  "key": "item.total",
                                  "themeKey": "total",
                                },
                              ],
                            },
                          ],
                        },
                        {
                          "type": "container",
                          "themeKey": "track",
                          "classes": ["mt-md"],
                          "height": 6,
                          "fullWidth": true,
                          "child": {
                            "type": "container",
                            "themeKey": "fill",
                            "height": 6,
                            "progressKey": "item.progress",
                          },
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
        "id": "driver_score_benefits",
        "type": "text_block",
        "bind": "content.benefits",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-card-soft", "rounded-xl", "p-lg"],
          "title": ["text-body", "text-sm", "font-bold"],
          "item": ["text-muted", "text-xs"],
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
                "crossAxis": "start",
                "children": [
                  {"type": "text", "key": "title", "themeKey": "title"},
                  {
                    "type": "for_each",
                    "itemsKey": "items",
                    "itemName": "benefit",
                    "layout": "column",
                    "classes": ["mt-md"],
                    "child": {
                      "type": "row",
                      "classes": ["mb-xs"],
                      "children": [
                        {"type": "text", "value": "✓", "themeKey": "item"},
                        {
                          "type": "text",
                          "key": "benefit",
                          "themeKey": "item",
                          "classes": ["ml-xs"],
                          "flex": 1,
                        },
                      ],
                    },
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "driver_score_improve",
        "type": "text_block",
        "bind": "content.improve",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-lg"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
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
                "crossAxis": "start",
                "children": [
                  {"type": "text", "key": "title", "themeKey": "title"},
                  {
                    "type": "text",
                    "key": "text",
                    "themeKey": "text",
                    "classes": ["mt-sm"],
                    "maxLines": 4,
                    "softWrap": true,
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
