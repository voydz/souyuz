module Souyuz
  module Msbuild
    class Solution
      attr_accessor :projects

      def initialize
        @projects = []
      end

      def add_project(project)
        @projects << project
      end
    end
  end
end
