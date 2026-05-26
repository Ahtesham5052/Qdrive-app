const Map<dynamic, dynamic> createAccountJson = {
  "version": "1.0",
  "screen": "create_account",

  "meta": {
    "generatedAt": "2026-05-18T18:30:00Z",
    "cacheKey": "create_account_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "title": "Create account",
      "subtitle": "Secure access to your Qdrive account",
    },

    "social": {
      "googleLabel": "Google",
      "appleLabel": "Apple",
      "dividerText": "OR REGISTER",
    },

    "form": {
      "title": "",
      "buttonLabel": "Continue",
      "signinPrefix": "Already a member?",
      "signinLabel": "Sign in",

      "fields": [
        {
          "id": "signup_full_name",
          "type": "text",
          "label": "Full name",
          "placeholder": "Alex Morgan",
          "keyboardType": "text",
          "textCapitalization": "words",
          "required": true,
          "width": "full",
        },
        {
          "id": "signup_email",
          "type": "text",
          "label": "Email",
          "placeholder": "you@example.com",
          "keyboardType": "email",
          "required": true,
          "width": "full",
        },
        {
          "id": "signup_password",
          "type": "text",
          "label": "Password",
          "placeholder": "Min. 8 characters",
          "keyboardType": "text",
          "obscureText": true,
          "required": true,
          "minLength": 8,
          "width": "full",
        },
        {
          "id": "signup_confirm_password",
          "type": "text",
          "label": "Confirm password",
          "placeholder": "Repeat password",
          "keyboardType": "text",
          "obscureText": true,
          "required": true,
          "matchFieldId": "signup_password",
          "matchMessage": "Passwords do not match",
          "width": "full",
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "signInGoogle": {"type": "sign_in_google", "params": {}},
    "signInApple": {"type": "sign_in_apple", "params": {}},
    "continueCreateAccount": {"type": "continue_create_account", "params": {}},
    "openSignIn": {"type": "open_sign_in", "params": {}},
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "create_account_top_back",
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
        "id": "create_account_header",
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
        "id": "create_account_social",
        "type": "text_block",
        "bind": "content.social",
        "classes": ["mb-xl"],
        "theme": {
          "googleButton": ["bg-white", "rounded-xl", "px-lg", "py-md"],
          "googleIcon": ["text-info", "text-xl", "font-bold"],
          "googleLabel": ["text-black", "text-sm", "font-bold"],

          "appleButton": ["bg-black", "rounded-xl", "px-lg", "py-md"],
          "appleIcon": ["text-white"],
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
        "id": "create_account_form",
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

          "button": ["bg-white", "rounded-xl", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-sm", "font-bold"],

          "signinMuted": ["text-muted", "text-sm"],
          "signinLink": ["text-body", "text-sm", "font-bold"],
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
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-lg"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "continue_create_account"},
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
                      "key": "signinPrefix",
                      "themeKey": "signinMuted",
                    },
                    {
                      "type": "container",
                      "classes": ["ml-xs"],
                      "action": {"type": "open_sign_in"},
                      "child": {
                        "type": "text",
                        "key": "signinLabel",
                        "themeKey": "signinLink",
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
