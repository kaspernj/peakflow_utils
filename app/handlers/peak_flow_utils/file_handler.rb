class PeakFlowUtils::FileHandler < PeakFlowUtils::ApplicationHandler
  def groups
    ArrayEnumerator.new do |yielder|
      erb_inspector.files.each do |file|
        id = file.file_path.gsub(/[^A-z0-9]/, "_")

        group = PeakFlowUtils::GroupService.new(
          id: id,
          handler: self,
          data: {
            name: file.file_path,
            root_path: file.root_path,
            full_path: file.full_path,
            file_path: file.file_path
          }
        )

        yielder << group if translations_for_group(group).any?
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      translations_found = {}

      file = erb_inspector.file(group.data.fetch(:root_path), group.data.fetch(:file_path))
      file.translations.each do |translation|
        next if translations_found.key?(translation.full_key)
        translations_found[translation.full_key] = true
        yielder << translation.model
      end
    end
  end

private

  def erb_inspector
    @erb_inspector ||= PeakFlowUtils::ErbInspector.new
  end
end
