local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("all", {
  s("ccstart", {
    t("Hello Claude! Its time to start working on the Mario RL Agent project. Please look through the following files:"),
    t({"", "- /home/blasley/mlp/CLAUDE.md"}),
    t({"", "- /home/blasley/mlp/docs"}),
    t({"", ""}),
    t("These documents should tell you all of the progress I've made so far on the project, all the details of the overall project, and instructions for how to interact in the session. After you have finished reading the files please tell me summary of what you think was done most recently and what the next steps to start on are now. Thanks!"),
  }),
})