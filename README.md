#Nested Attributes in Rails Forms
###accepts\_nested\_attributes\_for

##Introduction

Developing web applications in Rails will inevitably lead to an Active Record `has_many`/`has_one` and `belongs_to` relationship. These Active Record associations can produce overly verbose and redundant code that become very difficult to maintain. Luckily, Ruby on Rails provides the `accepts_nested_attributes_for` method that results in the syntactic goodness that we strive for.  

[For those that just want to see the code.](https://github.com/johnotander/nested_attr)


##The Less Correct Way
If this relationship isn't accomplished with `accepts_nested_attributes_for`, we result in two undesirable situations:


###A sloppy controller

Consider the abstracted new/create actions below:
######Note: The parameters in the create action may vary, depending on your form.

    class ParentModelController < ApplicationController
    
      def new
        @parent_model = ParentModel.new
        @child_model = ChildModel.new
      end
      
      def create
        @parent_model = ParentModel.new params[:parent_model]
        @child_model = ChildModel.new params[:child_model]
        @child_model.parent_model = @parent_model
        
        if @parent_model.valid? and @child_model.valid?
          @parent_model.save!
          @child_model.save!
          
          redirect_to parent_models_path, notice: "Your ParentModel was created successfully!"
        else
          render :new
        end
      end
    end



As you can see, the controller becomes rather sloppy. Also, as the models change, since they always do, the upkeep becomes unbearable.  For example, what happens if we decide to add a ChildToTheChildModel?  If this is expected to be created in the same form as the others, we will have an ugly `if @parent_model.valid? and @child_model.valid? and @child_to_the_child_model.valid?` conditional.  We don't want that.


###Redundant error views

Consider error messages, which are typically handled by a block similar to what's below.

    <% if @parent_model.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(@forest.errors.count, "error") %> prohibited this ParentModel from being saved:</h2>

        <ul>
        <% @parent_model.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    <% end %>
    
We won't be displaying any error messages if all of them occurred on the child\_model. So, we will have to violate the DRY principle by adding redundant error handling. Additionally, like the consideration made before, what happens as more dependent models are needed? This view redundancy really begins to exhibit side-effects.



##Taking Advantage of accepts\_nested\_attributes\_for

By utilizing the `accepts_nested_attributes_for` method, we can quickly, and efficiently clear up any model dependency code smells.  Essentially, all this method does is accept a nested hash of attributes from the form, and assigns them to all the child models that are associated with the parent model.  This is achieved by defining a writer on the dependent models.

__Parent => Child => Child to the Child => ...__ where child\_attributes=(attributes) and child\_to\_the\_child\_attributes=(attributes).

<http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html>


###A Forest that has\_many Trees

For this example we will use Forest and Tree models where a Tree `belongs_to` a Forest like so:

    class Forest < ActiveRecord::Base
      has_many :trees, dependent: :destroy
    end
    

    class Tree < ActiveRecord::Base
      belongs_to :forest
    end


####So lets start a little project to test this out \([or clone it on github](https://github.com/johnotander/nested_attr.git)\):

First, create the project.

    john-mbp:~ johno$ rails new nested_attributes; cd nested_attributes   
    
Then, create a Forest scaffold with some attributes
######note: I'm not normally a fan of utilizing scaffolds, but I will use them here for brevity's sake.

    john-mbp:nested_attributes johno$ rails g scaffold Forest name:string size:integer latitude:integer longitude:integer climate:string

Thirdly, create the Tree scaffold.

    john-mbp:nested_attributes johno$ rails g scaffold Tree common_name:string scientific_name:string forest_id:integer
    


