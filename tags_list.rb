

module Tags_list
  def get_list_of_tags
      @para_content='pi\d?|p|li\d?|q\d?|qm\d?|m1|m|pm|d|mi|nb|pmr|pmo|qr|sp|pc|pmc|iex|pr|qs|cls'
      @para_header='s\d?|h|ide|toc1|toc2|toc3|mt\d?|cl|r|h|rem|msk|mr|qc|qa|ms1|tbotb'
      @para_intro='imt\d?|ip|iot|io\d?|is\d|sr|toc|is|ili|ms\d|im|ipi|imq|ipq|ipr|ms|ili1|imt1|imte1|cp|iq\d?|imi'
      @all_para='pi\d?|p|li\d?|q\d?|qm\d?|m1|m|pm|d|mi|nb|pmr|pmo|qr|sp|pc|pmc|iex|pr|qs|cls|s\d?|h|ide|toc1|toc2|toc3|mt\d?|cl|r|h|rem|msk|mr|qc|qa|ms1|tbotb|imt\d?|ip|iot|io\d?|is\d|sr|toc|is|ili|ms\d|im|ipi|imq|ipq|ipr|ms|ili1|imt1|imte1|cp|iq\d?|imi'
      @self_close='b|ib|pb|ie|erqe|erq'
      @char_in_note ='nd|bk|xt|tl|wj|pn|w|k|ord|add'
      @char='nd|wj|sc|tl|it|fm|qt|bk|ior|w|bd|k|em'
      @char_closed='fr|ft|fqa|fq|xo|xt|fp|fl'
      @table='tc1|tc2|tc3|tc4|tc5|tc6|tc7|tc8|th1|th2|th3|tcr3|tcr2|tcr1'
      @add_bcv_to = 'tc1|tc2|tc3|tc4|tc5|tc6|tc7|tc8|th1|th2|th3|tcr3|tcr2|tcr1|pi\d?|p|li\d?|q\d?|qm\d?|m1|m|pm|d|mi|nb|pmr|pmo|qr|sp|pc|pmc|iex|pr|qs|cls'
      @books= Hash["GEN" => "01", "EXO" => "02", "LEV" => "03", "NUM" => "04", "DEU" => "05", "JOS" => "06", "JDG" => "07", "RUT" => "08", "1SA" => "09", "2SA" => 10, "1KI" => 11, "2KI" => 12, "1CH" => 13, "2CH" => 14 ,"EZR" => 15, "NEH" => 16, "EST" => 17, "JOB" => 18, "PSA" => 19, "PRO" => 20, "ECC" => 21, "SNG" => 22, "ISA" => 23, "JER" => 24,"LAM" => 25,"EZK" => 26, "DAN" => 27, "HOS" => 28, "JOL" => 29, "AMO" => 30, "OBA" => 31, "JON" => 32,"MIC" => 33 ,"NAM" => 34 ,"HAB" => 35 ,"ZEP" => 36 ,"HAG" => 37  ,"ZEC" => 38,"MAL" => 39,"MAT" => 40, "MRK" => 41, "LUK" => 42, "JHN" => 43, "ACT" => 44, "ROM" => 45, "1CO" => 46, "2CO" => 47, "GAL" => 48, "EPH" => 49, "PHP" => 50, "COL" => 51, "1TH" => 52, "2TH" => 53, "1TI" => 54, "2TI" => 55, "TIT" => 56, "PHM" => 57, "HEB" => 58, "JAS" => 59, "1PE" => 60, "2PE" => 61, "1JN" => 62, "2JN" => 63, "3JN" => 64, "JUD" => 65, "REV" => 66]
      #headers
      @html_hybrid=  '<html><head><meta charset="UTF-8"><title>Matthew - Hybrid</title><link id="css-link" rel="stylesheet" href="../../css/standard-style.css"><link rel="stylesheet" href="../../css/toggle.css"><link rel="stylesheet" href="../../font/font-face.css"><script src="../../js/jquery-2.1.4.min.js"></script><script>
    $(document).ready(function () {
      $("#switcher").click(function () {
        var $topElement = $(document.elementFromPoint(document.width / 2, 10));
        if ($(this).is(":checked")) {
          $("#css-link").attr("href", "../../css/tbotb-style.css");
        } else {
          $("#css-link").attr("href", "../../css/standard-style.css");
        }
        setTimeout(function () {
          $(window).scrollTop($topElement.offset().top);
        }, 50);
      });
    });
  </script></head><body><main><label class="toggler">Standard</label><div class="toggle"><input type="checkbox" id="switcher" class="check"><b class="switch"></b></div><label class="toggler">TBOTB</label></main>'
      @html_standard ='<html>
<head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/standard-style.css"><link rel="stylesheet" href="../../font/font-face.css"><title>Matthew - Standard</title></head><body>'
      @html_tbotb  ='<html><head><meta charset="UTF-8"><link rel="stylesheet" href="../../css/tbotb-style.css"><link rel="stylesheet" href="../../font/font-face.css"><title>Matthew - TBOTB</title></head><body>'

      @spanish= %w[a b c d e f g h i j k l m n ñ o p q r s t u v w x y z]


end

end