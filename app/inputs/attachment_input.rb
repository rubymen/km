class AttachmentInput < SimpleForm::Inputs::FileInput
  def input
    out = ''

    if object.send("#{attribute_name}?")
      out << template.link_to(File.basename(object.send(attribute_name).path).to_s, object.send(attribute_name).url, class: 'btn btn-default visible', target: '_blank')
    end

    (out << @builder.file_field(attribute_name, input_html_options)).html_safe
  end
end
