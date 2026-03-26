const Map<String, dynamic> homeScreenData = {
  "type": "Column",
  "children": [
    // Top App Bar
    {
      "type": "Container",
      "color": "#1A1D24",
      "height": 60,
      "padding": 16,
      "child": {
        "type": "Row",
        "children": [
          {
            "type": "Container",
            "color": "#4A6DF2",
            "width": 30,
            "height": 30,
            "child": {
              "type": "Center",
              "child": {
                "type": "Text",
                "text": "S",
                "color": "white",
                "fontWeight": "bold"
              }
            }
          },
          {
            "type": "SizedBox",
            "width": 12
          },
          {
            "type": "Text",
            "text": "StartFront Studio",
            "color": "white",
            "fontSize": 18,
            "fontWeight": "bold"
          },
          {
            "type": "Expanded",
            "child": { "type": "SizedBox" }
          },
          {
            "type": "Button",
            "label": "Save",
            "color": "#2B323F"
          },
          {
            "type": "SizedBox",
            "width": 8
          },
          {
            "type": "Button",
            "label": "Preview App",
            "color": "#28A745"
          }
        ]
      }
    },
    // Main Body
    {
      "type": "Expanded",
      "child": {
        "type": "Row",
        "crossAxisAlignment": "stretch",
        "children": [
          // Left Palette
          {
            "type": "Container",
            "width": 250,
            "color": "#1E222A",
            "child": {
              "type": "Column",
              "crossAxisAlignment": "start",
              "children": [
                {
                  "type": "Padding",
                  "padding": 16,
                  "child": {
                    "type": "Column",
                    "crossAxisAlignment": "start",
                    "children": [
                      {
                        "type": "Text",
                        "text": "Widget Palette",
                        "color": "white",
                        "fontSize": 16,
                        "fontWeight": "bold"
                      },
                      {
                        "type": "SizedBox",
                        "height": 4
                      },
                      {
                        "type": "Text",
                        "text": "Drag widgets to canvas",
                        "color": "grey",
                        "fontSize": 12
                      }
                    ]
                  }
                },
                {
                  "type": "Expanded", // The ListView inside ApiPalette will expand gracefully here
                  "child": {
                    "type": "ApiPalette"
                  }
                }
              ]
            }
          },
          // Center Canvas Container
          {
            "type": "Expanded",
            "child": {
              "type": "Container",
              "color": "#F4F6F9",
              "child": {
                "type": "Padding",
                "padding": 24,
                "child": {
                  "type": "Container",
                  "color": "white",
                  "child": {
                     "type": "DragTarget"
                  }
                }
              }
            }
          },
          // Right Properties Panel Placeholder
          {
            "type": "Container",
            "width": 250,
            "color": "#FFFFFF",
            "child": {
              "type": "Padding",
              "padding": 16,
              "child": {
                "type": "Column",
                "crossAxisAlignment": "start",
                "children": [
                  {
                    "type": "Text",
                    "text": "Properties",
                    "color": "black",
                    "fontSize": 16,
                    "fontWeight": "bold"
                  },
                  {
                    "type": "SizedBox",
                    "height": 8
                  },
                  {
                    "type": "Text",
                    "text": "Select a widget to edit",
                    "color": "grey",
                    "fontSize": 14
                  }
                ]
              }
            }
          }
        ]
      }
    }
  ]
};
