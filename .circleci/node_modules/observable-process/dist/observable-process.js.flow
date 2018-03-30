// @flow

const child_process = require('child_process')   // eslint-disable-line camelcase
const debug = require('debug')('observable-process')
const extend = require('extend')
const mergeStream = require('merge-stream')
const stringArgv = require('string-argv')
const TextStreamSearch = require('text-stream-search')

// a list of environment variables
type Env = { [string]: ?string }

type EndedNotification = {
  exitCode: number,
  killed: boolean
}

type EndedListener = (EndedNotification) => void

// a stream that we can write into using write(string),
// plus some boilerplate to make process.stdout fit in here
export interface WriteStream {
 // flowlint-next-line unclear-type:off
  write(chunk: Buffer | string, encodingOrCallback?: string | Function, callback?: Function): boolean;
}

// Runs the given command as a separate, parallel process
// and allows to observe it.
class ObservableProcess {
  cwd: string
  ended: boolean
  endedListeners: Array<(EndedNotification) => void>
  env: Env
  exitCode: number
  killed: boolean
  process: child_process$ChildProcess  // eslint-disable-line camelcase
  stdout: WriteStream
  stderr: WriteStream
  stdin: WriteStream
  textStreamSearch: TextStreamSearch
  verbose: boolean

  // command: "ls -la *.js"
  // commands: ["ls", "-la", "*.js"]
  // options.verbose: whether to log
  //        .stdout: the stdout stream to write output to
  //        .stderr: the stderr stream to write errors to
  constructor (args: {command?: string, commands?: string[], env?: Env, verbose?: boolean, cwd?: string, stdout?: ?WriteStream, stderr?: ?WriteStream}) {
    if (args.env != null) this.env = args.env
    this.verbose = args.verbose || false
    this.cwd = (args.cwd != null) ? args.cwd : process.cwd()
    this.stdout = args.stdout || process.stdout
    this.stderr = args.stderr || process.stderr
    this.ended = false
    this.endedListeners = []

    // build up the options
    const options: child_process$spawnOpts = {    // eslint-disable-line camelcase
      env: {},
      cwd: this.cwd
    }
    extend(options.env, process.env, this.env)
    var runnable = ''
    var params = []
    if (args.command != null) {
      [runnable, ...params] = this._splitCommand(args.command)
    }
    if (args.commands != null) {
      runnable = args.commands[0]
      params = args.commands.splice(1)
    }
    debug(`starting '${runnable}' with arguments [${params.join(',')}]`)
    this.process = child_process.spawn(runnable, params, options)
    this.process.on('close', this._onClose.bind(this))

    this.textStreamSearch = new TextStreamSearch(mergeStream(this.process.stdout, this.process.stderr))

    if (this.stdout) {
      this.process.stdout.on('data', (data) => { this.stdout.write(data.toString()) })
    }
    if (this.stderr) {
      this.process.stderr.on('data', (data) => { this.stderr.write(data.toString()) })
    }

    // indicates whether this process has been officially killed
    // (to avoid unnecessary panic if it is killed)
    this.killed = false

    this.stdin = this.process.stdin
  }

  // Enters the given text into the subprocess.
  // Types the ENTER key automatically.
  enter (text: string) {
    this.stdin.write(`${text}\n`)
  }

  fullOutput () {
    return this.textStreamSearch.fullText()
  }

  kill () {
    this.killed = true
    this.process.kill()
  }

  // notifies all registered listeners that this process has ended
  notifyEnded () {
    for (let resolver of this.endedListeners) {
      resolver({exitCode: this.exitCode, killed: this.killed})
    }
  }

  _onClose (exitCode: number) {
    this.exitCode = exitCode
    this.ended = true
    if (this.verbose) {
      if (this.stderr) this.stderr.write('PROCESS ENDED\n')
      if (this.stderr) this.stderr.write(`\nEXIT CODE: ${this.exitCode}`)
    }
    this.notifyEnded()
  }

  pid () {
    if (this.process) return this.process.pid
  }

  waitForEnd (): Promise<EndedNotification> {
    return new Promise((resolve) => {
      this.endedListeners.push(resolve)
    })
  }

  // Calls the given handler when the given text shows up in the output
  async waitForText (text: string, timeout?: number) {
    await this.textStreamSearch.waitForText(text, timeout)
  }

  resetOutputStreams () {
    this.textStreamSearch.reset()
  }

  _splitCommand (command: string | string[]): string[] {
    if (Array.isArray(command)) {
      return command
    } else {
      return stringArgv(command)
    }
  }
}

module.exports = ObservableProcess
