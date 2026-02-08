import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "calculator"

    StyledText {
        width: parent.width
        text: "Calculator Plugin"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Evaluates mathematical expressions and copies the result to your clipboard."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    ToggleSetting {
        id: noTriggerToggle
        settingKey: "noTrigger"
        label: "Always Active"
        description: noTriggerToggle.value ? "Calculator is always active. Type expressions like '3 + 3' directly." : "Use a trigger prefix to activate. Type the trigger before your expression."
        defaultValue: false
        onValueChanged: {
            if (value) {
                root.saveValue("trigger", "");
            } else {
                root.saveValue("trigger", triggerSetting.value || "=");
            }
        }
    }

    StringSetting {
        id: triggerSetting
        visible: !noTriggerToggle.value
        settingKey: "trigger"
        label: "Trigger"
        description: "Prefix character(s) to activate the calculator (e.g., =, calc, c)"
        placeholder: "="
        defaultValue: "="
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Supported Operations"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM

        Repeater {
            model: ["Addition: 3 + 3", "Subtraction: 10 - 5", "Multiplication: 4 * 7", "Division: 20 / 4", "Exponentiation: 2 ^ 8", "Modulo: 17 % 5", "Parentheses: (5 + 3) * 2", "Decimals: 3.14 * 2"]

            StyledText {
                required property string modelData
                text: "• " + modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Usage"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM
        bottomPadding: Theme.spacingL

        Repeater {
            model: ["1. Open Launcher (Ctrl+Space or click launcher button)", noTriggerToggle.value ? "2. Type a mathematical expression (e.g., '3 + 3')" : "2. Type your trigger followed by the expression (e.g., '= 3 + 3')", "3. The result will appear as a launcher item", "4. Press Enter to copy the result to clipboard"]

            StyledText {
                required property string modelData
                text: modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }
}
