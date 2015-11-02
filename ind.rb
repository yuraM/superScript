require './script'

module Ind


  def ind_generate(heading)
    @local_doc = Nokogiri::HTML('<html><body><h1>test</h1></body></html>')
    @ind = Nokogiri::XML( @doc.to_s)
    element = @ind.xpath('//usx/descendant::*')
    element_count = @ind.xpath('//usx/descendant::*').count
    element_index = 0
    @chapter_number=''
    book=   @doc.xpath("//book").attribute("code").value
    @book_number = @books[book]

    while element_index < element_count do
      @element = element[element_index]
      name = @element.name
      if    @element.attribute('style')!=nil
        style = @element.attribute('style').value
      end

      ##############
      delete_intro(name, style)
      temp_delete(name, style)
      save_chap_number(name)
      s1(name, style,heading)
      s2(name, style,heading)
      s3(name, style,heading)
      ms(name, style)
      ms1(name, style)
      mr(name, style)
      cl(name, style)
      d(name, style)
      h(name, style)
      sp(name, style)
      qa(name, style)
      s4(name, style)
      verse(name)
      p_style(name, style)
      note(name)
      para_b(name, style)
      char(name, style)
      tbotb(name, style)
      para_ms2(name, style)
      para_r(name, style)
      tables(name, style)
      ##############

        if @element.name=='para'  ||  @element.name=='char'|| @element.name=='cell' and   check
          puts @element
          puts @book
          puts 'indesign '+ @TBOTB
        end
      element_index+=1
    end

    save_as
  end

  ################# CHAR ###################
  def check
    intro_style = %w[s3 sp rem h qa toc1 toc2 toc3 imt2 mt2 imt1 im ip qt ili1 imte1 ie ms1  fr fqa ft fq s1 fm iq1 imq bd fv wj io1 io2 io3 k ib imi xt bk s2 tbotb tc1 tc2 tc3 tc4 tc5 tc6 tc7 tc8 sr ide fl]
    intro_style.each { |a|
      if @element.attribute('style').value== a
        return false
      end
    }
  end

  def   char(name, style)
    if name=='char'
      wj(style)
      fm(style)
      sc(style)
      tl(style)
      char_w(style)
      bd(style)
      k(style)
      it(style)
      char_nd(style)
      xt(style)
      ior(style)
      xo(style)
    end
  end


  def   xo(style)
    if style=='xo'
      @element.name= @element.attribute('style').value
      @element.attribute('style').remove
    end
  end
  def   ior(style)
    if style=='ior'
      @element.name= @element.attribute('style').value
      @element.attribute('style').remove
    end
  end



  def wj(style)
    if style=='wj'
      if   @element.parent.name == 'tl'
        @element.add_next_sibling(@element.content)
        @element.remove
      else
        @element.name ='wj'
      end
    end
  end

  def xt(style)
    if  style=='xt'
      @element.remove
    end
  end

  def k(style)
    if  style=='k'
      @element.remove
    end
  end

  def bd(style)
    if  style=='bd'
      @element.add_previous_sibling(@element.content)
      if @TBOTB=='yes'
          if @element.parent.name=='p-flush'
             @element.parent.name='p-drop-cap'
          else

            @element.parent.name  +='-drop-cap'

          end
    if  @element.parent.children[0].name=='bcv'
      ind=0
    elsif @element.parent.children[0].name=='text' and  @element.parent.children[0].content=='tabulation'  and  @element.parent.children[1].content!=' '

      ind=1
    else

      ind=2
    end

      if  @element.parent.children[ind].content.length ==3
        @element.parent.name+='-1'
      elsif @element.parent.children[ind].content.length ==4
        @element.parent.name+='-2'
      elsif @element.parent.children[ind].content.length ==5
        @element.parent.name+='-3'
      elsif @element.parent.children[ind].content.length ==6
        @element.parent.name+='-4'
      else
        puts "BCV TBOTB ERROR"
       puts  @element.parent.children[0].content.length
        puts @element.parent
      end

      elsif @TBOTB=='yes'  and  @element.parent.name=='m'
        if  @element.parent.children[0].content.length ==3
          @element.parent.name+='-drop-cap-1'
        elsif @element.parent.children[0].content.length ==4
          @element.parent.name+='-drop-cap-2'
        elsif @element.parent.children[0].content.length ==5
          @element.parent.name+='-drop-cap-3'
        elsif @element.parent.children[0].content.length ==6
          @element.parent.name+='-drop-cap-4'
          end
      end
     if @TBOTB=='yes' and @element.content=='“'
       @element.parent.name+='-quote'
     end

      @element.remove

    end
  end

  def fm(style)
    if  style=='fm'
      @element.remove
    end
  end

  def it(style)
    if  style=='it'
      @element.name ='it'
       if  @element.parent.next_element!=nil and @element.parent.next_element.name=='para'
           @element.parent.next_element.children.count
           i=0
           add='yes'
           while i!= @element.parent.next_element.children.count do

           if @element.parent.next_element.children[i].name =='char' and   @element.parent.next_element.children[i].attribute('style').value=='it'
             add='no'
           end
             #puts @book

             i+=1
           end
              if add=='yes'
                hr = Nokogiri::XML::Node.new 'hr', @local_doc
                @element.parent.next_element.add_previous_sibling(hr)

              end
       end
    end
  end
  def sc(style)
    if  style=='sc'
      @element.name ='sc'
    end
  end

  def tl(style)
    if style=='tl'
      @element.name ='tl'
    end
  end
  def char_w(style)
    if style=='w'
      @element.name ='w'
    end
  end
  def char_nd(style)
    if style=='nd'
      @element.name ='nd'
    end
  end

  ###########################################

  #####################Table#################
  def tables(name, style)
        tr(name)
        tc1(name,style)
        tc2(name,style)
        tcr3(name,style)
        tc3(name,style)
        tc4(name,style)
  end

  def tc4(name,style)
    if name=='cell' and  style =='tc4'
      if @chapter_number==''
        @element.remove
      else
        @element.remove
    end
    end
  end
  def tc5(name,style)
    if name=='cell' and  style =='tc5'
      if  @chapter_number==''
        @element.remove
      else
        @element.remove
      end
    end
  end

  def tc6(name,style)
    if name=='cell' and  style =='tc6'
      if  @chapter_number==''
        @element.remove
      else
        @element.remove
      end
    end
  end
  def tc7(name,style)
    if name=='cell' and  style =='tc7'
      if  @chapter_number==''
        @element.remove
      else
        @element.remove
      end
    end
  end
  def tc8(name,style)
    if name=='cell' and  style =='tc8'
      if  @chapter_number==''
        @element.remove
      else
        @element.remove
      end
    end
  end

  def tc1(name,style)
    if name=='cell' and  style =='tc1'
      if  @chapter_number==''
        @element.remove
        else
      @element.name='tc1'
      @element.attribute('align').remove
      @element.add_previous_sibling('tabulation')
      new_line_in_table
        end
    end
  end

  def tc2(name,style)
    if name=='cell' and  style =='tc2'
      if  @chapter_number==''
        @element.remove
        else
      @element.name='tc2'
      @element.attribute('align').remove
      @element.add_previous_sibling('tabulationtabulation')
      new_line_in_table
      end
    end
  end


  def tc3(name,style)
    if name=='cell' and  style =='tc3'
      if  @chapter_number==''
        @element.remove
      else
      @element.name='tc3'
      @element.attribute('align').remove
      @element.add_previous_sibling('tabulation')
        end
    end
  end


  def tcr3(name,style)
    if name=='cell' and  style =='tcr3'
      if  @chapter_number==''
        @element.remove
      else
      @element.name='tcr3'
      @element.attribute('align').remove
      if  @element.previous_element!=nil and @element.previous_element.name !='tc3'
        @element.add_previous_sibling('tabulation')

      end
      if @element.previous_element==nil
        @element.parent.name='tr-tcr3'
        else
          @element.add_previous_sibling('tabulation')
      end

        end
    end
  end

  def     tr(name)
    if name=='row'
      if  @chapter_number==''
        @element.remove
      else
      @element.name='tr'

        end
    end
  end

  def new_line_in_table
       if @element.children.last.content.length > 60

         i=60
         while i >0
            if  @element.children.last.content[i]==' '
                 @element.children.last.content = @element.children.last.content[1..i] + "\n tabulationtabulation" +   @element.children.last.content[i+1..-1]
                break
            end
              i-=1
         end
       end
  end

  ###########################################


  ################# Heading ################

  def ms1(name, style)
    if name=='para' and style=='ms1'

      if @TBOTB=='yes'
        @element.remove
      else
        @element.name ='ms1'
      end

    end
    end

  def   ms(name, style)
    if name=='para' and style=='ms'
      @element.name ='ms'
    end
  end

  def       qa(name, style)
    if name=='para' and style=='qa'
      if @TBOTB =='yes'
        @element.remove
        else
        @element.name ='qa'
        end
    end
  end


  def   sp(name, style)
    if name=='para' and style=='sp' and @TBOTB!='yes'
      @element.name ='sp'
    elsif  name=='para' and style=='sp' and  @TBOTB=='yes'
      @element.remove
    end
  end

  def       h(name, style)
    if name=='para' and style=='h'
      @book=@element.content
      @element.remove

    end
  end
  def   d(name, style)
    if name=='para' and style=='d'
      @element.name ='d'
    end
  end
     def   cl(name, style)
       if name=='para' and style=='cl'
         @element.name ='cl'
       end
     end

  def   mr(name, style)
    if name=='para' and style=='mr'
      @element.name ='mr'
    end
  end

  def s1(name, style,heading)

    if name=='para' and style=='s1'
      if heading
        @element.name ='s1'
          else
            @element.remove
        end
    end

  end

  def  s3(name, style,heading)
    if name=='para' and style=='s3'
      if  heading
      @element.name ='s3'
    else
      @element.remove
        end
    end
  end



  def s2(name, style,heading)
    if name=='para' and style=='s2'
      if heading
          @element.name ='s2'
          else
      @element.remove
        end
    end
  end

  def s4(name, style)
    if name=='para' and style=='s4'
      @element.name ='s4'
      hr = Nokogiri::XML::Node.new 'hr', @local_doc
      @element.add_previous_sibling(hr)
    end
  end

  def para_ms2(name, style)
    if name=='para' and style=='ms2' and @TBOTB!='yes'
      @element.name ='ms2'
    elsif  name=='para' and style=='ms2' and  @TBOTB=='yes'
      @element.name ='ms2'
      @element.remove
    end
  end

  def para_r(name, style)
    if name=='para' and style=='r' and @TBOTB!='yes'
      @element.name ='r'
    elsif  name=='para' and style=='r' and  @TBOTB=='yes'
      @element.name ='r'
      @element.remove
    end
  end


  def tbotb(name, style)
    if name=='para' and style=='tbotb' and @TBOTB!='yes'
      @element.remove
    elsif  name=='para' and style=='tbotb' and  @TBOTB=='yes'
      if @element.previous_element.name=='b'
        @element.previous_element.remove
        elsif    @element.previous_element.name=='b-half'
          @element.previous_element.remove
        end


      if @element.content=='veritical_padding_0 next_para_flush'
        @element.name ='b-4'
      elsif @element.content=='veritical_padding_1 next_para_flush'
        @element.name ='b-1'
      elsif @element.content=='veritical_padding_2 next_para_flush'
        @element.name ='b-2'
      elsif @element.content=='veritical_padding_3 next_para_flush'
        @element.name ='b-3'
      else
        @element.remove
      end
      @element.content=''

    end

  end
  ###########################################

  ################ paragraph ################
  def p_style(name, style)
    if name=='para' and paragraph(style)==true
      @element.name = @element.attribute('style').value
      if @TBOTB=='yes'  and @element.previous_element.name=='b-1' || @element.previous_element.name=='b-2'  || @element.previous_element.name=='b-3' || @element.previous_element.name=='b-4'  and @element.name=='p'
        @element.name+='-flush'
      end
          if  @element.name=='nb' and  @TBOTB=='yes'
              @element.previous_element.add_child(' ')
              @element.previous_element.add_child(@element.children)
              @element.remove
          elsif     @element.name=='nb' and  @TBOTB!='yes'
            puts @book
            puts @element
          end

          if    @element.name=='pm'|| @element.name=='pmo'||@element.name=='pmc' ||@element.name=='pmr'
            if @element.previous_element.name!= 'pm'and @element.previous_element.name!= 'pm-first'  and  @element.previous_element.name!= 'pmo'  and  @element.previous_element.name!= 'pmo-first'and @element.previous_element.name!= 'pmr'  and @element.previous_element.name!= 'pmr-first'and @element.previous_element.name!= 'pmc'  and @element.previous_element.name!= 'b'
              #@element.name+='-first'
              top = Nokogiri::XML::Node.new 'b-half', @local_doc
              @element.add_previous_sibling(top)
            end

            if  @element.next_element!=nil and @element.next_element.name=='para' and @element.next_element.attribute('style').value !='pm' and @element.next_element.attribute('style').value !='pmr'  and @element.next_element.attribute('style').value !='pmo' and @element.next_element.attribute('style').value !='pmc' and @element.next_element.attribute('style').value !='b'   #s1 deleted 1kings
              bot = Nokogiri::XML::Node.new 'b-half', @local_doc
              @element.add_next_sibling(bot)
            end

          end

          if  @element.name=='pc'
            if @element.previous_element.name!= 'pc'
              top = Nokogiri::XML::Node.new 'b-half', @local_doc
              @element.add_previous_sibling(top)
            end

            if  @element.next_element!=nil and @element.next_element.name=='para' and @element.next_element.attribute('style').value !='pc'
              bot = Nokogiri::XML::Node.new 'b-half', @local_doc
              @element.add_next_sibling(bot)
            end
          end
      if @element.name == 'li' and @book_number.to_i ==2 ||  @book_number.to_i ==5
         @element.name+='-ot'
      end

    elsif  name=='para'  and stanza(style)==true
      @element.name = @element.attribute('style').value

      check_verse
      check_first(style)
      check_last(style)
    if @element.name=='li1' || @element.name=='li2'|| @element.name=='li3'|| @element.name=='li4' and @book_number.to_i <40   ||  @book_number.to_i==66
      @element.name+='-ot'
    end

    end
  end

  def stanza(style)
    intro_style = %w[li1 li2 q1 q2 q3 q4 qc li3 li4 qm2 qm1 qr]
    intro_style.each { |a|
      if style== a
        return true
      end
    }
  end

  def paragraph(style)
    intro_style = %w[p m pi1 pi2 nb pm pmo pmc mi pc pi li pi3 pmr ]
    intro_style.each { |a|
      if style== a
        return true
      end
    }
  end

  def para_b(name, style)
    if name=='para' and style=='b'
      @element.name ='b'
    end
  end

  def check_first(style)
    if style == 'q1' || style == 'q2' || style == 'q3' || style == 'q4' || style == 'qm1'|| style == 'qm1'|| style == 'qc'|| style == 'qr' || style == 'qs'


      if    @element.previous_element.attribute('style')!=nil and  @element.previous_element.attribute('style').value !='q1' and
          @element.previous_element.attribute('style').value !='q2' and
          @element.previous_element.attribute('style').value !='q3' and
          @element.previous_element.attribute('style').value !='q4' and
          @element.previous_element.attribute('style').value !='qm1' and
          @element.previous_element.attribute('style').value !='qm2' and
          @element.previous_element.attribute('style').value !='qc' and
          @element.previous_element.attribute('style').value !='qr' and
          @element.previous_element.attribute('style').value !='qs' and
          @element.previous_element.attribute('style').value !='tbotb' and
          @element.previous_element.attribute('style').value !='b'

        top = Nokogiri::XML::Node.new 'b-half', @local_doc
        @element.add_previous_sibling(top)
      end
    end
  end

  def check_last(style)
    if style == 'q1' || style == 'q2' || style == 'q3' || style == 'q4'|| style == 'qm1'|| style == 'qm2' || style == 'qc'   || style == 'qr'   || style == 'qs'
      if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and  @element.next_element.attribute('style').value !='q1' and
          @element.next_element.attribute('style').value !='q2' and
          @element.next_element.attribute('style').value !='q3' and
          @element.next_element.attribute('style').value !='q4' and
          @element.next_element.attribute('style').value !='qm1' and
          @element.next_element.attribute('style').value !='qm2' and
          @element.next_element.attribute('style').value !='qc' and
          @element.next_element.attribute('style').value !='qs' and
          @element.next_element.attribute('style').value !='qr' and
          @element.next_element.attribute('style').value !='b'

        if @TBOTB=='yes'
          bot = Nokogiri::XML::Node.new 'b-half', @local_doc
          @element.next_element.add_previous_sibling(bot)
        elsif  @element.next_element.attribute('style').value !='s1' and
               @element.next_element.attribute('style').value !='s2'

          bot = Nokogiri::XML::Node.new 'b-half', @local_doc
          @element.next_element.add_previous_sibling(bot)
        end
      end
    end
  end

  def check_verse

    if @element.children[0].name == 'verse'

      verse_number = @element.children[0].attribute('number').value
      if  @element.children[1].name=='char' and   @element.children[1].attribute('style').value=='bd'
      else

        if @element.previous_element!=nil and @element.previous_element.name.include?("q1-drop-cap-")

        else

      @element.children[0].add_next_sibling('tabulation')
      @element.children[0].add_previous_sibling('tabulation')
          end
      end
      if  verse_number=='1' and @TBOTB!='yes'
        @element.name+= '-flush'
      end
    else
      if @element.previous_element==nil
        puts  @element
      end
      if @element.previous_element.name.include?("q1-drop-cap-")
      elsif @element.children[0].name=='note'  and @element.children[1].name =='text' and @element.children[1].content==' '  and   @element.children[2].name=='verse'
        @element.children[1].remove
        @element.children[1].add_next_sibling('tabulation')
        @element.children[1].add_previous_sibling('tabulation')

      else

      @element.children[0].add_previous_sibling('tabulationtabulation')
        end
    end

  end


  ###########################################

  ################# VERSE ###################
  def verse(name)
    if name == 'verse' and @TBOTB!='yes'
      @element.name= 'ver'
      style = @element.parent.name
      if stanza(style) ==true   and @element.parent.children.first.content =='tabulation' and @element.parent.children[1]== @element
        @element.content =  @element.attribute('number').value
      else
        @element.content =  @element.attribute('number').value+' '
      end

      if  @element.attribute('number').value =='1'
        if @element.parent.attribute('style')!=nil and @element.parent.attribute('style').value =='nb'
        else
          @element.name+= '-hidden'
        end
      end
      if @element.attribute('pubnumber')!=nil
        @element.content = @element.attribute('pubnumber').value
        @element.attribute('pubnumber').remove
      end

      if @element.attribute('number').value=='1'
        chp = Nokogiri::XML::Node.new 'chap', @local_doc
        kern = Nokogiri::XML::Node.new 'chap-kern', @local_doc
        if   @chapter_number.length  ==1
          @element.add_previous_sibling(kern)
          kern.content= @chapter_number
        elsif    @chapter_number.length  ==2
          chp.content= @chapter_number[0]
          kern.content= @chapter_number[1]
          @element.add_previous_sibling(chp)
          @element.add_previous_sibling(kern)
        elsif       @chapter_number.length  ==3
          chp.content= @chapter_number[0..1]
          kern.content= @chapter_number[-1]
          @element.add_previous_sibling(chp)
          @element.add_previous_sibling(kern)

        end


        #@element.add_previous_sibling(chp)
        #@element.add_previous_sibling(kern)
        if     @chapter_number.length==1
          @element.parent.name+='-chap-1'
        elsif  @chapter_number.length==2
          @element.parent.name+='-chap-2'
        else
          @element.parent.name+='-chap-3'
        end
      end

      bcv = Nokogiri::XML::Node.new 'bcv', @local_doc
      bcv.content=@chapter_number+':'+@element.attribute('number').value
      @element.add_previous_sibling(bcv)
      @element.attribute('number').remove
      @element.attribute('style').remove


    elsif   name == 'verse'
      bcv = Nokogiri::XML::Node.new 'bcv', @local_doc
      bcv.content=@chapter_number+':'+@element.attribute('number').value
      @element.add_previous_sibling(bcv)
      @element.remove
    end
  end

  ###########################################

  def save_chap_number(name)
    if name=='chapter'
      @chapter_number = @element.attribute('number').value
      @element.remove
    end
  end


  def delete_intro(name, style)
    if name=='para' and intro(style)==true
      @element.remove
      #@element.name = @element.attribute('style').value
      #@element.attribute('style').remove
    end
  end


  def intro(style)
    intro_style = %w[im ip ili1 ie imte1 imt2 imt1 rem ide is1 iot io1 io2 is2 ib imq iq1 io1 io2 io3 ib imi iot sr]
    intro_style.each { |a|
      if style== a
        return true
      end
    }
  end


  def temp_delete(name, style)
    if name=='book'|| name=='para' and temp_delete_elements(style)==true
      if style =='mt1'

        if @book_number.to_i==10 || @book_number.to_i==11|| @book_number.to_i==12 and @TBOTB=='yes'
          @element.name='book-title-hidden'
        else
          @element.name='book-title'
        end

        #@book=@element.content
        book = Nokogiri::XML::Node.new 'book', @local_doc
        @element.content='| '
        book.content =  @book

        @element.add_child(book)
        @element.add_child(' |')
      else
        @element.remove
      end
    end
  end

  def temp_delete_elements(style)
    del_temp = %w[id toc1 toc2 toc3 mt1 mt2 rem ide]
    del_temp.each { |a|
      if style== a
        return true
      end
    }
  end

  def note(name)
    if name=='note'
      @element.remove
    end
  end


  def save_as

    @ind.xpath('//@style').remove
    @ind.root.name ='body'
    @ind.root.attribute('version').remove
    @ind.xpath('//@closed').remove
    @ind.xpath('//@caller').remove
    @ind.search('//text()').each { |attr_value|
    #if attr_value.previous!= nil
    #  if  attr_value.previous.content=="\n"
    #    attr_value.remove
    #  end
    #
    #end
      if  attr_value.content !~ /\S/
        if  attr_value.content !=' '
          attr_value.remove
        end
      else
      end
    }

    replace = @ind.to_s.gsub(/<([^<\/]*)>\n/, '<\1>')
    replace = replace.gsub("</wj>\n", '</wj>')
    replace = replace.gsub("</ver-first>\n", '</ver-first>')
    replace = replace.gsub("</chap-number>\n", '</chap-number>')
    replace = replace.gsub("</ver-hidden>\n", '</ver-hidden>')
    replace = replace.gsub('<b-half/>', "<b-half></b-half>")
    replace = replace.gsub("</ver>\n", '</ver>')
    replace = replace.gsub('    <', '<')
    replace = replace.gsub('  <', '<')
    replace = replace.gsub('?><', "?>\n<")
    replace = replace.gsub('<b/>', '<b></b>')
    replace = replace.gsub('<b-1/>', "<b-1>1</b-1>")
    replace = replace.gsub('<b-2/>', "<b-2>2</b-2>")
    replace = replace.gsub('<b-3/>', "<b-3>3</b-3>")
    replace = replace.gsub('<b-4/>', "<b-4>4</b-4>")
    replace = replace.gsub('<hr/>', '<hr></hr>')
    replace = replace.gsub('<table>', '')
    replace = replace.gsub("</table>\n", '')
    replace = replace.gsub("<table/>\n", '')
    replace = replace.gsub("</chap-kern>\n", '</chap-kern>')
    replace = replace.gsub("</tc1>\n", '</tc1>')
    replace = replace.gsub("<tc3/>", '<tc3></tc3>')
    replace = replace.gsub("</tc2>\n", '</tc2>')
    replace = replace.gsub("</tcr3>\n", '</tcr3>')
    replace = replace.gsub("</bcv>\n", '</bcv>')
    replace = replace.gsub("</cell>\n", '</cell>')
    #replace = replace.gsub("<book-title>", "\n<book-title>")
    replace = replace.gsub('<book-title-hidden>', "\n<book-title-hidden>")
    replace = replace.gsub('ʼ', '’')
    replace = replace.gsub("</it>\n", '</it>')
    replace = replace.gsub('tabulation', '	')
    @ind_content =  replace

    save_ind


  end

end