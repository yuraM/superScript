require './script'

module New_ind
  HEARER_STYLES = %w[s1 s2 ms1 s3 qa qs r] # qa dont show in jast bible,  qs r delete in psalms
  PSALMS = %w[cl d ms mr sp s4]
  INTRO_STYLES = %w[im ip ili1 ie imte1 imt2 imt1 is1 iot is2 ib imq iq1 iq2 io1 io2 io3 ib imi iot iq is iex erq ili mt1]
  TEMP_DELETE = %w[sr id toc1 toc2 toc3 mt2 rem ide h erqe]
  PARAGRAPH =  %w[p m pi1 pi2 nb pm pmo pmc mi pc pi pi3 pmr]
  PMO=  %w[pm pmo pmc pmr]
  TABULATION =  %w[li1 li2 q1 q2 q3 q4 qc li3 li4 qm2 qm1 qr li ]
  STANZA =  %w[q1 q2 q3 q4 qc qm2 qm1 qr]
  CHAR =  %w[nd w fm fv ft fq fqa tl sc wj xt it fl fp em bk k ior]
  CELL =  %w[tc1 tc2 tcr3 tc3 ]
  BREAK = %w[b b-half]
  ADD_OT =   %w[li1 li2 li3 li4]
  VERTICAL=  %w[b-1 b-2 b-3 b-4]
  NOTE=%w[f ef]
  def get_design(heading,show_verse,extra_vertical,delete_intro)
    @local_doc = Nokogiri::HTML('<html><body><h1>test</h1></body></html>')
    @ind = @doc
    show_new_tags
    add_blocks
    vertical
    headers(heading)
    psalms
    introduction(delete_intro)
    delete_temp_elements
    char

    book
    paragraph
    stanza
    table_ind
    tr
    if @book_number.to_i ==2
      add_exo
    end
    verse
    bd
    note

    ##########
    remove_elements(show_verse)
    replace
    save_ind
   ###########


  end


  def show_new_tags
    @ind.xpath("//@style").each { |element|
      if    !(@new_tags.include?(element.value))
        #puts 'new element ' + element
        @new_tags.push(element.value)
      end
    }
  end

  ##########################################ZTANZA###############################################
  def stanza
    TABULATION.each { |stanza_style|
      @ind.xpath("//para[@style='#{stanza_style}']").each { |element|
        if     STANZA.include?(element.attribute('style').value)
          if element.previous_element.attribute('style')!=nil and  !(STANZA.include?(element.previous_element.attribute('style').value))  and  !(BREAK.include?(element.previous_element.attribute('style').value))   and  element.previous_element.attribute('style').value!='tbotb'
            top = Nokogiri::XML::Node.new 'b-half', @local_doc
            element.add_previous_sibling(top.to_xml+ "\n")
          elsif element.next_element!=nil and element.next_element.attribute('style')!=nil and  !(STANZA.include?(element.next_element.attribute('style').value))  and  !(BREAK.include?(element.next_element.attribute('style').value)) and  !(HEARER_STYLES.include?(element.next_element.attribute('style').value))   and  element.next_element.attribute('style').value!='tbotb'
            top = Nokogiri::XML::Node.new 'b-half', @local_doc
            element.next_element.add_previous_sibling(top.to_xml+ "\n")
          end
        end
        element.name=stanza_style
        if element.children[0].name == 'verse'
          element.children[0].add_next_sibling('tabulation')
          if   element.children[0].attribute('number').value !='1'
          element.children[0].add_previous_sibling('tabulation')
          elsif    element.children[0].attribute('number').value =='1' and   @book_number==19

              element.children[0].add_previous_sibling('tabulation')
            end

        else
          element.children[0].add_previous_sibling('tabulationtabulation')
        end
      }
    }
  end

  def  add_exo
      @ind.xpath('//li').each { |element|
        element.name+='-exo'
    }
  end

  def add_ot
    ADD_OT.each { |ot_style|
      @ind.xpath("//#{ot_style}").each { |element|
        element.name+='-ot'
      }
    }
  end
  ###############################################################################################
  ##########################################VERSE################################################
  def verse

      @ind.xpath('//verse').each { |element|
        element.name= 'ver'
        element.content =    element.attribute('number').value
        chap_number = element.parent.xpath(element.parent.path+'/preceding::chapter[1]').attribute('number').value
        if  element.attribute('number').value =='1'    and @book_number != 19   #book 19 for psalms in just. bible
          element.name= 'ver-hidden'
                  kern = Nokogiri::XML::Node.new 'chap-kern', @local_doc
              if   chap_number.length  ==1
                element.add_previous_sibling(kern)
                kern.content= chap_number
                element.parent.name+='-chap-1'
              elsif    chap_number.length  ==2
                chp = Nokogiri::XML::Node.new 'chap', @local_doc
                chp.content= chap_number[0]
                kern.content= chap_number[1]
                element.add_previous_sibling(chp)
                element.add_previous_sibling(kern)
                element.parent.name+='-chap-2'
              elsif       chap_number.length  ==3
                chp = Nokogiri::XML::Node.new 'chap', @local_doc
                chp.content= chap_number[0..1]
                kern.content= chap_number[-1]
                element.add_previous_sibling(chp)
                element.add_previous_sibling(kern)
                element.parent.name+='-chap-3'
              end

        end
        if  element.parent.previous_element!= nil and element.parent.previous_element.attribute('style')!=nil  and element.parent.previous_element.attribute('style').value=='tbotb'  and  !(element.parent.name.include?('-chap-'))      and  !(element.parent.name.include?('-flush'))

          if element.parent.previous_element.content.include?('next_para_flush')
              element.parent.name+='-flush'
          end
        end

        bcv = Nokogiri::XML::Node.new 'bcv', @local_doc
        bcv.content= chap_number + ':'+  element.attribute('number').value
        element.add_previous_sibling(bcv)

      }

  end
  ################################################################################################
  ##########################################BOOK##################################################

  def book
    @ind.xpath("//book").each { |element|
      element.attribute('code').remove
      element.content= @book_name_ind
      book_title = Nokogiri::XML::Node.new 'book-title', @local_doc
      if  @ind.xpath("//ie").count == 1

        @ind.xpath("//ie").first.next_element.add_previous_sibling(book_title)
        book_title.add_child(element)
      else

        element.add_previous_sibling(book_title)
        book_title.add_child('| ')
        book_title.add_child(element)
        book_title.add_child(' |')
      end

    }

  end
  ################################################################################################
  ##########################################BLOCKS################################################
  def     tr
    @ind.xpath("//row[@style='tr']").each { |element|
      element.name='tr'
      if element.children[1].name=='tc1'
        element.name='tr-tc1'
        elsif  element.children[1].name=='tc2'
          element.name='tr-tc2'
        elsif  element.children[1].name=='tcr3'
          element.name='tr-tcr3'
      end
    }
  end
  def table_ind

    CELL.each { |cell_style|
      @ind.xpath("//cell[@style='#{cell_style}']").each { |element|
        element.name=cell_style

              if  cell_style=='tcr3'
                element.add_previous_sibling('tabulation')
              end
       if element.name=='tc1'|| element.name=='tc2'
          if element.children[0].name=='verse'
            element.children[1].add_previous_sibling('tabulation')
          else
            element.children[0].add_previous_sibling('tabulation')
          end
        end

        #new_line_in_table(element)
        element.add_previous_sibling('tabulation')
      }
    }
  end


  def new_line_in_table(element)
    if element.children.last.content.length > 60

      i=60
      while i >0
        if  element.children.last.content[i]==' '
          element.children.last.content = element.children.last.content[1..i] + "\n tabulationtabulation" +   element.children.last.content[i+1..-1]
          break
        end
        i-=1
      end
    end
  end

  ################################################################################################
  ##########################################BLOCKS################################################
  def add_blocks
    meta = Nokogiri::XML::Node.new 'meta', @local_doc
    @introduction = Nokogiri::XML::Node.new 'intro', @local_doc
    footnotes = Nokogiri::XML::Node.new 'footnotes', @local_doc
    text = Nokogiri::XML::Node.new 'text', @local_doc
    study_notes= Nokogiri::XML::Node.new 'study-notes', @local_doc
    text.add_child(  @ind.xpath('//usx')[0].children)
    @ind.xpath('//usx')[0].add_child(meta)
    @ind.xpath('//usx')[0].add_child(@introduction)
    @ind.xpath('//usx')[0].add_child(text)
    @ind.xpath('//usx')[0].add_child(footnotes)
    @ind.xpath('//usx')[0].add_child(study_notes)
  end
  ################################################################################################
  ##########################################PARAGRAPH############################################
  def paragraph
    PARAGRAPH.each { |paragraph_style|
      @ind.xpath("//para[@style='#{paragraph_style}']").each { |element|
          element.name=paragraph_style

          if     PMO.include?(element.attribute('style').value)
            if element.previous_element.attribute('style')!=nil and  !(PMO.include?(element.previous_element.attribute('style').value))  and  !(BREAK.include?(element.previous_element.attribute('style').value))   and  element.previous_element.attribute('style').value!='tbotb'
              top = Nokogiri::XML::Node.new 'b-half', @local_doc
              element.add_previous_sibling(top.to_xml+ "\n")
            elsif element.next_element!=nil and element.next_element.attribute('style')!=nil and  !(PMO.include?(element.next_element.attribute('style').value))  and  !(BREAK.include?(element.next_element.attribute('style').value))   and  element.next_element.attribute('style').value!='tbotb'
              top = Nokogiri::XML::Node.new 'b-half', @local_doc
              element.next_element.add_previous_sibling(top.to_xml+ "\n")
            end
          end
      }
    }
  end
  ################################################################################################
  ##########################################NOTE##################################################
  def note
    if @language == 'spanish'
      letters = @spanish
      index=0
    end
    NOTE.each { |note_style|
      @fn_index=0
    @ind.xpath("//note[@style='#{note_style}']").each { |element|
      @fn_index+=1

      if   note_style=='f'
        element.name= 'f-note'
        f_note = Nokogiri::XML::Node.new 'f-note', @local_doc
        mark = Nokogiri::XML::Node.new 'f-mark', @local_doc

        mark.content=letters[index]
        f_note.add_child(mark)
      elsif    note_style=='ef'
        f_note = Nokogiri::XML::Node.new 'study-note', @local_doc
        element.name= 'study-note'
      end
      #f_note = Nokogiri::XML::Node.new 'f-note', @local_doc

      f_note.set_attribute('f-id',@fn_index)
      element.add_previous_sibling(f_note)
      element.set_attribute('f-id',@fn_index)
      element.attribute('caller').remove

      ###########################################################################################


          if   note_style=='f'

            child=  element.children.first
            mark = Nokogiri::XML::Node.new 'f-mark', @local_doc
            mark.content=letters[index]
            if letters.last ==  letters[index]
              index=0
            else
              index+=1
            end


            child.add_previous_sibling(mark)

            if   child.attribute('style').value=='fr'
              child.name='f-ver'

              if    @ind.xpath("//chapter").count ==1
                child.content=  /(.*)/.match(child.content)[1]
              else
                child.content=  /\d+:(.*)/.match(child.content)[1]
              end

            end


      @ind.xpath('//footnotes')[0].add_child(element)

          elsif    note_style=='ef'

            child=  element.children.first
            if   child.attribute('style').value=='fr'
                    child.name='f-ver'

              if    @ind.xpath("//chapter").count ==1
                child.content=  /(.*)/.match(child.content)[1]
              else
                child.content=  /\d+:(.*)/.match(child.content)[1]
              end

            end
            @ind.xpath('//study-notes')[0].add_child(element)
            end
    }
    }
    end

  ################################################################################################
  ##########################################CHAR##################################################
  def char
    CHAR.each { |char_style|
      @ind.xpath("//char[@style='#{char_style}']").each { |element|
          element.name=char_style
       if char_style =='fm'

         puts @book_name_ind
         element.add_previous_sibling(element.children)
         element.remove
       end
          if char_style =='ior'

            element.add_previous_sibling('tabulation')

          end
          if  char_style=='it'
            if  element.parent.next_element!=nil and element.parent.next_element.name=='para'
              element.parent.next_element.children.count
              i=0
              add='yes'
              while i!= element.parent.next_element.children.count do
                if element.parent.next_element.children[i].name =='char' and   element.parent.next_element.children[i].attribute('style').value=='it'
                  add='no'
                end
                i+=1
              end
              if add=='yes'
                hr = Nokogiri::XML::Node.new 'hr', @local_doc
                element.parent.next_element.add_previous_sibling(hr)
              end
            end
          end
      }
    }
  end

  def bd
    @ind.xpath("//char[@style='bd']").each { |element|
      #bcv_content = element.xpath(element.path+'/preceding::bcv[1]')[0].content
   ################DROPCAP#############################
      if element.xpath(element.path+'/preceding::bcv[1]')[0]==nil
       element.parent.name += '-raised-cap'
       element.name = 'raised-cap'
      else
        element.add_previous_sibling(element.content)
        element.remove
      end

   ####################################################

    }
  end
  ################################################################################################
  ##########################################TBOTB#################################################
  def vertical

      @ind.xpath("//para[@style='tbotb']").each { |element|
          if element.content.include?('veritical_padding_0')
            element.name ='b-4'
          elsif element.content.include?('veritical_padding_1')
            element.name ='b-1'
          elsif element.content.include?('veritical_padding_2')
            element.name ='b-2'
          elsif element.content.include?('veritical_padding_3')
            element.name ='b-3'
          end

      }

  end
  ################################################################################################

  ##########################################HEADERS###############################################
  def psalms
    PSALMS.each { |header_style|
      @ind.xpath("//para[@style='#{header_style}']").each { |element|
          element.name=header_style
          if header_style=='s4'
            hr = Nokogiri::XML::Node.new 'hr', @local_doc
            element.add_previous_sibling(hr)
          end
      }
    }
  end
  ################################################################################################
  ##########################################HEADERS###############################################
  def headers(heading)
    HEARER_STYLES.each { |header_style|
      @ind.xpath("//para[@style='#{header_style}']").each { |element|
        if  heading
          element.name=header_style
        else
          element.remove
        end
      }
    }
  end
  ################################################################################################
  ############################################INTRO###############################################
  def introduction(delete_intro)
    INTRO_STYLES.each { |introduction_style|
      @ind.xpath("//para[@style='#{introduction_style}']").each { |element|
        if  delete_intro
          element.remove
        else

          element.name=introduction_style
        end
      }
    }
  end

  def delete_temp_elements
    TEMP_DELETE.each { |temp_style|
      @ind.xpath("//para[@style='#{temp_style}']").each { |element|
        if temp_style=='h'
          @book_name_ind=element.content
        end
          element.remove

      }
    }
  end
  ################################################################################################
  ##########################################BREAK&REPLACE#########################################


  def remove_elements(show_verse)

    @ind.xpath('//@number').remove
    @ind.xpath('//@version').remove
    @ind.xpath('//chapter').remove
    if !show_verse
      @ind.xpath('//ver').remove
    end

    ######



    ######
    @ind.xpath("//para[@style='b']").each { |element|
         element.name='b'
          if  element.next_element.name == 'b-half'
            element.next_element.remove
          end
         }
    VERTICAL.each { |tbotb_style|
    @ind.xpath("//#{tbotb_style}").each { |element|
      element.content=''

    }
    }
    #puts @book_name_ind
    #puts @ind.xpath('//char')
    #puts @ind.xpath('//cell')
    #puts @ind.xpath('//para')
    @ind.xpath('//@style').remove
    @ind.xpath('//@closed').remove
    @ind.xpath('//@align').remove
    @ind.root.name ='body'

    add_intro

  end



        def add_intro
          element_count = @ind.xpath('//text/descendant::*').count
          element = @ind.xpath('//text/descendant::*')
          element_index=0
          while element_index < element_count do
            current_element = element[element_index]

                if current_element.name  == 'mt1'
                  @introduction.add_child(current_element)
                end
            INTRO_STYLES.each { |introduction_style|
             if  current_element.name ==  introduction_style
               @introduction.add_child(current_element)
             end
            }


            if    current_element.name==  'ie'
              break
            end
            element_index+=1
            end
        end



  def  replace





    replace = @ind.to_s.gsub(/\n\s?\n/, "\n")
    replace = replace.gsub(/^\n/, "")
    replace = replace.gsub('• ', '•	')
    replace = replace.gsub('tabulation', '	')
    replace = replace.gsub('  ', '')
    replace = replace.gsub(/ code=".*"/, '')
    replace = replace.gsub('<b-half/>', '<b-half></b-half>')
    replace = replace.gsub('<b/>', '<b></b>')
    replace = replace.gsub('<ib/>', '<ib></ib>')
    replace = replace.gsub("<body>\n", '<body>')
    replace = replace.gsub('<b-1/>', "<b-1></b-1>\n")
    replace = replace.gsub('<b-2/>', "<b-2></b-2>\n")
    replace = replace.gsub('<b-3/>', "<b-3></b-3>\n")
    replace = replace.gsub('<b-4/>', "<b-4></b-4>\n")
    replace = replace.gsub('ʼ', '\'')
    replace = replace.gsub("<footnotes>\n", '<footnotes>')
    replace = replace.gsub("<study-notes>\n", '<study-notes>')

    replace = replace.gsub("</f-note>\n", '</f-note>   ')
    replace = replace.gsub("</study-note>\n", '</study-note>   ')
    replace = replace.gsub("</ft>\n", '</ft>')
    replace = replace.gsub("<ft>\n", '<ft>')
    replace = replace.gsub("</fq>\n", '</fq>')
    replace = replace.gsub("</f-ver>\n", '</f-ver>')
    replace = replace.gsub("</fqa>\n", '</fqa>')
    replace = replace.gsub("</f-mark>\n", '</f-mark> ')
    replace = replace.gsub("</fv>\n", '</fv>')
    replace = replace.gsub("</fl>\n", '</fl>')
    replace = replace.gsub("</xt>\n", '</xt>')
    replace = replace.gsub("</fp>\n", '</fp>')
    replace = replace.gsub("</nd>\n", '</nd>')
    replace = replace.gsub("<fqa>\n", '<fqa>')
    replace = replace.gsub('<table>', '')
    replace = replace.gsub("</table>\n", '')
    replace = replace.gsub("<text>\n", '<text>')
    replace = replace.gsub("<intro>\n", '<intro>')
    replace = replace.gsub("</book-title>\n", '</book-title>')
    replace = replace.gsub('</tr-tc1>', "</tr-tc1>\n")
    replace = replace.gsub('</tr-tc2>', "</tr-tc2>\n")
    replace = replace.gsub('</tr-tcr3>', "</tr-tcr3>\n")
    replace = replace.gsub('<hr/>', "<hr></hr>\n")
    replace = replace.gsub(/<study-note f-id="(\d+)">\s+/, '<study-note f-id="\1">')
    replace = replace.gsub(/<f-note f-id="(\d+)">\s+/, '<f-note f-id="\1">')
    @ind_content =  replace
  end

  def remove_empty_lines
    @ind.search('//text()').each { |text|
      if  text.content !~ /\S/ and text.content !=' '
        #puts text.previous_element.name
          text.remove
      end
    }
  end
  ################################################################################################

end