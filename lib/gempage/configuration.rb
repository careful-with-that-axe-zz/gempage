require 'fileutils'

module Gempage::Configuration

  def root(root=nil)
    return @root if defined? @root and root.nil?
    @root = File.expand_path(root || Dir.getwd)
  end

  def gempage_dir(dir=nil)
    return @gempage_dir if defined? @gempage_dir and dir.nil?
    @gempage_dir = (dir || 'public/gempage')
  end

  def gempage_path
    gempage_path = File.join(root, gempage_dir)
    FileUtils.mkdir_p gempage_path
    gempage_path
  end

  def asset_gempage_path
    return @asset_gempage_path if defined? @asset_gempage_path and @asset_gempage_path
    @asset_gempage_path = File.join(gempage_path, 'assets', Gempage::VERSION)
    FileUtils.mkdir_p(@asset_gempage_path)
    @asset_gempage_path
  end

  def assets_path(name)
    File.join(@asset_gempage_path, name)
  end

end
