require 'time'

class Public < Application
  PATH_SEGMENT = /[a-z](?:-?[a-z]+)*/.freeze

  only_provides :html
  cache_for 5.minutes

  def show
    path = params[:public_path]

    # validate the path
    if path && !path.match(%r{\A#{PATH_SEGMENT}(?:/#{PATH_SEGMENT})*\z})
      raise BadRequest, 'Path is invalid'
    end

    # check to make sure the template exists
    template = controller_name / path.to_s
    template += 'index' if File.directory?(Merb.dir_for(:view) / template)

    files = Dir[Merb.dir_for(:view) / "#{template}.#{content_type}.{#{Merb::Template.template_extensions.join(',')}}"]

    if files.empty?
      raise NotFound, "Template #{template} not found"
    end

    headers['Last-Modified'] = File.mtime(files.first).httpdate

    render :template => template
  end

end
