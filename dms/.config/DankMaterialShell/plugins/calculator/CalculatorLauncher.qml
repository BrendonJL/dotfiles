import QtQuick
import Quickshell
import qs.Services
import "calculator.js" as Calculator

QtObject {
    id: root

    property var pluginService: null
    property string trigger: ""

    signal itemsChanged

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData("calculator", "trigger", "=");
    }

    function getItems(query) {
        if (!query || query.trim().length === 0)
            return [];

        const trimmedQuery = query.trim();
        if (!Calculator.isMathExpression(trimmedQuery))
            return [];

        const result = Calculator.evaluate(trimmedQuery);
        if (!result.success)
            return [];

        let resultString = result.result.toString();
        if (typeof result.result === 'number') {
            if (resultString.length > 15 && Math.abs(result.result) >= 1e6) {
                resultString = result.result.toExponential(6);
            } else if (resultString.length > 15 && Math.abs(result.result) < 1e-6) {
                resultString = result.result.toExponential(6);
            }
        }

        return [
            {
                name: resultString,
                icon: "material:equal",
                comment: trimmedQuery + " = " + resultString,
                action: "copy:" + resultString,
                categories: ["Calculator"]
            }
        ];
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        const actionParts = item.action.split(":");
        const actionType = actionParts[0];
        const actionData = actionParts.slice(1).join(":");

        switch (actionType) {
        case "copy":
            copyToClipboard(actionData);
            break;
        default:
            showToast("Unknown action: " + actionType);
        }
    }

    function copyToClipboard(text) {
        Quickshell.execDetached(["sh", "-c", "echo -n '" + text + "' | wl-copy"]);
        showToast("Copied to clipboard: " + text);
    }

    function showToast(message) {
        if (typeof ToastService !== "undefined") {
            ToastService.showInfo("Calculator", message);
        }
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData("calculator", "trigger", trigger);
    }
}
