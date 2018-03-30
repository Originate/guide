const psTree = require('ps-tree'),
      debug = require('debug')('end-child-process')

module.exports = function(done) {
  psTree(process.pid, function(err, children) {
    if (err) return done(err)
    for (var i = 0; i < children.length; i++) {
      if (children[i].COMM === 'ps') continue
      debug(`ending child process: ${children[i].COMM}`)
      try {
        process.kill(children[i].PID)
      } catch (e) {
        debug(`cannot kill process ${children[i].COMM}: ${e.message}`)
      }
    }
    if (done) done()
  })
}
