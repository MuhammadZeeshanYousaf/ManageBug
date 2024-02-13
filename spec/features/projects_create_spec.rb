# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Creating project' do

  context 'Manager' do

    let(:manager) { create :user, :manager }
    before do
      # Using Devise's sign_in helper
      sign_in manager
      visit projects_path
    end

    def create_project(name, details, form_id: 'new_project')
      click_on 'Add New Project'  # Assuming this is the button/link to create a new project

      # Assuming there's a form to create a new project, fill it out
      within('form#' + form_id) do
        fill_in 'Project Name', with: name
        fill_in 'Short Details', with: details
        # find select users dropdown and choose first two
        begin
          select_dropdown = find('select', text: 'Select users')
        rescue
          # Find the label using its text
          label = find('label', text: 'Select users')
          # Find the sibling select element
          select_dropdown = label.sibling('select')
        ensure
          # Select the first two options (users)
          select_dropdown.find(:option, match: :first).select_option
          select_dropdown.all(:option, minimum: 2)[1].select_option
        end

        # Upload project image
        label = find('label', text: 'Upload project photo')
        input_field = find('input', id: label[:for], visible: :all)
        input_field.attach_file Rails.root.join('spec', 'fixtures', 'images', 'example.png')
      end
      click_on 'Add'

      if block_given?
        expect(page).to have_content(name)
        expect(page).to have_content(details)
        yield true
      end
    end


    scenario 'can create multiple projects' do
      # 1 - New project
      expect(page).to have_content('Projects')  # Assuming this is a heading on the projects#index page

      create_project('Project 1', 'This is Project 1 details') do |project|
        expect(project).to be_present
      end

      # 2 - Another project
      create_project('Project 2', 'This is Project 2 details') do |project|
        expect(project).to be_present
      end
    end

  end

end