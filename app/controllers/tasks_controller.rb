class TasksController < ApplicationController
  def index
#    byebug
    if params[:task_name].present? && params[:status].present?
      @tasks = Task.page(params[:page]).per(10).search_task_name_and_status(params[:task_name], params[:status])
#      @tasks = Task.where('task_name LIKE ?', "%#{params[:task_name]}%").where(status: params[:status])
    elsif (params[:task_name].blank?) && (params[:status].present?)
      @tasks = Task.page(params[:page]).per(10).search_status(params[:status])
#      @tasks = Task.where(status: params[:status])
    elsif (params[:task_name].present?) && (params[:status].blank?)
      @tasks = Task.page(params[:page]).per(10).search_task_name(params[:task_name])
#      @tasks = Task.where('task_name LIKE ?', "%#{params[:task_name]}%")
    elsif params[:sort_deadline]
      @tasks = Task.page(params[:page]).per(10).sort_deadline
    elsif params[:sort_priority]
      @tasks = Task.page(params[:page]).per(10).sort_priority
    else
      @tasks = Task.page(params[:page]).per(10).sort_created_at
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path, notice: "新規タスクを作成しました"
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました！"
  end

  private
  def task_params
    params.require(:task).permit(:task_name, :detail, :deadline, :status, :priority)
  end
end
