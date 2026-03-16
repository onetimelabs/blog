module Jekyll

require 'tempfile'
require 'json'

  # Shared helper used by all three typst plugins.
  # Compiles math_code to a cleaned, single-line SVG string using the given
  # fill color and optional extra Typst preamble lines.
  # Returns the SVG string, or nil on compilation failure.
  def self.compile_typst_svg(math_code, color, prefix = 'typst', extra_preamble = '')
    result = nil
    Tempfile.create([prefix, '.typ']) do |file|
      file.write("#set page(width: auto, height: auto, fill: none, margin: 2pt)\n")
      file.write("#set text(fill: rgb(\"#{color}\"))\n")
      file.write("#set curve(stroke: rgb(\"#{color}\"))\n")
      file.write("#set line(stroke: rgb(\"#{color}\"))\n")
      file.write("#set rect(stroke: rgb(\"#{color}\"))\n")
      file.write("#set polygon(stroke: rgb(\"#{color}\"))\n")
      file.write("#{extra_preamble}\n") unless extra_preamble.to_s.strip.empty?
      file.write("$#{math_code}$")
      file.rewind

      out_path = file.path.sub('.typ', '.svg')
      system("typst compile #{file.path} #{out_path}")

      if File.exist?(out_path)
        result = File.read(out_path)
          .gsub(/<\?xml.*?\?>/, '')
          .gsub(/<!DOCTYPE.*?>/, '')
          .delete("\n")
          .strip
        File.delete(out_path)
      end
    end
    result
  end

  class TypstBlock < Liquid::Block
    def initialize(tag_name, input, tokens)
      super
      @input = input.strip
    end

    def render(context)
      typst_code = super
      site  = context.registers[:site]
      tcfg  = site.config['typst'] || {}
      dark  = tcfg['dark_color']  || '#fff9e0'
      light = tcfg['light_color'] || '#667d6e'
      extra = tcfg['preamble'].to_s

      # Extract optional arguments: {"id": "eq-1", "preamble": "#let ..."}
      id = ""
      local_preamble = ""
      begin
        if !@input.nil? && !@input.empty?
          jdata = JSON.parse(@input)
          id              = jdata["id"].strip      if jdata.key?("id")
          local_preamble  = jdata["preamble"].to_s if jdata.key?("preamble")
        end
      rescue
      end

      full_extra = [extra, local_preamble].reject(&:empty?).join("\n")

      svg_dark  = Jekyll.compile_typst_svg(typst_code, dark,  'typst_input', full_extra)
      svg_light = Jekyll.compile_typst_svg(typst_code, light, 'typst_input', full_extra)

      inner = ""
      inner += "<div class=\"typst-theme-dark\">#{svg_dark}</div>"   if svg_dark
      inner += "<div class=\"typst-theme-light\">#{svg_light}</div>" if svg_light

      id_attr = id.empty? ? "" : " id=\"#{id}\""
      "<div class=\"typst-math\"#{id_attr}>#{inner}</div>"
    end
  end

Liquid::Template.register_tag('typst', Jekyll::TypstBlock)

end
