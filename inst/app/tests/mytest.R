app <- ShinyDriver$new("../", seed = 123, loadTimeout = 1e+05)
app$snapshotInit("mytest")

Sys.sleep(2)
app$setInputs(sidebarItemExpanded = "Electric")
Sys.sleep(2)
app$setInputs(sidebarItemExpanded = "Hydropower")
# Input 'map1_groups' was set, but doesn't have an input binding.
# Input 'hydroTable_rows_current' was set, but doesn't have an input binding.
# Input 'hydroTable_rows_all' was set, but doesn't have an input binding.
Sys.sleep(2)
app$setInputs(sidebarItemExpanded = "NaturalGas")
# Input 'map2_groups' was set, but doesn't have an input binding.
# Input 'map3_groups' was set, but doesn't have an input binding.
# Input 'pipelineTable_rows_current' was set, but doesn't have an input binding.
# Input 'pipelineTable_rows_all' was set, but doesn't have an input binding.
Sys.sleep(2)
app$setInputs(sidebarItemExpanded = "Oil")
app$snapshot()
