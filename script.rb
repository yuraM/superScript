# encoding: utf-8
require 'nokogiri'
require './tags_list'
#require './tbotb'
require './nvi'
#require './ind'
require './new_ind'
require './usx_to_html'

module Script

  include  Tags_list
  #include  Ind
  include  New_ind
  include  UsxToHtml

  def main(sfm_content,filename,path,heading,extra_vertical,show_verse,delete_intro)

      get_list_of_tags
      if path=='./sfm'
         create_sample_xml(sfm_content)
      else
        clean_usx(sfm_content)
      end


      add_bcv(sfm_content,path)
      save_usx(sfm_content,path)
      if extra_vertical
        add_tb_data
      end

      save_super_usx(sfm_content,filename)
      #get_ind_format(heading)
      get_design(heading,show_verse,extra_vertical,delete_intro)
      create_html


  end

  def clean_usx(sfm_content)
    sfm_content.gsub!(/\s^$/,'')
    sfm_content.gsub!(/>\n<verse/,'><verse')
  end


  def get_ind_format(heading)
      ind_generate(heading)
  end
  def add_veritical_padding(para, pedding,i)

    if  TB_DATA[i][2]==1
      para.content = "veritical_padding_#{pedding}"
    else
      para.content = "veritical_padding_#{pedding} next_para_flush"
    end

  end

  def  add_tb_data
    book=   @doc.xpath('//book').attribute('code').value
    book_number = @books[book]
    local_doc = Nokogiri::HTML('<html><body><h1>test</h1></body></html>')
    i=0
    while i<  TB_DATA.count
     if  /(\d+)\.(\d+)\.(\d+)\.?(\d?)/.match(TB_DATA[i][0])[1] == book_number.to_s
      chapter = /(\d+)\.(\d+)\.(\d+)\.?(\d?)/.match(TB_DATA[i][0])[2]
      verse = /(\d+)\.(\d+)\.(\d+)\.?(\d?)/.match(TB_DATA[i][0])[3]
      verse_index = /(\d+)\.(\d+)\.(\d+)\.?(\d?)/.match(TB_DATA[i][0])[4]
       if   verse_index==''
            if  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0]==nil
              puts "ERROR: bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, but there is no current verse"

            else
                 if  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[0].content =="#{chapter}:#{verse}"
                   para = Nokogiri::XML::Node.new 'para', local_doc
                   para.set_attribute('style', 'tbotb')
                   pedding=  TB_DATA[i][1]
                   if     pedding==4
                     pedding=0
                   end
                   add_veritical_padding(para, pedding,i)


                   if @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.name=='para' and @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.attribute('style').value=='tbotb'
                     puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, there is 2 pedding, that myst be on other place"
                   end
                   @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.add_previous_sibling(para)
                 if TB_DATA[i][3] ==1
                   bd= Nokogiri::XML::Node.new 'char', local_doc
                   bd.set_attribute('style', 'bd')
                   bd.content = @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content[0]
                   @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content=  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content[1..-1]
                   @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].add_previous_sibling(bd)
                 end


                 else
                  if @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[0].name!='note'
                   puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, but first verse is #{@doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[0].content}"
                  end
                   para = Nokogiri::XML::Node.new 'para', local_doc
                   para.set_attribute('style', 'tbotb')
                   pedding=  TB_DATA[i][1]
                   if     pedding==4
                     pedding=0
                   end
                  add_veritical_padding(para, pedding,i)
                   if @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.name=='para' and @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.attribute('style').value=='tbotb'
                     puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, there is 2 pedding, that myst be on other place"
                   end
                   @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.add_previous_sibling(para)
                   if TB_DATA[i][3] ==1
                     bd= Nokogiri::XML::Node.new 'char', local_doc
                     bd.set_attribute('style', 'bd')
                     if  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[0].name=='note' and  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].name=='bcv'
                       bd.content = @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[4].content[0]
                       @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[4].content=  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[4].content[1..-1]
                       @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[4].add_previous_sibling(bd)

                     else

                       bd.content = @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content[0]
                       @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content=  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].content[1..-1]
                       @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[2].add_previous_sibling(bd)

                     end
                   end
                 end
            end

       else
         if    @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1]==nil
           puts "ERROR: bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, verse have no #{verse_index} part"

         else

          if  @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.children[0].content =="#{chapter}:#{verse}"
            para = Nokogiri::XML::Node.new 'para', local_doc
            para.set_attribute('style', 'tbotb')
            pedding=  TB_DATA[i][1]
            if     pedding==4
              pedding=0
            end

            add_veritical_padding(para, pedding,i)
            if @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.name=='para' and @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.attribute('style').value=='tbotb'
              puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, there is 2 pedding, that myst be on other place"
            end
            @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.add_previous_sibling(para)
          else
            puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, but first verse is #{@doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[0].parent.children[0].content}"
            para = Nokogiri::XML::Node.new 'para', local_doc
            para.set_attribute('style', 'tbotb')
            pedding=  TB_DATA[i][1]
            if     pedding==4
              pedding=0
            end

            add_veritical_padding(para, pedding,i)
             if @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.name=='para' and @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.previous_element.attribute('style').value=='tbotb'
               puts "bad reference in tbotb data in book #{book}, verse must be: #{chapter}.#{verse}, there is 2 pedding, that myst be on other place"
             end
            @doc.xpath("//bcv[text() = '#{chapter}:#{verse}']")[verse_index.to_i-1].parent.add_previous_sibling(para)

          end

         end
        end
     end

    i+=1
    end

  end

  def add_bcv(sfm_content,path)
    if path==  './sfm'
     @doc =   Nokogiri::XML('<usx version="2.0">'+sfm_content+'</usx>', nil, 'UTF-8')
    else
      @doc =   Nokogiri::XML(sfm_content, nil, 'UTF-8')

  end
     local_doc = Nokogiri::HTML('<html><body><h1>test</h1></body></html>')
     element = @doc.xpath('//usx/descendant::*')
     element_count = @doc.xpath('//usx/descendant::*').count
     element_index = 0
     while element_index < element_count do
       current_element = element[element_index]
       if   current_element.attribute('style')!=nil
            @style = current_element.attribute('style').value
       end
        #############################CHAPTER#############################
         if  current_element.name=='chapter'
           current_element.attribute('number').value= current_element.attribute('number').value.to_i.to_s
           chapter = current_element.attribute('number').value
         end
        #################################################################
        #############################TABLE###############################
         if current_element.name=='row'  and  path==  './sfm'

           if current_element.previous_element.name!= 'row' and current_element.previous_element.name!= 'table'
                table = Nokogiri::XML::Node.new 'table', local_doc
                current_element.add_previous_sibling(table)
                table.add_child(current_element)
           elsif  current_element.previous_element.name== 'table'
             current_element.previous_element.add_child(current_element)

             end
         end

       #################################################################
        if  current_element.name == 'para'|| current_element.name == 'cell' and add_bcv_to ==true

         i=0
           while i!= current_element.children.count do
             if chapter == nil
               chapter='1'
             end

             if  current_element.children[i].name=='verse'
               @verse = current_element.children[i].attribute('number').value
               bcv = Nokogiri::XML::Node.new 'bcv', local_doc
               bcv.content = chapter+':'+ @verse
               current_element.children[i].add_previous_sibling(bcv)
               i+=1
             elsif i==0 and current_element.children[i].name=='text'
               bcv = Nokogiri::XML::Node.new 'bcv', local_doc
              if  @verse == nil
              else

                bcv.content = chapter+':'+ @verse
                current_element.children[i].add_previous_sibling(bcv)
              end



             elsif i==0 and current_element.children[i].name=='char'
               bcv = Nokogiri::XML::Node.new 'bcv', local_doc
               bcv.content = chapter+':'+ @verse
               current_element.children[i].add_previous_sibling(bcv)
             end

             i+=1
           end

        end
       element_index+=1
     end

end

  def add_bcv_to
    intro_style = %w[tc1 tc2 tc3 tc4 tc5 tc6 tc7 tc8 th1 th2 th3 tcr3 tcr2 tcr1 pi p li li1 li2 li3 li4 q1 q2 q3 q4 qm1 qm2 qm3 m1 m pm d mi nb pmr pmo qr sp pc pmc pr qs cls pi1 qc]
    intro_style.each { |a|
      if @style== a
        return true
      end
    }
  end

  def create_sample_xml(sfm_content)

    sfm_content.gsub!("\r", '')
    sfm_content.gsub!("\n", ' ')
    sfm_content.gsub!(/\\(#{@all_para}) /, "\n"+'<\1> ')
    sfm_content.gsub!(/\\tr /, "\n"+'<tr> ')
    sfm_content.gsub!(/\\c /, "\n"+'\c ')
    sfm_content.gsub!(/\\(#{@self_close}) /, "\n"+'<para style="\1"/>')
    sfm_content.gsub!(/\\v\s+(\d+)\s+\\vp\s?(\[\d+\])\s?\\vp\*/,'<verse number="\1" style="v" pubnumber="\2" />')
    sfm_content.gsub!(/\\v\s+(\d+) /,'<verse number="\1" style="v"/>')
    sfm_content.gsub!(/\\v (\d+-\d+) /,'<verse number="\1" style="v"/>')
    sfm_content.gsub!(/<(#{@all_para})>\s+(.*?)\r?\n/,'<para style="\1">\2</para>'+"\n")
    sfm_content.gsub!(/\\(#{@self_close})\s*?\r?\n/,'<para style="\1" />'+"\n")
    sfm_content.gsub!(/\\c\s+(.*?)\r?\n/,'<chapter number="\1" style="c"/>'+"\n")
    sfm_content.gsub!(/\\id (...$)/,'<book code="\1" style="id" />')
    sfm_content.gsub!(/\\id\s(...)\s(.*)/,'<book code="\1" style="id">\2</book>')
    ####################################char_in_notes#####################################
    sfm_content.gsub!(/\\\+nd (.*?)\\\+nd\*/,'<in_note style="nd">\1</in_note>')
    sfm_content.gsub!(/\\\+bk (.*?)\\\+bk\*/,'<in_note style="bk">\1</in_note>')
    sfm_content.gsub!(/\\\+xt (.*?)\\\+xt\*/,'<in_note style="xt">\1</in_note>')
    sfm_content.gsub!(/\\xt (.*?)\\xt\*/,'<in_note style="xt">\1</in_note>')
    sfm_content.gsub!(/\\\+tl (.*?)\\\+tl\*/,'<in_note style="tl">\1</in_note>')
    sfm_content.gsub!(/\\\+wj (.*?)\\\+wj\*/,'<in_note style="wj">\1</in_note>')
    sfm_content.gsub!(/\\\+pn (.*?)\\\+pn\*/,'<in_note style="pn">\1</in_note>')
    sfm_content.gsub!(/\\\+w (.*?)\\\+w\*/,'<in_note style="w">\1</in_note>')
    sfm_content.gsub!(/\\\+k (.*?)\\\+k\*/,'<in_note style="k">\1</in_note>')
    sfm_content.gsub!(/\\\+em (.*?)\\\+em\*/,'<in_note style="em">\1</in_note>')
    sfm_content.gsub!(/\\\+ord (.*?)\\\+ord\*/,'<in_note style="ord">\1</in_note>')
    sfm_content.gsub!(/\\\+add (.*?)\\\+add\*/,'<in_note style="add">\1</in_note>')
    ####################################NOTES#############################################
    sfm_content.gsub!(/\\f \+ (.*?)\\f\*/,'<note caller="+" style="f">\1</note>')
    sfm_content.gsub!(/\\ef \- (.*?)\\ef\*/,'<note caller="-" style="ef">\1</note>')
    sfm_content.gsub!(/\\x \- (.*?)\\x\*/,'<note caller="-" style="x">\1</note>')
    sfm_content.gsub!(/\\fe \+ (.*?)\\fe\*/,'<note caller="+" style="fe">\1</note>')
    sfm_content.gsub!(/\\f (.*?)\\f\*/,'<note caller="+" style="f">\1</note>')
    ####################################char##############################################
    sfm_content.gsub!(/\\(#{@char}) (.*?)\\(#{@char})\*/,'<char style="\1">\2</char>')
    sfm_content.gsub!(/\\(#{@char_closed}) (.*?)(<char|\\|<\/note>)/,'<char style="\1" closed="false">\2</char>\3')
    sfm_content.gsub!(/\\(#{@char_closed}) (.*?)(<char|\\|<\/note>)/,'<char style="\1" closed="false">\2</char>\3')
    sfm_content.gsub!(/\\fv\s+(\d+)/,'<char style="fv">\1</char>')
    ####################################table##############################################
    sfm_content.gsub!(/<(tr)>\s+(.*)\n/,'<row style="\1">\2</row>'+"\n")
    table(sfm_content)
    sfm_content.gsub!(/\\tc3/,'<cell style="tc3" align="start" />')
    sfm_content.gsub!(/\\tcr3/,'<cell style="tcr3" align="start" />')
    sfm_content.gsub!(/<(#{@all_para})>\s+(.*)/,'<para style="\1">\2</para>'+"\n")
    sfm_content.gsub!('in_note','char')
    sfm_content.gsub!(' </para>','</para>')
    sfm_content.gsub!(' </book>','</book>')
    sfm_content.gsub!('\qs*','')
    sfm_content.gsub!('\fl*','')
    sfm_content.gsub!(/<chapter number="(\d+)\s+" style="c"\/>/,'<chapter number="\1" style="c"/>')

  if sfm_content.include?('\\')
    puts sfm_content
  end

  end
  def table(sfm_content)
    if sfm_content =~ /\\(#{@table}) (.*?)\s?(\\|<\/row>)/
      sfm_content.gsub!(/\\(#{@table}) (.*?)\s?(\\|<\/row>)/,'<cell style="\1" align="start">\2</cell>\3')
      table(sfm_content)
    end
  end
end