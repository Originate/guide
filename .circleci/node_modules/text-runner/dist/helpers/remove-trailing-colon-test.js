const removeTrailingColon = require('./remove-trailing-colon.js')

describe('removeTrailingColon', function () {
  context('with trailing colon', function () {
    it('removes the trailing colon', function () {
      expect(removeTrailingColon('foo:')).to.equal('foo')
    })
  })

  context('without trailing colon', function () {
    it('returns the string as-is', function () {
      expect(removeTrailingColon('foo')).to.equal('foo')
    })
  })
})
