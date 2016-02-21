require_relative "relation"

describe FileTree::Relation do
  describe "#others" do
    let(:relation) { FileTree::Relation.new(path, anything) }

    context "with a file" do
      let(:path) { t("another_top_level_file") }

      it "returns just files" do
        result = relation.other_files

        match_file_array result, %w(
        another_top_level_file
        even_more
        some_file
        yet_another_file
        )
      end

      it "returns just directories" do
        result = relation.other_directories

        match_file_array result, %w(
          another_sub_directory
          sub_directory
          yet_another_directory
        )
      end
    end

    context "with a directory" do
      let(:path) { t("sub_directory") }

      it "returns just files" do
        result = relation.other_files

        match_file_array result, %w(
          another_top_level_file
          even_more
          some_file
          yet_another_file
        )
      end

      it "returns just directories" do
        result = relation.other_directories

        match_file_array result, %w(
          another_sub_directory
          sub_directory
          yet_another_directory
        )
      end
    end


  end

#▾ fixtures/
#  ▾ tree/
#    ▾ another_sub_directory/
#        another_file
#        yet_another_file
#    ▾ sub_directory/
#      ▸ another_directory/
#      ▸ second_level/
#      ▸ yet_another_directory/
#        even_more
#        file_in_sub_directory
#        some_more
#    ▸ yet_another_directory/
#      another_top_level_file
#      even_more
#      some_file
#      yet_another_file
end
  def match_file_array(a,b)
    expect(a).to match_array b.map{|f| Pathname.new(t f)}
  end



describe FileTree::SiblingFileThenDirectoryThenParentDirectory do
  let(:instance) { described_class.new(a,b) }
  let(:b) { t("sub_directory") }
  let(:a) { t("sub_directory/file_in_sub_directory") }

  it do
    match_file_array instance.other_files, %w(
      sub_directory/some_more
      sub_directory/even_more
      sub_directory/file_in_sub_directory
    )
  end

  context "traversing all files" do
    let(:a) { t("sub_directory/some_more") }

    it do
      match_file_array instance.traversed_files, %w(
        sub_directory/some_more
        sub_directory/even_more
        sub_directory/file_in_sub_directory
      )
    end
  end

  context "traversing some files" do
    let(:a) { t("sub_directory/file_in_sub_directory") }

    it do
      match_file_array instance.traversed_files, %w(
        sub_directory/even_more
        sub_directory/file_in_sub_directory
    )
    end
  end

  it do
    match_file_array instance.other_directories, %w(
      sub_directory/another_directory/
      sub_directory/second_level/
      sub_directory/yet_another_directory/
    )
  end

  context "traversing some directories" do
    let(:a) { t("sub_directory/file_in_sub_directory") }
    let(:b) { t("sub_directory/second_level") }

    it do
      match_file_array instance.traversed_directories, %w(
        sub_directory/yet_another_directory
        sub_directory/second_level
    )
    end
  end

  context "traversing all directories" do
    let(:a) { t("sub_directory/file_in_sub_directory") }
    let(:b) { t("sub_directory/another_directory") }

    it do
      match_file_array instance.traversed_directories, %w(
        sub_directory/another_directory/
        sub_directory/second_level/
        sub_directory/yet_another_directory/
      )
    end
  end
end
