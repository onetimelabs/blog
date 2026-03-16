# _plugins/typst_block.rb
#
# Processes @@@...@@@ as block math, producing <div class="typst-math">.
# Equivalent to {% typst %}...{% endtypst %} but without id support.
#
# Must run before typst_inline.rb so that @@@...@@@ is consumed first and the
# @@ inline pass never sees the triple-@ delimiters. File name sorts before
# typst_inline.rb alphabetically, which guarantees hook registration order.
#
# Escape with \@@@ to emit a literal @@@ in output.

module Jekyll
  @typst_block_cache = {}

  Hooks.register [:pages, :documents], :pre_render do |doc|

    site  = Jekyll.sites.first
    tcfg  = site.config['typst'] || {}
    dark  = tcfg['dark_color']   || '#fff9e0'
    light = tcfg['light_color']  || '#667d6e'
    extra = tcfg['preamble'].to_s
    dsize = tcfg['display_size'] || '20pt'

    # STEP 1: Process @@@...@@@ block math, skipping code spans/blocks.
    doc.content.gsub!(/(`+)([\s\S]*?)\1|(?<!\\)@@@([\s\S]+?)(?<!\\)@@@/) do |match|
      if $1
        next match  # leave code spans/blocks untouched
      end

      math_code = $3.strip

      if @typst_block_cache.key?(math_code)
        next @typst_block_cache[math_code]
      end

      svg_dark  = Jekyll.compile_typst_svg(math_code, dark,  'typst_block', extra, display_math: true, size: dsize)
      svg_light = Jekyll.compile_typst_svg(math_code, light, 'typst_block', extra, display_math: true, size: dsize)

      result = if svg_dark || svg_light
        inner = ""
        inner += "<div class=\"typst-theme-dark\">#{svg_dark}</div>"   if svg_dark
        inner += "<div class=\"typst-theme-light\">#{svg_light}</div>" if svg_light
        "<div class=\"typst-math\">#{inner}</div>"
      else
        "<div class=\"typst-error\" style=\"color:red;\">[Typst Block Error]</div>"
      end

      @typst_block_cache[math_code] = result
      result
    end

    # STEP 2: Replace escaped \@@@ with literal @@@ outside code spans.
    doc.content.gsub!(/(`+)([\s\S]*?)\1|\\@@@/) do |match|
      $1 ? match : '@@@'
    end

  end
end
