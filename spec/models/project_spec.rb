require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
  end

  it "is valid with a name, description, user" do
    project = Project.new(
      name: "shopping",
      description: "buy apple",
      owner: @user,
    )
    expect(project).to be_valid
  end

  it "is invalid without a name" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  describe "create same name project" do
    before do
      @user.projects.create(
        name: "Test Project",
      )
    end
    # ユーザー単位では重複したプロジェクト名を許可しないこと
    context "When duplicate project names per user" do
      it "does not allow" do
        new_project = @user.projects.build(
          name: "Test Project",
        )

        new_project.valid?
        expect(new_project.errors[:name]).to include("has already been taken")
      end
    end
    # 二人のユーザーが同じ名前を使うことは許可すること
    context "two users to share a project name" do
      it "allows" do
        other_user = User.create(
          first_name: "Jane",
          last_name: "Tester",
          email: "janetester@example.com",
          password: "dottle-nouveau-pavilion-tights-furze",
        )

        other_project = other_user.projects.build(
          name: "Test Project",
        )

        expect(other_project).to be_valid
      end
    end
  end
end
