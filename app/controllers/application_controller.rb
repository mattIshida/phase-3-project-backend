class ApplicationController < Sinatra::Base
    set :default_content_type, 'application/json'
    
    # Add your routes here
    get "/legislators" do
      Legislator.all.map {|leg| leg.attributes.merge({summary_stats: leg.summary_stats})}.to_json()
    end

    get "/bills" do
        Bill.all.to_json({include: :subjects})
    end

    get "/bills/:id" do
        bill = Bill.find(params[:id])
        bill.to_json({include: [{comments: {include: {user: {only: :name}}}}, :subjects]})
    end

    get "/users" do
        User.all.to_json
    end

    get "/users/:id" do
        user = User.find(params[:id])
        user.to_json({include: [:follows, :comments, :legislators_followed]})
    end

    # get "/issues" do
    #     Subject.all.to_json
    # end

    #Full CRUD on comments

    post "/comments" do
        comment = Comment.create(content: params[:content],
        user_id: params[:user_id],
        commentable_type: params[:commentable_type],
        commentable_id: params[:commentable_id])
        comment.to_json
    end

    get "/comments/:id" do
        comment = Comment.find(params[:id])
        comment.to_json
    end

    patch "/comments/:id" do
        comment = Comment.find(params[:id])
        comment.update(content: params[:content])
        comment.to_json
    end

    delete "/comments/:id" do
        comment = Comment.find(params[:id])
        comment.destroy
        comment.to_json
    end

    # CRD on follows

    post "/follows" do
        follow = Follow.create(
            followable_id: params[:followable_id],
            followable_type: params[:followable_type],
            user_id: params[:user_id]
        )
        follow.to_json
    end

    get "/follows/:id" do
        follow = Follow.find(params[:id])
        follow.to_json
    end

    delete "/follows/:id" do
        follow = Follow.find(params[:id])
        follow.destroy
        follow.to_json
    end

    # Issues/subjects

    get "/issues" do
        issues = Subject.all #find(21)
        issues.to_json({include: :bills})
    end


  
  end
  