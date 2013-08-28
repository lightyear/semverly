shared_examples 'parsing' do
  context 'without pre-release or metadata' do
    context 'with major, minor and patch' do
      subject { SemVer.parse("#{prefix}1.2.3") }

      it 'has major version 1' do
        expect(subject.major).to eq(1)
      end

      it 'has minor version 2' do
        expect(subject.minor).to eq(2)
      end

      it 'has patch version 3' do
        expect(subject.patch).to eq(3)
      end
    end

    context 'without patch' do
      subject { SemVer.parse("#{prefix}1.2") }

      it 'has major version 1' do
        expect(subject.major).to eq(1)
      end

      it 'has minor version 2' do
        expect(subject.minor).to eq(2)
      end

      it 'has patch version 0' do
        expect(subject.patch).to eq(0)
      end
    end

    context 'without minor or patch' do
      subject { SemVer.parse("#{prefix}1") }

      it 'has major version 1' do
        expect(subject.major).to eq(1)
      end

      it 'has minor version 0' do
        expect(subject.minor).to eq(0)
      end

      it 'has patch version 0' do
        expect(subject.patch).to eq(0)
      end
    end
  end

  context 'with pre-release' do
    subject { SemVer.parse("#{prefix}1.2.3-beta.1")}

    it 'has major version 1' do
      expect(subject.major).to eq(1)
    end

    it 'has minor version 2' do
      expect(subject.minor).to eq(2)
    end

    it 'has patch version 3' do
      expect(subject.patch).to eq(3)
    end

    it 'has pre-release beta.1' do
      expect(subject.prerelease).to eq('beta.1')
    end
  end

  context 'with metadata' do
    subject { SemVer.parse("#{prefix}1.2.3+abc123")}

    it 'has major version 1' do
      expect(subject.major).to eq(1)
    end

    it 'has minor version 2' do
      expect(subject.minor).to eq(2)
    end

    it 'has patch version 3' do
      expect(subject.patch).to eq(3)
    end

    it 'has metadata abc123' do
      expect(subject.metadata).to eq('abc123')
    end
  end

  context 'with pre-release and metadata' do
    subject { SemVer.parse("#{prefix}1.2.3-beta.1+abc123")}

    it 'has major version 1' do
      expect(subject.major).to eq(1)
    end

    it 'has minor version 2' do
      expect(subject.minor).to eq(2)
    end

    it 'has patch version 3' do
      expect(subject.patch).to eq(3)
    end

    it 'has pre-release beta.1' do
      expect(subject.prerelease).to eq('beta.1')
    end

    it 'has metadata abc123' do
      expect(subject.metadata).to eq('abc123')
    end
  end
end

describe SemVer do
  describe '.new' do
    subject { SemVer.new(1) }

    it 'has major version 1' do
      expect(subject.major).to eq(1)
    end

    it 'has minor version 0' do
      expect(subject.minor).to eq(0)
    end

    it 'has minor version 0' do
      expect(subject.patch).to eq(0)
    end

    it 'is not a pre-release' do
      expect(subject.prerelease).to be_nil
    end

    it 'has no metadata' do
      expect(subject.metadata).to be_nil
    end
  end

  describe '.parse' do
    context 'with a version prefix' do
      let(:prefix) { 'v' }
      include_examples 'parsing'
    end

    context 'without a version prefix' do
      let(:prefix) { '' }
      include_examples 'parsing'
    end

    context 'with a non-SemVer compliant string' do
      {
        'non-numeric major, minor and patch parts' => 'a.b.c',
        'invalid characters in pre-release' => '1.2.3-this/that',
        'blank identifier in pre-release' => '1.2.3-this..that',
        'invalid characters in metadata' => '1.2.3+this/that',
        'blank identifier in metadata' => '1.2.3+this..that'
      }.each do |description, string|
        it "returns nil with #{description}" do
          expect(SemVer.parse(string)).to be_nil
        end
      end
    end
  end

  describe '#to_s' do
    context 'without pre-release or metadata' do
      it 'returns a properly formatted string' do
        semver = SemVer.new(1, 2, 3)
        expect(semver.to_s).to eq('1.2.3')
      end
    end

    context 'with pre-release' do
      it 'returns a properly formatted string' do
        semver = SemVer.new(1, 2, 3, 'beta')
        expect(semver.to_s).to eq('1.2.3-beta')
      end
    end

    context 'with metadata' do
      it 'returns a properly formatted string' do
        semver = SemVer.new(1, 2, 3, nil, 'abc123')
        expect(semver.to_s).to eq('1.2.3+abc123')
      end
    end

    context 'with pre-release and metadata' do
      it 'returns a properly formatted string' do
        semver = SemVer.new(1, 2, 3, 'beta', 'abc123')
        expect(semver.to_s).to eq('1.2.3-beta+abc123')
      end
    end
  end

  describe 'sorting' do
    it 'sorts the major version numerically' do
      first = SemVer.new(1)
      second = SemVer.new(2)
      expect(first <=> second).to eq(-1)
    end

    it 'sorts the minor version numerically' do
      first = SemVer.new(1, 1)
      second = SemVer.new(1, 2)
      expect(first <=> second).to eq(-1)
    end

    it 'sorts the patch version numerically' do
      first = SemVer.new(1, 1, 1)
      second = SemVer.new(1, 1, 2)
      expect(first <=> second).to eq(-1)
    end

    it 'sorts pre-release versions before release' do
      first = SemVer.new(1, 0, 0, 'beta')
      second = SemVer.new(1, 0, 0)
      expect(first <=> second).to eq(-1)
    end

    it 'sorts pre-release parts with only digits numerically' do
      first = SemVer.new(1, 0, 0, 'beta.2')
      second = SemVer.new(1, 0, 0, 'beta.10')
      expect(first <=> second).to eq(-1)
    end

    it 'sorts pre-release parts with letters lexically' do
      first = SemVer.new(1, 0, 0, 'alpha')
      second = SemVer.new(1, 0, 0, 'beta')
      expect(first <=> second).to eq(-1)
    end

    it 'sorts numeric pre-release parts before non-numeric' do
      first = SemVer.new(1, 0, 0, 'alpha.1')
      second = SemVer.new(1, 0, 0, 'alpha.beta')
      expect(first <=> second).to eq(-1)
    end

    it 'sorts fewer pre-release parts before more' do
      first = SemVer.new(1, 0, 0, 'alpha')
      second = SemVer.new(1, 0, 0, 'alpha.1')
      expect(first <=> second).to eq(-1)
    end

    it 'does not consider metadata when sorting' do
      first = SemVer.new(1, 0, 0, nil, 'foo')
      second = SemVer.new(1, 0, 0, nil, 'bar')
      expect(first <=> second).to eq(0)
    end
  end
end
