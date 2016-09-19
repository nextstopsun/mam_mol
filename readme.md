# $mol

Reactive micro-modular ui framework. Very simple, but very powerful.

# Concepts

* Zero configuration. Just checkout and use it. 
* Full [reactive programming](https://en.wikipedia.org/wiki/Reactive_programming) in all application layers. Not only between View and ViewModel.
* Lazy rendering/evaluating/loading etc.
* Automatic dependency tracking between reactive containers. No need to manual (un)subscribe and streams routing.
* Effective state synchronization in right way. 
* Automatic include modules in package at compile time. No need to manual import them. Just use it.
* Very small modules. All of them are optional.
* Cross platform. Support any environment (NodeJS, Web, Cordova).
* Static typing ([TypeScript](https://www.typescriptlang.org/)). Full IDE support.
* Full customization. No implementation hiding. All aspects are overridable.
* Lifecycle management. Automatic destroy of components.
* Easy debugging. No exception catching. User readable id's of all objects. Quick access to all objects from console.
* Easy user friendly logging of all state changes.
* Pseudosynchronous code. Asynchrony is abstracted by reactivity. No callbacks/promises/streams hell. No async/awiat/yield virus.
* Automatic [BEM](https://en.bem.info/methodology/naming-convention/)-attributes generation for elements.

# [Demo applications](demo)

* [$mol_app_demo](app/demo) - demonstrates all components ([online](http://eigenmethod.github.io/mol/))
* [$mol_app_signup](app/signup) - simple form with persistence ([online](http://eigenmethod.github.io/mol/#demo=mol_app_signup))
* [$mol_app_todomvc](app/todomvc) - [ToDoMVC](http://todomvc.com/) realization ([online](http://eigenmethod.github.io/mol/#demo=mol_app_todomvc), [benchmark](https://github.com/nin-jin/todomvc/tree/master/benchmark))
* [$mol_app_supplies](app/supplies) - Supplies management tool ([online](http://eigenmethod.github.io/mol/#demo=mol_app_supplies))
* [$mol_app_users](app/users) - GitHub user "management" tool ([online](http://eigenmethod.github.io/mol/#demo=mol_app_users))

# [Benchmarks](perf)

* [$mol_perf_render](perf/render) - simple benchmark of rendering ([online](http://eigenmethod.github.io/mol/perf/render/))
* [ToDoMVC benchmark](https://github.com/nin-jin/todomvc/tree/master/benchmark)

# Quick start

**Create PMS project**

Easy way is checkout [this preconfigured PMS repository](http://github.com/nin-jin/pms/) and start dev server:

```sh
git clone https://github.com/nin-jin/pms.git ./pms && cd pms
npm start
```

**Create your application component**

In examples we will use namespace `my` and application name `hello`, but you must use your own namespace and application name.

Add **web entry point** at `./my/hello/index.html`:`

```html
<!doctype html>

<!-- link to autogenerated css bundle -->
<link rel="stylesheet" href="-/web.css" />

<!-- autobind component to element on load -->
<div mol_viewer_root="$my_hello"></div>

<!-- links to realease and test js bundles -->
<script src="-/web.js"></script>
<script src="-/web.test.js"></script>
```

Your application will be served at **`http://localhost:8080/my/`**.

Add **declarative component description** at `./my/hello/hello.view.tree` with string input field and greeting message:
```tree
$my_hello $mol_viewer childs /
	< input $mol_stringer
		hint \Name
		value > name \
	< message \
```

That will be compiled to typescript code like this:

```typescript
module $ { export class $my_hello extends $mol_viewer {

	/// name \
	@ $mol_prop()
	name( ...diff : any[] ) {
		return ( diff[0] !== void 0 ) ? diff[0] : ""
	}

	/// input $mol_stringer 
	/// 	hint \Name
	/// 	value > name
	@ $mol_prop()
	input( ...diff : any[] ) {
		return ( diff[0] !== void 0 ) ? diff[0] : new $mol_stringer().setup( __ => { 
			__.hint = () => "Name"
			__.value = ( ...diff : any[] ) => this.name(  ...diff )
		} )
	}

	/// message \
	message() {
		return ""
	}

	/// childs / 
	/// 	< input 
	/// 	< message
	childs() {
		return [].concat( this.input() , this.message() )
	}

} }
```

Add **your behaviour** at `./my/hello/hello.view.ts` by extending generated class:

```typescript
module $.$mol {
	export class $my_hello extends $.$my_hello {
		
		message() {
			let name = this.name()
			return name && `Hello, ${name}!`
		}
		
	}
}
```

Add **styles** at `./my/hello/hello.view.css`:

```css
/* Styling BEM-block by autogenerated attribute */
[my_hello] {
	margin: auto;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	font: 1.5rem/1 sans-serif;
}

/* Styling BEM-element by autogenerated attribute */
[my_hello_input] {
	flex-grow: 0;
	margin: 1rem;
}
```

That is all!

# Rationale

## Zero configuration

Вместо обеспечения конфигурируемости под любую хотелку, мы концентрируемся на том, чтобы всё работало как следует сразу из коробки и не напрягало разработчика необходимостью типовой настройки (что, однако, не исключает возможности подстроить под себя, если требуется).

Например, скачав **[базовый PMS-проект](http://github.com/nin-jin/pms/)** вы сразу получаете:

**Сборку JS и CSS бандлов.** Бандл можно собрать для любого модуля и в него войдут как собственно исходники этого модуля, так и исходники всех модулей, от которых тот зависит.

Полный набор поддерживаемых бандлов:

* `-/web.js` - JS для браузера
* `-/web.test.js` - JS с тестами для браузера
* `-/web.css` - CSS для браузера
* `-/web.deps.json` - карта зависимостей модулей для браузера
* `-/node.js` - JS для NodeJS
* `-/node.test.js` - JS с тестами для NodeJS
* `-/node.deps.json` - карта зависимостей модулей для NodeJS

**Поддержку Source Maps**. Исходники вкомпиливаются в сами карты, так что они вполне себе самодостаточны.

**Девелоперский сервер**, который собирает нужные бандлы по мере необходимости. Например, при запросе `http://localhost:8080/mol/app/todomvc/-/web.js` происходит сборка `js` бандла пакета `mol/app/todomvc` для `web` окружения. Пересборка будет произведена только при изменении файлов-исходников.

**Трансляцию современного CSS в CSS поддерживаемый браузерами** ([postcss-cssnext](https://github.com/MoOx/postcss-cssnext)): расстановка префиксов, разворачивание переменных и тд.

**Трансляцию [TypeScript](https://github.com/Microsoft/TypeScript) в JS**. В TS включена поддержка аннотаций и выключена поддержка автоматической расстановки типа any, чтобы случайно не терять типизацию.

**Отслеживание зависимостей по факту использования** и автоматическое включение необходимых модулей в результирующий бандл. То есть не надо писать никакие `include` или `require` - достаточно обращаться к сущности по полному имени вида `$mol_state_arg` или `$mol.state.arg` (смотря как она определена) в `*.ts`, `*.view.ts` и `*.view.tree` файлах. В CSS зависимости ищутся по вхождениям вида `[mol_checker_checked]` , `[mol_checker_checked=` или `.mol_checker_checked`.

## Lego components

В $mol используется компонентный подход к построению интерфейса, при этом **каждая компонента самодостаточна** и может быть использована как самостоятельное приложение. Мелкие компоненты собираются вместе под крылом более крупной компоненты, и так далее по нарастающей.

В отличие от многих других фреймворков, $mol не стремится изолировать внутренности компонент. Наоборот, предоставляется удобный механизм настройки их поведения, не требуя от создателя компоненты дополнительных телодвижений.
 
 Например, чтобы задать список дочерних копонент для заданной, нужно просто переопределить свойство `childs()`:
 
 ```tree
$mol_viewer childs /
	< button1
	< button2
 ```

 Или то же самое через TypeScript:
 
 ```typescript
 new $mol_viewer().setup( obj => {
 	obj.childs = ()=> [ this.button1() , this.button2() ]
 } )
 ```

В обоих вариантах компилятор проверит существование свойства и соответствие сигнатуры. В норме, вам не требуется работать с полями объекта напрямую, поэтому все определяемые свойства являются публичными и могут быть безопасно перегружены.

# Modules

## Object model

* [$mol_atom](atom) - reactive container
* [$mol_prop](prop) - reactive property decorator
* [$mol_object](object) - components base class
* [$mol_model](model) - reactive model base class
* [$mol_log](log) - logging
* [$mol_const](const) - const value returning function

## Collections

* [$mol_range](range) - lazy array
* [$mol_set](set) - [Set API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set)
* [$mol_dict](dict) - [Map API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map)
* [$mol_maybe](maybe) - [maybe monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)#The_Maybe_monad)

## [State modules](state)

* [$mol_state_arg](state/arg) - arguments state (location/argv)
* [$mol_state_local](state/local) - persistent local state (localStorage)
* [$mol_state_session](state/session) - session temporaty state (sessionStorage)
* [$mol_state_stack](state/stack) - state of current stack of execution

## Communication modules

* [$mol_http_request](http/request) - Reactive HTTP Request
* [$mol_http_resource](http/resource) - Reactive REST HTTP resource

## Simple components

* [$mol_viewer](viewer) - reactive view model base class with lazy error-proof renderer
* [$mol_filler](filler) - lorem ipsum

## Simple controls

* [$mol_linker](linker) - navigation link
* [$mol_clicker](clicker) - button
* [$mol_checker](checker) - check box
* [$mol_switcher](switcher) - radio buttons
* [$mol_stringer](stringer) - one string input control
* [$mol_number](number) - one number input control
* [$mol_coder](coder) - bar code scanner
* [$mol_portioner](portioner) - portion visualizer

## Layout components

* [$mol_scroller](scroller) - scroll pane with position saving
* [$mol_tiler](tiler) - items in row with balanced wrapping
* [$mol_rower](rower) - items in row with wrapping and padding between
* [$mol_barer](barer) - group of controls as own control
* [$mol_lister](lister) - vertical list of rows

## Complex components

* [$mol_labeler](labeler) - labeled content
* [$mol_sectioner](sectioner) - section with header
* [$mol_stacker](stacker) - horizontal stack of panels
* [$mol_pager](pager) - page with header, body and footer
* [$mol_decker](decker) - deck of panels with tab bar
* [$mol_form](form) - forms with validators
* [$mol_demo](demo) - demonstrates widget in various screens

## Data formats

* [$mol_tree](tree) - [tree format](https://github.com/nin-jin/tree.d)

## Resources

* [$mol_logo](logo) - $mol logotypes
* [$mol_icon](icon) - css styled icons
* [$mol_skin](skin) - theming

## Testing

* [$mol_test](test) - unit testing
* [$mol_stub](stub) - stub data generators

## Flow

* [$mol_defer](defer) - deferred but immediate execution

## API

* [$mol_cordova](cordova) - [Apache Cordova](https://cordova.apache.org) API

