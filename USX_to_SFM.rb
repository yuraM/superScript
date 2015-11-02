#!/bin]env ruby
# encoding: utf-8
require 'nokogiri'
class USXToSFM
  def start
  index_file=0
  while index_file < Dir["usx/*"].count do
    @filename = File.basename(Dir['usx/*'][index_file], '.usx')
    file= File.open("usx/#{@filename}.usx")
    usx_content=file.read
    #puts usx_content
    to_sfm(usx_content)
    index_file+=1
  end
  end

  def to_sfm(usx_content)
    @usx = Nokogiri::XML(usx_content)
    element = @usx.xpath('//descendant::*')
    element_count = @usx.xpath('//descendant::*').count
    element_index = 0
    #@book_number = @books[book]

    while element_index < element_count do
      @element = element[element_index]
        book_code
        para
        char
        verse
        chapter
      table
      note
      #puts @element
      element_index+=1
    end
    replacing
  end

  def book_code
    if @element.name =='book'
      @element.name= 'id'+   @element.attribute('code').value
      @element.attribute('style').remove
      @element.attribute('code').remove
    end
  end

  def table
    if @element.name =='row' ||   @element.name =='cell'
      @element.name=@element.attribute('style').value
      @element.attribute('style').remove
      if   @element.attribute('align')!=nil
            @element.attribute('align').remove
        end
    end
  end

  def para
        if @element.name =='para' and @element.attribute('style')!=nil
        @element.name="para_"+@element.attribute('style').value
        @element.attribute('style').remove
        end
  end
  def char
    if @element.name =='char' and @element.attribute('style')!=nil

      if @element.parent.name.include?("para") ||  @element.parent.name=='f+'  ||  @element.parent.name=='ef-'
        @element.name=@element.attribute('style').value
      else
        @element.name="+"+@element.attribute('style').value
      end

      @element.attribute('style').remove
      if     @element.attribute('closed')!= nil
          @element.attribute('closed').remove
      end

    end
  end
  def verse
    if @element.name =='verse'
      @element.name= @element.attribute('style').value + @element.attribute('number').value
      @element.attribute('style').remove
      @element.attribute('number').remove
    end
  end
  def chapter
    if @element.name =='chapter'
      @element.name= @element.attribute('style').value + @element.attribute('number').value
      @element.attribute('style').remove
      @element.attribute('number').remove
    end
  end
  def note
    if @element.name =='note'
      @element.name= @element.attribute('style').value + @element.attribute('caller').value
      @element.attribute('style').remove
      #@element.attribute('number').remove
      @element.attribute('caller').remove
    end
  end

  def replacing
    @sfm_content = @usx.to_s
    @sfm_content.gsub!(/<\/para_.*>/,'')
    @sfm_content.gsub!(/<para_(\w*)>/, '"\\"\1 ')
    @sfm_content.gsub!(/<para_(\w*)\/>/, '"\\"\1 ')
    @sfm_content.gsub!(/<c(\d*)\/>/, '"\\"c \1 ')
    @sfm_content.gsub!(/<v(\d*)\/>/, '"\\"v \1 ')
    @sfm_content.gsub!(/<fv(\d*)>/, '"\\"fv \1')
    @sfm_content.gsub!(/<\/fv(\d*)>/, '')
    @sfm_content.gsub!(/<v(\d*-\d*)\/>/, '"\\"v \1 ')
    @sfm_content.gsub!(/<id(\w*)>/, '"\\"id \1 ')
    @sfm_content.gsub!(/<\/id\w*>/, '')

    @sfm_content.gsub!(/<(nd|wj|sc|tl|it|fm|qt|bk|ior|w|bd|k|em|xt)>/, '"\\"\1 ')
    @sfm_content.gsub!(/<\/(nd|wj|sc|tl|it|fm|qt|bk|ior|w|bd|k|em|xt)>/, '"\\"\1*')
    @sfm_content.gsub!(/<(fr|ft|fqa|fq|xo|fp|fl)>/, '"\\"\1 ')
    @sfm_content.gsub!(/<\/(fr|ft|fqa|fq|xo|fp|fl)>/, '')
    @sfm_content.gsub!(/<\+(nd|wj|sc|tl|it|fm|qt|bk|ior|w|bd|k|em|xt)>/, '"\\"+\1 ')
    @sfm_content.gsub!(/<\/\+(nd|wj|sc|tl|it|fm|qt|bk|ior|w|bd|k|em|xt)>/, '"\\"+\1*')
    @sfm_content.gsub!("<f+>", '\f + ')
    @sfm_content.gsub!("</f+>", '\f*')
    @sfm_content.gsub!("<ef->", '\ef - ')
    @sfm_content.gsub!("</ef->", '\ef*')
    @sfm_content.gsub!('"\"', '\\')
    @sfm_content.gsub!('\v', "\n\\v")
    @sfm_content.gsub!(/\s$/, '')
    @sfm_content.gsub!('<?xml version="1.0" encoding="utf-8"?>', '')
    @sfm_content.gsub!('<usx version="2.0">', '')
    @sfm_content.gsub!('</usx>', '')
    @sfm_content.gsub!('</tr>', '')
    @sfm_content.gsub!('<tr>', '\tr ')
    @sfm_content.gsub!('<tc1>', '\tc1 ')
    @sfm_content.gsub!('</tc1>', '')
    @sfm_content.gsub!('<tc2>', '\tc2 ')
    @sfm_content.gsub!('</tc2>', '')
    @sfm_content.gsub!('<tc3>', '\tc3 ')
    @sfm_content.gsub!('</tc3>', '')
    @sfm_content.gsub!('<tcr3>', '\tcr3 ')
    @sfm_content.gsub!('</tcr3>', '')
    @sfm_content.gsub!(/^$\n/, '')
    @sfm_content.gsub!(/\\tc1 $\n/, "\\tc1\n")
   if @sfm_content.include?("<")
     puts    @sfm_content
end
      #puts @sfm_content
    File.open("./to_sfm/#{@filename}.SFM", 'w') { |f| f.write(@sfm_content) }
  end

end
parsing= USXToSFM.new
parsing.start