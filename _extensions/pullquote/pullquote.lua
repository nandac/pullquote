--- pullquote.lua
---
--- A Pandoc Lua Filter for semantic, multi-format pullquote components.
--- Uses a strict attribute-based API (e.g., pq-text-align="center") alongside a single .pullquote class.
--- Translates to precise LaTeX, HTML, and Typst elements.
---
--- @author    Nandakumar Chandrasekhar (nandac)
--- @copyright © 2026 Nandakumar Chandrasekhar
--- @license   MIT - see LICENSE for details
--- @version   1.1.0
--- @release   2026-09-01
---
--- @note      LaTeX output requires pullquote.tex to be included in the document preamble.
---            Typst and HTML outputs are fully standalone.

PANDOC_VERSION:must_be_at_least('3.10')

assert(type(pandoc) == 'table', 'Cannot find the pandoc library')

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

local function get_attr(el, attr_key)
  if el.attributes[attr_key] then
    return el.attributes[attr_key]
  elseif global_meta[attr_key] then
    return utils.stringify(global_meta[attr_key])
  end
  return nil
end

-- ==============================================================================
-- SECTION 2: DATA DICTIONARIES & CONFIGURATION
-- ==============================================================================

-- Typst bundles Libertinus Serif and DejaVu Sans Mono, but ships no default
-- sans-serif font. Absent explicit configuration, fall back to a chain of
-- widely-available sans fonts and let Typst pick the first one it can resolve.
local typst_fonts = {
  serif = "Libertinus Serif",
  sans  = { "Noto Sans", "DejaVu Sans", "Liberation Sans", "Arial", "Helvetica" },
  mono  = "DejaVu Sans Mono"
}

-- Populated from mainfont/sansfont/monofont/codefont (if set) so HTML's
-- serif/sans/mono keywords resolve to the document's actual configured font,
-- not just the bare generic CSS keyword. Left nil per-key when unset, so
-- resolve_html_family() falls back to the generic keyword alone.
local html_fonts = {}

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
  typstblack   = '000000', typstgray    = 'AAAAAA', typstsilver  = 'DDDDDD',
  typstwhite   = 'FFFFFF', typstnavy    = '001F3F', typstblue    = '0074D9',
  typstaqua    = '7FDBFF', typstteal    = '39CCCC', typsteastern = '239DAD',
  typstpurple  = 'B10DC9', typstfuchsia = 'F012BE', typstmaroon  = '85144B',
  typstred     = 'FF4136', typstorange  = 'FF851B', typstyellow  = 'FFDC00',
  typstolive   = '3D9970', typstgreen   = '2ECC40', typstlime    = '01FF70'
}

-- Symmetrical 9-point size scale mapped to native relative font multipliers
local pq_sizes = {
  ['3xs'] = { tex = '\\tiny',         scale = '0.5',    typst = '0.5em' },
  ['2xs'] = { tex = '\\scriptsize',   scale = '0.6667', typst = '0.6667em' },
  ['xs']  = { tex = '\\footnotesize', scale = '0.8333', typst = '0.8333em' },
  ['s']   = { tex = '\\small',        scale = '0.9125', typst = '0.9125em' },
  ['m']   = { tex = '\\normalsize',   scale = '1.0',    typst = '1.0em' },
  ['l']   = { tex = '\\large',        scale = '1.2',    typst = '1.2em' },
  ['xl']  = { tex = '\\Large',        scale = '1.44',   typst = '1.44em' },
  ['2xl'] = { tex = '\\LARGE',        scale = '1.728',  typst = '1.728em' },
  ['3xl'] = { tex = '\\huge',         scale = '2.0736', typst = '2.0736em' },
}

local pq_text_aligns = {
  ['left']   = { tex = '\\raggedright', css = 'left' },
  ['center'] = { tex = '\\centering',   css = 'center' },
  ['right']  = { tex = '\\raggedleft',  css = 'right' }
}

local pq_box_aligns = {
  ['left']   = { tex = 'flush left',  html_margin = '1.5rem auto 1.5rem 0', typst = 'left' },
  ['center'] = { tex = 'center',      html_margin = '1.5rem auto',          typst = 'center' },
  ['right']  = { tex = 'flush right', html_margin = '1.5rem 0 1.5rem auto', typst = 'right' }
}

local pq_weights = {
  ['bold']   = { tex = '\\bfseries',   css = 'font-weight: bold !important;',   typst = '#set text(weight: 700)\n' },
  ['medium'] = { tex = '\\mdseries',   css = 'font-weight: 500 !important;',    typst = '#set text(weight: 500)\n' },
  ['normal'] = { tex = '\\normalfont', css = 'font-weight: normal !important;', typst = '#set text(weight: 400, style: "normal")\n' }
}

local pq_styles = {
  ['emph']      = { tex = '\\em',      css = 'font-style: italic !important;',       typst = '#set text(style: "italic")\n' },
  ['italic']    = { tex = '\\itshape', css = 'font-style: italic !important;',       typst = '#set text(style: "italic")\n' },
  ['slanted']   = { tex = '\\slshape', css = 'font-style: oblique !important;',      typst = '#set text(style: "oblique")\n' },
  ['smallcaps'] = { tex = '\\scshape', css = 'font-variant: small-caps !important;', typst = '#show text: smallcaps\n' },
  ['upright']   = { tex = '\\upshape', css = 'font-style: normal !important;',       typst = '#set text(style: "normal")\n' }
}

local pq_families = {
  ['mono']  = { tex = '\\ttfamily', css_generic = 'monospace',  typst_family = 'mono' },
  ['sans']  = { tex = '\\sffamily', css_generic = 'sans-serif', typst_family = 'sans' },
  ['serif'] = { tex = '\\rmfamily', css_generic = 'serif',      typst_family = 'serif' }
}

-- Resolves a serif/sans/mono family to a CSS font-family declaration. Uses
-- the actual configured mainfont/sansfont/monofont (via html_fonts) when
-- available, with the generic CSS keyword as a fallback — both as the
-- trailing chain fallback when a specific font is set, and as the sole
-- value when it's not, mirroring how LaTeX/Typst already resolve these
-- to the document's real configured font rather than a generic category.
local function resolve_html_family(key)
  local generic = pq_families[key].css_generic
  local actual = html_fonts[key]
  if actual then
    return string.format('font-family: "%s", %s !important;', actual, generic)
  end
  return string.format('font-family: %s !important;', generic)
end

-- ==============================================================================
-- SECTION 3: COLOR PARSING & HELPER FUNCTIONS
-- ==============================================================================

local function resolve_single_color(input)
  if not input then return nil, nil end
  local clean_input = input:match("^%s*(.-)%s*$")
  if not clean_input then return nil, nil end

  local clean_name = clean_input:lower():gsub('[^%w]', '')

  if typst_palette[clean_name] then
    local hex = typst_palette[clean_name]
    return '#' .. hex, hex
  end

  if css_colors[clean_name] then
    local hex = css_colors[clean_name]
    return '#' .. hex, hex
  end

  local raw_hex = clean_input:gsub('^#', '')
  if raw_hex:match('^%x+$') then
    local len = #raw_hex
    if len == 6 or len == 8 then
      local full_hex = raw_hex:upper()
      return '#' .. full_hex, full_hex
    elseif len == 3 or len == 4 then
      local r, g, b = raw_hex:sub(1,1), raw_hex:sub(2,2), raw_hex:sub(3,3)
      local full_hex = r .. r .. g .. g .. b .. b
      if len == 4 then
        local a = raw_hex:sub(4,4)
        full_hex = full_hex .. a .. a
      end
      full_hex = full_hex:upper()
      return '#' .. full_hex, full_hex
    end
  end

  -- Unresolved beyond this point: not a known CSS/Typst name, and not valid
  -- hex. Aborts unconditionally, the same way for every format, so a color
  -- name behaves identically regardless of which output this pullquote
  -- happens to render to — this filter has no per-format color vocabulary,
  -- only the single shared CSS/hex/mixing syntax documented in the README.
  abort(string.format('Undefined color keyword "%s".\nColor must be a valid standard CSS keyword, a Hex code (e.g. #FF0000), or valid cross-platform mixing syntax.', clean_input))
end

local function format_typst_font(font_value)
  if type(font_value) == 'table' then
    local quoted = {}
    for _, name in ipairs(font_value) do
      table.insert(quoted, '"' .. name .. '"')
    end
    return '(' .. table.concat(quoted, ', ') .. ')'
  end
  return '"' .. font_value .. '"'
end

-- Validates a "px"/"pt"/"rem"/"em" dimension string (e.g. pq-bar-width,
-- pq-padding-left). Returns the value unchanged if valid, or nil (with a
-- warning) otherwise, letting the caller fall back to its own per-engine
-- default.
local function validate_px_pt(value, attr_name)
  if not value then return nil end
  local num, unit = value:match("^(%d+%.?%d*)(%a+)$")
  if num and (unit == "px" or unit == "pt" or unit == "rem" or unit == "em") then
    return value
  end
  warn(string.format('Invalid value "%s" for %s. Use a "px", "pt", "rem", or "em" unit (e.g., "4px", "3pt", "0.25rem"). Falling back to default.', value, attr_name))
  return nil
end

-- Converts an already-validated px/pt/rem/em dimension to a PDF-safe value
-- for the LaTeX and Typst pathways. "px" uses the standard 96dpi:72pt ratio
-- (1px = 0.75pt) rather than a naive suffix swap; "rem" maps directly to
-- "em" (both LaTeX and Typst resolve "em" natively against the current font
-- size, so no numeric conversion is needed, mirroring how pq-size already
-- treats rem for PDF output); "pt"/"em" pass through unchanged.
local function px_to_pt(value)
  local num, unit = value:match("^(%d+%.?%d*)(%a+)$")
  if unit == "px" then
    return string.format("%.4gpt", tonumber(num) * 0.75)
  elseif unit == "rem" then
    return num .. "em"
  end
  return value
end

-- resolve_single_color() below either returns a resolved value or aborts
-- outright, so every call site here can use its result directly with no
-- "unresolved" fallback branch to handle.

local function format_html_color(c)
  if not c then return nil end
  c = c:match("^%s*(.-)%s*$")
  if c:find('!') then
    local c1, pct, c2 = c:match('^([^!]+)!(%d+)!?([^!]*)$')
    if c1 and pct then
      c2 = (c2 == '' or not c2) and 'white' or c2
      local css_c1 = resolve_single_color(c1)
      local css_c2 = resolve_single_color(c2)
      return string.format("color-mix(in srgb, %s %s%%, %s)", css_c1, pct, css_c2)
    end
    warn(string.format('Invalid color-mix syntax "%s". Use "Color!Percent" or "Color1!Percent!Color2" (e.g. "red!30"). Falling back to default.', c))
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
      local col1 = 'rgb("#' .. hex1:lower() .. '")'
      local col2 = 'rgb("#' .. hex2:lower() .. '")'
      return string.format('color.mix((%s, %d%%), (%s, %d%%))', col1, tonumber(pct), col2, 100 - tonumber(pct))
    end
    warn(string.format('Invalid color-mix syntax "%s". Use "Color!Percent" or "Color1!Percent!Color2" (e.g. "red!30"). Falling back to default.', c))
    return nil
  end
  local css_val = resolve_single_color(c)
  return 'rgb("' .. css_val .. '")'
end

-- =========================================================================
-- SECTION 4: MAIN FILTER LOGIC
-- =========================================================================

local function process_pullquote(el)
  -- Extract all configuration parameters using strict pq- attributes
  local width          = get_attr(el, 'pq-width')
  local color          = get_attr(el, 'pq-text-color')
  local barwidth       = validate_px_pt(get_attr(el, 'pq-bar-width'), 'pq-bar-width')
  local barcolor       = get_attr(el, 'pq-bar-color')
  local paddingleft    = validate_px_pt(get_attr(el, 'pq-padding-left'), 'pq-padding-left')
  local paddingright   = validate_px_pt(get_attr(el, 'pq-padding-right'), 'pq-padding-right')
  local paddingtop     = validate_px_pt(get_attr(el, 'pq-padding-top'), 'pq-padding-top')
  local paddingbottom  = validate_px_pt(get_attr(el, 'pq-padding-bottom'), 'pq-padding-bottom')
  local raw_skip       = get_attr(el, 'pq-skip')
  local raw_size       = get_attr(el, 'pq-size')
  local raw_text_align = get_attr(el, 'pq-text-align')
  local raw_box_align  = get_attr(el, 'pq-box-align')
  local raw_weight     = get_attr(el, 'pq-weight')
  local raw_style      = get_attr(el, 'pq-style')
  local raw_family     = get_attr(el, 'pq-family') or 'serif'

  -- Validate pq-family: letters, digits, spaces, hyphens, and apostrophes
  -- only. This also rejects a CSS-style comma-separated fallback chain
  -- (e.g. "Playfair Display, Georgia") with a clear error instead of
  -- silently emitting a broken single literal name (see README's "No Font
  -- Chaining" note) and, for LaTeX, keeps raw_family safe to splice
  -- unescaped into \fontspec{...} inside a tcolorbox keyval option list.
  if not raw_family:match("^[%w%s%-']+$") then
    abort(string.format('Invalid pq-family value "%s". Font names may only contain letters, digits, spaces, hyphens, and apostrophes.', raw_family))
  end

  -- Validate pq-width: must be a percentage (e.g. "80%") or an absolute
  -- length, so the LaTeX percentage-to-linewidth math below never runs on
  -- a non-numeric value. Unlike pq-bar-width/pq-padding-*, this also
  -- allows cm/mm/in: pt/em/cm/mm/in are all native LaTeX and Typst length
  -- units (px_to_pt() passes them through unchanged below), while px/rem
  -- are converted since neither engine understands them natively.
  local width_units = { px = true, pt = true, rem = true, em = true, cm = true, mm = true, ["in"] = true }
  local width_is_percent = width and width:match("^%d+%.?%d*%%$")
  if width and not width_is_percent then
    local num, unit = width:match("^(%d+%.?%d*)(%a+)$")
    if not (num and width_units[unit]) then
      warn(string.format('Invalid value "%s" for pq-width. Use a percentage (e.g., "80%%") or a length in px/pt/rem/em/cm/mm/in (e.g., "300pt"). Falling back to default.', width))
      width = nil
    end
  end

  -- Fetch global or inline HTML unit preference, defaulting to rem
  local html_unit      = get_attr(el, 'pq-html-unit') or 'rem'
  if html_unit ~= 'rem' and html_unit ~= 'em' then
    warn(string.format('Invalid value "%s" for pq-html-unit. Use "rem" or "em". Falling back to "rem".', html_unit))
    html_unit = 'rem'
  end

  -- Resolve Final Size (Dictionary > Custom Dimension > Default Fallback)
  local final_tex_size, final_css_size, final_typst_size
  if raw_size then
    if pq_sizes[raw_size] then
      final_tex_size   = pq_sizes[raw_size].tex
      final_css_size   = pq_sizes[raw_size].scale .. html_unit
      final_typst_size = pq_sizes[raw_size].typst
    else
      local num, unit = raw_size:match("^(%d+%.?%d*)([a-zA-Z]+)$")
      if num and tonumber(num) > 0 and (unit == "pt" or unit == "em" or unit == "ex" or unit == "rem" or unit == "px" or unit == "vw") then
         local lead = tostring(tonumber(num) * 1.2)

         -- Safely convert web-specific units for PDF engines
         local pdf_unit = unit
         if unit == "rem" or unit == "vw" then
            pdf_unit = "em"
         elseif unit == "px" then
            pdf_unit = "pt"
         end

         final_tex_size = string.format("\\fontsize{%s%s}{%s%s}\\selectfont", num, pdf_unit, lead, pdf_unit)
         final_css_size = raw_size
         final_typst_size = num .. pdf_unit
      else
         warn(string.format('Invalid value "%s" for pq-size. Use standard keys (e.g., xs, s, m, l) or standard units (pt, em, ex, rem, px, vw). Falling back to default.', raw_size))
         final_tex_size   = pq_sizes['l'].tex
         final_css_size   = pq_sizes['l'].scale .. html_unit
         final_typst_size = pq_sizes['l'].typst
      end
    end
  else
    final_tex_size   = pq_sizes['l'].tex
    final_css_size   = pq_sizes['l'].scale .. html_unit
    final_typst_size = pq_sizes['l'].typst
  end

  -- Validate pq-skip: either a bare unitless multiplier (the documented
  -- form, e.g. "1.5") or a px/pt/rem/em length passed straight through to
  -- each engine's own line-height/leading option. Anything else (e.g. CSS's
  -- "normal" keyword) is valid nowhere but HTML, so reject it here instead
  -- of letting it reach LaTeX's \setlength or Typst's #set par(leading:)
  -- and fail with an engine-native "not a length" error.
  if raw_skip and not tonumber(raw_skip) and not validate_px_pt(raw_skip, 'pq-skip') then
    raw_skip = nil
  end

  -- Calculate line-height/leading across engines. Typst's par "leading" is
  -- the em value applied directly (matching how tex_skip already treats
  -- the multiplier as a literal em value), so the documented default
  -- multiplier of 1.0 lines up with the "1em" fallback used when pq-skip
  -- is omitted entirely, instead of the two diverging.
  local tex_skip, html_skip, typst_skip = nil, "1.5", "1em"
  if raw_skip then
    local num = tonumber(raw_skip)
    if num then
      tex_skip = num .. "em"
      html_skip = tostring(num)
      typst_skip = tostring(num) .. "em"
    else
      -- CSS understands px/pt/rem/em natively; LaTeX and Typst don't
      -- understand "px"/"rem" at all, so those two need the same
      -- PDF-safe conversion every other px/pt/rem/em attribute gets.
      html_skip = raw_skip
      tex_skip = px_to_pt(raw_skip)
      typst_skip = px_to_pt(raw_skip)
    end
  end

  -- Validate Alignments
  if raw_text_align and not pq_text_aligns[raw_text_align] then
    warn(string.format('Unknown text-align value "%s" ignored.', raw_text_align))
    raw_text_align = nil
  end
  if raw_box_align and not pq_box_aligns[raw_box_align] then
    warn(string.format('Unknown box-align value "%s" ignored.', raw_box_align))
    raw_box_align = nil
  end

  -- Build Typography Arrays
  local active_tex_fonts, active_css_fonts, active_typst_fonts = {}, {}, {}

  if raw_weight and pq_weights[raw_weight] then
    table.insert(active_tex_fonts, pq_weights[raw_weight].tex)
    table.insert(active_css_fonts, pq_weights[raw_weight].css)
    table.insert(active_typst_fonts, pq_weights[raw_weight].typst)
  elseif raw_weight then
    warn(string.format('Unknown weight value "%s" ignored.', raw_weight))
  end

  if raw_style and pq_styles[raw_style] then
    table.insert(active_tex_fonts, pq_styles[raw_style].tex)
    table.insert(active_css_fonts, pq_styles[raw_style].css)
    table.insert(active_typst_fonts, pq_styles[raw_style].typst)
  elseif raw_style then
    warn(string.format('Unknown style value "%s" ignored.', raw_style))
  else
    table.insert(active_tex_fonts, '\\itshape')
    table.insert(active_css_fonts, 'font-style: italic !important;')
    table.insert(active_typst_fonts, '#set text(style: "italic")\n')
  end

  if pq_families[raw_family] then
    table.insert(active_tex_fonts, pq_families[raw_family].tex)
    table.insert(active_css_fonts, resolve_html_family(raw_family))
    table.insert(active_typst_fonts, '#set text(font: ' .. format_typst_font(typst_fonts[pq_families[raw_family].typst_family]) .. ')\n')
  else
    -- Any value other than serif/sans/mono is treated as a single literal
    -- font name, applied directly across all three engines. A comma-
    -- separated value is NOT split into a CSS/Typst fallback chain — it is
    -- passed through as one literal name, which will fail to resolve in
    -- all three backends. If the named font isn't actually available,
    -- LaTeX's fontspec raises its own compile error and Typst warns and
    -- substitutes a fallback — expected native engine behavior, not
    -- something this filter validates. HTML chains a generic serif
    -- fallback, per standard CSS practice.
    table.insert(active_tex_fonts, '\\fontspec{' .. raw_family .. '}')
    table.insert(active_css_fonts, string.format('font-family: "%s", serif !important;', raw_family))
    table.insert(active_typst_fonts, '#set text(font: ' .. format_typst_font(raw_family) .. ')\n')
  end

  -------------------------------------------------------------------------
  -- TARGET: LATEX (PDF)
  -------------------------------------------------------------------------
  if FORMAT:match 'latex' then
    local options = {}
    local tex_open = "\\begingroup\n"

    if width then
      local tex_width = width:match("%%$") and (tonumber(width:sub(1, -2)) / 100) .. "\\linewidth" or px_to_pt(width)
      table.insert(options, "width=" .. tex_width)
    end

    local function process_tex_color(input_color, option_key, temp_color_name)
      if not input_color then return end
      local c = input_color:match("^%s*(.-)%s*$")
      if c:find('!') then
        table.insert(options, option_key .. "=" .. c)
      else
        -- resolve_single_color() either returns a resolved hex value or
        -- aborts outright, so there's no unresolved case to fall back to
        -- here.
        local _, tex_val = resolve_single_color(c)
        -- xcolor's HTML model takes exactly 6 hex digits; drop any alpha
        -- suffix from an 8-digit #RRGGBBAA input (LaTeX text color has no
        -- transparency channel here).
        tex_open = tex_open .. "\\definecolor{" .. temp_color_name .. "}{HTML}{" .. tex_val:sub(1, 6) .. "}\n"
        table.insert(options, option_key .. "=" .. temp_color_name)
      end
    end

    process_tex_color(color, "color", "pqtxtcol")
    process_tex_color(barcolor, "barcolor", "pqbarcol")

    if tex_skip then table.insert(options, "skip=" .. tex_skip) end
    if barwidth then table.insert(options, "barwidth=" .. px_to_pt(barwidth)) end
    if paddingleft then table.insert(options, "paddingleft=" .. px_to_pt(paddingleft)) end
    if paddingright then table.insert(options, "paddingright=" .. px_to_pt(paddingright)) end
    if paddingtop then table.insert(options, "paddingtop=" .. px_to_pt(paddingtop)) end
    if paddingbottom then table.insert(options, "paddingbottom=" .. px_to_pt(paddingbottom)) end

    local tex_size_str = final_tex_size
    for _, font_cmd in ipairs(active_tex_fonts) do
      tex_size_str = tex_size_str .. font_cmd
    end
    table.insert(options, "size=" .. tex_size_str)

    if raw_text_align then table.insert(options, "align=" .. pq_text_aligns[raw_text_align].tex) end
    if raw_box_align then table.insert(options, "boxalign=" .. pq_box_aligns[raw_box_align].tex) end

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
      "box-sizing: border-box !important;",
      "padding-left: " .. (paddingleft or "1em") .. " !important;",
      "padding-right: " .. (paddingright or "0") .. " !important;",
      "padding-top: " .. (paddingtop or "0.25em") .. " !important;",
      "padding-bottom: " .. (paddingbottom or "0.25em") .. " !important;",
      "line-height: " .. html_skip .. " !important;",
      "width: " .. (width or "80%") .. " !important;",
      "color: " .. final_color .. " !important;",
      "border-left: " .. (barwidth or "0.25em") .. " solid " .. final_barcolor .. " !important;"
    }

    local margin = "1.5rem auto"
    if raw_box_align then margin = pq_box_aligns[raw_box_align].html_margin end
    table.insert(styles, "margin: " .. margin .. " !important;")

    table.insert(styles, "font-size: " .. final_css_size .. " !important;")

    if raw_text_align then table.insert(styles, "text-align: " .. pq_text_aligns[raw_text_align].css .. " !important;") end

    for _, font_rule in ipairs(active_css_fonts) do
      table.insert(styles, font_rule)
    end

    -- Handle paragraph margins to prevent stacking with custom padding
    if #el.content == 1 and el.content[1].t == 'Para' then
      -- For a single paragraph, simply strip the <p> tags entirely
      el.content[1] = pandoc.Plain(el.content[1].content)
    elseif #el.content > 1 then
      -- For multiple paragraphs, safely inject a scoped <style> block to neutralize outer margins
      local css_fix = '<style>.pullquote p:first-of-type { margin-top: 0 !important; } .pullquote p:last-of-type { margin-bottom: 0 !important; }</style>'
      el.content:insert(1, pandoc.RawBlock('html', css_fix))
    end

    el.attributes['style'] = (el.attributes['style'] or "") .. " " .. table.concat(styles, " ")
    return el

  -------------------------------------------------------------------------
  -- TARGET: TYPST (PDF)
  -------------------------------------------------------------------------
  elseif FORMAT:match 'typst' then
    local final_color = color and format_typst_color(color) or 'rgb("#888888")'
    local final_barcolor = barcolor and format_typst_color(barcolor) or 'rgb("#d9d9d9")'

    local b_width = width and (width:match("%%$") and width or px_to_pt(width)) or "80%"
    local b_stroke = (barwidth and px_to_pt(barwidth) or "4pt") .. " + " .. final_barcolor
    local b_padding_left = paddingleft and px_to_pt(paddingleft) or "12pt"
    local b_padding_right = paddingright and px_to_pt(paddingright) or "0pt"
    local b_padding_top = paddingtop and px_to_pt(paddingtop) or "4pt"
    local b_padding_bottom = paddingbottom and px_to_pt(paddingbottom) or "4pt"

    local box_align = "center"
    if raw_box_align then box_align = pq_box_aligns[raw_box_align].typst end

    local text_align = "left"
    if raw_text_align then text_align = pq_text_aligns[raw_text_align].css end

    local block_open = string.format(
      '#align(%s)[\n  #block(width: %s, above: 15pt, below: 15pt, stroke: (left: %s), inset: (left: %s, right: %s, top: %s, bottom: %s))[\n',
      box_align, b_width, b_stroke, b_padding_left, b_padding_right, b_padding_top, b_padding_bottom
    )

    local typst_injections = string.format(
      '    #set align(%s)\n    #set text(fill: %s, size: %s)\n    #set par(leading: %s)\n',
      text_align, final_color, final_typst_size, typst_skip
    )

    for _, font_rule in ipairs(active_typst_fonts) do
      typst_injections = typst_injections .. '    ' .. font_rule
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
  {
    Meta = function(meta)
      global_meta = meta
    end
  },
  {
    Pandoc = function(doc)
      if FORMAT:match('html') then
        if doc.meta['mainfont'] then html_fonts.serif = utils.stringify(doc.meta['mainfont']) end
        if doc.meta['sansfont'] then html_fonts.sans = utils.stringify(doc.meta['sansfont']) end
        if doc.meta['codefont']     then html_fonts.mono = utils.stringify(doc.meta['codefont'])
        elseif doc.meta['monofont'] then html_fonts.mono = utils.stringify(doc.meta['monofont']) end
      end

      if not FORMAT:match('typst') then return end

      if doc.meta['mainfont']    then typst_fonts.serif = utils.stringify(doc.meta['mainfont'])
      else typst_fonts.serif = "Libertinus Serif" end

      if doc.meta['codefont']    then typst_fonts.mono = utils.stringify(doc.meta['codefont'])
      elseif doc.meta['monofont']    then typst_fonts.mono = utils.stringify(doc.meta['monofont'])
      else typst_fonts.mono = "DejaVu Sans Mono" end

      if doc.meta['sansfont']    then typst_fonts.sans = utils.stringify(doc.meta['sansfont'])
      else
        warn('No sans font configured for Typst output (set "sansfont" in metadata). Typst has no bundled sans-serif font, so a best-effort fallback chain will be used and may not render as true sans-serif on all systems.')
      end
    end
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
