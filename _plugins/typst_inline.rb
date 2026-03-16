# _plugins/typst_inline.rb

module Jekyll
  @typst_cache = {}

  Hooks.register [:pages, :documents], :pre_render do |doc|

    site  = Jekyll.sites.first
    tcfg  = site.config['typst'] || {}
    dark  = tcfg['dark_color']  || '#fff9e0'
    light = tcfg['light_color'] || '#667d6e'
    extra = tcfg['preamble'].to_s

    # STEP 1: Process Math, strictly ignoring code blocks
    # Regex explanation:
    # (`+)([\s\S]*?)\1             : Match any backticks (inline or block) and their contents, capture to $1
    # |                            : OR
    # (?<!\\)@@([\s\S]+?)(?<!\\)@@ : Match our math block, capture math to $3
    doc.content.gsub!(/(`+)([\s\S]*?)\1|(?<!\\)@@([\s\S]+?)(?<!\\)@@/) do |match|
      if $1
        # We matched a code block (e.g., `\@@`). Leave it 100% unchanged!
        next match
      end

      math_code = $3.strip

      if @typst_cache.key?(math_code)
        next @typst_cache[math_code]
      end

      svg_dark  = Jekyll.compile_typst_svg(math_code, dark,  'typst_inline', extra)
      svg_light = Jekyll.compile_typst_svg(math_code, light, 'typst_inline', extra)

      result = if svg_dark || svg_light
        inner = ""
        inner += "<span class=\"typst-theme-dark\">#{svg_dark}</span>"   if svg_dark
        inner += "<span class=\"typst-theme-light\">#{svg_light}</span>" if svg_light
        "<span class=\"typst-inline\">#{inner}</span>"
      else
        "<span class=\"typst-error\" style=\"color:red;\">[Typst Error]</span>"
      end

      @typst_cache[math_code] = result
      result
    end

    # STEP 2: Cleanup escaped \@@ ONLY outside of code blocks
    doc.content.gsub!(/(`+)([\s\S]*?)\1|\\@@/) do |match|
      $1 ? match : '@@'
    end

  end
end
