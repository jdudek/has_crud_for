require File.dirname(__FILE__) + "/../lib/has_crud_for"

describe HasCrudFor do
  describe "without :through" do
    before do
      klass = Class.new do
        extend HasCrudFor
        has_crud_for :items
      end
      @subject = klass.new
      @items = mock
      @subject.stub!(:items).and_return(@items)
      @id = 1
      @attributes = {}
    end

    it "should have find_item" do
      @items.should_receive(:find).with(@id)
      @subject.find_item(@id)
    end

    it "should have build_item" do
      @items.should_receive(:build).with(@attributes)
      @subject.build_item(@attributes)
    end

    it "should have create_item" do
      @items.should_receive(:create).with(@attributes)
      @subject.create_item(@attributes)
    end

    it "should have create_item!" do
      @items.should_receive(:create!).with(@attributes)
      @subject.create_item!(@attributes)
    end

    it "should have update_item" do
      @items.should_receive(:update).with(@id, @attributes)
      @subject.update_item(@id, @attributes)
    end

    it "should have destroy_item" do
      @items.should_receive(:destroy).with(@id)
      @subject.destroy_item(@id)
    end
  end

  describe "with :through" do
    before do
      klass = Class.new do
        extend HasCrudFor
        has_crud_for :children, :through => :parents
      end
      @subject = klass.new
      @parent_id = 1
      @child_id = 2
      @attributes = {}
      @parent = mock
      @children = mock
      @subject.stub!(:find_parent).with(@parent_id).and_return(@parent)
    end

    it "should have find_child" do
      @parent.should_receive(:find_child).with(@child_id)
      @subject.find_child(@parent_id, @child_id)
    end

    it "should have build_child" do
      @parent.should_receive(:build_child).with(@attributes)
      @subject.build_child(@parent_id, @attributes)
    end

    it "should have create_child" do
      @parent.should_receive(:create_child).with(@attributes)
      @subject.create_child(@parent_id, @attributes)
    end

    it "should have update_child" do
      @parent.should_receive(:update_child).with(@child_id, @attributes)
      @subject.update_child(@parent_id, @child_id, @attributes)
    end

    it "should have destroy_child" do
      @parent.should_receive(:destroy_child).with(@child_id)
      @subject.destroy_child(@parent_id, @child_id)
    end
  end

  describe "with :except" do
    klass = Class.new do
      extend HasCrudFor
      has_crud_for :items, :except => [:update, :destroy]
    end

    subject { klass.new }

    it { should respond_to :find_item }
    it { should respond_to :build_item }
    it { should respond_to :create_item }
    it { should_not respond_to :update_item }
    it { should_not respond_to :destroy_item }
  end

  describe "with :only" do
    klass = Class.new do
      extend HasCrudFor
      has_crud_for :items, :only => [:find, :build, :create]
    end

    subject { klass.new }

    it { should respond_to :find_item }
    it { should respond_to :build_item }
    it { should respond_to :create_item }
    it { should_not respond_to :update_item }
    it { should_not respond_to :destroy_item }
  end

  describe "with :as" do
    klass = Class.new do
      extend HasCrudFor
      has_crud_for :items, :as => :things
    end

    subject { klass.new }

    it { should respond_to :find_thing }
    it { should respond_to :build_thing }
    it { should respond_to :create_thing }
    it { should respond_to :update_thing }
    it { should respond_to :destroy_thing }
  end
end
