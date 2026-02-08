import QtQuick
import Quickshell
import qs.Services
import qs.Common

QtObject {
    id: root

    // Plugin properties
    property var pluginService: null
    property string trigger: "#"

    // Plugin interface signals
    signal itemsChanged

    Component.onCompleted: {
        console.info("Power Options: Plugin loaded");

        // Load custom trigger from settings
        if (!pluginService) 
            return;
        trigger = pluginService.loadPluginData("powerOptions", "trigger", "#");
    }

    // All Power Options
    function getItems(query) {
        const baseItems = [
            {
                name: I18n.tr("Reboot"),
                icon: "material:restart_alt",
                comment: I18n.tr("Reboot the computer"),
                keywords: ["restart","reset"],
                action: "reboot",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Log Out"),
                icon: "material:logout",
                comment: I18n.tr("Log out this user"),
                keywords: ["logout","log-out","logoff","log off","log-off","sign out","sign off","exit session"],
                action: "logout",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Power Off"),
                icon: "material:power_settings_new",
                comment: I18n.tr("Power off the computer"),
                keywords: ["shutdown","poweroff","shut down","turn off","switch off","power down","halt"],
                action: "poweroff",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Lock"),
                icon: "material:lock",
                comment: I18n.tr("Lock the session"),
                keywords: ["screen lock"],
                action: "lock",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Suspend"),
                icon: "material:bedtime",
                comment: I18n.tr("Suspend the computer"),
                keywords: ["sleep","standby","pause"],
                action: "suspend",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Hibernate"),
                icon: "material:ac_unit",
                comment: I18n.tr("Hibernate the computer"),
                keywords: ["hibernation","deep sleep","power save"],
                action: "hibernate",
                categories: ["Power Options"]
            },
            {
                name: I18n.tr("Restart DMS"),
                icon: "material:refresh",
                comment: I18n.tr("Restart the DankMaterialShell"),
                keywords: ["dms"],
                action: "restart",
                categories: ["Power Options"]
            }
        ];
        
        // Get the currently enabled power options from the settings
        const allowedActions = SettingsData.powerMenuActions || [];
        
        // Reduce baseItems to ONLY those found in allowedActions
        const enabledItems = baseItems.filter(item => allowedActions.includes(item.action));

	    // Return immediately if no search query is typed
        if (!query || query.length === 0) {
            return enabledItems;
        }

        // If there is a query, filter the already reduced list
        const lowerQuery = query.toLowerCase();
        
        return enabledItems.filter(item => {
            // Match name (partial)
            const matchName = item.name.toLowerCase().includes(lowerQuery);
            
            // Match comment (partial)
            const matchComment = item.comment.toLowerCase().includes(lowerQuery);
            
            // Match keywords (partial)
	        const matchKeywords = item.keywords && item.keywords.some(keyword => keyword.toLowerCase().includes(lowerQuery));
	    
	        return matchName || matchComment || matchKeywords
        });
    }

    // Required function: Execute item action
    function executeItem(item) {
        if (!item || !item.action) {
            console.warn("Power Options: Invalid item or action");
            return
        }

        console.log("Power Options: Executing item:", item.name, "with action:", item.action);

        switch (item.action) {
            case "reboot":
            	SessionService.reboot();
                break
            case "logout":
                SessionService.logout();
                break
            case "poweroff":
                SessionService.poweroff();
                break
            case "lock":
                Quickshell.execDetached(["dms", "ipc", "call", "lock", "lock"]);
                break
            case "suspend":
                SessionService.suspend();
                break
            case "hibernate":
                SessionService.hibernate();
                break
            case "restart":
                Quickshell.execDetached(["dms", "restart"]);
                break
            default:
                console.warn("Power Options: Unknown action type:", item.action);
                showToast("Unknown action: " + item.action);
        }
    }
    

    // Watch for trigger changes
    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData("powerOptions", "trigger", trigger);
        
    }
}
