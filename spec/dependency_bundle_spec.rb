RSpec.describe DependencyBundle do
  subject(:deps) { described_class.new }

  describe '#set' do
    it 'defines a method named with the provided key that returns the provided value' do
      deps.set :x, 5

      expect(deps.x).to eq 5
    end

    context 'with a global' do
      before do
        ::X = {}
        deps.set :x, X
      end

      it 'reflects changes made to the global after instantiation' do
        ::X['ARBITRARY_KEY'] = '4'
        expect(deps.x['ARBITRARY_KEY']).to eq '4'

        ::X['ARBITRARY_KEY'] = '5'
        expect(deps.x['ARBITRARY_KEY']).to eq '5'

        deps.x['ARBITRARY_KEY'] = '6'
        expect(::X['ARBITRARY_KEY']).to eq '6'
      end
    end

    context "when something with that name already exists" do
      before { deps.set :already_exists, 5 }

      it "raises an exception indicataing it can't override existing methods" do
        expect {
          deps.set :already_exists, 4
        }.to raise_error DependencyBundle::OverrideAttempted, /:already_exists/
      end
    end
  end

  describe '#initialize' do
    context 'once instantiated' do
      it "has env vars" do
        expect(deps.env).to eq ENV
      end

      it 'has stdin' do
        expect(deps.stdin).to eq STDIN
      end

      it 'has stdout' do
        expect(deps.stdout).to eq STDOUT
      end

      it 'has stderr' do
        expect(deps.stderr).to eq STDERR
      end
    end
  end

  describe '#verify_dependencies!' do
    context 'when no arguments are passed' do
      it 'raises an ArgumentError' do
        expect {
          deps.verify_dependencies!
        }.to raise_error(ArgumentError)
      end
    end

    context 'when all of the dependencies are provided' do
      subject(:deps) do
        described_class.new do
          set :x, 4
          set :y, 5
        end
      end

      it "doesn't raise an error" do
        expect {
          deps.verify_dependencies!(:x, :y)
        }.to_not raise_error
      end
    end

    context 'when some of the dependencies are provided' do
      subject(:deps) do
        described_class.new do
          set :x, 4
        end
      end

      it 'raises an error mentioning the dependencies not provided' do
        expect {
          deps.verify_dependencies!(:x, :y)
        }.to raise_error(DependencyBundle::DependencyNotProvided, /:y/)
      end
    end

    context 'when none of the dependencies are provided' do
      it 'raises an error mentioning the dependencies not provided' do
        expect {
          deps.verify_dependencies!(:x, :y)
        }.to raise_error(DependencyBundle::DependencyNotProvided, /[:x, :y]/)
      end
    end
  end

  it "has a version number" do
    expect(DependencyBundle::VERSION).not_to be nil
  end
end
