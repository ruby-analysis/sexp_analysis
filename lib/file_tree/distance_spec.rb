require_relative "file_tree"
require_relative "distance"

describe FileTree::Distance do
  let(:distance) { described_class.new(a,b) }

  describe "#traversal_path" do
    let(:a) { t("another_top_level_file") }
    let(:b) { t("yet_another_file") }

    it do
      expect(distance.traversal_path).to eq [
        expand_fixture_path("another_top_level_file"),
        expand_fixture_path("yet_another_file"),
      ]
    end

    context do
      let(:a) { t("some_file") }
      let(:b) { t("sub_directory/file_in_sub_directory") }


      it do
        result = distance.traversal_path

        expect(result).to eq [
          expand_fixture_path("some_file"),
          expand_fixture_path("/sub_directory"),
          expand_fixture_path("/sub_directory/file_in_sub_directory"),
        ]
      end
    end
  end

  describe "#remove_traversals_from_files_to_parents_then_back_down_to_sub_directories" do
    let(:a) { t("some_file") }
    let(:b) { t("sub_directory/file_in_sub_directory") }


    it do
      result = distance.remove_traversals_from_files_to_parents_then_back_down_to_sub_directories [
        expand_fixture_path("some_file"),
        expand_fixture_path(""),
        expand_fixture_path("/sub_directory"),
      ]

      expect(result).to eq [
        expand_fixture_path("some_file"),
        expand_fixture_path("/sub_directory"),
      ]
    end

    it do
      result = distance.remove_traversals_from_files_to_parents_then_back_down_to_sub_directories [
        expand_fixture_path("another_sub_directory/another_file"),
        expand_fixture_path("another_sub_directory"),
        expand_fixture_path("another_sub_directory/yet_another_file"),
        expand_fixture_path("another_sub_directory"),
        expand_fixture_path("."),
        expand_fixture_path("sub_directory"),
      ]

      expect(result).to eq [
        expand_fixture_path("another_sub_directory/another_file"),
        expand_fixture_path("another_sub_directory/yet_another_file"),
        expand_fixture_path("another_sub_directory"),
        expand_fixture_path("sub_directory"),
      ]
    end

    it do
      result = distance.remove_traversals_from_files_to_parents_then_back_down_to_sub_directories [
        expand_fixture_path(""),
        expand_fixture_path("/sub_directory"),
      ]

      expect(result).to eq [
        expand_fixture_path(""),
        expand_fixture_path("/sub_directory"),
      ]
    end
  end

  describe "#traversals" do
    let(:a) { t("some_file") }
    let(:b) { t("sub_directory/file_in_sub_directory") }

    it do
      expect(distance.traversal_klasses.map(&:class)).to eq [
        FileTree::SiblingFile,
        FileTree::SiblingDirectory,
        FileTree::ChildFile
      ]
      expect(distance.traversal_klasses.map(&:distance)).to match_array [
        2,  # FileTree::SiblingFile
        1,  # FileTree::SiblingDirectory
        1   # FileTree::ChildFile
      ]
    end
  end


  describe "#traversal_klasses" do
    let(:a) { t("another_top_level_file") }
    let(:b) { t("yet_another_file") }

    it do
      expect(distance.traversal_klasses.map(&:class)).to eq [
        FileTree::SiblingFile
      ]
    end

    context do
      let(:a) { t("sub_directory/file_in_sub_directory") }
      let(:b) { t("another_sub_directory/another_file") }

      it do
        expect(distance.traversal_klasses.map(&:class)).to eq [
          FileTree::SiblingFile,
          FileTree::SiblingDirectory,
          FileTree::ParentDirectory,
          FileTree::SiblingDirectory,
          FileTree::ChildFile
        ]
      end
    end


  end

  describe "#possible_traversals" do
    pending do
      expect(distance.possible_traversals).to eq [
        FileTree::SiblingFile.new(3),
        FileTree::SiblingDirectory.new(3)
      ]
    end

    pending do
      expect(distance.possible_traversals).to eq [
        FileTree::SiblingFile.new(4),
        FileTree::SiblingDirectory.new(2),
        FileTree::ChildDirectory.new(1),
        FileTree::SiblingFile.new(2),
        FileTree::SiblingDirectory.new(3),
      ]
    end
  end

  describe "#sum_traversals" do
    let(:a) { t("another_top_level_file") }
    let(:b) { t("yet_another_file") }


    pending do
      expect(distance.sum_traversals).to eq 3
    end

    pending do
      expect(distance.sum_traversals).to eq 3 + 1 + 1 + 3 + 1
    end
  end

  describe "#sum_possible_traversals" do
    pending do
      expect(distance.sum_possible_traversals).to eq 3 + 3
    end

    pending do
      expect(distance.sum_possible_traversals).to eq 4 + 2 + 1 + 3 + 2
    end
  end

  describe "#top_ancestor" do
    let(:a) { t("some_file") }
    let(:b) { t("sub_directory/file_in_sub_directory") }


    it do
      result = distance.top_ancestor

      expect(result).to eq fixture_path
    end
  end
end

