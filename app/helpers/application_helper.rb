module ApplicationHelper
  def app_size
    total = 0
    Find.find('.').each { |f| total += File.stat(f).size }
    total = total / 1024 / 1024
  end

  def app_number_files
    total_files = []
    Find.find('./public/uploads').each { |f| total_files << f }
    total_files.length
  end

  def keywords
    'documents, milicon, knowledge, management, manager, km, knowledge management, knowledge-management, knowledgemanagement, rubymen, ruby on rails, document, tag'
  end

  def server_size
    stat = Sys::Filesystem.stat('/')
    mb_available = stat.block_size * stat.blocks_available / 1024 / 1024
  end

  def to_b field
    field.to_i == 0 ? false : true
  end
end
