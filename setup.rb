require "fileutils"
require './script'
require './ind'

class Setup
  include  Script
  #include  Setup

  def setup
    path='./sfm'
    #path='./usx'
    @TBOTB=''
    @new_tags  = Array.new
    #@language='english'
    @language='spanish'
    heading=true
    extra_vertical=true
    show_verse=true
    delete_intro=false
    if  path =='./sfm'
       format='SFM'
    elsif   path=='./usx'
      format='usx'
    end
    open_file(path,format,heading,extra_vertical,show_verse,delete_intro)

  end


  def open_file(path,format,heading,extra_vertical,show_verse,delete_intro)
    no_files_error(path)
     if format!='usx'
       FileUtils.rm_rf Dir.glob("./usx/*")
     end
    FileUtils.rm_rf Dir.glob('./super_usx/*')
    FileUtils.rm_rf Dir.glob('./xml/tbotb/*')
    FileUtils.rm_rf Dir.glob('./xml/stand/*')
    FileUtils.rm_rf Dir.glob('./html/TBOTB/*')
    FileUtils.rm_rf Dir.glob('./html/Standard/*')
    FileUtils.rm_rf Dir.glob('./html/hybrid/*')
    index_file=0

    while index_file < Dir["#{path}/*"].count do
      filename = File.basename(Dir["#{path}/*"][index_file], format)
      file=  File.open("#{path}/#{filename}#{format}")
      sfm_content=file.read

      main(sfm_content, filename, path,heading,extra_vertical,show_verse,delete_intro)
      index_file+=1
    end

  end
  def    no_files_error(path)
    if Dir["#{path}/*"].count==0
      puts 'Wrong path to files, or it is not exist'
    end

  end

  def  save_usx(sfm_content,path)
    @book=   @doc.xpath("//book").attribute("code").value

    @book_number = @books[@book]
     if path=='./usx'
       File.open("./usx/0#{@book_number.to_s+@book}.usx", 'w') { |f| f.write(sfm_content) }
     else
       File.open("./usx/0#{@book_number.to_s+@book}.usx", 'w') { |f| f.write('<?xml version="1.0" encoding="utf-8"?>'+"\n"+'<usx version="2.0">'+"\n"+sfm_content+"\n</usx>") }
     end

  end

  def save_super_usx(sfm_content,filename)


    @usx_with_bcv = @doc.to_s
    @doc.xpath("//bcv").remove
    File.open("./super_usx/0#{@book_number.to_s+@book}.usx", 'w') { |f| f.write(@doc)
    }

  end

  def save_ind

      File.open("./xml/stand/0#{@book_number.to_s+@book}.xml", 'w') { |f| f.write(@ind_content) }



  end

  def save_html


    if @format == 'Standard'
      html_file= @html.to_s.gsub!('<?xml version="1.0" encoding="UTF-8"?>
<usx version="2.0">', @html_standard )
      html_file.gsub!('</usx>','</body><html>')
      html_file.gsub!(/<(div class=.*)\/>/,'<\1></div>')
      html_file.gsub!('<span class="note-icon"/>','<span class="note-icon"></span>')
        File.open("./html/Standard/0#{@book_number.to_s+@book}.html", 'w') { |f| f.write(html_file) }
    elsif @format == 'hybrid'
      html_file= @html.to_s.gsub!('<?xml version="1.0" encoding="UTF-8"?>
<usx version="2.0">', @html_hybrid)
      html_file.gsub!('</usx>','</body><html>')
      html_file.gsub!(/<(div class=.*)\/>/,'<\1></div>')
      html_file.gsub!('<span class="note-icon"/>','<span class="note-icon"></span>')
      File.open("./html/hybrid/0#{@book_number.to_s+@book}.html", 'w') { |f| f.write(html_file) }
    elsif @format == 'TBOTB'

      html_file= @html.to_s.gsub!('<?xml version="1.0" encoding="UTF-8"?>
<usx version="2.0">', @html_tbotb )

      html_file.gsub!('</usx>','</body><html>')
      html_file.gsub!(/<(div class=.*)\/>/,'<\1></div>')
      html_file.gsub!('<span class="note-icon"/>','<span class="note-icon"></span>')
      File.open("./html/TBOTB/0#{@book_number.to_s+@book}.html", 'w') { |f| f.write(html_file) }
    end
  end

end


parsing= Setup.new
parsing.setup
