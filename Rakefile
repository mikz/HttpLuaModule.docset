require 'open-uri'
require 'html/pipeline'
class Theme
  def initialize(name)
    @url = "https://raw.githubusercontent.com/richleland/pygments-css/master/#{name}.css"
  end

  def css
    @css ||= open(@url).read
  end

  def html
    @html ||= "<style>#{css}</style>"
  end
end

class Documentation
  def initialize(version)
    @version = version or raise 'missing version'
    @url = "https://raw.githubusercontent.com/openresty/lua-nginx-module/v#{version}/README.markdown"
    @pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::TableOfContentsFilter
    ]
    @theme = Theme.new('github')
  end

  def html
    @html ||= @theme.html + @pipeline.call(markdown)[:output].to_s
  end

  def markdown
    @markdown ||= open(@url).read
  end

  def file
    'HttpLuaModule.html'.freeze
  end

  def sql
    document = Nokogiri::HTML(html)

    headings = document.css('h1,h2')
    directives = []
    lua_api = []

    sql = headings.map do |heading|
      a = heading.at_css('a[id]')
      text = heading.text.strip
      id = a['id']
      href = a['href']

      case text
        when 'Directives'.freeze
          directives = heading.next_element.css('li a').map(&:text)
        when 'Nginx API for Lua'.freeze
          lua_api = heading.next_element.css('li a').map{|a|a['href']}
      end

      case heading.name
        when 'h1'
          next "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Category', '#{file}##{id}');"
        when 'h2'
          if directives.include?(id) || lua_api.include?(href)
            next "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Function', '#{file}##{id}');"
          end
        else
          raise "UNKNOWN ELEMENT: #{heading.to_html}"
      end
    end

    sql.compact.join("\n")
  end


  def export(path)
    path = Pathname(path)
    create = %q{
      CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);
      CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
    }
    sqlite = IO.popen("sqlite3 #{path.join('docSet.dsidx')}" , 'r+' )

    sqlite << create << sql

    path.join('Documents/HttpLuaModule.html').open('w') do |f|
      f.puts(html)
    end
  end
end

task :generate, :version do |_t, args|
  doc = Documentation.new(args[:version])
  doc.export('Contents/Resources')
end
