module ApplicationHelper
  def keywords
    'documents, milicon, knowledge, management, manager, km, knowledge management, knowledge-management, knowledgemanagement, rubymen, ruby on rails, document, tag'
  end

  def to_b field
    field.to_i == 0 ? false : true
  end
end
