require 'test_helper'

class ProjectTest < MiniTest::Unit::TestCase

  def setup
    @project = build(:project)
  end

  def validate(obj, attr, val)
    obj.send("#{attr}=", val)
    obj.valid?
  end

  context '.validations' do
    should 'validate presence of title' do
      validate(@project, :title, nil)
      refute_nil @project.errors[:title]
    end

    should 'validate presence of url' do
      validate(@project, :url, nil)
      refute_nil @project.errors[:url]
    end

    should 'validate presence of body' do
      validate(@project, :body, nil)
      refute_nil @project.errors[:body]
    end

    should 'validate presence of published' do
      validate(@project, :published, nil)
      refute_nil @project.errors[:published]
    end
  end

  context '.scopes' do
    context '.published' do
      should 'return published projects' do
        @project.save
        create(:project, published: false)
        assert Project.published == [@project], 'published scope return unpublished Projects'
      end
    end
  end

end

