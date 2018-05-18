let ini = require('inireader')

let norm = s => s.replace(/[^\w.,/-]/g, '_')
let props = hash => {
    return Object.entries(hash).map( ([k,v]) => {
	return {['.'+norm(k)]: k === 'dest' ? norm(v) : v}
    })
}
let se = s => "'" + s.replace(/'/g, "'\\''") + "'"
let xargs_escape = o => se(':' + JSON.stringify(o))

let parser = new ini.IniReader()
parser.load(process.argv[2])
Object.entries(parser.getBlock()).forEach( ([k,v]) => {
    if (!v.dest) throw new Error(`'${k}' hash no 'dest' prop!`)
    if (process.argv[3] && !v.dest.match(process.argv[3])) return // g= opt
    process.stdout.write(xargs_escape(Object.assign({'.url': k}, ...props(v))) + "\n")
})
