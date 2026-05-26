const Map<dynamic, dynamic> qdriveBlogJson = {
  "version": "1.0",
  "screen": "qdrive_blog",

  "meta": {
    "generatedAt": "2026-05-13T17:25:00Z",
    "cacheKey": "qdrive_blog_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "blogHeader": {
      "eyebrow": "JOURNAL",
      "title": "Qdrive blog",
      "subtitle":
          "Ideas for better trips—comfort, booking clarity, and getting more from every mile.",
    },
  },

  "dynamicData": {
    "blogPosts": {
      "source": "api",
      "endpoint": "/blog/posts",
      "cache": false,
      "value": null,
      "fallback": {
        "items": [
          {
            "id": "comfort-long-drives",
            "image":
                "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900",
            "category": "UPDATES",
            "categoryIcon": "tag",
            "title": "The power of prioritising comfort on long drives",
            "description":
                "How seat position, cabin noise, and the right vehicle class turn motorway hours into relaxed travel.",
            "meta": "May 2, 2026 · 8 min read",
          },
          {
            "id": "choosing-hire-class",
            "image":
                "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=900",
            "category": "GUIDES",
            "categoryIcon": "tag",
            "title": "A practical guide to choosing the right hire class",
            "description":
                "City runabouts, tourers, and people-carriers—match the vehicle to your route and parking reality.",
            "meta": "April 18, 2026 · 7 min read",
          },
          {
            "id": "smarter-booking-season",
            "image":
                "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=900",
            "category": "RESOURCES",
            "categoryIcon": "tag",
            "title": "Five tips for smarter booking this season",
            "description":
                "Lead times, flexible dates, and insurance clarity—small decisions that save time at the desk.",
            "meta": "April 2, 2026 · 6 min read",
          },
          {
            "id": "hire-cover-basics",
            "image":
                "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900",
            "category": "BASICS",
            "categoryIcon": "tag",
            "title": "Separating fact from fiction on hire cover",
            "description":
                "Excess, waivers, and what is already included—plain language for confident decisions.",
            "meta": "March 20, 2026 · 9 min read",
          },
        ],
      },
    },
  },

  "actions": {
    "openBlogPost": {
      "type": "navigate",
      "params": {"route": "blog_detail", "postIdParamKey": "id"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": true,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "blog_header",

        "type": "text_block",

        "bind": "content.blogHeader",

        "classes": ["my-md"],

        "theme": {
          "eyebrow": ["text-white", "text-xs", "font-bold"],
          "title": ["text-body", "text-3xl", "font-extrabold"],
          "subtitle": ["text-muted", "text-base"],
        },

        "config": {
          "layout": [
            {
              "type": "column",

              "crossAxis": "start",

              "children": [
                {"type": "text", "key": "eyebrow", "themeKey": "eyebrow"},

                {
                  "type": "text",

                  "key": "title",

                  "themeKey": "title",

                  "classes": ["mt-sm"],
                },

                {
                  "type": "text",

                  "key": "subtitle",

                  "themeKey": "subtitle",

                  "classes": ["mt-sm"],
                },
              ],
            },
          ],
        },

        "props": {
          "eyebrowKey": "eyebrow",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "align": "start",
        },
      },

      {
        "id": "blog_posts",

        "type": "blog_post_list",

        "bind": "dynamicData.blogPosts",

        "classes": ["mb-xl"],

        "theme": {
          "item": ["bg-transparent", "border-bottom-muted", "py-xl"],

          "image": [
            "rounded-lg",
            "object-cover",
            "w-blog-thumb",
            "h-blog-thumb",
          ],

          "category": ["text-secondary", "text-xs", "font-bold"],
          "categoryIcon": ["text-secondary"],
          "title": ["text-body", "text-base", "font-bold"],
          "description": ["text-muted", "text-sm"],
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

                "themeKey": "item",

                "action": {"type": "blog_reading"},

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

                          "classes": ["mt-sm"],

                          "maxLines": 2,

                          "overflow": "ellipsis",
                        },

                        {
                          "type": "text",

                          "key": "post.description",

                          "themeKey": "description",

                          "classes": ["mt-sm"],

                          "maxLines": 3,

                          "overflow": "ellipsis",
                        },

                        {
                          "type": "text",

                          "key": "post.meta",

                          "themeKey": "meta",

                          "classes": ["mt-md"],
                        },
                      ],
                    },
                  ],
                },
              },
            },
          ],
        },

        "props": {"itemsKey": "items", "actionRef": "openBlogPost"},
      },
    ],
  },
};
