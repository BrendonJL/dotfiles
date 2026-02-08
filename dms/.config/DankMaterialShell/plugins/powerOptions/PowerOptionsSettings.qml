import QtQuick
import qs.Widgets
import qs.Modules.Plugins
import qs.Services

PluginSettings {
    id: root
    pluginId: "powerOptions"

    StyledText {
        width: parent.width
        text: "Power Options Plugin Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
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
        description: value ? "Items will always show in the launcher (no trigger needed)." : "Set the trigger text to activate this plugin. Type the trigger in the launcher to run commands."
        defaultValue: false
        onValueChanged: {
            if (value) {
                root.saveValue("trigger", "");
            } else {
                root.saveValue("trigger", triggerSetting.value || "#");
            }
        }
    }

    StringSetting {
        id: triggerSetting
        visible: !noTriggerToggle.value
        settingKey: "trigger"
        label: "Trigger"
        description: "Prefix character(s) to activate command runner (e.g., #, >, $, !, run). Avoid triggers reserved by DMS or other plugins (e.g., / for file search)."
        placeholder: "#"
        defaultValue: "#"
    }
}
