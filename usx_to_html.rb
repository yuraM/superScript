module UsxToHtml
 def create_html
   arr= ['TBOTB','Standard', 'hybrid']
   a=0
   while a <3
     @format = arr[a]
     parse

     save_html
     a+=1
   end
 end
 def parse
   if @format == 'Standard'
     @css=  'standard-style.css'
   elsif @format == 'hybrid'
     @css=  'tbotb-style.css'
   elsif @format == 'TBOTB'
     @css=  'tbotb-style.css'
   end
   @html_local_doc = Nokogiri::HTML("<html><body><h1>test</h1></body></html>")
   @html=  Nokogiri::XML(@usx_with_bcv)
   element = @html.xpath('//usx/descendant::*')
   @element_count = @html.xpath('//usx/descendant::*').count
   @line ='no'
   @element_index = 0

   @chapter_count = @doc.xpath('//chapter').count
   while @element_index < @element_count do
     @element = element[@element_index]
     @name = @element.name
     if    @element.attribute('style')!=nil
       @style = @element.attribute('style').value
     else
       @style=''
     end
     #=======================================
     html_delete_intro
     html_chapter
     html_para_s1
     html_para_s2
     html_para_s3
     html_add_chapter_number
     html_p_style
     html_verse
     html_note
     html_para_b
     html_wj
     html_tl
     html_fm
     html_em
     html_sc
     html_tbotb
     html_ms1
     html_ms2
     html_mt1
     html_mt2
     html_bd
     html_qt
     html_footnote_styles
     html_it
     html_s4
     html_w
     html_nb
     html_k
     html_bk
     html_mt
     html_xt
     html_ior
     html_xo
     #=======================================


     if @element.name == 'para' || @element.name == 'char' and  @element.attribute('style')!=nil  and  @element.attribute('style').value !='fm'   and  @element.attribute('style').value !='fv'  and  @element.attribute('style').value !='ide'
       puts "html #{@format}"
       puts @element
       puts @full_book_name
       puts @chapter_number
     end
     @element_index+=1

   end
   @html.xpath('//@style').remove
   @html.xpath('//remove').remove
   @html.search('//text()').each { |attr_value|
     if  attr_value.content !~ /\S/
       if attr_value.content!= ' '

         attr_value.remove
       end
     else
       if  attr_value.content.include? " "
         #attr_value.content = attr_value.content.gsub!(' ', ' ')
       end
     end
   }
 end



 def   html_ms1
   if @name =='para' and @style=='ms1'
   @element.name = 'p'
   @element.set_attribute('class', "ms1")
   @element.attribute('style').remove
 end
 end

 def  html_ms2
   if @name =='para' and @style=='ms2'
     @element.name = 'p'
     @element.set_attribute('class', "ms2")
     @element.attribute('style').remove
end
 end

 def html_xt
   if @name =='char' and @style=='xt'
     @element.name = 'span'
     @element.set_attribute('class', "xt")
     @element.attribute('style').remove
   end
 end


 def html_bk
   if @name =='char' and @style=='bk'
     @element.name = 'span'
     @element.set_attribute('class', "k")
     @element.attribute('style').remove
   end
 end

def  html_w
  if @name =='char' and @style=='w'
    @element.name = 'span'
    @element.set_attribute('class', "w")
    @element.attribute('style').remove
  end
end

 def html_k
   if @name =='char' and @style=='k'
     @element.name = 'span'
     @element.set_attribute('class', "k")
     @element.attribute('style').remove
   end
 end

 def html_nb
   if @name == 'para' and @style=='nb'

     nb = Nokogiri::XML::Node.new 'div', @local_doc
     nb.set_attribute('class', "nb-wrapper")
     if @format !='TBOTB'
       nb.add_child(@element.previous_element.previous_element.previous_element) #p
       nb.add_child(@element.previous_element.previous_element) # chap
       nb.add_child(@element.previous_element) #chap
       if  @element.previous_element.name=='div' and @element.previous_element.attribute('class').value[0..4]=='tbotb'
         nb.attribute('class').value+=" tbotb-flush"
       end

     else
       #puts @full_book_name
       #puts @element.previous_element.previous_element
       nb.add_child(@element.previous_element.previous_element.previous_element)
       nb.add_child(@element.previous_element.previous_element) # p
       nb.add_child(@element.previous_element) # chap
       if  @element.previous_element.name=='div' and @element.previous_element.attribute('class').value[0..4]=='tbotb'
         nb.attribute('class').value+=" tbotb-flush"
       end
     end
     @element.add_previous_sibling(nb)
     nb.add_child(@element)
     @element.name= 'p'
     @element.set_attribute('class','p nb')

     if @style=='nb'
       it=0
       set=''
       while it <  @element.children.count
         if @element.children[it].name =='char' and @element.children[it].attribute('style')!=nil and @element.children[it].attribute('style').value =='it'
           @element.children[it].add_previous_sibling(@element.children[it].children)
           @element.children[it+1].remove
           if set==''
             @element.attribute('class').value +=" it"
             @element.parent.attribute('class').value+=' flush'
             set='yes'
           end
         end
         it+=1
       end


     end

   end

 end

 def html_s4
   if @name =='para' and @style=='s4'

     line = Nokogiri::XML::Node.new 'div', @local_doc
     line.set_attribute('class', "hr")
     @element.add_previous_sibling(line)
     @element.name ='p'
     @element.set_attribute('class', "s4")
     @element.attribute('style').remove
     @line='yes'
   end
 end
     def  html_xo
       if @name =='char' and @style=='xo'

         @element.name ='span'
         @element.set_attribute('class', "xo")
         @element.attribute('style').remove
       end
     end
 def html_ior
   if @name =='char' and @style=='ior'

     @element.name ='span'
     @element.set_attribute('class', "ior")
     @element.attribute('style').remove
   end
 end
 def html_it
   if @name =='char' and @style=='it'

     @element.name ='span'
     @element.set_attribute('class', "it")
     @element.attribute('style').remove
   end
 end

 def html_footnote_styles
   if @style=='fr'|| @style=='ft'|| @style=='fqa' || @style=='fq' || @style=='nd' || @style=='fl'   || @style=='fp'


     @element.name = 'span'
     @element.set_attribute('class', @style)
     if @element.attribute('closed')!=nil
       @element.attribute('closed').remove
     end

     if @element.attribute('style')!= nil
       @element.attribute('style').remove
     end
   end
 end

 def html_qt
   if @name =='char' and @style=='qt'
     if   @format!='Standard'
       @element.name = 'span'
       @element.set_attribute('class', "qt")
     else
       @element.attribute('style').remove
       @element.remove
     end
   end
 end

 def html_bd
   if @name =='char' and @style=='bd'
     if @format=='TBOTB' ||  @format=='hybrid'
       @element.name = 'span'
       @element.set_attribute('class', "drop-cap")
       @element.attribute('style').remove
     elsif @format=='Standard'
       @element.next= @element.content
       @element.attribute('style').remove
       @element.remove
     end
   end
 end

 def html_tbotb
   if @name=="para" and @style=='tbotb'
     if @format=='TBOTB' ||  @format=='hybrid'
       if @element.content == 'veritical_padding_0 next_para_flush'
         @element.name='div'
         @element.set_attribute('class', "tbotb-top-0")
         @element.content=''
         @element.attribute('style').remove
       elsif   @element.content == 'veritical_padding_1 next_para_flush'
         @element.name='div'
         @element.set_attribute('class', "tbotb-top-1")
         @element.content=''
         @element.attribute('style').remove
       elsif   @element.content == 'veritical_padding_2 next_para_flush'
         @element.name='div'
         @element.set_attribute('class', "tbotb-top-2")
         @element.content=''
         @element.attribute('style').remove
       elsif   @element.content == 'veritical_padding_3 next_para_flush'
         @element.name='div'
         @element.set_attribute('class', "tbotb-top-3")
         @element.content=''
         @element.attribute('style').remove
       else
         @element.name='div'
         @element.set_attribute('class', "tbotb")
         @element.attribute('style').remove
       end
       @element.next_element.set_attribute('tbotb', "flush")
     elsif @format=='Standard'
       @element.attribute('style').remove
       @element.remove

     end
   end
 end


 def html_sc
   if @name =='char' and @style=='sc'
     @element.name ='span'
     @element.set_attribute('class', "sc")
     @element.attribute('style').remove
   end
 end


 def   html_fm
   if @name =='char' and @style=='fm'
     @element.add_next_sibling(@element.children)
     @element.remove
   end
 end

 def  html_tl
   if @name =='char' and @style=='tl'
     @element.name ='span'
     @element.set_attribute('class', "tl")
     @element.attribute('style').remove
   end
 end

 def html_em
   if @name =='char' and @style=='em'
     @element.name ='span'
     @element.set_attribute('class', "em")
     @element.attribute('style').remove
   end
 end

 def html_wj
   if @name =='char' and @style=='wj'
     @element.name ='span'
     @element.set_attribute('class', "wj")
     @element.attribute('style').remove
   end
 end

 def html_para_b
   if @name == 'para'  and @style== 'b'
     @element.name = 'div'
     @element.set_attribute('class', "b")
     @element.attribute('style').remove
   end
 end


 def html_note
   if @name == 'note'
     if @format =="TBOTB"
       @element.remove
     else

       @element.name = 'span'
       @element.set_attribute('class', "note")
       note_icon = Nokogiri::XML::Node.new 'span', @local_doc
       note_icon.set_attribute('class', "note-icon")
       f = Nokogiri::XML::Node.new 'span', @local_doc
       f.set_attribute('class', "f")
       f.add_child(@element.children)
       @element.add_child(f)
       f.add_previous_sibling(note_icon)
       @element.attribute('caller').remove
       @element.attribute('style').remove
       note_children = @element.children[1].children

       i=0
       while i< note_children.count

         if  note_children[i].attribute('style')!=nil and note_children[i].attribute('style').value=='fr'  ||note_children[i].attribute('style').value=='ft'  ||note_children[i].attribute('style').value=='fqa'  ||note_children[i].attribute('style').value=='fq' ||note_children[i].attribute('style').value=='nd'  ||note_children[i].attribute('style').value=='tl' ||note_children[i].attribute('style').value=='fv' ||note_children[i].attribute('style').value=='xo'  ||note_children[i].attribute('style').value=='xt'    ||note_children[i].attribute('style').value=='fl'  ||note_children[i].attribute('style').value=='fp'
           note_children[i].name = 'span'
           note_children[i].set_attribute('class', note_children[i].attribute('style').value)
           if  note_children[i].attribute('closed')!=nil
             note_children[i].attribute('closed').remove
           end
           note_children[i].attribute('style').remove
         elsif    note_children[i].attribute('class')!=nil and note_children[i].attribute('class').value=='f' || note_children[i].attribute('class').value=='note-icon'
         elsif note_children[i].name=='text' and   note_children[i].content==' '   || note_children[i].content=='  '    || note_children[i].content==' '
                    note_children[i-1].content = note_children[i-1].content+' '
                    note_children[i].content=''
         else
           puts  note_children[i].content
           puts   "new element"
           puts @element
         end
         i+=1
       end

     end
   end
 end


 def html_verse
   if @name == 'verse'
     if @format=='Standard' || @format =='hybrid'
       @element.name= 'span'
       @element.set_attribute('class', "ver")
       @element.content =  @element.attribute('number').value
       if  @element.parent.children[0]  == @element
         if @element.parent.attribute('style')!=nil and @element.parent.attribute('style').value =='nb'
         elsif @element.parent.attribute('style')!=nil and @element.parent.attribute('style').value =='li1'||
             @element.parent.attribute('style').value =='li2'||
             @element.parent.attribute('style').value =='q1'||
             @element.parent.attribute('style').value =='q2'||
             @element.parent.attribute('style').value =='q3'||
             @element.parent.attribute('style').value =='q4'||
             @element.parent.attribute('style').value =='qc'
           @element.attribute('class').value += " first"
         end
       end
       if  @element.attribute('number').value =='1'  and @chapter_count!=1
         if @element.parent.attribute('style')!=nil and @element.parent.attribute('style').value =='nb'
         else
           @element.attribute('class').value+= " hidden"
         end
       end
       if @element.attribute('pubnumber')!=nil
         @element.content = @element.attribute('pubnumber').value
         @element.attribute('pubnumber').remove
       end
       @element.attribute('number').remove
       @element.attribute('style').remove
     else
       @element.name= 'span'
       @element.set_attribute('class', "ver")
       @element.content =  @element.attribute('number').value
       @element.remove
     end
   end
 end

 def html_check_first
   if @style == 'q1' || @style == 'q2' || @style == 'q3' || @style == 'q4'|| @style == 'qc'  || @style == 'pc'


     if    @element.previous_element.attribute('style')!=nil and  @element.previous_element.attribute('style').value !='q1' and
         @element.previous_element.attribute('style').value !='q2' and
         @element.previous_element.attribute('style').value !='q3' and
         @element.previous_element.attribute('style').value !='q4' and
         @element.previous_element.attribute('style').value !='qc' and
         @element.previous_element.attribute('style').value !='pc' and
         @element.previous_element.attribute('style').value !='b'
       @element.attribute('class').value +=" top-half"
     end
   end
 end

 def html_check_last
   if @style == 'q1' || @style == 'q2' || @style == 'q3' || @style == 'q4' || @style == 'qc'  || @style == 'pc'
     if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and  @element.next_element.attribute('style').value !='q1' and
         @element.next_element.attribute('style').value !='q2' and
         @element.next_element.attribute('style').value !='q3' and
         @element.next_element.attribute('style').value !='q4' and
         @element.next_element.attribute('style').value !='qc' and
         @element.next_element.attribute('style').value !='pc' and
         @element.next_element.attribute('style').value !='b'
       @element.attribute('class').value +=" bottom-half"

     end
   end
 end

 def html_check_verse
    if @element.children[0]==nil
      puts @full_book_name
        puts @element
    end
   if @element.children[0].name == 'verse' and  @element.attribute('class').value=='q1'|| @element.attribute('class').value=='q2'|| @element.attribute('class').value=='q3'|| @element.attribute('class').value=='q4'|| @element.attribute('class').value=='qc'|| @element.attribute('class').value=='li1'|| @element.attribute('class').value=='li2'
     if @format=='Standard'  ||      @format =='hybrid'
       verse_number = @element.children[0].attribute('number').value
       if verse_number.length == 1

         @element.attribute('class').value =  @element.attribute('class').value+ " ver-1"
       elsif  verse_number.length == 2
         @element.attribute('class').value =  @element.attribute('class').value+ " ver-1"
       else
         @element.attribute('class').value =  @element.attribute('class').value+ " ver-2"
       end


     else
       #dont add
     end
   end
   if @element.children[0].name == 'verse'
     verse_number = @element.children[0].attribute('number').value
     if  verse_number=='1'  and @chapter_count!=1
       @element.attribute('class').value += ' flush'
     end
   end
 end


 def   html_p_style
   if @name == 'para' and @style == 'p' || @style == 'li1'  || @style == 'li2'|| @style == 'li3'|| @style == 'li4' || @style == 'qm1'|| @style == 'qm2'|| @style == 'q1'|| @style == 'q2' || @style == 'q3' || @style == 'q4'|| @style == 'qc' || @style == 'm'   || @style == 'pmo'   || @style == 'pm' || @style == 'pmc' || @style == 'pi2'|| @style == 'pi1' || @style == 'mi' || @style == 'pc' || @style == 'li'|| @style == 'pi'|| @style == 'pi3'  || @style == 'pmr'|| @style == 'cl'|| @style == 'd' || @style == 'qr'|| @style == 'qa'|| @style == 'ms'|| @style == 'mr'|| @style == 'sp' || @style == 'r'|| @style == 'sr'|| @style == 'qs'
     @element.name ='p'
     @element.set_attribute('class', @style)
     html_check_verse
     html_check_first
     html_check_last
     if @style=='p'
       it=0
       set=''
       while it <  @element.children.count
         if @element.children[it].name =='char' and @element.children[it].attribute('style')!=nil and @element.children[it].attribute('style').value =='it'
           @element.children[it].add_previous_sibling(@element.children[it].children)
           @element.children[it+1].remove
           if set==''
             @element.attribute('class').value +=" it"
             set='yes'
           end
         end
         it+=1
       end

     end
     if @style=='pm' || @style=='pmo' || @style=='pmc' #and  @element.previous_element.name=='p' #and  @element.previous_element.attribute('style')!= nil  and    @element.previous_element.attribute('style').value == 'p'

       if  @element.previous_element.attribute('style')!=nil and  @element.previous_element.attribute('style').value !='pm' and
           @element.previous_element.attribute('style').value !='pmo' and
           @element.previous_element.attribute('style').value !='pmc' and
           @element.previous_element.attribute('style').value !='s1' and
           @element.previous_element.attribute('style').value !='s2' and
           @element.previous_element.attribute('style').value !='b'
         @element.attribute('class').value +=" top-1"
       end
       if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and  @element.next_element.attribute('style').value !='pm' and
           @element.next_element.attribute('style').value !='pmo' and
           @element.next_element.attribute('style').value !='pmc' and
           @element.next_element.attribute('style').value !='s1' and
           @element.next_element.attribute('style').value !='s2' and
           @element.next_element.attribute('style').value !='b'
         @element.attribute('class').value +=" bottom-1"
       end
       if @element.previous_element.name=='div' and  @element.previous_element.attribute('class')!=nil and  @element.previous_element.attribute('class').value!='b'
         @element.attribute('class').value +=" top-1"
       end
       if @element.next_element!=nil and  @element.next_element.name=='div' and @element.next_element.attribute('class')!=nil    and @element.next_element.attribute('class').value!='b'
         @element.attribute('class').value +=" bottom-1"
       end

     end

     if @element.attribute('tbotb')!=nil
       @element.attribute('class').value +=" tbotb-flush"
       @element.attribute('tbotb').remove
     end
   end
 end


 def html_add_chapter_number
   if @name =="para"
     if @element.children[0] != nil and @element.children[0].name=='verse' and @element.children[0].attribute('number').value =='1' and @chapter_count!=1
       # MAYBE NEED COUNT +1
       chp = Nokogiri::XML::Node.new 'div', @local_doc
       chp.set_attribute('class', "chap-number")
       chp.content =@chapter_number
       @element.add_previous_sibling(chp)
     end
   end
 end


 def   html_para_s3
   if @name =='para' and @style=='s3'
     @element.name ='p'
     @element.set_attribute('class', "s3")
     @element.attribute('style').remove
   end
 end


 def html_para_s2
   if @style =='s2'
     if   @format =='Standard' || @format =='hybrid'
       @element.set_attribute('class', @style)
       @element.attribute('style').remove
       @element.name = 'p'
       if  @line=='yes'
         line = Nokogiri::XML::Node.new 'div', @local_doc
         line.set_attribute('class', "hr")
         @element.add_previous_sibling(line)
         @line='no'
       end
     else
       if  @line=='yes'
         line = Nokogiri::XML::Node.new 'div', @local_doc
         line.set_attribute('class', "hr")
         @element.add_previous_sibling(line)
         @line='no'
       end
       @element.attribute('style').remove
       @element.remove
     end
   end
 end


 def html_para_s1
   if @style =='s1'
     if   @format =='Standard' || @format =='hybrid'
       @element.set_attribute('class', @style)
       @element.attribute('style').remove
       @element.name = 'p'
       if  @line=='yes'
         line = Nokogiri::XML::Node.new 'div', @local_doc
         line.set_attribute('class', "hr")
         @element.add_previous_sibling(line)
         @line='no'
       end
     else
       if  @line=='yes'
         line = Nokogiri::XML::Node.new 'div', @local_doc
         line.set_attribute('class', "hr")
         @element.add_previous_sibling(line)
         @line='no'
       end
       @element.attribute('style').remove
       @element.remove
     end
   end
 end


 def html_chapter
   if @name == 'chapter'  and @chapter_count !=1
     @chapter_number = @element.attribute('number').value
     @element.set_attribute('class', "chap")
     @element.name = 'div'
     @element.set_attribute('id', "chap-#{@chapter_number}")
     @element.attribute('number').remove
     #@element.attribute('style').remove
   elsif  @name == 'chapter'  and @chapter_count ==1
     @element.name ='remove'
   end
 end


 def html_delete_intro
   if @element.name != 'table' and  @style =='im' || @style =='ip'  || @style =='imte1' || @style =='imt2'   || @style =='imt1' || @style =='io1' || @style =='io2'|| @style =='io3' || @style =='imq'    || @style =='iq1'  || @style =='iq2'|| @style =='imi' || @style =='ib' || @style =='ili1'|| @style =='iot' || @style =='iex'|| @style =='iq'  || @style =='erqe'|| @style =='erq'|| @style =='is'  || @style =='ili'

     if @format!='Standard'
       if @style=='imt1'
         line = Nokogiri::XML::Node.new 'div', @local_doc
         line.set_attribute('class', "hr-full")
         @element.add_next_sibling(line)
       end
       @element.name='p'
       @element.set_attribute('class', @style)
       if @style == 'ili1'
         if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and  @element.next_element.attribute('style').value !='ili1'
           @element.attribute('class').value +=" bottom-half"
         end
         if  @element.previous_element.attribute('style')!=nil and  @element.previous_element.attribute('style').value !='ili1'
           @element.attribute('class').value +=" top-half"
         end
       end

       if  @style == 'iq1'  || @style =='iq2' || @style == 'imq'
         if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and
             @element.next_element.attribute('style').value !='imq'and
             @element.next_element.attribute('style').value !='iq1'
           @element.next_element.attribute('style').value !='iq2'
           @element.attribute('class').value +=" bottom-half"
         end
         if  @element.previous_element.attribute('style')!=nil and
             @element.previous_element.attribute('style').value!='imq' and
             @element.previous_element.attribute('style').value!="iq1"
           @element.previous_element.attribute('style').value!="iq2"
           @element.attribute('class').value +=" top-half"
         end
       end

       if  @style == 'imi'
         if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and
             @element.next_element.attribute('style').value !='imi'
           @element.attribute('class').value +=" bottom-half"
         end
         if  @element.previous_element.attribute('style')!=nil and
             @element.previous_element.attribute('style').value!='imi'
           @element.attribute('class').value +=" top-half"
         end
       end

       if  @style == 'io1'  || @style == 'io2'  || @style == 'io3'
         if  @element.next_element!=nil and @element.next_element.attribute('style')!=nil and
             @element.next_element.attribute('style').value !='io1'and
             @element.next_element.attribute('style').value !='io2'and
             @element.next_element.attribute('style').value !='io3'
           @element.attribute('class').value +=" bottom-half"
         end
         if  @element.previous_element.attribute('style')!=nil and
             @element.previous_element.attribute('style').value!='io1' and
             @element.previous_element.attribute('style').value!='io3' and
             @element.previous_element.attribute('style').value!="io2"
           @element.attribute('class').value +=" top-half"
         end
       end
     else

       @element.attribute('style').remove
       @element.remove
     end

   end
   if   @element.name != 'table' and   @style =='rem' || @style =='toc1'|| @style =='toc2'|| @style =='toc3' ||  @style =='h' || @style =='id' || @style =='ie'
     @element.attribute('style').remove
     @element.remove

   end
 end


 def html_mt1
   if @name == 'para' and @style=='mt1'
     @full_book_name =   @element.content
     @element.remove
     @element.attribute('style').remove
   end
 end
 def html_mt2
   if @name == 'para' and @style=='mt2'
     @full_book_name =   @element.content
     @element.remove
     @element.attribute('style').remove
   end
 end


 def html_mt
    if @name == 'para' and @style=='mt'
      @element.name = 'p'
      @element.set_attribute('class', @element.attribute('style').value)
      @element.attribute('style').remove
    end
  end




end