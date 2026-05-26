const Map<dynamic, dynamic> signInJson = {
  "version": "1.0",
  "screen": "sign_in",

  "meta": {
    "generatedAt": "2026-05-18T18:10:00Z",
    "cacheKey": "sign_in_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "title": "Sign in",
      "subtitle": "Secure access to your Qdrive account",
    },

    "social": {
      "googleLabel": "Google",
      "appleLabel": "Apple",
      "dividerText": "OR EMAIL",
    },

    "form": {
      "title": "",
      "rememberLabel": "Remember me",
      "forgotPasswordLabel": "Forgot password?",
      "buttonLabel": "Sign in",
      "createPrefix": "New to Qdrive?",
      "createLabel": "Create an account",

      "fields": [
        {
          "id": "signin_email",
          "type": "text",
          "label": "Email",
          "placeholder": "you@example.com",
          "keyboardType": "email",
          "required": true,
          "width": "full",
        },
        {
          "id": "signin_password",
          "type": "text",
          "label": "Password",
          "placeholder": "••••••••",
          "keyboardType": "text",
          "obscureText": true,
          "required": true,
          "width": "full",
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "signIn": {"type": "sign_in", "params": {}},
    "signInGoogle": {"type": "sign_in_google", "params": {}},
    "signInApple": {"type": "sign_in_apple", "params": {}},
    "forgotPassword": {"type": "forgot_password", "params": {}},
    "createAccount": {"type": "create_account", "params": {}},
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "signin_top_back",
        "type": "button_group",
        "classes": ["mb-lg"],
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
              "crossAxis": "center",
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
        "id": "signin_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-xl", "font-bold"],
          "subtitle": ["text-muted", "text-sm"],
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
                  "classes": ["mt-xs"],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "signin_social",
        "type": "text_block",
        "bind": "content.social",
        "classes": ["mb-xl"],
        "theme": {
          "googleButton": ["bg-white", "rounded-xl", "px-lg", "py-md"],
          "googleIcon": ["text-info", "text-xl", "font-bold"],
          "googleLabel": ["text-black", "text-sm", "font-bold"],

          "appleButton": ["bg-black", "rounded-xl", "px-lg", "py-md"],
          "appleIcon": ["text-white", "text-xl", "font-bold"],
          "appleLabel": ["text-white", "text-sm", "font-bold"],

          "divider": ["bg-muted"],
          "dividerText": ["text-muted", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "container",
                  "themeKey": "googleButton",
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "sign_in_google"},
                  "child": {
                    "type": "row",
                    "mainAxis": "center",
                    "crossAxis": "center",
                    "children": [
                      {"type": "text", "value": "G", "themeKey": "googleIcon"},
                      {
                        "type": "text",
                        "key": "googleLabel",
                        "themeKey": "googleLabel",
                        "classes": ["ml-md"],
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "appleButton",
                  "classes": ["mt-md"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "sign_in_apple"},
                  "child": {
                    "type": "row",
                    "mainAxis": "center",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "apple",
                        "themeKey": "appleIcon",
                        "size": "md",
                      },
                      {
                        "type": "text",
                        "key": "appleLabel",
                        "themeKey": "appleLabel",
                        "classes": ["ml-md"],
                      },
                    ],
                  },
                },

                {
                  "type": "row",
                  "crossAxis": "center",
                  "classes": ["mt-xl"],
                  "children": [
                    {
                      "type": "container",
                      "themeKey": "divider",
                      "height": 1,
                      "flex": 1,
                    },
                    {
                      "type": "text",
                      "key": "dividerText",
                      "themeKey": "dividerText",
                      "classes": ["ml-md", "mr-md"],
                    },
                    {
                      "type": "container",
                      "themeKey": "divider",
                      "height": 1,
                      "flex": 1,
                    },
                  ],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "signin_form",
        "type": "form_section",
        "bind": "content.form",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold"],

          "label": ["text-body", "text-sm", "font-bold"],
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

          "checkboxChecked": ["bg-white", "border-muted", "rounded-sm"],
          "checkboxUnchecked": ["bg-transparent", "border-muted", "rounded-sm"],
          "checkboxIcon": ["text-black"],
          "rememberText": ["text-muted", "text-sm", "font-bold"],
          "forgotText": ["text-body", "text-sm", "font-bold"],

          "button": ["bg-white", "rounded-xl", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-sm", "font-bold"],

          "createMuted": ["text-muted", "text-sm"],
          "createLink": ["text-body", "text-sm", "font-bold"],
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
                {
                  "type": "form_fields",
                  "itemsKey": "fields",
                  "classes": ["mt-xs"],
                },

                {
                  "type": "row",
                  "crossAxis": "center",
                  "classes": ["mt-lg"],
                  "children": [
                    {
                      "type": "row",
                      "crossAxis": "center",
                      "flex": 1,
                      "children": [
                        {
                          "type": "checkbox_toggle",
                          "id": "remember_me",
                          "defaultValue": true,
                          "width": 18,
                          "height": 18,
                          "checkedThemeKey": "checkboxChecked",
                          "uncheckedThemeKey": "checkboxUnchecked",
                          "iconThemeKey": "checkboxIcon",
                        },
                        {
                          "type": "text",
                          "key": "rememberLabel",
                          "themeKey": "rememberText",
                          "classes": ["ml-sm"],
                        },
                      ],
                    },
                    {
                      "type": "container",
                      "action": {"type": "forgot_password"},
                      "child": {
                        "type": "text",
                        "key": "forgotPasswordLabel",
                        "themeKey": "forgotText",
                      },
                    },
                  ],
                },

                {
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-lg"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "sign_in"},
                  "child": {
                    "type": "text",
                    "key": "buttonLabel",
                    "themeKey": "buttonLabel",
                    "textAlign": "center",
                  },
                },

                {
                  "type": "row",
                  "mainAxis": "center",
                  "crossAxis": "center",
                  "classes": ["mt-xl"],
                  "children": [
                    {
                      "type": "text",
                      "key": "createPrefix",
                      "themeKey": "createMuted",
                    },
                    {
                      "type": "container",
                      "classes": ["ml-xs"],
                      "action": {"type": "create_account"},
                      "child": {
                        "type": "text",
                        "key": "createLabel",
                        "themeKey": "createLink",
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
};
