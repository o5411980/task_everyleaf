class TasksController < ApplicationController
  def index
    if params[:task_name] && params[:status]
      @tasks = Task.where('task_name LIKE ?', "%#{params[:task_name]}%").where(status: params[:status])
    elsif (params[:task_name] == "") && (params[:status])
      @tasks = Task.where(status: params[:status])
    elsif params[:task_name] && (params[:status] == "")
      @tasks = Task.where('task_name LIKE ?', "%#{params[:task_name]}%")
    elsif params[:sort_deadline]
      @tasks = Task.order(deadline: :asc)
    else
      @tasks = Task.sort_created_at
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
    params.require(:task).permit(:task_name, :detail, :deadline, :status)
  end
end
