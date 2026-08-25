--- pullquote.lua
---
--- A Pandoc Lua Filter for semantic, multi-format pullquote components.
--- Translates a systematic utility class taxonomy into precise LaTeX, HTML, and Typst elements.
--- Unrecognized color values pass through directly to let the target compiler handle validation.
---
--- @author    Nandakumar Chandrasekhar (nandac)
--- @copyright © 2026 Nandakumar Chandrasekhar
--- @license   MIT - see LICENSE for details
--- @version   1.0.0
--- @release   2026-08-25
---
--- @note      LaTeX output requires \usepackage[most]{tcolorbox} and the custom \begin{pullquote}
---            environment defined in the preamble. Typst and HTML outputs are fully standalone
---            and generate native inline blocks/styles directly.

PANDOC_VERSION:must_be_at_least('3.10')

local pandoc_lib = assert(pandoc, 'Cannot find the pandoc library')
if type(pandoc_lib) ~= 'table' then
  error('Expected variable pandoc to be a table')
end

local List = assert(pandoc.List, 'Cannot find the pandoc.List class')
local utils = require 'pandoc.utils'

-- ==============================================================================
-- SECTION 1: LOGGING, ERROR HANDLING & STATE
-- ==============================================================================

local function warn(message)
  io.stderr:write(string.format("[pullquote] WARNING: %s\n", message))
end

local function abort(message)
  error(string.format("\n\n[pullquote] CRITICAL ERROR: %s\nHalting compilation to prevent engine crash.\n", message), 0)
end

if PANDOC_READER_OPTIONS and PANDOC_READER_OPTIONS.extensions then
  local ext = PANDOC_READER_OPTIONS.extensions
  if not ext:includes('fenced_divs') then
    warn('Required extension "fenced_divs" is disabled.')
  end
end

local global_meta = {}

-- Checks the inline div attribute first, then falls back to global metadata
local function get_attr(el, attr_name, meta_name)
  if el.attributes[attr_name] then
    return el.attributes[attr_name]
  elseif global_meta[meta_name] then
    return utils.stringify(global_meta[meta_name])
  end
  return nil
end

-- ==============================================================================
-- SECTION 2: DATA DICTIONARIES & CONFIGURATION
-- ==============================================================================

local typst_fonts = {
  serif = "Libertinus Serif",
  sans  = "DejaVu Sans Mono",
  mono  = "DejaVu Sans Mono"
}

local css_colors = {
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

local typst_palette = {
  typstblack = '000000', typstgray = 'AAAAAA', typstsilver = 'DDDDDD',
  typstwhite = 'FFFFFF', typstnavy = '001F3F', typstblue = '0074D9', typstaqua = '7FDBFF',
  typstteal = '39CCCC', typsteastern = '239DAD', typstpurple = 'B10DC9', typstfuchsia = 'F012BE',
  typstmaroon = '85144B', typstred = 'FF4136', typstorange = 'FF851B', typstyellow = 'FFDC00',
  typstolive = '3D9970', typstgreen = '2ECC40', typstlime = '01FF70'
}

local pq_sizes = {
  ['pq-size-3xs']    = { tex = '\\tiny',                             css = '0.5em' },
  ['pq-size-2xs']    = { tex = '\\scriptsize',                       css = '0.6667em' },
  ['pq-size-xs']     = { tex = '\\footnotesize',                     css = '0.8333em' },
  ['pq-size-s']      = { tex = '\\small',                            css = '0.9125em' },
  ['pq-size-normal'] = { tex = '\\normalsize',                       css = '1.0em' },
  ['pq-size-l']      = { tex = '\\large',                            css = '1.2em' },
  ['pq-size-xl']     = { tex = '\\Large',                            css = '1.44em' },
  ['pq-size-2xl']    = { tex = '\\LARGE',                            css = '1.728em' },
  ['pq-size-3xl']    = { tex = '\\huge',                             css = '2.0736em' },
}

local pq_text_aligns = {
  ['pq-align-left']   = { tex = '\\raggedright', css = 'left' },
  ['pq-align-center'] = { tex = '\\centering',   css = 'center' },
  ['pq-align-right']  = { tex = '\\raggedleft',  css = 'right' }
}

local pq_box_aligns = {
  ['pq-box-left']   = { tex = 'flush left',  html_margin = '1.5rem auto 1.5rem 0', typst = 'left' },
  ['pq-box-center'] = { tex = 'center',      html_margin = '1.5rem auto',          typst = 'center' },
  ['pq-box-right']  = { tex = 'flush right', html_margin = '1.5rem 0 1.5rem auto', typst = 'right' }
}

local pq_font_styles = {
  ['pq-weight-bold']      = { tex = '\\bfseries',   css = 'font-weight: bold !important;',         typst = '#set text(weight: 700)\n' },
  ['pq-weight-medium']    = { tex = '\\mdseries',   css = 'font-weight: 500 !important;',          typst = '#set text(weight: 500)\n' },
  ['pq-weight-normal']    = { tex = '\\normalfont', css = 'font-weight: normal !important;',       typst = '#set text(weight: 400, style: "normal")\n' },
  ['pq-style-emph']       = { tex = '\\em',         css = 'font-style: italic !important;',        typst = '#set text(style: "italic")\n' },
  ['pq-style-italic']     = { tex = '\\itshape',    css = 'font-style: italic !important;',        typst = '#set text(style: "italic")\n' },
  ['pq-style-slanted']    = { tex = '\\slshape',    css = 'font-style: oblique !important;',       typst = '#set text(style: "oblique")\n' },
  ['pq-style-smallcaps']  = { tex = '\\scshape',    css = 'font-variant: small-caps !important;',  typst = '#show text: smallcaps\n' },
  ['pq-style-upright']    = { tex = '\\upshape',    css = 'font-style: normal !important;',        typst = '#set text(style: "normal")\n' },
  ['pq-family-mono']      = { tex = '\\ttfamily',   css = 'font-family: monospace !important;',    typst_family = 'mono' },
  ['pq-family-sans']      = { tex = '\\sffamily',   css = 'font-family: sans-serif !important;',   typst_family = 'sans' },
  ['pq-family-serif']     = { tex = '\\rmfamily',   css = 'font-family: serif !important;',        typst_family = 'serif' }
}

-- ==============================================================================
-- SECTION 3: COLOR PARSING & HELPER FUNCTIONS
-- ==============================================================================

local function resolve_single_color(input)
  if not input then return nil, nil, false end
  local clean_input = input:match("^%s*(.-)%s*$")
  if not clean_input then return nil, nil, false end

  local clean_name = clean_input:lower():gsub('[^%w]', '')

  if typst_palette[clean_name] then
    local hex = typst_palette[clean_name]
    return '#' .. hex, hex, true
  end
  if css_colors[clean_name] then
    local hex = css_colors[clean_name]
    return '#' .. hex, hex, true
  end

  local raw_hex = clean_input:gsub('^#', '')
  if raw_hex:match('^%x+$') then
    if #raw_hex == 6 then
      return '#' .. raw_hex:upper(), raw_hex:upper(), true
    elseif #raw_hex == 3 then
      local r, g, b = raw_hex:sub(1,1), raw_hex:sub(2,2), raw_hex:sub(3,3)
      local full_hex = (r .. r .. g .. g .. b .. b):upper()
      return '#' .. full_hex, full_hex, true
    end
  end

  if clean_input:match('^[a-zA-Z%-]+$') then
    abort(string.format('Undefined color keyword "%s".\nColor must be a valid standard CSS keyword, a Hex code (e.g. #FF0000), or valid cross-platform mixing syntax.', clean_input))
  end

  return nil, nil, false
end

local function format_tex_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then return c end
  local css_val, tex_val, is_hex = resolve_single_color(c)
  if is_hex then return "HEX" .. tex_val end
  return c
end

local function format_html_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then
    local c1, pct, c2 = c:match('^([^!]+)!(%d+)!?([^!]*)$')
    if c1 and pct then
      c2 = (c2 == '' or not c2) and 'white' or c2
      local css_c1 = resolve_single_color(c1) or c1
      local css_c2 = resolve_single_color(c2) or c2
      return string.format("color-mix(in srgb, %s %s%%, %s)", css_c1, pct, css_c2)
    end
  end
  local css_val, _, is_hex = resolve_single_color(c)
  if css_val then return css_val end
  return c
end

local function format_typst_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then
    local c1, pct, c2 = c:match('^([^!]+)!(%d+)!?([^!]*)$')
    if c1 and pct then
      c2 = (c2 == '' or not c2) and 'white' or c2
      local _, hex1, is_hex1 = resolve_single_color(c1)
      local _, hex2, is_hex2 = resolve_single_color(c2)
      local col1 = is_hex1 and 'rgb("#' .. hex1:lower() .. '")' or c1:lower()
      local col2 = is_hex2 and 'rgb("#' .. hex2:lower() .. '")' or c2:lower()
      return string.format('color.mix((%s, %d%%), (%s, %d%%))', col1, tonumber(pct), col2, 100 - tonumber(pct))
    end
  end
  local css_val, _, is_hex = resolve_single_color(c)
  if is_hex then return 'rgb("' .. css_val .. '")' end
  return c:lower()
end

-- =========================================================================
-- SECTION 4: MAIN FILTER LOGIC
-- =========================================================================

local function process_pullquote(el)
  -- Use the fallback function to check inline attributes first, then global metadata
  local width        = get_attr(el, 'width', 'pq-width')
  local color        = get_attr(el, 'color', 'pq-color')
  local barwidth     = get_attr(el, 'barwidth', 'pq-barwidth')
  local barcolor     = get_attr(el, 'barcolor', 'pq-barcolor')
  local size_key     = get_attr(el, 'size', 'pq-size')
  local align_key    = get_attr(el, 'align', 'pq-align')
  local boxalign_key = get_attr(el, 'boxalign', 'pq-boxalign')
  local raw_skip     = get_attr(el, 'skip', 'pq-skip')

  -- Validate attributes against dictionaries
  if size_key and not pq_sizes[size_key] then
    warn(string.format('Unknown size class "%s" ignored. Falling back to default.', size_key))
    size_key = nil
  end
  if align_key and not pq_text_aligns[align_key] then
    warn(string.format('Unknown align class "%s" ignored. Falling back to default.', align_key))
    align_key = nil
  end
  if boxalign_key and not pq_box_aligns[boxalign_key] then
    warn(string.format('Unknown boxalign class "%s" ignored. Falling back to default.', boxalign_key))
    boxalign_key = nil
  end

  local tex_skip, html_skip, typst_skip = nil, "1.5", "1em"

  if raw_skip then
    local num = tonumber(raw_skip)
    if num then
      tex_skip = num .. "em"
      html_skip = tostring(num)
      typst_skip = tostring(num - 1.0) .. "em"
    else
      tex_skip, html_skip, typst_skip = raw_skip, raw_skip, raw_skip
    end
  end

  local active_font_styles = {}
  for _, class in ipairs(el.classes) do
    if pq_font_styles[class] then
      table.insert(active_font_styles, pq_font_styles[class])
    end
  end

  -------------------------------------------------------------------------
  -- TARGET: LATEX (PDF)
  -------------------------------------------------------------------------
  if FORMAT:match 'latex' then
    local options = {}
    local tex_open = "\\begingroup\n"

    if width then
      local tex_width = width:match("%%$") and (tonumber(width:sub(1, -2)) / 100) .. "\\linewidth" or width
      table.insert(options, "width=" .. tex_width)
    end

    local function process_tex_color(input_color, option_key, temp_color_name)
      if not input_color then return end
      local c = input_color:match("^%s*(.-)%s*$")
      if c:find('!') then
        table.insert(options, option_key .. "=" .. c)
      else
        local _, tex_val, is_hex = resolve_single_color(c)
        if is_hex then
          tex_open = tex_open .. "\\definecolor{" .. temp_color_name .. "}{HTML}{" .. tex_val .. "}\n"
          table.insert(options, option_key .. "=" .. temp_color_name)
        else
          table.insert(options, option_key .. "=" .. c)
        end
      end
    end

    process_tex_color(color, "color", "pqtxtcol")
    process_tex_color(barcolor, "barcolor", "pqbarcol")

    if tex_skip then table.insert(options, "skip=" .. tex_skip) end
    if barwidth then table.insert(options, "barwidth=" .. barwidth:gsub("px", "pt")) end

    local tex_size_str = size_key and pq_sizes[size_key].tex or "\\large"
    if #active_font_styles > 0 then
      for _, st in ipairs(active_font_styles) do tex_size_str = tex_size_str .. st.tex end
    else
      tex_size_str = tex_size_str .. "\\itshape"
    end
    table.insert(options, "size=" .. tex_size_str)

    if align_key then
      table.insert(options, "align=" .. pq_text_aligns[align_key].tex)
    end
    if boxalign_key then
      table.insert(options, "boxalign=" .. pq_box_aligns[boxalign_key].tex)
    end

    local opt_str = #options > 0 and ("[" .. table.concat(options, ", ") .. "]") or ""

    local blocks = List({ pandoc.RawBlock('latex', tex_open .. '\\begin{pullquote}' .. opt_str) })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('latex', '\\end{pullquote}\n\\endgroup'))
    return blocks

  -------------------------------------------------------------------------
  -- TARGET: HTML
  -------------------------------------------------------------------------
  elseif FORMAT:match 'html' then

    local final_color = format_html_color(color) or "#888888"
    local final_barcolor = format_html_color(barcolor) or "#d9d9d9"

    local styles = {
      "display: block !important;",
      "padding-left: 1rem !important;",
      "line-height: " .. html_skip .. " !important;",
      "width: " .. (width or "80%") .. " !important;",
      "color: " .. final_color .. " !important;",
      "border-left: " .. (barwidth or "4px") .. " solid " .. final_barcolor .. " !important;"
    }

    local margin = "1.5rem auto"
    if boxalign_key then margin = pq_box_aligns[boxalign_key].html_margin end
    table.insert(styles, "margin: " .. margin .. " !important;")

    local final_size = "1.2em"
    if size_key then final_size = pq_sizes[size_key].css end
    table.insert(styles, "font-size: " .. final_size .. " !important;")

    if align_key then
      table.insert(styles, "text-align: " .. pq_text_aligns[align_key].css .. " !important;")
    end

    if #active_font_styles > 0 then
      for _, st in ipairs(active_font_styles) do table.insert(styles, st.css) end
    else
      table.insert(styles, "font-style: italic !important;")
    end

    el.attributes['style'] = (el.attributes['style'] or "") .. " " .. table.concat(styles, " ")
    return el

  -------------------------------------------------------------------------
  -- TARGET: TYPST (PDF)
  -------------------------------------------------------------------------
  elseif FORMAT:match 'typst' then
    local final_color = color and format_typst_color(color) or 'rgb("#888888")'
    local final_barcolor = barcolor and format_typst_color(barcolor) or 'rgb("#d9d9d9")'

    local b_width = width or "80%"
    local b_stroke = (barwidth and barwidth:gsub("px", "pt") or "4pt") .. " + " .. final_barcolor

    local box_align = "center"
    if boxalign_key then box_align = pq_box_aligns[boxalign_key].typst end

    local text_align = "left"
    if align_key then text_align = pq_text_aligns[align_key].css end

    local t_size = size_key and pq_sizes[size_key].css or "1.2em"

    local block_open = string.format(
      '#align(%s)[\n  #block(width: %s, above: 15pt, below: 15pt, stroke: (left: %s), inset: (left: 12pt, top: 4pt, bottom: 4pt))[\n',
      box_align, b_width, b_stroke
    )

    local typst_injections = string.format(
      '    #set align(%s)\n    #set text(fill: %s, size: %s)\n    #set par(leading: %s)\n',
      text_align, final_color, t_size, typst_skip
    )

    if #active_font_styles > 0 then
      for _, st in ipairs(active_font_styles) do
        if st.typst_family then
          typst_injections = typst_injections .. '    #set text(font: "' .. typst_fonts[st.typst_family] .. '")\n'
        elseif st.typst then
          typst_injections = typst_injections .. '    ' .. st.typst
        end
      end
    else
      typst_injections = typst_injections .. '    #set text(style: "italic")\n'
    end

    local blocks = List({ pandoc.RawBlock('typst', block_open .. typst_injections) })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', '\n  ]\n]'))
    return blocks
  end
  return nil
end

-- =========================================================================
-- PANDOC FILTER EXECUTION PIPELINE
-- =========================================================================

return {
  -- Run the Meta filter block first to extract document-level metadata
  {
    Meta = function(meta)
      global_meta = meta
    end
  },
  {
    Pandoc = function(doc)
      if doc.meta['pq-family-serif'] then typst_fonts.serif = utils.stringify(doc.meta['pq-family-serif'])
      elseif doc.meta['mainfont']    then typst_fonts.serif = utils.stringify(doc.meta['mainfont'])
      else typst_fonts.serif = "Libertinus Serif" end

      if doc.meta['pq-family-mono']  then typst_fonts.mono = utils.stringify(doc.meta['pq-family-mono'])
      elseif doc.meta['codefont']    then typst_fonts.mono = utils.stringify(doc.meta['codefont'])
      elseif doc.meta['monofont']    then typst_fonts.mono = utils.stringify(doc.meta['monofont'])
      else typst_fonts.mono = "DejaVu Sans Mono" end

      if doc.meta['pq-family-sans']  then typst_fonts.sans = utils.stringify(doc.meta['pq-family-sans'])
      elseif doc.meta['sansfont']    then typst_fonts.sans = utils.stringify(doc.meta['sansfont'])
      else typst_fonts.sans = "DejaVu Sans Mono" end
    end
  },
  {
    Div = function(el)
      if not el.classes:includes('pullquote') then return nil end

      -- Wrap the execution in a protected call (pcall) to catch fatal lua errors gracefully
      local status, result = pcall(process_pullquote, el)

      if not status then
        local el_id = el.identifier ~= "" and el.identifier or "[unnamed div]"
        abort(string.format('Failed to process pullquote div id: %s\nDetails: %s', el_id, result))
      end

      return result
    end
  }
}
