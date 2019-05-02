require "dependency_bundle/version"

class DependencyBundle
  DependencyNotProvided = Class.new(StandardError)
  OverrideAttempted     = Class.new(StandardError)

  def initialize(**dependencies)
    set(
      {
        env:    ENV,
        stdin:  STDIN,
        stdout: STDOUT,
        stderr: STDERR,
      }.merge(**dependencies)
    )
  end

  def set(**dependencies)
    dependencies.each do |name, dependency|
      set_single_dependency(name, dependency)
    end
  end

  def verify_dependencies!(*names)
    raise(ArgumentError, "##{__method__} expects names of dependencies to be passed") if names.empty?

    not_found_names = names.reject(&method(:respond_to?))

    raise(DependencyNotProvided, "#{not_found_names} not set") if not_found_names.any?

    true
  end

  private

  def set_single_dependency(name, value)
    if respond_to?(name)
      raise(OverrideAttempted, "You can't override `:#{name}` on #{inspect}, since it already responds to `:#{name}`. If you're seeing this because you tried to override a dependency, please don't. DependencyBundle doesn't allow that because of the misery it would introduce into debugging (your logger or http client changing between constructors is just asking for trouble). If you didn't try to override a dependency, and there's just a pre-existing Ruby method that happens to be named the same as the key you're using, I'm sorry. Please register your dependency with a different key.")
    else
      define_singleton_method(name) { value }
    end
  end
end
