-- Options are automatically loaded before lazy.nvim startup
vim.g.lazyvim_picker = "telescope"
vim.opt.relativenumber = false

-- Hide inline diagnostic text and misspelling underlines
vim.diagnostic.enable(false)
vim.opt.spell = false

-- Change the main Normal background color dynamically
vim.api.nvim_set_hl(0, "Normal", { bg = "#2a2a2a" })

-- Change the cursor line or current visual selection background
vim.api.nvim_set_hl(0, "Visual", { bg = "#4b4b4b" })

-- local fn_curl2buffer asks curl to dump data directly into a Neovim buffer
local function fn_curl2buffer(url)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_cmd({ cmd = "vsplit" }, {})
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Fetching data..." })
  vim.system({ "curl", "-sL", url }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        local lines = vim.split(obj.stdout, "\n")
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error fetching data:", obj.stderr })
      end
    end)
  end)
end

-- user exec cmd to move report into gitHorae
vim.api.nvim_create_user_command("GitReport", function(opts)
  local cp_source = os.getenv("HOME") .. "/Documents/GitHello/action-flow/report.md"
  local cp_target = os.getenv("HOME") .. "/Documents/GitHub/gitHorae/市場情緒覺醒-潛意識和解.md"
  local cp_cmd = "cp -f " .. cp_source .. " " .. cp_target
  vim.fn.system(cp_cmd)
  vim.notify("report to gitHorae already.", vim.log.levels.INFO)
end, { nargs = 0 })

-- user exec command to fn_curl2buffer
vim.api.nvim_create_user_command("CurlToBuf", function(opts)
  fn_curl2buffer(opts.args)
end, { nargs = 1 })

-- user exec command to fn_futu_sentiment
vim.api.nvim_create_user_command("FutuSentiment", function(opts)
  require("futu-search").fn_futu_sentiment(opts.args)
end, { nargs = 1 })

-- user exec command to fn_futu_search_news
vim.api.nvim_create_user_command("FutuSearch", function(opts)
  require("futu-search").fn_futu_search_news(
    opts.args,
    "https://ai-news-search.futunn.com/news_search",
    "User-Agent: futunn-news-search/0.0.2 (Skill)",
    "/.config/futu/futuNews.json"
  )
end, { nargs = 1 })

-- user exec command to fn_futu_search_digit
vim.api.nvim_create_user_command("FutuDigit", function(opts)
  require("futu-search").fn_futu_search_news(
    opts.args,
    "https://ai-news-search.futunn.com/stock_feed",
    "User-Agent: futu-stock-digest/0.0.2 (Skill)",
    "/.config/futu/futuDigit.json"
  )
end, { nargs = 1 })

-- add more command
