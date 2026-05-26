const Map<dynamic, dynamic> accountSettingsJson = {
  "version": "1.0",
  "screen": "account_settings",

  "meta": {
    "generatedAt": "2026-05-18T18:40:00Z",
    "cacheKey": "account_settings_v2_api_driven",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Account"},

    "accountSettings": {
      "sections": [
        {
          "id": "account",
          "title": "ACCOUNT",
          "items": [
            {
              "id": "personal_information",
              "icon": "person",
              "label": "Personal information",
              "trailing": "chevron",
              "api_path": "/account/personal-information.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "account",
                "itemId": "personal_information",
              },
            },
            {
              "id": "contact_details",
              "icon": "email",
              "label": "Contact details",
              "trailing": "chevron",
              "api_path": "/account/contact-details.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "account",
                "itemId": "contact_details",
              },
            },
            {
              "id": "identity_verification",
              "icon": "security",
              "label": "Identity verification",
              "trailing": "chevron",
              "api_path": "/account/identity-verification.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "account",
                "itemId": "identity_verification",
              },
            },
          ],
        },

        {
          "id": "security",
          "title": "SECURITY",
          "items": [
            {
              "id": "password_devices",
              "icon": "lock",
              "label": "Password & devices",
              "trailing": "chevron",
              "api_path": "/account/password-devices.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "security",
                "itemId": "password_devices",
              },
            },
            {
              "id": "dark_mode",
              "icon": "moon",
              "label": "Dark mode",
              "trailing": "toggle",
              "enabled": true,
              "api_path": "/account/settings/dark-mode.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "security",
                "itemId": "dark_mode",
                "settingKey": "dark_mode",
                "enabled": true,
              },
            },
          ],
        },

        {
          "id": "app",
          "title": "APP",
          "items": [
            {
              "id": "language_region",
              "icon": "language",
              "label": "Language & region",
              "trailing": "chevron",
              "api_path": "/account/language-region.json",
              "api_path_type": "POST",
              "api_path_data": {"section": "app", "itemId": "language_region"},
            },
            {
              "id": "notifications",
              "icon": "notification",
              "label": "Notifications",
              "trailing": "chevron",
              "api_path": "/account/notifications.json",
              "api_path_type": "POST",
              "api_path_data": {"section": "app", "itemId": "notifications"},
            },
            {
              "id": "payments",
              "icon": "credit_card",
              "label": "Payments",
              "trailing": "chevron",
              "api_path": "/account/payments.json",
              "api_path_type": "POST",
              "api_path_data": {"section": "app", "itemId": "payments"},
            },
          ],
        },

        {
          "id": "support",
          "title": "SUPPORT",
          "items": [
            {
              "id": "help_centre",
              "icon": "help",
              "label": "Help centre",
              "trailing": "chevron",
              "api_path": "/support/help-centre.json",
              "api_path_type": "POST",
              "api_path_data": {"section": "support", "itemId": "help_centre"},
            },
          ],
        },

        {
          "id": "account_management",
          "title": "ACCOUNT MANAGEMENT",
          "items": [
            {
              "id": "delete_account",
              "icon": "warning",
              "label": "Deactivate or delete account",
              "trailing": "chevron",
              "api_path": "/account/delete-account.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "account_management",
                "itemId": "delete_account",
              },
            },
            {
              "id": "sign_out",
              "icon": "sign_out",
              "label": "Sign out",
              "trailing": "chevron",
              "api_path": "/auth/sign-out.json",
              "api_path_type": "POST",
              "api_path_data": {
                "section": "account_management",
                "itemId": "sign_out",
              },
            },
          ],
        },
      ],
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
        "id": "account_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-lg", "font-bold", "text-center"],
          "divider": ["bg-muted"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
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
                {
                  "type": "container",
                  "themeKey": "divider",
                  "height": 1,
                  "classes": ["mt-md"],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "account_settings_list",
        "type": "text_block",
        "bind": "content.accountSettings",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-muted", "text-xs", "font-bold"],

          "row": ["bg-transparent", "py-md"],
          "icon": ["text-body"],
          "label": ["text-body", "text-sm", "font-bold"],
          "chevron": ["text-muted"],

          "switchTrackOn": ["bg-white", "rounded-full"],
          "switchTrackOff": ["bg-muted", "rounded-full"],
          "switchThumbOn": ["bg-black", "rounded-full"],
          "switchThumbOff": ["bg-white", "rounded-full"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "for_each",
              "itemsKey": "sections",
              "itemName": "section",
              "layout": "column",
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "classes": ["mb-xl"],
                "children": [
                  {
                    "type": "text",
                    "key": "section.title",
                    "themeKey": "sectionTitle",
                    "classes": ["mb-sm"],
                  },

                  {
                    "type": "for_each",
                    "itemsKey": "section.items",
                    "itemName": "item",
                    "layout": "column",
                    "child": {
                      "type": "container",
                      "themeKey": "row",
                      "action": {
                        "type": "api_call",
                        "params": {
                          "apiPathKey": "item.api_path",
                          "apiPathTypeKey": "item.api_path_type",
                          "apiPathDataKey": "item.api_path_data",
                        },
                      },
                      "child": {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "key": "item.icon",
                            "themeKey": "icon",
                            "size": "md",
                          },
                          {
                            "type": "text",
                            "key": "item.label",
                            "themeKey": "label",
                            "classes": ["ml-md"],
                            "flex": 1,
                          },

                          {
                            "type": "icon",
                            "icon": "chevron_right",
                            "themeKey": "chevron",
                            "size": "sm",
                            "visibleWhen": "item.trailing == 'chevron'",
                          },

                          {
                            "type": "switch_button",
                            "valueKey": "item.enabled",
                            "width": 42,
                            "height": 24,
                            "thumbSize": 20,
                            "padding": 2,
                            "visibleWhen": "item.trailing == 'toggle'",
                            "onTrackThemeKey": "switchTrackOn",
                            "offTrackThemeKey": "switchTrackOff",
                            "onThumbThemeKey": "switchThumbOn",
                            "offThumbThemeKey": "switchThumbOff",
                            "action": {
                              "type": "api_call",
                              "params": {
                                "apiPathKey": "item.api_path",
                                "apiPathTypeKey": "item.api_path_type",
                                "apiPathDataKey": "item.api_path_data",
                              },
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
      },
    ],
  },
};
