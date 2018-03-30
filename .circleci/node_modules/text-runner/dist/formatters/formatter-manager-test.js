/* eslint no-unused-expressions: 0 */
const FormatterManager = require('../../dist/formatters/formatter-manager.js')
const jsdiffConsole = require('jsdiff-console')
const { expect } = require('chai')

describe('FormatterManager', function () {
  beforeEach(function () {
    this.formatterManager = new FormatterManager()
  })

  describe('availableFormatterNames', function () {
    beforeEach(function () {
      this.formatterNames = this.formatterManager.availableFormatterNames()
    })

    it('returns the names of the available formatters', function () {
      expect(this.formatterNames).to.eql(['detailed', 'dot'])
    })
  })

  describe('getFormatter', function () {
    context('with correct formatter name', function () {
      beforeEach(function () {
        this.result = this.formatterManager.getFormatter('dot')
      })

      it('returns the formatter with the given name', function () {
        expect(typeof this.result).to.equal('object')
      })
    })

    context('with unknown formatter name', function () {
      beforeEach(function () {
        try {
          this.formatterManager.getFormatter('zonk')
        } catch (e) {
          this.err = e.message
        }
      })

      it('returns no formatter', function () {
        expect(this.result).to.be.undefined
      })

      it('returns an error', function () {
        jsdiffConsole(
          this.err,
          `Unknown formatter: 'zonk'

Available formatters are detailed, dot`
        )
      })
    })
  })
})
