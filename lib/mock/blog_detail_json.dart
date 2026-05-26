const Map<dynamic, dynamic> qdriveBlogDetailJson = {
  "version": "1.0",
  "screen": "qdrive_blog_detail",

  "meta": {
    "generatedAt": "2026-05-19T10:40:00Z",
    "cacheKey": "qdrive_blog_detail_v3",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "article": {
      "backLabel": "Back to blog",
      "category": "UPDATES",
      "categoryIcon": "tag",
      "title": "The power of prioritising comfort on long drives",
      "meta": "May 2, 2026 · 8 min read",
      "image":
          "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=1200",
      "body": [
        "Long journeys reward preparation. Before you pick a vehicle, think about how many hours you will spend behind the wheel and what kind of roads you will use most.",
        "Cabin refinement matters as much as headline performance. A quieter interior and supportive seats reduce fatigue, especially when you are carrying passengers or luggage.",
        "When you book with Qdrive, use filters for seating, transmission, and luggage capacity so the car you choose matches the trip—not just the price.",
      ],
    },

    "relatedSection": {"title": "Related posts"},
  },

  "dynamicData": {
    "relatedPosts": {
      "source": "api",
      "endpoint": "/blog/posts/related",
      "cache": false,
      "value": null,
      "fallback": {
        "items": [
          {
            "id": "choosing-hire-class",
            "image":
                "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=900",
            "category": "GUIDES",
            "categoryIcon": "tag",
            "title": "A practical guide to choosing the right hire class",
            "meta": "Apr 18, 2026 · 11 min",
          },
          {
            "id": "smarter-booking-season",
            "image":
                "https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=900",
            "category": "RESOURCES",
            "categoryIcon": "tag",
            "title": "Five tips for smarter booking this season",
            "meta": "Apr 2, 2026 · 6 min",
          },
          {
            "id": "hire-cover-basics",
            "image":
                "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900",
            "category": "BASICS",
            "categoryIcon": "tag",
            "title": "Separating fact from fiction on hire cover",
            "meta": "Mar 20, 2026 · 9 min",
          },
        ],
      },
    },
  },

  "actions": {
    "goBackToBlog": {
      "type": "navigate",
      "params": {"route": "blog"},
    },

    "openRelatedPost": {
      "type": "navigate",
      "params": {"route": "blog_detail", "postIdParamKey": "id"},
    },
  },

  "ui": {
    "showAppBar": true,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "blog_article",
        "type": "blog_article",
        "bind": "content.article",
        "classes": ["mb-2xl"],

        "theme": {
          "back": ["text-muted", "text-sm", "font-medium"],
          "backIcon": ["text-muted"],

          "category": ["text-secondary", "text-xs", "font-bold", "uppercase"],
          "categoryIcon": ["text-secondary"],

          "title": ["text-body", "text-3xl", "font-extrabold"],
          "meta": ["text-muted", "text-sm"],

          "image": ["w-full", "h-card-image", "rounded-xl", "object-cover"],

          "body": ["text-body", "text-sm", "font-medium"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "align",
                  "alignment": "topLeft",
                  "child": {
                    "type": "container",
                    "action": {"type": "go_back"},
                    "child": {
                      "type": "row",
                      "mainAxisSize": "min",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "icon",
                          "icon": "arrow_back",
                          "themeKey": "backIcon",
                          "size": "md",
                        },
                        {
                          "type": "text",
                          "key": "backLabel",
                          "themeKey": "back",
                          "classes": ["ml-sm"],
                        },
                      ],
                    },
                  },
                },

                {
                  "type": "align",
                  "alignment": "center",
                  "classes": ["mt-2xl"],
                  "child": {
                    "type": "row",
                    "mainAxisSize": "min",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "key": "categoryIcon",
                        "themeKey": "categoryIcon",
                        "size": "sm",
                      },
                      {
                        "type": "text",
                        "key": "category",
                        "themeKey": "category",
                        "classes": ["ml-sm"],
                      },
                    ],
                  },
                },

                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mt-lg"],
                  "textAlign": "center",
                  "maxLines": 3,
                },

                {
                  "type": "text",
                  "key": "meta",
                  "themeKey": "meta",
                  "classes": ["mt-md"],
                  "textAlign": "center",
                },

                {
                  "type": "image",
                  "key": "image",
                  "themeKey": "image",
                  "classes": ["mt-2xl", "mb-lg"],
                },

                {
                  "type": "for_each",
                  "itemsKey": "body",
                  "itemName": "paragraph",
                  "layout": "column",
                  "child": {
                    "type": "text",
                    "key": "paragraph",
                    "themeKey": "body",
                    "classes": ["mt-md"],
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "backLabelKey": "backLabel",
          "categoryKey": "category",
          "categoryIconKey": "categoryIcon",
          "titleKey": "title",
          "metaKey": "meta",
          "imageKey": "image",
          "bodyKey": "body",
          "backActionRef": "goBackToBlog",
        },
      },

      {
        "id": "related_heading",
        "type": "text_block",
        "bind": "content.relatedSection",
        "classes": ["mb-md"],

        "theme": {
          "divider": ["border-muted"],
          "title": ["text-body", "text-sm", "font-bold"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "divider",
                  "themeKey": "divider",
                  "classes": ["mb-2xl"],
                },
                {"type": "text", "key": "title", "themeKey": "title"},
              ],
            },
          ],
        },

        "props": {"titleKey": "title", "align": "start"},
      },

      {
        "id": "related_posts",
        "type": "related_post_list",
        "bind": "dynamicData.relatedPosts",
        "classes": ["mb-xl"],

        "theme": {
          "card": ["bg-card", "border-muted", "rounded-lg", "p-md", "mb-md"],

          "image": [
            "rounded-md",
            "object-cover",
            "w-blog-thumb-md",
            "h-blog-thumb-md",
          ],

          "category": ["text-secondary", "text-xs", "font-bold", "uppercase"],
          "categoryIcon": ["text-secondary"],

          "title": ["text-body", "text-sm", "font-bold"],
          "meta": ["text-muted", "text-xs"],
        },

        "config": {
          "layout": [
            {
              "type": "for_each",
              "itemsKey": "items",
              "itemName": "post",
              "layout": "column",
              "child": {
                "type": "container",
                "action": {"type": "related_posts_reading"},
                "themeKey": "card",
                "child": {
                  "type": "row",
                  "crossAxis": "start",
                  "children": [
                    {"type": "image", "key": "post.image", "themeKey": "image"},

                    {
                      "type": "column",
                      "flex": 1,
                      "classes": ["ml-md"],
                      "children": [
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "icon",
                              "key": "post.categoryIcon",
                              "themeKey": "categoryIcon",
                              "size": "sm",
                            },
                            {
                              "type": "text",
                              "key": "post.category",
                              "themeKey": "category",
                              "classes": ["ml-xs"],
                            },
                          ],
                        },

                        {
                          "type": "text",
                          "key": "post.title",
                          "themeKey": "title",
                          "classes": ["mt-xs"],
                          "maxLines": 2,
                          "overflow": "ellipsis",
                        },

                        {
                          "type": "text",
                          "key": "post.meta",
                          "themeKey": "meta",
                          "classes": ["mt-sm"],
                        },
                      ],
                    },
                  ],
                },
              },
            },
          ],
        },

        "props": {"itemsKey": "items", "actionRef": "openRelatedPost"},
      },
    ],
  },
};
