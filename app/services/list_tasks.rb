class ListTasks < ListCollection

  attr_defaultable :result_serializer, -> { V1::TaskSerializer }

  def initialize page: 1, page_size: 25, project_id:
  	@project_id = project_id
    super(page: page, page_size: page_size)
  end

  def collection_type
    :tasks
  end

  def collection
    @tasks ||= Project.find(@project_id).tasks
  end

end