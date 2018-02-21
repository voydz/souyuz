# -*- encoding : utf-8 -*-

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

      def get_platform(platform)
        @projects.select { |p| p.is_platform? platform }
      end
    end
  end
end
