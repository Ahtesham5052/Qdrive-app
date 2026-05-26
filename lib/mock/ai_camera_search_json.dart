const Map<dynamic, dynamic> visualSearchDialogJson = {
  "title": "Visual Search",
  "subtitle": "AI-powered vehicle recognition",

  "body": {
    "id": "visual_search_dialog_body",
    "type": "text_block",

    "props": {
      "upload": {
        "icon": "upload",
        "title": "Upload Photo or Video",
        "subtitle": "PNG, JPG, MP4 up to 50MB",
      },
      "cameraButton": {"icon": "camera", "label": "Take Photo Now"},
      "howItWorks": {
        "icon": "sparkles",
        "title": "How it works",
        "text":
            "Our AI analyzes the vehicle in your photo/video, identifies make, model, and trim, then finds the closest available matches in our inventory. Perfect for when you see a car you like!",
      },
    },

    "theme": {
      "uploadBox": [
        "bg-black",
        "border-strong",
        "border-dashed",
        "border-2",
        "rounded-xl",
        "p-xl",
      ],
      "uploadIcon": ["text-muted"],
      "uploadTitle": ["text-body", "text-sm", "font-bold", "text-center"],
      "uploadSubtitle": ["text-muted", "text-xs", "font-bold", "text-center"],

      "button": ["bg-info", "rounded-xl", "px-lg", "py-md"],
      "buttonIcon": ["text-white"],
      "buttonLabel": ["text-white", "text-sm", "font-bold"],

      "infoCard": ["bg-white", "rounded-xl", "p-lg"],
      "infoIcon": ["text-info-soft"],
      "infoTitle": ["text-info-soft", "text-sm", "font-bold"],
      "infoText": ["text-info-soft", "text-xs"],
    },

    "config": {
      "layout": [
        {
          "type": "column",
          "crossAxis": "stretch",
          "children": [
            {
              "type": "container",
              "themeKey": "uploadBox",
              "height": 176,
              "alignment": "center",
              "action": {"type": "upload_visual_search_media"},
              "child": {
                "type": "column",
                "mainAxis": "center",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "key": "upload.icon",
                    "themeKey": "uploadIcon",
                    "size": "xl",
                  },
                  {
                    "type": "text",
                    "key": "upload.title",
                    "themeKey": "uploadTitle",
                    "classes": ["mt-md"],
                    "textAlign": "center",
                  },
                  {
                    "type": "text",
                    "key": "upload.subtitle",
                    "themeKey": "uploadSubtitle",
                    "classes": ["mt-xs"],
                    "textAlign": "center",
                  },
                ],
              },
            },

            {
              "type": "container",
              "themeKey": "button",
              "classes": ["mt-lg"],
              "fullWidth": true,
              "height": 56,
              "alignment": "center",
              "action": {"type": "take_visual_search_photo"},
              "child": {
                "type": "row",
                "mainAxis": "center",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "key": "cameraButton.icon",
                    "themeKey": "buttonIcon",
                    "size": "lg",
                  },
                  {
                    "type": "text",
                    "key": "cameraButton.label",
                    "themeKey": "buttonLabel",
                    "classes": ["ml-sm"],
                  },
                ],
              },
            },

            {
              "type": "container",
              "themeKey": "infoCard",
              "classes": ["mt-lg"],
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  {
                    "type": "icon",
                    "key": "howItWorks.icon",
                    "themeKey": "infoIcon",
                    "size": "md",
                  },
                  {
                    "type": "column",
                    "flex": 1,
                    "classes": ["ml-md"],
                    "children": [
                      {
                        "type": "text",
                        "key": "howItWorks.title",
                        "themeKey": "infoTitle",
                      },
                      {
                        "type": "text",
                        "key": "howItWorks.text",
                        "themeKey": "infoText",
                        "classes": ["mt-sm"],
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
};
