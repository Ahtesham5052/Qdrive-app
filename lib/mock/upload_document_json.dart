const Map<dynamic, dynamic> uploadDocumentsJson = {
  "version": "1.0",
  "screen": "upload_documents",

  "meta": {
    "generatedAt": "2026-04-15T10:00:00Z",
    "cacheKey": "upload_documents_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "title": "Upload Documents",
      "subtitle": "Required before your rental starts",
    },

    "warning": {
      "icon": "warning",
      "title": "Upload within 48 hours",
      "text":
          "Your documents must be uploaded before your rental start date. The upload link will expire after 48 hours.",
    },

    "requirements": {
      "title": "Document Requirements",
      "items": [
        "Clear, high-quality photos",
        "All four corners visible",
        "No glare or shadows",
        "Information must be readable",
        "Valid and not expired",
      ],
    },

    "securityNotice": {
      "icon": "lock",
      "text":
          "Your documents are encrypted and stored securely. They will only be used for verification purposes and will be deleted after your rental period.",
    },
  },

  "dynamicData": {
    "documents": {
      "source": "api",
      "endpoint": "/bookings/documents",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,
      "fallback": {
        "uploadedCount": 0,
        "totalRequired": 2,
        "progress": 0,
        "progressLabel": "Upload Progress",
        "progressValue": "0/2",

        "compliance": {
          "showWhenUploadedCountAtLeast": 1,
          "title": "AI Compliance Check Complete",
          "titleIcon": "sparkles",
          "checkIcon": "check",
          "checksByDocumentType": {
            "driving_license":
                "Valid License • Expires in 2.5 years • Category matches vehicle",
            "identity_document": "Valid passport • Name matches license",
          },
          "fieldsByDocumentType": {
            "driving_license": [
              {"label": "Expiry Date", "value": "2028-12-15"},
              {"label": "Category", "value": "B (Car)"},
            ],
            "identity_document": [
              {"label": "Expiry Date", "value": "2030-06-20"},
            ],
          },
        },

        "uploads": {
          "driving_license": {
            "documentType": "driving_license",
            "uploaded": false,
            "fileName": null,
            "title": "Driving License",
            "subtitle": "Required",
            "missingLabel": "Upload required",
            "uploadedLabel": "Uploaded successfully",
          },

          "identity_document": {
            "documentType": "identity_document",
            "uploaded": false,
            "fileName": null,
            "title": "Identity Document",
            "subtitle": "Passport or ID card",
            "missingLabel": "Upload required",
            "uploadedLabel": "Uploaded successfully",
          },
        },
      },
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "continueAfterDocuments": {
      "type": "navigate",
      "params": {"route": "/booking-complete", "bookingId": "BK-2026-4521"},
    },

    "takeDocumentPhoto": {
      "type": "take_document_photo",
      "params": {"bookingId": "BK-2026-4521"},
    },

    "uploadDocument": {
      "type": "upload_document",
      "params": {"bookingId": "BK-2026-4521"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "upload_top_back",

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

        "config": {
          "layout": [
            {
              "type": "row",

              "crossAxis": "center",

              "children": [
                {
                  "type": "for_each",

                  "itemsKey": "buttons",

                  "itemName": "button",

                  "layout": "row",

                  "child": {
                    "type": "container",
                    "action": {"type": "go_back"},

                    "themeKey": "iconButton",

                    "child": {
                      "type": "icon",

                      "key": "button.icon",

                      "themeKey": "iconButtonIcon",

                      "size": "md",
                    },
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "align": "start",
          "buttons": [
            {"icon": "arrow_back", "variant": "icon", "actionRef": "goBack"},
          ],
        },
      },

      {
        "id": "upload_header",

        "type": "text_block",

        "bind": "content.header",

        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
        },

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

        "props": {
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "align": "start",
        },
      },

      {
        "id": "upload_warning",

        "type": "info_card",

        "bind": "content.warning",

        "classes": ["mb-lg"],

        "theme": {
          "card": ["bg-warning-soft", "border-warning", "rounded-lg", "p-md"],
          "icon": ["text-warning"],
          "title": ["text-warning", "text-xs", "font-bold"],
          "text": ["text-warning", "text-xs"],
        },

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
                    ],
                  },
                ],
              },
            },
          ],
        },

        "props": {"iconKey": "icon", "titleKey": "title", "textKey": "text"},
      },

      {
        "id": "upload_progress",

        "type": "progress_section",

        "bind": "dynamicData.documents",

        "classes": ["mb-lg"],

        "theme": {
          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-xs", "font-bold"],
          "track": ["bg-muted", "rounded-full"],
          "fill": ["bg-primary", "rounded-full"],
        },

        "config": {
          "layout": [
            {
              "type": "column",

              "crossAxis": "start",

              "children": [
                {
                  "type": "row",

                  "crossAxis": "center",

                  "mainAxis": "spaceBetween",

                  "children": [
                    {
                      "type": "text",

                      "key": "progressLabel",

                      "themeKey": "label",
                    },

                    {
                      "type": "text",

                      "key": "progressValue",

                      "themeKey": "value",
                    },
                  ],
                },

                {
                  "type": "container",

                  "themeKey": "track",

                  "classes": ["mt-sm"],

                  "height": 8,

                  "child": {
                    "type": "container",

                    "themeKey": "fill",

                    "height": 8,

                    "progressKey": "progress",
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "labelKey": "progressLabel",
          "valueKey": "progressValue",
          "progressKey": "progress",
          "totalRequiredKey": "totalRequired",
          "uploadedCountKey": "uploadedCount",
          "progressSourceKey": "documents",
        },
      },

      {
        "id": "document_requirements",

        "type": "check_list_section",

        "bind": "content.requirements",

        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-base", "font-bold"],
          "content": ["bg-card-soft", "rounded-lg", "p-md"],
          "itemIconBox": ["bg-transparent"],
          "itemIcon": ["text-muted"],
          "itemText": ["text-muted", "text-xs"],
        },

        "config": {
          "layout": [
            {
              "type": "column",

              "crossAxis": "start",

              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},

                {
                  "type": "container",

                  "themeKey": "content",

                  "classes": ["mt-md"],

                  "child": {
                    "type": "for_each",

                    "itemsKey": "items",

                    "itemName": "item",

                    "layout": "column",

                    "child": {
                      "type": "row",

                      "crossAxis": "start",

                      "classes": ["mb-sm"],

                      "children": [
                        {
                          "type": "container",

                          "themeKey": "itemIconBox",

                          "child": {
                            "type": "icon",

                            "icon": "check_circle",

                            "themeKey": "itemIcon",

                            "size": "xs",
                          },
                        },

                        {
                          "type": "text",

                          "key": "item",

                          "themeKey": "itemText",

                          "classes": ["ml-sm"],

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

        "props": {
          "titleKey": "title",
          "markerType": "dot",
          "itemsKey": "items",
        },
      },

      {
        "id": "document_compliance",

        "type": "document_compliance_card",

        "bind": "dynamicData.documents",

        "classes": ["mb-lg"],

        "theme": {
          "card": ["bg-success-dark", "border-success", "rounded-lg", "p-md"],
          "iconBox": ["bg-success", "rounded-md", "p-sm"],
          "icon": ["text-success-soft"],
          "titleIcon": ["text-success"],
          "checkIcon": ["text-success"],
          "title": ["text-success", "text-sm", "font-bold"],
          "checkText": ["text-success", "text-xs", "font-bold"],
          "fieldBox": ["bg-surface", "rounded-md", "p-sm"],
          "fieldLabel": ["text-muted", "text-xs"],
          "fieldValue": ["text-body", "text-xs", "font-bold"],
        },

        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "column",
                "crossAxis": "start",
                "children": [
                  {
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
                          {
                            "type": "row",
                            "crossAxis": "start",
                            "children": [
                              {
                                "type": "icon",
                                "key": "titleIcon",
                                "themeKey": "titleIcon",
                                "size": "sm",
                              },
                              {
                                "type": "text",
                                "key": "title",
                                "themeKey": "title",
                                "classes": ["ml-sm"],
                                "flex": 1,
                              },
                            ],
                          },
                          {
                            "type": "row",
                            "crossAxis": "start",
                            "classes": ["mt-sm"],
                            "children": [
                              {
                                "type": "icon",
                                "key": "checkIcon",
                                "themeKey": "checkIcon",

                                "size": "sm",
                              },
                              {
                                "type": "text",
                                "key": "latestCheck",
                                "themeKey": "checkText",
                                "classes": ["ml-sm"],
                                "flex": 1,
                              },
                            ],
                          },
                        ],
                      },
                    ],
                  },
                  {
                    "type": "for_each",
                    "itemsKey": "fields",
                    "itemName": "field",
                    "layout": "row",
                    "classes": ["mt-md"],
                    "expanded": true,
                    "child": {
                      "type": "container",
                      "themeKey": "fieldBox",
                      "classes": ["mr-sm"],
                      "child": {
                        "type": "column",
                        "crossAxis": "start",
                        "children": [
                          {
                            "type": "text",
                            "key": "field.label",
                            "themeKey": "fieldLabel",
                          },
                          {
                            "type": "text",
                            "key": "field.value",
                            "themeKey": "fieldValue",
                            "classes": ["mt-xs"],
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
          "uploadedCountKey": "uploadedCount",
          "showWhenUploadedCountAtLeastKey":
              "compliance.showWhenUploadedCountAtLeast",
          "titleKey": "compliance.title",
          "titleIconKey": "compliance.titleIcon",
          "checkIconKey": "compliance.checkIcon",
          "checksByDocumentTypeKey": "compliance.checksByDocumentType",
          "fieldsByDocumentTypeKey": "compliance.fieldsByDocumentType",
        },
      },

      {
        "id": "driving_license_upload",

        "type": "document_upload_card",

        "bind": "dynamicData.documents",

        "documentBind": "uploads.driving_license",

        "classes": ["mb-md"],

        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "uploadedCard": [
            "bg-success-dark",
            "border-success",
            "rounded-lg",
            "p-md",
          ],
          "iconBox": ["bg-card-soft", "rounded-md", "p-sm"],
          "uploadedIconBox": ["bg-success", "rounded-md", "p-sm"],
          "uploadedIcon": ["text-success-soft"],
          "icon": ["text-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
          "uploadedSubtitle": ["text-success", "text-xs"],
          "uploadBox": [
            "bg-black",
            "border-strong",
            "border-dashed",
            "rounded-xl",
            "p-xl",
          ],
          "uploadIcon": ["text-muted"],
          "uploadTitle": ["text-body", "text-xs", "font-bold"],
          "uploadSubtitle": ["text-muted", "text-xs"],
          "button": ["bg-inverse-card", "rounded-lg", "px-lg", "py-md"],
          "buttonIcon": ["text-inverse-body"],
          "buttonLabel": ["text-inverse-body", "text-sm", "font-bold"],
          "fileRow": ["bg-surface", "rounded-md", "p-md"],
          "fileIconBox": ["bg-card-soft", "rounded-md", "p-sm"],
          "fileIcon": ["text-muted"],
          "fileName": ["text-body", "text-xs", "font-bold"],
          "fileStatusIcon": ["text-success"],
        },

        "config": {
          "layout": [
            {
              "type": "container",

              "themeKey": "card",

              "child": {
                "type": "column",

                "crossAxis": "start",

                "children": [
                  {
                    "type": "row",

                    "crossAxis": "start",
                    "classes": ["mb-sm"],

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

                            "key": "subtitle",

                            "themeKey": "subtitle",

                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },

                  {
                    "type": "container",

                    "themeKey": "uploadBox",

                    "fullWidth": true,

                    "classes": ["mt-md"],

                    "child": {
                      "type": "column",

                      "crossAxis": "center",

                      "children": [
                        {
                          "type": "icon",

                          "key": "uploadIcon",

                          "themeKey": "uploadIcon",

                          "size": "lg",
                        },

                        {
                          "type": "text",

                          "key": "uploadTitle",

                          "themeKey": "uploadTitle",

                          "classes": ["mt-sm"],
                        },

                        {
                          "type": "text",

                          "key": "uploadSubtitle",

                          "themeKey": "uploadSubtitle",

                          "classes": ["mt-xs"],
                        },

                        {
                          "type": "container",

                          "themeKey": "button",

                          "classes": ["mt-md"],

                          "child": {
                            "type": "row",

                            "crossAxis": "center",
                            "mainAxis": "center",

                            "children": [
                              {
                                "type": "icon",

                                "key": "button.icon",

                                "themeKey": "buttonIcon",

                                "size": "md",
                              },

                              {
                                "type": "text",

                                "key": "button.label",

                                "themeKey": "buttonLabel",

                                "classes": ["ml-sm"],
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
          ],
        },

        "props": {
          "icon": "document",
          "uploadedIcon": "check_circle",
          "fileIcon": "document",
          "fileStatusIcon": "check_circle",
          "uploadIcon": "upload",
          "uploadTitle": "Upload from device",
          "uploadSubtitle": "PNG, JPG up to 10MB",
          "button": {
            "icon": "camera",
            "label": "Take Photo",
            "actionRef": "takeDocumentPhoto",
          },
          "documentTypeKey": "documentType",
          "uploadedKey": "uploaded",
          "fileNameKey": "fileName",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "missingLabelKey": "missingLabel",
          "uploadedLabelKey": "uploadedLabel",
        },
      },

      {
        "id": "identity_document_upload",

        "type": "document_upload_card",

        "bind": "dynamicData.documents",

        "documentBind": "uploads.identity_document",

        "classes": ["mb-lg"],

        "theme": {
          "card": ["bg-transparent", "border-muted", "rounded-lg", "p-md"],
          "uploadedCard": [
            "bg-success-dark",
            "border-success",
            "rounded-lg",
            "p-md",
          ],
          "iconBox": ["bg-card-soft", "rounded-md", "p-sm"],
          "uploadedIconBox": ["bg-success", "rounded-md", "p-sm"],
          "uploadedIcon": ["text-success-soft"],
          "icon": ["text-muted"],
          "uploadedSubtitle": ["text-success", "text-xs"],
          "title": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
          "uploadBox": [
            "bg-black",
            "border-strong",
            "border-dashed",
            "rounded-xl",
            "p-xl",
          ],
          "uploadIcon": ["text-muted"],
          "uploadTitle": ["text-body", "text-xs", "font-bold"],
          "uploadSubtitle": ["text-muted", "text-xs"],
          "button": ["bg-inverse-card", "rounded-lg", "px-lg", "py-md"],
          "buttonIcon": ["text-inverse-body"],
          "buttonLabel": ["text-inverse-body", "text-sm", "font-bold"],
          "fileRow": ["bg-surface", "rounded-md", "p-md"],
          "fileIconBox": ["bg-card-soft", "rounded-md", "p-sm"],
          "fileIcon": ["text-muted"],
          "fileName": ["text-body", "text-xs", "font-bold"],
          "fileStatusIcon": ["text-success"],
        },

        "config": {
          "layout": [
            {
              "type": "container",

              "themeKey": "card",

              "child": {
                "type": "column",

                "crossAxis": "start",

                "children": [
                  {
                    "type": "row",

                    "crossAxis": "start",
                    "classes": ["mb-sm"],

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

                            "key": "subtitle",

                            "themeKey": "subtitle",

                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },

                  {
                    "type": "container",

                    "themeKey": "uploadBox",

                    "classes": ["mt-md"],

                    "child": {
                      "type": "column",

                      "crossAxis": "center",

                      "children": [
                        {
                          "type": "icon",

                          "key": "uploadIcon",

                          "themeKey": "uploadIcon",

                          "size": "lg",
                        },

                        {
                          "type": "text",

                          "key": "uploadTitle",

                          "themeKey": "uploadTitle",

                          "classes": ["mt-sm"],
                        },

                        {
                          "type": "text",

                          "key": "uploadSubtitle",

                          "themeKey": "uploadSubtitle",

                          "classes": ["mt-xs"],
                        },

                        {
                          "type": "container",

                          "themeKey": "button",

                          "classes": ["mt-md"],

                          "child": {
                            "type": "row",

                            "crossAxis": "center",
                            "mainAxis": "center",

                            "children": [
                              {
                                "type": "icon",

                                "key": "button.icon",

                                "themeKey": "buttonIcon",

                                "size": "md",
                              },

                              {
                                "type": "text",

                                "key": "button.label",

                                "themeKey": "buttonLabel",

                                "classes": ["ml-sm"],
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
          ],
        },

        "props": {
          "icon": "document",
          "uploadedIcon": "check_circle",
          "fileIcon": "document",
          "fileStatusIcon": "check_circle",
          "uploadIcon": "upload",
          "uploadTitle": "Upload from device",
          "uploadSubtitle": "PNG, JPG up to 10MB",
          "button": {
            "icon": "camera",
            "label": "Take Photo",
            "actionRef": "takeDocumentPhoto",
          },
          "documentTypeKey": "documentType",
          "uploadedKey": "uploaded",
          "fileNameKey": "fileName",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "missingLabelKey": "missingLabel",
          "uploadedLabelKey": "uploadedLabel",
        },
      },

      {
        "id": "document_security_notice",

        "type": "info_card",

        "bind": "content.securityNotice",

        "classes": ["mb-xl"],

        "theme": {
          "card": ["bg-card-soft", "rounded-lg", "p-md"],
          "icon": ["text-primary"],
          "text": ["text-muted", "text-xs"],
        },

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
                    "type": "icon",

                    "key": "icon",

                    "themeKey": "icon",

                    "size": "md",
                  },

                  {
                    "type": "text",

                    "key": "text",

                    "themeKey": "text",

                    "classes": ["ml-md"],

                    "flex": 1,
                  },
                ],
              },
            },
          ],
        },

        "props": {"iconKey": "icon", "textKey": "text"},
      },
      {
        "id": "documents_continue_bottom_bar",
        "type": "bottom_bar",
        "bind": "dynamicData.documents",

        "classes": ["bg-surface", "border-muted", "px-md", "py-md"],

        "visibleWhen": {
          "source": "dynamicData.documents",
          "all": [
            {"path": "uploads.driving_license.uploaded", "equals": true},
            {"path": "uploads.identity_document.uploaded", "equals": true},
          ],
        },

        "theme": {
          "button": ["bg-primary", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-surface", "text-sm", "font-bold"],
          "buttonIcon": ["text-surface"],
        },

        "props": {
          "mode": "single_button",
          "button": {
            "label": "Continue",
            "icon": "arrow_forward",
            "action": {"type": "open_active_rental"},
          },
        },
      },
    ],
  },
};
