const Configuration = require('../../dist/configuration/configuration')
const fs = require('fs')
const path = require('path')
const tmp = require('tmp')

describe('Configuration', function () {
  context('no config file given', function () {
    beforeEach(function () {
      this.config = new Configuration()
    })

    describe('files attribute', function () {
      it('returns the default value', function () {
        expect(this.config.get('files')).to.equal('**/*.md')
      })
    })
  })

  context('config file given', function () {
    beforeEach(function () {
      this.configDir = tmp.dirSync()
      this.configFilePath = path.join(this.configDir.name, 'text-run.yml')
      fs.writeFileSync(this.configFilePath, "files: '*.md'")
      this.config = new Configuration(this.configFilePath)
    })

    describe('files attribute', function () {
      it('returns the value from the file', function () {
        expect(this.config.get('files')).to.equal('*.md')
      })
    })
  })
})
