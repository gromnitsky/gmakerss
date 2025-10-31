let ini = require('inireader')
let crypto = require('crypto')

let norm = s => s.replace(/[^\w.,/-]/g, '_')
let props = hash => {
    return Object.entries(hash).map( ([k,v]) => {
	return {['.'+norm(k)]: k === 'dest' ? norm(v) : v}
    })
}
let se = s => "'" + s.replace(/'/g, "'\\''") + "'"
let xargs_escape = o => se(':' + JSON.stringify(o))
let match = (patrn, dest, url) => {
    return /^url:/.test(patrn) ? url.match(patrn.slice(4)) : dest.match(patrn)
}
let md5 = s => crypto.createHash('md5').update(String(s)).digest('hex')

let parser = new ini.IniReader()
parser.load(process.argv[2])
Object.entries(parser.getBlock()).forEach( ([k,v]) => {
    if (!v.dest) throw new Error(`'${k}' hash no 'dest' prop!`)
    if (process.argv[3] && !match(process.argv[3], v.dest, k)) return // g= opt
    process.stdout.write(xargs_escape(Object.assign({'.url': k},
                                                    {'.cache': `.cache/${md5(k)}.xml`},
                                                    ...props(v))) + "\n")
})
