module SexpAnalysis
  class GlobCoupling < Struct.new(:glob)
    def files
      glob.files
    end
  end
end
