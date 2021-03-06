require 'test/unit'
require 'htmlentities'
require '../../text_linker'
require '../../special_linker'


class SpecialLinkerTest < Test::Unit::TestCase

  def test_truth

    f = Struct.new(:title, :number, :parent_folder, :title_for_save) do
      def =~(regexp)
        title =~ regexp
      end
    end

    col = Struct.new(:files, :title, :title_for_save)
    c = col.new [f.new("you", 555, nil, "title_for_save")], 'col', 'col_title_for_save'


    c.files.first.parent_folder = c


    sp = GDriveImporter::SpecialLinker.new [c]
    result = "qdqdeowjd wdjdfj wdjwfjdwejf [LUCKY YOU](you)"
    sp.process_links result
    expected = "qdqdeowjd wdjdfj wdjwfjdwejf <%= link_to('LUCKY YOU',  '/texts/col_title_for_save/title_for_save.html') %>"
    assert result == expected, lambda {"expected #{expected}, got #{result}"}
  end
end


