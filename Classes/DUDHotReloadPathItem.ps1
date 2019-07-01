class DUDHotReloadPathItem {
    [String]$Path
    [String]$Filter
    [switch]$Recurse
    [DashboardAction]$Action
    [ScriptBlock]$CustomAction
    [int]$Delay
}