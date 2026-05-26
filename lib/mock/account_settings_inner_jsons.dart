const Map<dynamic, dynamic> personalInformationJson = {
  "version": "1.0",
  "screen": "personal_information",

  "meta": {
    "generatedAt": "2026-05-18T18:50:00Z",
    "cacheKey": "personal_information_v2_api_driven",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Personal information"},

    "profile": {
      "label": "Profile Photo",
      "image":
          "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=160",
      "buttonLabel": "Change Photo",

      "api_path": "/account/profile-photo.json",
      "api_path_type": "POST",
      "api_path_data": {
        "section": "personal_information",
        "field": "profile_photo",
        "source": "camera",
      },
    },

    "form": {
      "form_id": "personal_information",
      "buttonLabel": "Save Changes",

      "api_path": "/account/personal-information.json",
      "api_path_type": "POST",
      "api_path_data": {
        "section": "personal_information",
        "formId": "personal_information",
      },

      "fields": [
        {
          "id": "legal_name",
          "type": "text",
          "label": "Legal Name",
          "placeholder": "John Anderson",
          "value": "John Anderson",
          "keyboardType": "text",
          "textCapitalization": "words",
          "required": true,
          "width": "full",
        },
        {
          "id": "display_name",
          "type": "text",
          "label": "Display Name",
          "placeholder": "John A",
          "value": "John A",
          "keyboardType": "text",
          "textCapitalization": "words",
          "required": true,
          "width": "full",
        },
        {
          "id": "date_of_birth",
          "type": "date",
          "label": "Date of Birth",
          "placeholder": "05/15/1990",
          "value": "05/15/1990",
          "required": true,
          "width": "full",
        },
        {
          "id": "gender",
          "type": "dropdown",
          "label": "Gender",
          "placeholder": "Select gender",
          "value": "Male",
          "required": false,
          "width": "full",
          "icon": "chevron_down",
          "options": [
            {"label": "Male", "value": "Male"},
            {"label": "Female", "value": "Female"},
            {"label": "Rather not say", "value": "Rather not say"},
          ],
        },
        {
          "id": "address",
          "type": "textarea",
          "label": "Address",
          "placeholder": "123 Main Street, London, UK",
          "value": "123 Main Street, London, UK",
          "keyboardType": "multiline",
          "required": true,
          "width": "full",
          "minLines": 3,
          "maxLines": 5,
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
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "personal_information_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "profile_photo_section",
        "type": "text_block",
        "bind": "content.profile",
        "classes": ["mb-lg"],
        "theme": {
          "label": ["text-body", "text-xs", "font-bold"],
          "avatar": ["rounded-full"],
          "button": ["bg-card-soft", "rounded-full", "px-md", "py-sm"],
          "buttonIcon": ["text-body"],
          "buttonLabel": ["text-body", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "start",
              "children": [
                {"type": "text", "key": "label", "themeKey": "label"},
                {
                  "type": "row",
                  "crossAxis": "center",
                  "classes": ["mt-sm"],
                  "children": [
                    {
                      "type": "image",
                      "key": "image",
                      "themeKey": "avatar",
                      "width": 58,
                      "height": 58,
                      "fit": "cover",
                    },
                    {
                      "type": "container",
                      "themeKey": "button",
                      "classes": ["ml-md"],
                      "action": {
                        "type": "open_camera",
                        "params": {
                          "apiPathKey": "api_path",
                          "apiPathTypeKey": "api_path_type",
                          "apiPathDataKey": "api_path_data",
                        },
                      },
                      "child": {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "camera",
                            "themeKey": "buttonIcon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "key": "buttonLabel",
                            "themeKey": "buttonLabel",
                            "classes": ["ml-xs"],
                          },
                        ],
                      },
                    },
                  ],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "personal_information_form",
        "type": "form_section",
        "bind": "content.form",
        "classes": ["mb-xl"],
        "theme": {
          "label": ["text-body", "text-xs", "font-bold"],
          "field": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-md",
          ],
          "fieldText": ["text-body", "text-sm"],
          "placeholderText": ["text-body", "text-sm"],
          "fieldIcon": ["text-muted"],

          "dropdownMenu": ["bg-card-soft"],
          "dropdownItem": ["bg-card-soft", "px-md", "py-sm"],

          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],
        },
        "props": {
          "formIdKey": "form_id",
          "fieldsKey": "fields",
          "submitMode": "manual",
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "form_fields", "itemsKey": "fields"},
                {
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-lg"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {
                    "type": "save_form",
                    "params": {
                      "formIdKey": "form_id",
                      "apiPathKey": "api_path",
                      "apiPathTypeKey": "api_path_type",
                      "apiPathDataKey": "api_path_data",
                      "includeFormValues": true,
                    },
                  },
                  "child": {
                    "type": "text",
                    "key": "buttonLabel",
                    "themeKey": "buttonLabel",
                    "textAlign": "center",
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  },
};

const Map<dynamic, dynamic> contactDetailsJson = {
  "version": "1.0",
  "screen": "contact_details",

  "meta": {
    "generatedAt": "2026-05-18T18:51:00Z",
    "cacheKey": "contact_details_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Contact details"},

    "form": {
      "buttonLabel": "Save Changes",
      "note": "Person to contact in case of emergency",
      "fields": [
        {
          "id": "email_address",
          "type": "text",
          "label": "Email Address",
          "placeholder": "john.anderson@email.com",
          "value": "john.anderson@email.com",
          "keyboardType": "email",
          "required": true,
          "width": "full",
          "icon": "email",
        },
        {
          "id": "phone_number",
          "type": "text",
          "label": "Phone Number",
          "placeholder": "+44 7700 900000",
          "value": "+44 7700 900000",
          "keyboardType": "phone",
          "required": true,
          "width": "full",
          "icon": "phone",
        },
        {
          "id": "emergency_contact",
          "type": "text",
          "label": "Emergency Contact",
          "placeholder": "+44 7700 900001",
          "value": "+44 7700 900001",
          "keyboardType": "phone",
          "required": true,
          "width": "full",
          "icon": "phone",
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "saveContactDetails": {"type": "save_contact_details", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "contact_details_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "contact_details_form",
        "type": "form_section",
        "bind": "content.form",
        "classes": ["mb-xl"],
        "theme": {
          "label": ["text-body", "text-xs", "font-bold"],
          "field": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-md",
          ],
          "fieldText": ["text-body", "text-sm"],
          "placeholderText": ["text-body", "text-sm"],
          "fieldIcon": ["text-muted"],

          "note": ["text-muted", "text-xs"],
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],
        },
        "props": {"fieldsKey": "fields", "submitMode": "manual"},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "form_fields", "itemsKey": "fields"},
                {
                  "type": "text",
                  "key": "note",
                  "themeKey": "note",
                  "classes": ["mt-xs"],
                },
                {
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-xl"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "save_contact_details"},
                  "child": {
                    "type": "text",
                    "key": "buttonLabel",
                    "themeKey": "buttonLabel",
                    "textAlign": "center",
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  },
};

const Map<dynamic, dynamic> identityVerificationJson = {
  "version": "1.0",
  "screen": "identity_verification",

  "meta": {
    "generatedAt": "2026-05-18T18:52:00Z",
    "cacheKey": "identity_verification_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Identity verification"},

    "verification": {
      "items": [
        {
          "icon": "security",
          "title": "Government ID",
          "subtitle": "Passport, National ID, or Driver's License",
          "status": "Verified",
          "actionType": "open_government_id",
        },
        {
          "icon": "camera",
          "title": "Selfie Verification",
          "subtitle": "Take a photo to verify your identity",
          "status": "Verified",
          "actionType": "open_selfie_verification",
        },
        {
          "icon": "document",
          "title": "Driving License",
          "subtitle": "Required for vehicle rentals",
          "status": "Verified",
          "actionType": "open_driving_license",
        },
      ],
      "notice":
          "Identity verification helps keep our community safe and is required to complete bookings.",
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openGovernmentId": {"type": "open_government_id", "params": {}},
    "openSelfieVerification": {
      "type": "open_selfie_verification",
      "params": {},
    },
    "openDrivingLicense": {"type": "open_driving_license", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "identity_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "identity_verification_list",
        "type": "text_block",
        "bind": "content.verification",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "iconBox": ["bg-success-dark", "rounded-full"],
          "icon": ["text-success"],
          "title": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
          "status": ["text-success", "text-xs", "font-bold"],

          "noticeBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "notice": ["text-muted", "text-xs"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "item",
                  "layout": "column",
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "classes": ["mb-sm"],
                    "action": {
                      "type": "dynamic_action",
                      "paramKey": "item.actionType",
                    },
                    "child": {
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
                              "type": "text",
                              "key": "item.title",
                              "themeKey": "title",
                            },
                            {
                              "type": "text",
                              "key": "item.subtitle",
                              "themeKey": "subtitle",
                              "classes": ["mt-xs"],
                            },
                          ],
                        },
                        {
                          "type": "text",
                          "key": "item.status",
                          "themeKey": "status",
                        },
                      ],
                    },
                  },
                },
                {
                  "type": "container",
                  "themeKey": "noticeBox",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "text",
                    "key": "notice",
                    "themeKey": "notice",
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  },
};

const Map<dynamic, dynamic> passwordDevicesJson = {
  "version": "1.0",
  "screen": "password_devices",

  "meta": {
    "generatedAt": "2026-05-18T18:53:00Z",
    "cacheKey": "password_devices_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Password & devices"},

    "security": {
      "items": [
        {
          "icon": "lock",
          "title": "Change Password",
          "subtitle": "Last changed 30 days ago",
          "trailing": "chevron",
          "actionType": "open_change_password",
        },
        {
          "icon": "security",
          "title": "Two-Factor Authentication",
          "subtitle": "Add an extra layer of security",
          "trailing": "toggle",
          "enabled": false,
          "actionType": "toggle_two_factor",
        },
        {
          "icon": "globe",
          "title": "Connected Accounts",
          "subtitle": "Google, Apple",
          "trailing": "chevron",
          "actionType": "open_connected_accounts",
        },
        {
          "icon": "phone",
          "title": "Active Devices",
          "subtitle": "3 devices logged in",
          "trailing": "chevron",
          "actionType": "open_active_devices",
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openChangePassword": {"type": "open_change_password", "params": {}},
    "toggleTwoFactor": {"type": "toggle_two_factor", "params": {}},
    "openConnectedAccounts": {"type": "open_connected_accounts", "params": {}},
    "openActiveDevices": {"type": "open_active_devices", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "password_devices_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "password_devices_list",
        "type": "text_block",
        "bind": "content.security",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "icon": ["text-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
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
              "itemsKey": "items",
              "itemName": "item",
              "layout": "column",
              "child": {
                "type": "container",
                "themeKey": "card",
                "classes": ["mb-sm"],
                "action": {
                  "type": "dynamic_action",
                  "paramKey": "item.actionType",
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
                      "type": "column",
                      "classes": ["ml-md"],
                      "flex": 1,
                      "children": [
                        {
                          "type": "text",
                          "key": "item.title",
                          "themeKey": "title",
                        },
                        {
                          "type": "text",
                          "key": "item.subtitle",
                          "themeKey": "subtitle",
                          "classes": ["mt-xs"],
                        },
                      ],
                    },
                    {
                      "type": "icon",
                      "icon": "chevron_right",
                      "themeKey": "chevron",
                      "size": "md",
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
                        "type": "dynamic_action",
                        "paramKey": "item.actionType",
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
};

const Map<dynamic, dynamic> preferencesJson = {
  "version": "1.0",
  "screen": "preferences",

  "meta": {
    "generatedAt": "2026-05-18T18:54:00Z",
    "cacheKey": "preferences_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Preferences"},

    "preferences": {
      "fields": [
        {
          "id": "language",
          "type": "dropdown",
          "label": "Language",
          "placeholder": "Select language",
          "value": "English",
          "required": true,
          "width": "full",
          "icon": "chevron_down",
          "options": [
            {"label": "English", "value": "English"},
            {"label": "French", "value": "French"},
            {"label": "Spanish", "value": "Spanish"},
            {"label": "Arabic", "value": "Arabic"},
            {"label": "Urdu", "value": "Urdu"},
          ],
        },
        {
          "id": "currency",
          "type": "dropdown",
          "label": "Currency",
          "placeholder": "Select currency",
          "value": "GBP (£)",
          "required": true,
          "width": "full",
          "icon": "chevron_down",
          "options": [
            {"label": "GBP (£)", "value": "GBP"},
            {"label": "EUR (€)", "value": "EUR"},
            {"label": "USD (\$)", "value": "USD"},
            {"label": "AED (د.إ)", "value": "AED"},
            {"label": "PKR (₨)", "value": "PKR"},
          ],
        },
      ],

      "themeLabel": "Theme",
      "themeTitle": "Light Mode",
      "themeText": "Switch between light and dark mode",
      "themeIcon": "sun",

      "notificationsTitle": "Notifications",
      "notificationItems": [
        {
          "icon": "email",
          "title": "Email Notifications",
          "subtitle": "Booking updates & offers",
          "enabled": true,
          "actionType": "toggle_email_notifications",
        },
        {
          "icon": "phone",
          "title": "SMS Notifications",
          "subtitle": "Booking confirmations & reminders",
          "enabled": false,
          "actionType": "toggle_sms_notifications",
        },
      ],

      "privacyTitle": "Privacy Settings",
      "privacyButton": "Manage Privacy Preferences",
      "saveButton": "Save Preferences",
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openLanguageSelector": {"type": "open_language_selector", "params": {}},
    "openCurrencySelector": {"type": "open_currency_selector", "params": {}},
    "toggleTheme": {"type": "toggle_theme", "params": {}},
    "toggleEmailNotifications": {
      "type": "toggle_email_notifications",
      "params": {},
    },
    "toggleSmsNotifications": {
      "type": "toggle_sms_notifications",
      "params": {},
    },
    "openPrivacyPreferences": {
      "type": "open_privacy_preferences",
      "params": {},
    },
    "savePreferences": {"type": "save_preferences", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "preferences_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "preferences_content",
        "type": "text_block",
        "bind": "content.preferences",
        "classes": ["mb-xl"],
        "theme": {
          "label": ["text-body", "text-xs", "font-bold"],

          "field": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "fieldText": ["text-body", "text-xs", "font-bold"],
          "placeholderText": ["text-muted", "text-xs"],
          "fieldIcon": ["text-body"],
          "dropdownMenu": ["bg-card-soft"],
          "dropdownItem": ["bg-card-soft", "px-md", "py-sm"],

          "themeBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "themeText": ["text-muted", "text-xs"],
          "themeIconBox": ["bg-muted", "rounded-md", "p-sm"],
          "themeIcon": ["text-body"],

          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "rowIcon": ["text-muted"],
          "rowTitle": ["text-body", "text-sm", "font-bold"],
          "rowSubtitle": ["text-muted", "text-xs"],

          "switchTrackOn": ["bg-white", "rounded-full"],
          "switchTrackOff": ["bg-muted", "rounded-full"],
          "switchThumbOn": ["bg-black", "rounded-full"],
          "switchThumbOff": ["bg-white", "rounded-full"],
          "privacyBox": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "p-md",
          ],
          "privacyText": ["text-body", "text-xs", "font-bold"],
          "chevron": ["text-body"],

          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "form_fields", "itemsKey": "fields"},

                {
                  "type": "text",
                  "key": "themeLabel",
                  "themeKey": "label",
                  "classes": ["mt-md"],
                },
                {
                  "type": "container",
                  "themeKey": "themeBox",
                  "classes": ["mt-xs", "mb-md"],
                  "action": {"type": "toggle_theme"},
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "text",
                        "key": "themeText",
                        "themeKey": "themeText",
                        "flex": 1,
                      },
                      {
                        "type": "container",
                        "themeKey": "themeIconBox",
                        "child": {
                          "type": "icon",
                          "icon": "sun",
                          "themeKey": "themeIcon",
                          "size": "md",
                        },
                      },
                    ],
                  },
                },

                {
                  "type": "text",
                  "key": "notificationsTitle",
                  "themeKey": "sectionTitle",
                  "classes": ["mb-md"],
                },

                {
                  "type": "for_each",
                  "itemsKey": "notificationItems",
                  "itemName": "item",
                  "layout": "column",
                  "child": {
                    "type": "container",
                    "classes": ["mb-md"],
                    "action": {
                      "type": "dynamic_action",
                      "paramKey": "item.actionType",
                    },
                    "child": {
                      "type": "row",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "icon",
                          "key": "item.icon",
                          "themeKey": "rowIcon",
                          "size": "md",
                        },
                        {
                          "type": "column",
                          "classes": ["ml-sm"],
                          "flex": 1,
                          "children": [
                            {
                              "type": "text",
                              "key": "item.title",
                              "themeKey": "rowTitle",
                            },
                            {
                              "type": "text",
                              "key": "item.subtitle",
                              "themeKey": "rowSubtitle",
                              "classes": ["mt-xs"],
                            },
                          ],
                        },
                        {
                          "type": "switch_button",
                          "valueKey": "item.enabled",
                          "width": 42,
                          "height": 24,
                          "thumbSize": 20,
                          "padding": 2,
                          "onTrackThemeKey": "switchTrackOn",
                          "offTrackThemeKey": "switchTrackOff",
                          "onThumbThemeKey": "switchThumbOn",
                          "offThumbThemeKey": "switchThumbOff",
                          "action": {
                            "type": "dynamic_action",
                            "paramKey": "item.actionType",
                          },
                        },
                      ],
                    },
                  },
                },

                {
                  "type": "text",
                  "key": "privacyTitle",
                  "themeKey": "sectionTitle",
                  "classes": ["mt-md", "mb-md"],
                },

                {
                  "type": "container",
                  "themeKey": "privacyBox",
                  "action": {"type": "open_privacy_preferences"},
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "text",
                        "key": "privacyButton",
                        "themeKey": "privacyText",
                        "flex": 1,
                      },
                      {
                        "type": "icon",
                        "icon": "chevron_right",
                        "themeKey": "chevron",
                        "size": "md",
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "button",
                  "classes": ["mt-lg"],
                  "fullWidth": true,
                  "alignment": "center",
                  "action": {"type": "save_preferences"},
                  "child": {
                    "type": "text",
                    "key": "saveButton",
                    "themeKey": "buttonLabel",
                    "textAlign": "center",
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  },
};

const Map<dynamic, dynamic> paymentsSettingsJson = {
  "version": "1.0",
  "screen": "payments_settings",

  "meta": {
    "generatedAt": "2026-05-18T18:55:00Z",
    "cacheKey": "payments_settings_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Payments"},

    "payments": {
      "cards": [
        {
          "brand": "VISA",
          "number": "•••• 4242",
          "expiry": "Expires 12/26",
          "badge": "Default",
          "actionType": "open_payment_card",
        },
        {
          "brand": "MC",
          "number": "•••• 8888",
          "expiry": "Expires 08/27",
          "badge": "",
          "actionType": "open_payment_card",
        },
      ],
      "addButton": "Add Payment Method",
      "billingTitle": "Billing Address",
      "billingAddress": "123 Main Street, London, UK",
      "editAddress": "Edit Address",
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "openPaymentCard": {"type": "open_payment_card", "params": {}},
    "addPaymentMethod": {"type": "add_payment_method", "params": {}},
    "editBillingAddress": {"type": "edit_billing_address", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "payments_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "payments_content",
        "type": "text_block",
        "bind": "content.payments",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "brandBox": ["bg-white", "rounded-sm", "px-sm", "py-xs"],
          "brand": ["text-black", "text-xs", "font-bold"],
          "number": ["text-body", "text-sm", "font-bold"],
          "expiry": ["text-muted", "text-xs"],
          "badge": ["bg-card-soft", "rounded-sm", "px-sm", "py-xs"],
          "badgeText": ["text-body", "text-xs", "font-bold"],

          "addBox": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-md",
          ],
          "addIcon": ["text-muted"],
          "addText": ["text-body", "text-xs", "font-bold"],

          "sectionTitle": ["text-body", "text-sm", "font-bold"],
          "addressBox": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "p-md",
          ],
          "address": ["text-body", "text-xs", "font-bold"],
          "edit": ["text-body", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "for_each",
                  "itemsKey": "cards",
                  "itemName": "card",
                  "layout": "column",
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "classes": ["mb-sm"],
                    "action": {
                      "type": "dynamic_action",
                      "paramKey": "card.actionType",
                    },
                    "child": {
                      "type": "row",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "brandBox",
                          "child": {
                            "type": "text",
                            "key": "card.brand",
                            "themeKey": "brand",
                          },
                        },
                        {
                          "type": "column",
                          "classes": ["ml-md"],
                          "flex": 1,
                          "children": [
                            {
                              "type": "text",
                              "key": "card.number",
                              "themeKey": "number",
                            },
                            {
                              "type": "text",
                              "key": "card.expiry",
                              "themeKey": "expiry",
                              "classes": ["mt-xs"],
                            },
                          ],
                        },
                        {
                          "type": "container",
                          "themeKey": "badge",
                          "visibleWhen": "card.badge != ''",
                          "child": {
                            "type": "text",
                            "key": "card.badge",
                            "themeKey": "badgeText",
                          },
                        },
                      ],
                    },
                  },
                },

                {
                  "type": "container",
                  "themeKey": "addBox",
                  "classes": ["mt-sm", "mb-lg"],
                  "alignment": "center",
                  "action": {"type": "add_payment_method"},
                  "child": {
                    "type": "row",
                    "mainAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "credit_card",
                        "themeKey": "addIcon",
                        "size": "md",
                      },
                      {
                        "type": "text",
                        "key": "addButton",
                        "themeKey": "addText",
                        "classes": ["ml-sm"],
                      },
                    ],
                  },
                },

                {
                  "type": "text",
                  "key": "billingTitle",
                  "themeKey": "sectionTitle",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "container",
                  "themeKey": "addressBox",
                  "action": {"type": "edit_billing_address"},
                  "child": {
                    "type": "column",
                    "children": [
                      {
                        "type": "text",
                        "key": "billingAddress",
                        "themeKey": "address",
                      },
                      {
                        "type": "text",
                        "key": "editAddress",
                        "themeKey": "edit",
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
    ],
  },
};

const Map<dynamic, dynamic> accountControlsJson = {
  "version": "1.0",
  "screen": "account_controls",

  "meta": {
    "generatedAt": "2026-05-18T18:56:00Z",
    "cacheKey": "account_controls_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Account controls"},

    "controls": {
      "deactivate": {
        "icon": "warning",
        "title": "Deactivate Account",
        "text":
            "Temporarily disable your account. You can reactivate it anytime by logging back in.",
        "button": "Deactivate Account",
      },
      "delete": {
        "icon": "trash",
        "title": "Delete Account",
        "text":
            "Permanently delete your account and all data. This action cannot be undone.",
        "button": "Delete Account",
      },
      "notice":
          "Before deleting your account, make sure you've cancelled all active bookings and resolved any outstanding payments.",
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "deactivateAccount": {"type": "deactivate_account", "params": {}},
    "deleteAccount": {"type": "delete_account", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "account_controls_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-lg"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-sm", "font-bold", "text-center"],
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
                      "width": 38,
                      "height": 38,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "lg",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 38, "height": 38},
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
        "id": "account_controls_content",
        "type": "text_block",
        "bind": "content.controls",
        "classes": ["mb-xl"],
        "theme": {
          "dangerCard": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "icon": ["text-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],

          "button": ["bg-white", "rounded-md", "px-md", "py-sm"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],

          "noticeBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "notice": ["text-muted", "text-xs"],
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
                  "themeKey": "dangerCard",
                  "classes": ["mb-md"],
                  "child": {
                    "type": "column",
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "start",
                        "children": [
                          {
                            "type": "icon",
                            "key": "deactivate.icon",
                            "themeKey": "icon",
                            "size": "md",
                          },
                          {
                            "type": "column",
                            "classes": ["ml-sm"],
                            "flex": 1,
                            "children": [
                              {
                                "type": "text",
                                "key": "deactivate.title",
                                "themeKey": "title",
                              },
                              {
                                "type": "text",
                                "key": "deactivate.text",
                                "themeKey": "text",
                                "classes": ["mt-xs"],
                              },
                            ],
                          },
                        ],
                      },
                      {
                        "type": "container",
                        "themeKey": "button",
                        "classes": ["mt-md"],
                        "fullWidth": true,
                        "alignment": "center",
                        "action": {"type": "deactivate_account"},
                        "child": {
                          "type": "text",
                          "key": "deactivate.button",
                          "themeKey": "buttonLabel",
                          "textAlign": "center",
                        },
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "dangerCard",
                  "classes": ["mb-lg"],
                  "child": {
                    "type": "column",
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "start",
                        "children": [
                          {
                            "type": "icon",
                            "key": "delete.icon",
                            "themeKey": "icon",
                            "size": "md",
                          },
                          {
                            "type": "column",
                            "classes": ["ml-sm"],
                            "flex": 1,
                            "children": [
                              {
                                "type": "text",
                                "key": "delete.title",
                                "themeKey": "title",
                              },
                              {
                                "type": "text",
                                "key": "delete.text",
                                "themeKey": "text",
                                "classes": ["mt-xs"],
                              },
                            ],
                          },
                        ],
                      },
                      {
                        "type": "container",
                        "themeKey": "button",
                        "classes": ["mt-md"],
                        "fullWidth": true,
                        "alignment": "center",
                        "action": {"type": "delete_account"},
                        "child": {
                          "type": "text",
                          "key": "delete.button",
                          "themeKey": "buttonLabel",
                          "textAlign": "center",
                        },
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "noticeBox",
                  "child": {
                    "type": "text",
                    "key": "notice",
                    "themeKey": "notice",
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  },
};
