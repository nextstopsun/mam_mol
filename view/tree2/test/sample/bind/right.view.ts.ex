namespace $ {
	export class $mol_view_tree2_test_sample_bind_right extends $mol_view {

		/**
		 * ```tree
		 * Cls $mol_view
		 * 	inner => outer
		 * 	writable?val => writable_outer?val
		 * 	indexed!key => indexed_outer!key
		 * 	indexed_writable!key?val => indexed_writable_outer!key?val
		 * ```
		 */
		@ $mol_mem
		Cls() {
			const obj = new this.$.$mol_view()


			return obj
		}

		/**
		 * ```tree
		 * outer
		 * ```
		 */
		outer() {
			return this.Cls().inner()
		}

		/**
		 * ```tree
		 * writable_outer?val
		 * ```
		 */
		writable_outer(val?: any) {
			return this.Cls().writable(val)
		}

		/**
		 * ```tree
		 * indexed_outer!key
		 * ```
		 */
		indexed_outer(key: any) {
			return this.Cls().indexed(key)
		}

		/**
		 * ```tree
		 * indexed_writable_outer!key?val
		 * ```
		 */
		indexed_writable_outer(key: any, val?: any) {
			return this.Cls().indexed_writable(key, val)
		}

		/**
		 * ```tree
		 * q <= Cls2 $mol_view inner => outerQ
		 * ```
		 */
		q() {
			return this.Cls2()
		}

		/**
		 * ```tree
		 * Cls2 $mol_view inner => outerQ
		 * ```
		 */
		@ $mol_mem
		Cls2() {
			const obj = new this.$.$mol_view()


			return obj
		}

		/**
		 * ```tree
		 * outerQ
		 * ```
		 */
		outerQ() {
			return this.Cls2().inner()
		}
	}

}
