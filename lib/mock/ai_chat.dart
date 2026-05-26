const Map<dynamic, dynamic> aiConciergeChatJson = {
  "version": "1.0",
  "screen": "ai_concierge_chat",

  "content": {
    "chat": {
      "title": "QDrive AI Concierge",
      "status": "Online · ready to help",

      "suggestions": [
        "Find a car for 5 people",
        "What's included in insurance?",
        "Show me electric cars",
      ],

      "footerText": "Also available via WhatsApp & phone 24/7",
      "placeholder": "Ask me anything...",
      "bottomText": "Multilingual support · Secure & private",
    },
  },

  "actions": {
    "closeChat": {"type": "go_back", "params": {}},
    "expandChat": {"type": "expand_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "ai_chat",
        "type": "text_block",
        "bind": "content.chat",
        "classes": ["bg-black"],

        "theme": {
          "header": ["bg-card", "border-bottom-muted", "px-md", "py-sm"],

          "logoBox": ["bg-card-soft", "rounded-full", "p-sm"],
          "logoIcon": ["text-white"],

          "title": ["text-white", "text-sm", "font-extrabold"],

          "statusDot": ["bg-success", "rounded-full"],
          "statusText": ["text-white", "text-xs"],

          "headerAction": ["p-xs"],
          "headerActionIcon": ["text-white"],

          "suggestionChip": [
            "bg-black",
            "border-muted",
            "rounded-full",
            "px-md",
            "py-xs",
          ],
          "suggestionText": ["text-white", "text-xs", "font-bold"],

          "userMessageCard": ["bg-primary", "rounded-xl", "px-md", "py-md"],

          "userMessageText": ["text-black", "text-sm"],
          "userMessageLabel": ["text-black", "text-xs"],
          "userMessageTime": ["text-black", "text-xs"],

          "messageCard": ["bg-card-soft", "rounded-xl", "px-md", "py-md"],

          "messageLabel": ["text-muted", "text-xs"],
          "messageText": ["text-white", "text-sm"],
          "messageTime": ["text-muted", "text-xs"],

          "footerBar": ["bg-card", "border-bottom-muted", "px-md", "py-xs"],
          "footerText": ["text-muted", "text-xs"],

          "inputWrap": ["px-sm", "py-sm"],
          "inputBox": [
            "bg-card-soft",
            "border-muted",
            "rounded-xl",
            "px-md",
            "py-md",
          ],
          "placeholder": ["text-muted", "text-sm"],

          "sendButton": ["bg-white", "rounded-xl", "p-md"],
          "sendIcon": ["text-black"],

          "bottomText": ["text-muted", "text-xs"],
        },

        "config": {
          "layout": [
            {
              "type": "container",
              "fullWidth": true,
              "height": 720,
              "child": {
                "type": "stack",
                "fit": "expand",
                "children": [
                  {
                    "type": "positioned",
                    "left": 0,
                    "right": 0,
                    "top": 0,
                    "bottom": 118,
                    "child": {
                      "type": "column",
                      "crossAxis": "stretch",
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "header",
                          "child": {
                            "type": "row",
                            "crossAxis": "center",
                            "children": [
                              {
                                "type": "container",
                                "themeKey": "logoBox",
                                "child": {
                                  "type": "icon",
                                  "icon": "sparkles",
                                  "themeKey": "logoIcon",
                                  "size": "md",
                                },
                              },
                              {
                                "type": "column",
                                "classes": ["ml-md"],
                                "flex": 1,
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "title",
                                    "themeKey": "title",
                                  },
                                  {
                                    "type": "row",
                                    "crossAxis": "center",
                                    "classes": ["mt-xs"],
                                    "children": [
                                      {
                                        "type": "container",
                                        "themeKey": "statusDot",
                                        "width": 8,
                                        "height": 8,
                                      },
                                      {
                                        "type": "text",
                                        "key": "status",
                                        "themeKey": "statusText",
                                        "classes": ["ml-xs"],
                                      },
                                    ],
                                  },
                                ],
                              },
                              {
                                "type": "container",
                                "themeKey": "headerAction",
                                "action": {"type": "expand_chat"},
                                "child": {
                                  "type": "icon",
                                  "icon": "fullscreen",
                                  "themeKey": "headerActionIcon",
                                  "size": "sm",
                                },
                              },
                              {
                                "type": "container",
                                "themeKey": "headerAction",
                                "action": {"type": "go_back"},
                                "classes": ["ml-sm"],
                                "child": {
                                  "type": "icon",
                                  "icon": "close",
                                  "themeKey": "headerActionIcon",
                                  "size": "sm",
                                },
                              },
                            ],
                          },
                        },
                        {
                          "type": "ai_chat_suggestions",
                          "itemsKey": "suggestions",
                          "classes": ["mt-sm", "mb-md"],
                        },
                        {
                          "type": "expanded",
                          "child": {"type": "ai_chat_messages", "fill": true},
                        },
                      ],
                    },
                  },
                  {
                    "type": "positioned",
                    "left": 0,
                    "right": 0,
                    "bottom": 20,
                    "child": {
                      "type": "container",
                      "themeKey": "footerShell",
                      "child": {
                        "type": "column",
                        "crossAxis": "stretch",
                        "children": [
                          {
                            "type": "container",
                            "themeKey": "footerBar",
                            "child": {
                              "type": "row",
                              "crossAxis": "center",
                              "children": [
                                {
                                  "type": "icon",
                                  "icon": "phone",
                                  "themeKey": "footerText",
                                  "size": "xs",
                                },
                                {
                                  "type": "text",
                                  "key": "footerText",
                                  "themeKey": "footerText",
                                  "classes": ["ml-sm"],
                                },
                              ],
                            },
                          },
                          {
                            "type": "ai_chat_input",
                            "placeholderKey": "placeholder",
                          },
                          {
                            "type": "align",
                            "alignment": "center",
                            "classes": ["mb-sm"],
                            "child": {
                              "type": "text",
                              "key": "bottomText",
                              "themeKey": "bottomText",
                            },
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
        "props": {
          "titleKey": "title",
          "statusKey": "status",
          "suggestionsKey": "suggestions",
          "footerTextKey": "footerText",
          "placeholderKey": "placeholder",
          "bottomTextKey": "bottomText",
        },
      },
    ],
  },
};
