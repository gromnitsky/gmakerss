let ini = require('inireader')

let norm = s => s.replace(/[^\w.,/-]/g, '_')
let props = hash => {
    return Object.entries(hash).map( ([k,v]) => {
	return {['.'+norm(k)]: Array.isArray(v) ? v.join(' ') : v}
    })
}
let se = s => "'" + s.replace(/'/g, "'\\''") + "'"
let xargs_escape = o => se(':' + JSON.stringify(o))

let parser = new ini.IniReader({multiValue: 1})
parser.load(process.argv[2])
Object.entries(parser.getBlock()).forEach( ([k,v]) => {
    if (!v.url) return
    let urls = Array.isArray(v.url) ? v.url : [v.url]
    delete v.url
    urls.forEach( url => {
	process.stdout.write(xargs_escape(Object.assign({'.name': norm(k)}, ...props(v), {'.url': url})) + "\n")
    })
})
