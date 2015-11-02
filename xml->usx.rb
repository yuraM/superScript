#!/bin]env ruby
# encoding: utf-8
require 'nokogiri'

class XML_TO_USX
  def start
    @books= Hash[1=>"GEN", 2=>"EXO", 3=>"LEV", 4=>"NUM", 5=>"DEU", 6=>"JOS", 7=>"JDG", 8=>"RUT", 9=>"1SA", 10=>"2SA", 11=>"1KI", 12=>"2KI", 13=>"1CH", 14=>"2CH", 15=>"EZR", 16=>"NEH", 17=>"EST", 18=>"JOB", 19=>"PSA", 20=>"PRO", 21=>"ECC", 22=>"SNG", 23=>"ISA", 24=>"JER", 25=>"LAM", 26=>"EZK", 27=>"DAN", 28=>"HOS", 29=>"JOL", 30=>"AMO", 31=>"OBA", 32=>"JON", 33=>"MIC", 34=>"NAM", 35=>"HAB", 36=>"ZEP", 37=>"HAG", 38=>"ZEC", 39=>"MAL", 40=>"MAT", 41=>"MRK", 42=>"LUK", 43=>"JHN", 44=>"ACT", 45=>"ROM", 46=>"1CO", 47=>"2CO", 48=>"GAL", 49=>"EPH", 50=>"PHP", 51=>"COL", 52=>"1TH", 53=>"2TH", 54=>"1TI", 55=>"2TI", 56=>"TIT", 57=>"PHM", 58=>"HEB", 59=>"JAS", 60=>"1PE", 61=>"2PE", 62=>"1JN", 63=>"2JN", 64=>"3JN", 65=>"JUD", 66=>"REV"]
    @toc1_english= Hash[1=>"Genesis", 2=>"Exodus", 3=>"Leviticus", 4=>"Numbers", 5=>"Deuteronomy", 6=>"Joshua", 7=>"Judges", 8=>"Ruth", 9=>"1 Samuel", 10=>"2 Samuel", 11=>"1 Kings", 12=>"2 Kings", 13=>"1 Chronicles", 14=>"2 Chronicles", 15=>"Ezra", 16=>"Nehemiah", 17=>"Esther", 18=>"Job", 19=>"Psalms", 20=>"Proverbs", 21=>"Ecclesiastes", 22=>"Song of Songs", 23=>"Isaiah", 24=>"Jeremiah", 25=>"Lamentations", 26=>"Ezekiel", 27=>"Daniel", 28=>"Hosea", 29=>"Joel", 30=>"Amos", 31=>"Obadiah", 32=>"Jonah", 33=>"Micah", 34=>"Nahum", 35=>"Habakkuk", 36=>"Zephaniah", 37=>"Haggai", 38=>"Zechariah", 39=>"Malachi", 40=>"Matthew", 41=>"Mark", 42=>"Luke", 43=>"John", 44=>"Acts", 45=>"Romans", 46=>"1 Corinthians", 47=>"2 Corinthians", 48=>"Galatians", 49=>"Ephesians", 50=>"Philippians", 51=>"Colossians", 52=>"1 Thessalonians", 53=>"2 Thessalonians", 54=>"1 Timothy", 55=>"2 Timothy", 56=>"Titus", 57=>"Philemon", 58=>"Hebrews", 59=>"James", 60=>"1 Peter", 61=>"2 Peter", 62=>"1 John", 63=>"2 John", 64=>"3 John", 65=>"Jude", 66=>"Revelation"]
    @toc3_english=  Hash[1=>"Ge", 2=>"Ex", 3=>"Lev", 4=>"Nu", 5=>"Dt", 6=>"Jos", 7=>"Jdg", 8=>"Ru", 9=>"1Sa", 10=>"2Sa", 11=>"1Ki", 12=>"2Ki", 13=>"1Ch", 14=>"2Ch", 15=>"Ezr", 16=>"Ne", 17=>"Est", 18=>"Job", 19=>"Ps", 20=>"Pr", 21=>"Ecc", 22=>"SS", 23=>"Isa", 24=>"Jer", 25=>"La", 26=>"Eze", 27=>"Da", 28=>"Hos", 29=>"Joel", 30=>"Am", 31=>"Ob", 32=>"Jnh", 33=>"Mic", 34=>"Na", 35=>"Hab", 36=>"Zep", 37=>"Hag", 38=>"Zec", 39=>"Mal", 40=>"Mt", 41=>"Mk", 42=>"Lk", 43=>"Jn", 44=>"Ac", 45=>"Ro", 46=>"1Co", 47=>"2Co", 48=>"Gal", 49=>"Eph", 50=>"Php", 51=>"Col", 52=>"1Thes", 53=>"2Thes", 54=>"1Ti", 55=>"2Ti", 56=>"Tit", 57=>"Phm", 58=>"Heb", 59=>"Jas", 60=>"1Pe", 61=>"2Pe", 62=>"1Jn", 63=>"2Jn", 64=>"3Jn", 65=>"Jude", 66=>"Rev"]
    index_file=0

    while index_file < Dir["xml_j1w/*"].count do
      filename = File.basename(Dir['xml_j1w/*'][index_file], '.xml')
      file= File.open("xml_j1w/#{filename}.xml")
      sfm_content=file.read

      #puts sfm_content
      to_usx(sfm_content)
      save

      index_file+=1
    end
  end

  def to_usx(sfm_content)
    @local_doc = Nokogiri::HTML('<html><body><h1>test</h1></body></html>')
    @ind = Nokogiri::XML(sfm_content)
    element = @ind.xpath('//descendant::*')
    element_count = @ind.xpath('//descendant::*').count
    element_index = 0
    #@book_number = @books[book]

    while element_index < element_count do
      @element = element[element_index]

       bcv
       bk
       chapter
       mbk
        mt1
      otquote
      mt
      s1
      p0
      p1
      s
      half
       ch
      line
      xb
      v
      q1
      q2
      qvt
      f
      nd
      m1
      vmu
      s2
      q0
      char_it
      wj
      d
      flr
      hc
      mr
      vh
      vr
      q3
      ct
      xtable
      xtr
      xtd
      sn
      crossrefs
      qss
      span
      selah
      sc
      mt2
       if @element.name !='para' and @element.name !='chapter'   and @element.name !='usx'    and @element.name !='verse'    and @element.name !='mbk' and @element.name !='bcv'    and @element.name !='int'    and @element.name !='note'  and @element.name !='char'and @element.name !='char'and @element.name !='half'and @element.name !='it'  and @element.name !='line' and @element.name !='ch' and @element.name !='xb'and @element.name !='qvt'    and @element.name !='vmu'    and @element.name !='vh'     and @element.name !='table'   and @element.name !='row'    and @element.name !='cell'  and @element.name !='table_style'   and @element.name !='ct'   and @element.name !='crossrefs'   and @element.name !='qss'  and @element.name !='selah'  and @element.name !='sc'
         puts @element.name
         puts @element
         puts @element.parent
         puts @book_id
       end
      element_index+=1
    end

  end



  def span
    if @element.name == 'span' and @element.attribute('class')!=nil and @element.attribute('class').value=='small-caps'

      @element.name='char'
      @element.set_attribute('style','sc')
      @element.attribute('class').remove


    end
  end

       def sc
         if @element.name == 'sc'
           @element.add_previous_sibling(@element.children)
           @element.remove
         end
       end
    def selah
      if @element.name == 'selah'
        @element.add_previous_sibling(@element.children)
        @element.remove
      end
    end

  def qss
    if @element.name == 'qss'
      @element.add_previous_sibling(@element.children)
      @element.remove

    end
  end

  def crossrefs
    if @element.name == 'crossrefs'
      @element.remove

    end
  end
  def sn
    if @element.name == 'sn'
      @element.name='para'
      @element.set_attribute('style','s2')

    end
  end

  def xtd
    if @element.name == 'xtd'
        if @element.attribute('class').value == 'width6 bcv'||@element.attribute('class').value == 'width10 bcv'
        @element.name = 'cell'
        @element.set_attribute('style','tc1')
        @element.set_attribute('align','start')
        @element.attribute('class').remove
        @element.attribute('bcv').remove
        elsif @element.attribute('class').value == 'width6 txtar vab bcv' || @element.attribute('class').value == 'width2 txtar vab bcv'
          @element.name = 'cell'
          @element.set_attribute('style','tc3')
          @element.set_attribute('align','end')
          @element.attribute('class').remove
          @element.attribute('bcv').remove
        else
          puts @element
        end
         @element.children.each { |child|
       if  child.name=='q1'
          child.name='table_style'
       end

         }



    end
  end


  def xtr
    if @element.name == 'xtr'
      @element.name='row'
      @element.set_attribute('style','tr')

    end
  end
        def xtable
          if @element.name == 'xtable'
            @element.name='table'
            @element.attribute('class').remove
            puts   @element
            puts '++++++'
          end
        end

  def ct
    if @element.name == 'ct'
      @element.add_previous_sibling(@element.content)
       @element.remove
    end
  end

  def vr
    if @element.name == 'vr'
      @element.name='verse'
      @element.set_attribute('number', @element.attribute('id').value)
      @element.set_attribute('style', 'v')
      @element.attribute('id').remove
    end
  end


  def vh
    if @element.name == 'vh'
      @element.remove
    end
  end

  def mr
    if @element.name == 'mr'
      @element.name='para'
      @element.set_attribute('style','ms')

    end
  end
  def q3
    if @element.name == 'q3'
      @element.name='para'
      @element.set_attribute('style','q3')

    end
  end
  def hc
    if @element.name == 'hc'
      @element.name='para'
      @element.set_attribute('style','qa')

    end
  end
  def flr
    if @element.name == 'flr'
      @element.name='para'
      @element.add_previous_sibling(@element.children)
      @element.remove
    end
  end
  def d
    if @element.name == 'd'
      @element.name='para'
      @element.set_attribute('style','d')
    end
  end

  def wj
    if @element.name == 'wj'
      @element.name='char'
      @element.set_attribute('style','wj')
    end
  end


  def otquote
    if @element.name == 'otquote'
      @element.name = 'char'
      @element.add_previous_sibling(@element.children)
      @element.remove
    end
  end
  def char_it
    if @element.name == 'it'
      @element.add_previous_sibling(@element.children)
      @element.remove
    end
  end
  def q0
    if @element.name == 'q0'
      @element.name='para'
      @element.set_attribute('style','li1')
    end
  end
  def s2
    if @element.name == 's2'
      @element.name='para'
      @element.set_attribute('style','s2')
    end
  end

  def vmu
    if @element.name == 'vmu'
      @element.add_previous_sibling(@element.content)
   @element.remove
    end
  end

  def m1
    if @element.name == 'm1'
      #if @element.parent.name!= 'usx'
      #  puts  @element.parent.name
      #  puts @element
      #  puts @book_id
      #end
      @element.name='para'
      @element.set_attribute('style','li2')
    end
  end
  def nd
    if @element.name == 'nd'
      if @element.content=='Lord' || @element.content=='God'
      @element.name='char'
      @element.set_attribute('style','nd')
      elsif @element.content=='God,'
      @element.add_next_sibling(',')
      @element.name='char'
      @element.set_attribute('style','nd')
      @element.content='God'
      elsif @element.content=='God.'
        @element.add_next_sibling('.')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='God'
      elsif @element.content=='Gods'
        @element.add_next_sibling('s')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='God'
      elsif @element.content=='God;'
        @element.add_next_sibling(';')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='God'
      elsif @element.content=='God!'
        @element.add_next_sibling('!')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='God'
      elsif @element.content=='God:'
        @element.add_next_sibling(':')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='God'
      elsif @element.content=='Lord,'
        @element.add_next_sibling(',')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='Lord'
      elsif @element.content=='Lord.'
        @element.add_next_sibling('.')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='Lord'
      elsif @element.content=='Lord;'
        @element.add_next_sibling(';')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='Lord'
      elsif @element.content=='Lord?'
        @element.add_next_sibling('?')
        @element.name='char'
        @element.set_attribute('style','nd')
        @element.content='Lord'
      else

        @element.add_previous_sibling(@element.content)
        @element.name='char'
        @element.remove
        end
    end
  end
  def f
    if @element.name == 'f'
      @element.name= 'note'

      @element.set_attribute('style','f')
      @element.set_attribute('caller','+')
      @element.attribute('id').remove
      fr =   Nokogiri::XML::Node.new 'char', @local_doc
      fr.set_attribute('style','fr')
      fr.set_attribute('closed','false')
      if                   @verse!=nil
        fr.content= @chap_num+':'+@verse
      end
      #fr.content= @chap_num+':'+@verse
      @element.children[0].add_previous_sibling(fr)
     @element.children.each { |element|

      if  element.name=='text'
     ft =   Nokogiri::XML::Node.new 'char', @local_doc
     ft.set_attribute('style','ft')
     ft.set_attribute('closed','false')



     if   element.previous_element!=nil and element.previous_element.attribute('style')!=nil and element.previous_element.attribute('style').value =='ft'
       element.previous_element.add_child(element.content)

       element.remove

     else

       ft.content= element.content


     element.add_previous_sibling(ft)

     element.remove
          end
      elsif
       element.name=='nbsp'
        element.previous_element.add_child(' ')
        element.remove
      elsif
      element.name=='thinsp'
        element.previous_element.add_child(' ')
        element.remove
      elsif
      element.name=='vmu'
        element.previous_element.add_child(element.children)
        element.remove
      elsif
      element.name=='sc'
        element.previous_element.add_child(element.children)
        element.remove
      elsif
      element.name=='ref'
        element.previous_element.add_child(element.children)
        element.name ='char'
        element.remove
      elsif
      element.name=='xb'
        element.name ='char'
        element.remove
      elsif
      element.name=='it'
        element.name ='char'
        element.set_attribute('style','fq')
        element.set_attribute('closed','false')
        elsif element.name == 'wj'
          element.name='char'
          element.set_attribute('style','wj')

      elsif
      element.name=='char'
      elsif
      element.name=='ndash'
              element.previous_element.add_child('–')
              element.remove
      elsif   element.name=='mdash'
              element.previous_element.add_child('—')
              element.remove
      elsif   element.name=='eacute'
        element.previous_element.add_child('é')
        element.remove
      elsif   element.name=='sup2' ||   element.name=='frac12'   ||   element.name=='sup1'||   element.name=='sup3'   ||   element.name=='frac14'
        element.previous_element.add_child(element.to_s)
        element.remove
      elsif
      element.name=='nd'
        element.previous_element.add_child(element)
      else
        if element.name=='rsquo'  ||element.name=='lsquo' ||element.name=='rdquo'   ||element.name=='ldquo'
          element.previous_element.add_child(element)

        else
         puts 'NOTE PROBLEM, not setup style'+ element.to_s
         puts element.parent
         puts @book_id
          end


      end

      }
      @element.children.each { |element|
        if  element.name=='text'
          element.content=''
        elsif  element.name=='char'and element.content[0]==' '
          element.previous_element.add_child(' ')
          element.content=element.content[1..-1]
        end
      }
    end
  end


  def qvt
    if @element.name == 'qvt'
      verse =  Nokogiri::XML::Node.new 'verse', @local_doc
      @verse = @element.attribute('id').value
      verse.set_attribute('number',@element.attribute('id').value)
      verse.set_attribute('style','v')
      @element.next_element.children[0].add_previous_sibling(verse)
      @element.remove
    end

  end
  def q1
    if @element.name == 'q1'
      @element.name='para'

      @element.set_attribute('style','q1')

    end
  end
  def q2
    if @element.name == 'q2'
      @element.name='para'

      @element.set_attribute('style','q2')

    end
  end

  def v
    if @element.name == 'v'
       @element.name='verse'
       @verse= @element.attribute('id').value
       @element.set_attribute('number',@element.attribute('id').value)
       @element.set_attribute('style','v')
       @element.attribute('id').remove
    end
  end

  def xb
    if @element.name == 'xb'
      @element.add_previous_sibling(@element.children)
      @element.remove
    end
  end
  def line
    if @element.name == 'line'
    #  @element.name='para'
    #  @element.set_attribute('style','ie')
    #  @element.content =''
    #  imte1 =  Nokogiri::XML::Node.new 'para', @local_doc
    #  imte1.set_attribute('style','imte1')
    #
    #  imte1.content=@toc1_english[@book_id.to_i]
      @element.remove
    end
  end
  def ch
    if @element.name == 'ch'
      @element.remove
    end
  end
       def half
         if @element.name == 'half'
           if  @element.previous_element!=nil and  @element.previous_element.attribute('style')!=nil and @element.previous_element.attribute('style').value!='s1' || @element.next_element.name !='s'
                    @element.remove
           elsif @element.parent.name=='int'
             @element.remove
           else
             @element.name='para'
             @element.set_attribute('style','b')

             @element.content=''

           end

         end
       end

  def p0
    if @element.name == 'p0'
      @element.name='para'
      if @element.parent!=nil and  @element.parent.name=='int'
        @element.set_attribute('style','ip')
        @element.remove
      else
        @element.set_attribute('style','p')
      end
    end
  end
  def p1
    if @element.name == 'p1'
      @element.name='para'

        @element.set_attribute('style','pi')
    end
  end


  def mt2
    if @element.name == 'mt2'
      @element.name='para'

@element.remove

    end
  end
  def s
    if @element.name == 's'
      @element.name='para'

        @element.set_attribute('style','s1')

    end
  end
  def s1
    if @element.name == 's1'
      @element.name='para'
      if  @element.parent.name=='int'
          @element.set_attribute('style','is1')
          @element.remove
      else
        @element.set_attribute('style','s1')
       end
    end
  end


  def mt1
    if @element.name == 'mt1'
      @element.name='para'
      @element.set_attribute('style','imt2')
      @element.remove
    end
  end

  def mt
    if @element.name == 'mt'
      @element.name='para'
      @element.remove
    end
  end

  def mbk
    if @element.name == 'mbk'
       @element.remove

       #add_header

    end
  end

  def add_header(book)

    mt1 =  Nokogiri::XML::Node.new 'para', @local_doc
      mt1.set_attribute('style','mt1')
    book.add_next_sibling(mt1)
    mt1.content=@toc1_english[@book_id.to_i]
    toc3 =  Nokogiri::XML::Node.new 'para', @local_doc
    toc3.set_attribute('style','toc3')
    book.add_next_sibling(toc3)
    toc3.content=@toc3_english[@book_id.to_i]
    toc2 =  Nokogiri::XML::Node.new 'para', @local_doc
    toc2.set_attribute('style','toc2')
    book.add_next_sibling(toc2)
    puts   @book_id
    toc2.content=@books[@book_id.to_i].capitalize + "."
    toc1 =  Nokogiri::XML::Node.new 'para', @local_doc
    toc1.set_attribute('style','toc1')
    book.add_next_sibling(toc1)
    toc1.content=@toc1_english[@book_id.to_i]
    h =  Nokogiri::XML::Node.new 'para', @local_doc
    h.set_attribute('style','h')
    book.add_next_sibling(h)
    h.content=@toc1_english[@book_id.to_i].upcase
    #puts @toc1_english[@book_id.to_i]
  end


  def chapter
    if @element.name == 'container'
         @element.add_next_sibling(@element.children)
         @element.name= 'chapter'
          if  @element.attribute('id').value=~ /\d+\.0\.0-\d+\.0\.0/
               @element.remove
          else
               #puts @element.attribute('id').value
         @chap_num =   @element.attribute('id').value.match(/\d+\.(\d+)\.0-\d+\.(\d+)\.\d/)[1]
         @element.attribute('id').remove
         @element.set_attribute('number',@chap_num)
         @element.set_attribute('style','c')
          end


    end

  end

  def bk
    if @element.name == 'bk'
     if  @element.attribute('id').value == '22'
       #puts   @element
     end
      @element.name='usx'
      @book_id= @element.attribute('id').value

      @element.attribute('id').remove
      @element.set_attribute('version','2.0')
      book =  Nokogiri::XML::Node.new 'book', @local_doc
      book.set_attribute('code',@books[@book_id.to_i])
      book.set_attribute('style','id')
       @element.children[1].add_previous_sibling(book)
      add_header(book)
     @element.attribute('name').remove
     @element.attribute('short_name').remove
     @element.attribute('order').remove
    end

  end

  def bcv
    if @element.name == 'bcv'
      @element.add_next_sibling(@element.children)
      @element.remove
    end
  end


  def save

     @ind.xpath('//table_style').each { |table_style|
     table_style.add_previous_sibling(table_style.children)
     table_style.remove



     }

     @ind.xpath('//char[@style="ft"]').each { |style|
       if style.content==''
         style.remove
       end



     }


     @ind_content = @ind.to_s
    @ind_content.gsub!(/^\s+/,'')
    @ind_content.gsub!('<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">','')
    @ind_content.gsub!('<?xml-stylesheet href="usfx_to_xhtml.xsl" type="text/xsl"?>','')
    @ind_content.gsub!('"><verse','"'+">\n<verse")
    @ind_content.gsub!('&ldquo;','“')
    @ind_content.gsub!('&rdquo;','”')
    @ind_content.gsub!('&lsquo;','‘')
    @ind_content.gsub!('&rsquo;','ʼ')
    @ind_content.gsub!('&nbsp;',' ')
    @ind_content.gsub!('&rsquo;','ʼ')
    @ind_content.gsub!('&mdash;',' — ')
    @ind_content.gsub!('&ndash;','—')
     @ind_content.gsub!('&eacute;','é')
    @ind_content.gsub!('&thinsp;','')
    @ind_content.gsub!(' &hellip; ','…')
    @ind_content.gsub!('><para',">\n<para")
    @ind_content.gsub!('<int/>',"")
    @ind_content.gsub!('</int>',"")
    @ind_content.gsub!('<int>',"")


    name = @books[@book_id.to_i]

if  @book_id.to_i<10
  @pref='0'+ @book_id.to_s
else
  @pref= @book_id.to_s
end

    File.open("./usx/0#{@pref}#{name}.usx", 'w') { |f| f.write(@ind_content) }
  end


end



parsing= XML_TO_USX.new
parsing.start