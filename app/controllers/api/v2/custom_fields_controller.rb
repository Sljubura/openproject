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
    class CustomFieldsController < ApplicationController

      include ::Api::V2::ApiController

      def index
        @custom_fields = CustomField.find :all,
            :offset => params[:offset],
            :limit => params[:limit]

        @custom_fields.each do |field|
          with_visible_projects(field)
        end

        respond_to do |format|
          format.api
        end
      end

      def show
        @custom_field = with_visible_projects(CustomField.find params[:id])

        respond_to do |format|
          format.api
        end
      end

      protected

      def with_visible_projects(custom_field)
        def custom_field.visible_projects
          @visible_projects ||= Project.visible.all :conditions => ["id IN (?)", project_ids]
        end
        custom_field
      end

    end
  end
end
