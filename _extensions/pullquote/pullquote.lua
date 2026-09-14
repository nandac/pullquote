--- pullquote.lua
---
--- A Pandoc Lua Filter for semantic, multi-format pullquote components.
--- Delegated Architecture: Passes data to pullquote.css, pullquote.tex, and pullquote.typ
---
--- @author    Nandakumar Chandrasekhar
--- @copyright © 2026 Nandakumar Chandrasekhar
--- @license   MIT - see LICENSE for details
--- @version   2.0.0
--- @release   2026-09-14

PANDOC_VERSION:must_be_at_least('3.10')
assert(type(pandoc) == 'table', 'Cannot find the pandoc library')

local List = assert(pandoc.List, 'Cannot find the pandoc.List class')
local utils = require 'pandoc.utils'

-- ==============================================================================
-- SECTION 1: LOGGING, ERROR HANDLING & FAIL-FAST
-- ==============================================================================

local function warn(message)
  io.stderr:write(string.format("[pullquote] WARNING: %s\n", message))
end

local function abort(message)
  error(string.format("\n\n[pullquote] CRITICAL ERROR: %s\nHalting compilation to prevent engine crash.\n", message), 0)
end

if PANDOC_READER_OPTIONS and PANDOC_READER_OPTIONS.extensions then
  if not PANDOC_READER_OPTIONS.extensions:includes('fenced_divs') then
    warn("The 'fenced_divs' extension is disabled. Pullquotes will render as raw text.")
    return {}
  end
end

local global_meta = {}

local function get_attr(el, attr_key)
  if el.attributes[attr_key] then
    return el.attributes[attr_key]
  elseif global_meta[attr_key] then
    return utils.stringify(global_meta[attr_key])
  end
  return nil
end

-- ==============================================================================
-- SECTION 2: PARSING & HELPER FUNCTIONS
-- ==============================================================================

local CSS_COLORS = {
  aliceblue = 'F0F8FF', antiquewhite = 'FAEBD7', aqua = '00FFFF', aquamarine = '7FFFD4', azure = 'F0FFFF',
  beige = 'F5F5DC', bisque = 'FFE4C4', black = '000000', blanchedalmond = 'FFEBCD', blue = '0000FF',
  blueviolet = '8A2BE2', brown = 'A52A2A', burlywood = 'DEB887', cadetblue = '5F9EA0', chartreuse = '7FFF00',
  chocolate = 'D2691E', coral = 'FF7F50', cornflowerblue = '6495ED', cornsilk = 'FFF8DC', crimson = 'DC143C',
  cyan = '00FFFF', darkblue = '00008B', darkcyan = '008B8B', darkgoldenrod = 'B8860B', darkgray = 'A9A9A9',
  darkgreen = '006400', darkgrey = 'A9A9A9', darkkhaki = 'BDB76B', darkmagenta = '8B008B', darkolivegreen = '556B2F',
  darkorange = 'FF8C00', darkorchid = '9932CC', darkred = '8B0000', darksalmon = 'E9967A', darkseagreen = '8FBC8F',
  darkslateblue = '483D8B', darkslategray = '2F4F4F', darkslategrey = '2F4F4F', darkturquoise = '00CED1',
  darkviolet = '9400D3', deeppink = 'FF1493', deepskyblue = '00BFFF', dimgray = '696969', dimgrey = '696969',
  dodgerblue = '1E90FF', firebrick = 'B22222', floralwhite = 'FFFAF0', forestgreen = '228B22', fuchsia = 'FF00FF',
  gainsboro = 'DCDCDC', ghostwhite = 'F8F8FF', gold = 'FFD700', goldenrod = 'DAA520', gray = '808080',
  green = '008000', greenyellow = 'ADFF2F', grey = '808080', honeydew = 'F0FFF0', hotpink = 'FF69B4',
  indianred = 'CD5C5C', indigo = '4B0082', ivory = 'FFFFF0', khaki = 'F0E68C', lavender = 'E6E6FA',
  lavenderblush = 'FFF0F5', lawngreen = '7CFC00', lemonchiffon = 'FFFACD', lightblue = 'ADD8E6',
  lightcoral = 'F08080', lightcyan = 'E0FFFF', lightgoldenrodyellow = 'FAFAD2', lightgray = 'D3D3D3',
  lightgreen = '90EE90', lightgrey = 'D3D3D3', lightpink = 'FFB6C1', lightsalmon = 'FFA07A',
  lightseagreen = '20B2AA', lightskyblue = '87CEFA', lightslategray = '778899', lightslategrey = '778899',
  lightsteelblue = 'B0C4DE', lightyellow = 'FFFFE0', lime = '00FF00', limegreen = '32CD32', linen = 'FAF0E6',
  magenta = 'FF00FF', maroon = '800000', mediumaquamarine = '66CDAA', mediumblue = '0000CD',
  mediumorchid = 'BA55D3', mediumpurple = '9370DB', mediumseagreen = '3CB371', mediumslateblue = '7B68EE',
  mediumspringgreen = '00FA9A', mediumturquoise = '48D1CC', mediumvioletred = 'C71585', midnightblue = '191970',
  mintcream = 'F5FFFA', mistyrose = 'FFE4E1', moccasin = 'FFE4B5', navajowhite = 'FFDEAD', navy = '000080',
  oldlace = 'FDF5E6', olive = '808000', olivedrab = '6B8E23', orange = 'FFA500', orangered = 'FF4500',
  orchid = 'DA70D6', palegoldenrod = 'EEE8AA', palegreen = '98FB98', paleturquoise = 'AFEEEE',
  palevioletred = 'DB7093', papayawhip = 'FFEFD5', peachpuff = 'FFDAB9', peru = 'CD853F', pink = 'FFC0CB',
  plum = 'DDA0DD', powderblue = 'B0E0E6', purple = '800080', rebeccapurple = '663399', red = 'FF0000',
  rosybrown = 'BC8F8F', royalblue = '4169E1', saddlebrown = '8B4513', salmon = 'FA8072', sandybrown = 'F4A460',
  seagreen = '2E8B57', seashell = 'FFF5EE', sienna = 'A0522D', silver = 'C0C0C0', skyblue = '87CEEB',
  slateblue = '6A5ACD', slategray = '708090', slategrey = '708090', snow = 'FFFAFA', springgreen = '00FF7F',
  steelblue = '4682B4', tan = 'D2B48C', teal = '008080', thistle = 'D8BFD8', tomato = 'FF6347',
  turquoise = '40E0D0', violet = 'EE82EE', wheat = 'F5DEB3', white = 'FFFFFF', whitesmoke = 'F5F5F5',
  yellow = 'FFFF00', yellowgreen = '9ACD32'
}

local TYPST_PALETTE = {
  typstblack   = '000000', typstgray    = 'AAAAAA', typstsilver  = 'DDDDDD',
  typstwhite   = 'FFFFFF', typstnavy    = '001F3F', typstblue    = '0074D9',
  typstaqua    = '7FDBFF', typstteal    = '39CCCC', typsteastern = '239DAD',
  typstpurple  = 'B10DC9', typstfuchsia = 'F012BE', typstmaroon  = '85144B',
  typstred     = 'FF4136', typstorange  = 'FF851B', typstyellow  = 'FFDC00',
  typstolive   = '3D9970', typstgreen   = '2ECC40', typstlime    = '01FF70'
}

local SEMANTIC_SIZES = {
  ["s"]   = true, ["m"]   = true, ["l"]  = true,
  ["xl"]  = true, ["2xl"] = true
}

local SKIP_TARGETS = {
  tight   = 1.20,
  base    = 1.35,
  relaxed = 1.55,
  loose   = 1.80
}

local VALID_TEXT_ALIGNS = {
  ["left"]    = true,
  ["right"]   = true,
  ["center"]  = true,
  ["justify"] = true
}

local VALID_BOX_ALIGNS = {
  ["left"]   = true,
  ["right"]  = true,
  ["center"] = true
}

local function resolve_single_color(input)
  if not input then return nil, nil end
  local clean_input = input:match("^%s*(.-)%s*$")
  if not clean_input then return nil, nil end

  local clean_name = clean_input:lower():gsub('[^%w]', '')

  if TYPST_PALETTE[clean_name] then return '#' .. TYPST_PALETTE[clean_name], TYPST_PALETTE[clean_name] end
  if CSS_COLORS[clean_name] then return '#' .. CSS_COLORS[clean_name], CSS_COLORS[clean_name] end

  local raw_hex = clean_input:gsub('^#', '')
  if raw_hex:match('^%x+$') then
    local len = #raw_hex
    if len == 6 or len == 8 then return '#' .. raw_hex:upper(), raw_hex:upper() end
    if len == 3 or len == 4 then
      local r, g, b = raw_hex:sub(1,1), raw_hex:sub(2,2), raw_hex:sub(3,3)
      local full_hex = r .. r .. g .. g .. b .. b
      if len == 4 then
        local a = raw_hex:sub(4,4)
        full_hex = full_hex .. a .. a
      end
      return '#' .. full_hex:upper(), full_hex:upper()
    end
  end
  abort(string.format('Undefined color keyword or invalid hex: "%s"', clean_input))
end

local function format_html_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then
    local c1, pct, c2 = c:match('^([^!]+)!(%d+)!?([^!]*)$')
    if c1 and pct then
      c2 = (c2 == '' or not c2) and 'white' or c2
      local res1 = resolve_single_color(c1)
      local res2 = resolve_single_color(c2)
      if res1 and res2 then
        return string.format("color-mix(in srgb, %s %s%%, %s)", res1, pct, res2)
      end
    end
    warn('Invalid color-mix syntax. Falling back to default.')
    return nil
  end
  return (resolve_single_color(c))
end

local function format_typst_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then
    local c1, pct, c2 = c:match('^([^!]+)!(%d+)!?([^!]*)$')
    if c1 and pct then
      c2 = (c2 == '' or not c2) and 'white' or c2
      local _, hex1 = resolve_single_color(c1)
      local _, hex2 = resolve_single_color(c2)
      if hex1 and hex2 then
        return string.format('color.mix((rgb("#%s"), %d%%), (rgb("#%s"), %d%%))', hex1:lower(), tonumber(pct), hex2:lower(), 100 - tonumber(pct))
      end
    end
    warn('Invalid color-mix syntax. Falling back to default.')
    return nil
  end
  local resolved = resolve_single_color(c)
  if resolved then return 'rgb("' .. resolved .. '")' end
  return nil
end

local function format_typst_font(f)
  if not f then return nil end
  return f:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest end)
end

local function validate_font(font)
  if not font then return nil end
  if font:find(',') then abort(string.format('Invalid font specification (font chaining is not supported): "%s"', font)) end
  return font
end

local function validate_size(size)
  if not size then return nil end
  if SEMANTIC_SIZES[size] then return size end
  local num, unit = size:match("^(%d+%.?%d*)(%a+)$")
  if num and (unit == "px" or unit == "pt" or unit == "rem" or unit == "em") then return size end
  warn(string.format('Invalid unit for pq-size: "%s". Use semantic keys (s-2xl) or px, pt, rem, em.', size))
  return nil
end

-- Centralized skip logic (Returns a pure number)
local function resolve_skip(skip)
  if not skip then return 1.35 end
  if SKIP_TARGETS[skip] then return SKIP_TARGETS[skip] end
  local num_str = skip:match("^(%d+%.?%d*)%s*%a*$")
  if num_str and tonumber(num_str) then return tonumber(num_str) end
  warn(string.format('Invalid pq-skip value: "%s". Must be tight, base, relaxed, loose, or a unitless number. Falling back to base (1.35).', skip))
  return 1.35
end

local function validate_html_unit(unit)
  if not unit then return "rem" end -- Defaults to 'rem' if nil
  if unit == "rem" or unit == "em" then return unit end
  warn(string.format('Invalid pq-html-unit: "%s". Use rem or em. Falling back to rem.', unit))
  return "rem"
end

local function validate_width(width)
  if not width then return nil end
  if width:match("^%d+%.?%d*%%$") then return width end
  local num, unit = width:match("^(%d+%.?%d*)(%a+)$")
  if num and (unit == "px" or unit == "pt" or unit == "rem" or unit == "em") then return width end
  warn(string.format('Invalid unit for pq-width: "%s". Use %%, px, pt, rem, or em.', width))
  return nil
end

local function validate_px_pt(value, attr_name)
  if not value then return nil end
  local num, unit = value:match("^(%d+%.?%d*)(%a+)$")
  if num and (unit == "px" or unit == "pt" or unit == "rem" or unit == "em") then return value end
  warn(string.format('Invalid unit for %s: "%s". Use px, pt, rem, or em.', attr_name, value))
  return nil
end

local function px_to_pt(value)
  if not value then return nil end
  local num, unit = value:match("^(%d+%.?%d*)(%a+)$")
  if not num then return nil end
  if unit == "px" then return string.format("%.4gpt", tonumber(num) * 0.75) end
  if unit == "rem" then return num .. "em" end
  return value
end

local function validate_text_align(align)
  if not align then return nil end
  if VALID_TEXT_ALIGNS[align] then return align end
  warn(string.format('Invalid pq-text-align: "%s". Use left, right, center, or justify.', align))
  return nil
end

local function validate_box_align(align)
  if not align then return nil end
  if VALID_BOX_ALIGNS[align] then return align end
  warn(string.format('Invalid pq-box-align: "%s". Use left, right, or center.', align))
  return nil
end

-- =========================================================================
-- SECTION 3: MAIN FILTER LOGIC
-- =========================================================================

local function process_pullquote(el)
  local width          = validate_width(get_attr(el, 'pq-width'))
  local color          = get_attr(el, 'pq-text-color')
  local barwidth       = validate_px_pt(get_attr(el, 'pq-bar-width'), 'pq-bar-width')
  local barcolor       = get_attr(el, 'pq-bar-color')
  local paddingleft    = validate_px_pt(get_attr(el, 'pq-padding-left'), 'pq-padding-left')
  local paddingright   = validate_px_pt(get_attr(el, 'pq-padding-right'), 'pq-padding-right')
  local paddingtop     = validate_px_pt(get_attr(el, 'pq-padding-top'), 'pq-padding-top')
  local paddingbottom  = validate_px_pt(get_attr(el, 'pq-padding-bottom'), 'pq-padding-bottom')

  -- Skip is always resolved to a numeric baseline multiplier here
  local skip           = resolve_skip(get_attr(el, 'pq-skip'))
  local size           = validate_size(get_attr(el, 'pq-size'))
  local html_unit      = validate_html_unit(get_attr(el, 'pq-html-unit'))
  local text_align     = validate_text_align(get_attr(el, 'pq-text-align'))
  local box_align      = validate_box_align(get_attr(el, 'pq-box-align'))
  local weight         = get_attr(el, 'pq-weight')
  local style          = get_attr(el, 'pq-style')
  local font           = validate_font(get_attr(el, 'pq-font'))

  -------------------------------------------------------------------------
  -- TARGET: HTML
  -------------------------------------------------------------------------
  if FORMAT:match 'html' then
    local styles = {}

    local keys_to_remove = {}
    for k, _ in pairs(el.attributes) do
      if k:match("^pq%-") then
        table.insert(keys_to_remove, k)
      end
    end
    for _, k in ipairs(keys_to_remove) do el.attributes[k] = nil end

    if width then table.insert(styles, "--pq-width: " .. width .. ";") end
    if color then
      local hc = format_html_color(color)
      if hc then table.insert(styles, "--pq-text-color: " .. hc .. ";") end
    end
    if barwidth then table.insert(styles, "--pq-bar-width: " .. barwidth .. ";") end
    if barcolor then
      local bc = format_html_color(barcolor)
      if bc then table.insert(styles, "--pq-bar-color: " .. bc .. ";") end
    end
    if paddingleft then table.insert(styles, "--pq-padding-left: " .. paddingleft .. ";") end
    if paddingright then table.insert(styles, "--pq-padding-right: " .. paddingright .. ";") end
    if paddingtop then table.insert(styles, "--pq-padding-top: " .. paddingtop .. ";") end
    if paddingbottom then table.insert(styles, "--pq-padding-bottom: " .. paddingbottom .. ";") end
    if font then table.insert(styles, "font-family: '" .. font .. "';") end

    if size then
      if SEMANTIC_SIZES[size] then
        el.attributes['data-pq-size'] = size
      else
        table.insert(styles, "font-size: " .. size .. ";")
      end
    end

    -- Skip is now guaranteed to be a number, handled entirely via CSS variable
    table.insert(styles, "--pq-line-height: " .. skip .. ";")

    if #styles > 0 then el.attributes['style'] = table.concat(styles, " ") end

    if html_unit then el.attributes['data-pq-html-unit'] = html_unit end
    if text_align then el.attributes['data-pq-text-align'] = text_align end
    if box_align then el.attributes['data-pq-box-align'] = box_align end
    if weight then el.attributes['data-pq-weight'] = weight end
    if style then el.attributes['data-pq-style'] = style end
    if font then el.attributes['data-pq-font'] = font end

    el.classes:insert('pullquote')
    return el

  -------------------------------------------------------------------------
  -- TARGET: TYPST (PDF)
  -------------------------------------------------------------------------
  elseif FORMAT:match 'typst' then
    local args = {}

    if width then
      if width:match("%%$") then
        table.insert(args, 'width: ' .. width)
      else
        local conv = px_to_pt(width)
        if conv then table.insert(args, 'width: ' .. conv) end
      end
    end
    if color then
      local tc = format_typst_color(color)
      if tc then table.insert(args, 'color: ' .. tc) end
    end
    if barcolor then
      local tbc = format_typst_color(barcolor)
      if tbc then table.insert(args, 'barcolor: ' .. tbc) end
    end
    if barwidth then
      local conv = px_to_pt(barwidth)
      if conv then table.insert(args, 'barwidth: ' .. conv) end
    end

    if paddingleft then
      local conv = px_to_pt(paddingleft)
      if conv then table.insert(args, 'paddingleft: ' .. conv) end
    end
    if paddingright then
      local conv = px_to_pt(paddingright)
      if conv then table.insert(args, 'paddingright: ' .. conv) end
    end
    if paddingtop then
      local conv = px_to_pt(paddingtop)
      if conv then table.insert(args, 'paddingtop: ' .. conv) end
    end
    if paddingbottom then
      local conv = px_to_pt(paddingbottom)
      if conv then table.insert(args, 'paddingbottom: ' .. conv) end
    end

    -- Always emit skip as a raw float
    table.insert(args, 'skip: ' .. skip)

    if size then
      if SEMANTIC_SIZES[size] then
        table.insert(args, 'size: "' .. size .. '"')
      else
        local t_size = px_to_pt(size) or size
        table.insert(args, 'size: ' .. t_size)
      end
    end

    if text_align then table.insert(args, 'text-align: "' .. text_align .. '"') end
    if box_align then table.insert(args, 'box-align: "' .. box_align .. '"') end
    if weight then table.insert(args, 'weight: "' .. weight .. '"') end
    if style then table.insert(args, 'style: "' .. style .. '"') end
    if font then table.insert(args, 'font: "' .. format_typst_font(font) .. '"') end

    local arg_str = #args > 0 and "(" .. table.concat(args, ", ") .. ")" or "()"
    local blocks = List({ pandoc.RawBlock('typst', '#pullquote' .. arg_str .. '[\n') })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', '\n]'))
    return blocks

  -------------------------------------------------------------------------
  -- TARGET: LATEX (PDF)
  -------------------------------------------------------------------------
  elseif FORMAT:match 'latex' then
    local options = {}

    if width then
      if width:match("%%$") then
        local num = width:sub(1, -2)
        local num_val = tonumber(num)
        if num_val then
          table.insert(options, "width=" .. (num_val / 100) .. "\\linewidth")
        end
      else
        local valid_width = validate_px_pt(width, 'pq-width')
        if valid_width then
          local conv = px_to_pt(valid_width)
          if conv then table.insert(options, "width=" .. conv) end
        end
      end
    end

    local tex_open = "\\begingroup\n"
    local function process_tex_color(input_color, option_key, temp_color_name)
      if not input_color then return end
      if input_color:find('!') then
        table.insert(options, option_key .. "=" .. input_color)
      else
        local _, tex_val = resolve_single_color(input_color)
        if tex_val then
          tex_open = tex_open .. "\\definecolor{" .. temp_color_name .. "}{HTML}{" .. tex_val:sub(1, 6) .. "}\n"
          table.insert(options, option_key .. "=" .. temp_color_name)
        end
      end
    end

    process_tex_color(color, "color", "pqtxtcol")
    process_tex_color(barcolor, "barcolor", "pqbarcol")

    if barwidth then
      local conv = px_to_pt(barwidth)
      if conv then table.insert(options, "barwidth=" .. conv) end
    end
    if paddingleft then
      local conv = px_to_pt(paddingleft)
      if conv then table.insert(options, "paddingleft=" .. conv) end
    end
    if paddingright then
      local conv = px_to_pt(paddingright)
      if conv then table.insert(options, "paddingright=" .. conv) end
    end
    if paddingtop then
      local conv = px_to_pt(paddingtop)
      if conv then table.insert(options, "paddingtop=" .. conv) end
    end
    if paddingbottom then
      local conv = px_to_pt(paddingbottom)
      if conv then table.insert(options, "paddingbottom=" .. conv) end
    end

    -- Always emit skip as a raw float
    table.insert(options, "skip=" .. skip)

    if size then
      if SEMANTIC_SIZES[size] then
        table.insert(options, "size=" .. size)
      else
        local pt_size = px_to_pt(size) or size
        local num, unit = pt_size:match("^(%d+%.?%d*)(%a+)$")
        if num and unit then
          -- Dynamically use the resolved multiplier to set baseline skip for custom absolute sizes!
          local bl = tostring(tonumber(num) * skip) .. unit
          table.insert(options, "size={\\fontsize{" .. pt_size .. "}{" .. bl .. "}\\selectfont}")
        else
          table.insert(options, "size={" .. size .. "}")
        end
      end
    end

    if text_align then table.insert(options, "textalign=" .. text_align) end
    if box_align then table.insert(options, "boxalign=" .. box_align) end
    if weight then table.insert(options, "weight=" .. weight) end
    if style then table.insert(options, "style=" .. style) end
    if font then table.insert(options, "font={" .. font .. "}") end

    local opt_str = #options > 0 and ("[" .. table.concat(options, ", ") .. "]") or ""
    local blocks = List({ pandoc.RawBlock('latex', tex_open .. '\\begin{pullquote}' .. opt_str) })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('latex', '\\end{pullquote}\n\\endgroup'))
    return blocks
  end
  return nil
end

-- =========================================================================
-- SECTION 4: EXECUTION
-- =========================================================================
return {
  {
    Meta = function(meta) global_meta = meta end
  },
  {
    Div = function(el)
      if not el.classes:includes('pullquote') then return nil end
      local status, result = pcall(process_pullquote, el)
      if not status then
        local el_id = el.identifier ~= "" and el.identifier or "[unnamed div]"
        abort(string.format('Failed to process pullquote div id: %s\nDetails: %s', el_id, result))
      end
      return result
    end
  }
}
