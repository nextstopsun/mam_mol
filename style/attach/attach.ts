namespace $ {

	let all = [] as string[]
	let el : HTMLStyleElement | null = null
	let timer : $mol_after_tick | null = null

	export function $mol_style_attach(
		id : string ,
		text : string ,
	) {

		all.push( `/* ${ id } */\n\n${ text }`)

		if( timer ) return el!
		
		const doc = $mol_dom_context.document
		el = doc.createElement('style')
		el.id = `$mol_style_attach`
		doc.head.appendChild( el )

		timer = new $mol_after_tick( ()=> {
			el.innerHTML = '\n' + all.join( '\n\n' )
			all = []
			el = null
			timer = null
		} )

		return el

	}

}