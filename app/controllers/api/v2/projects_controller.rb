#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module Api
  module V2
    class ProjectsController < ProjectsController

      include ::Api::V2::ApiController

      before_filter :find_project, :except => :index
      before_filter :authorize, :only => :show
      before_filter :require_permissions, :only => :planning_element_custom_fields

      def index
        options = {:order => 'lft'}

        if params[:ids]
          ids, identifiers = params[:ids].split(/,/).map(&:strip).partition { |s| s =~ /\A\d*\z/ }
          ids = ids.map(&:to_i).sort
          identifiers = identifiers.sort

          options[:conditions] = ["id IN (?) OR identifier IN (?)", ids, identifiers]
        end

        @projects = @base.visible.all(options)
        respond_to do |format|
          format.api
        end
      end

      def show
        respond_to do |format|
          format.api
        end
      end

      def planning_element_custom_fields
        @custom_fields = @project.all_work_package_custom_fields

        respond_to do |format|
          format.api
        end
      end

      protected

      def find_project
        @project = Project.find(params[:id])
      end

      def require_permissions
        deny_access unless @project.visible?
      end

    end
  end
end
