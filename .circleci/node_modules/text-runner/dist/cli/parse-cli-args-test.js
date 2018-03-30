/* eslint no-unused-expressions: 0 */
const parseCliArgs = require('../../dist/cli/parse-cli-args')

describe('parse-cli-args', function () {
  context('with unix <node> call', function () {
    beforeEach(function () {
      this.result = parseCliArgs([
        '/usr/local/Cellar/node/9.3.0_1/bin/node',
        '/Users/kevlar/d/text-runner/bin/text-run',
        'run'
      ])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })
  })

  context('with windows <node> call', function () {
    beforeEach(function () {
      this.result = parseCliArgs([
        'C:\\Program Files (x86)\\nodejs\\node.exe',
        'C:\\projects\\text-runner\\bin\\text-run.cmd\\..\\..\\dist\\cli\\cli.js',
        'run'
      ])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })

    it('returns empty files', function () {
      expect(this.result.file).to.be.undefined
    })
  })

  context('with <node> and <text-run> call', function () {
    beforeEach(function () {
      this.result = parseCliArgs([
        '/usr/local/Cellar/node/9.3.0_1/bin/node',
        '/Users/kevlar/d/text-runner/bin/text-run',
        'run'
      ])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })
  })

  context('with <text-run> call', function () {
    beforeEach(function () {
      this.result = parseCliArgs([
        '/Users/kevlar/d/text-runner/bin/text-run',
        'run'
      ])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })
  })

  context('--offline <file>', function () {
    beforeEach(function () {
      this.result = parseCliArgs(['--offline', 'documentation/actions/cd.md'])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })

    it('returns the "offline" switch', function () {
      expect(this.result.offline).to.be.true
    })

    it('returns the filename', function () {
      expect(this.result.file).to.equal('documentation/actions/cd.md')
    })
  })

  context('<file>', function () {
    beforeEach(function () {
      this.result = parseCliArgs(['documentation/actions/cd.md'])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })

    it('returns the filename', function () {
      expect(this.result.file).to.equal('documentation/actions/cd.md')
    })
  })

  context('(no args)', function () {
    beforeEach(function () {
      this.result = parseCliArgs([])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })

    it('returns undefined as the filename', function () {
      expect(this.result.file).to.be.undefined
    })
  })

  context('--format dot', function () {
    beforeEach(function () {
      this.result = parseCliArgs(['--format', 'dot'])
    })

    it('returns the "run" command', function () {
      expect(this.result.command).to.equal('run')
    })

    it('returns the dot formatter option', function () {
      expect(this.result.format).to.equal('dot')
    })
  })
})
