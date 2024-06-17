module tamagotchi::tamagotchi_schema {
	use std::ascii::String;
	use std::option::some;
    use sui::tx_context::TxContext;
    use sui::table::{Self, Table};
    use tamagotchi::events;
    use tamagotchi::world::{Self, World, AdminCap};

    // Systems
	friend tamagotchi::tamagotchi_system;
	friend tamagotchi::deploy_hook;

	/// Entity does not exist
	const EEntityDoesNotExist: u64 = 0;

	const SCHEMA_ID: vector<u8> = b"tamagotchi";
	const SCHEMA_TYPE: u8 = 0;

	// name
	// date_of_birth
	// fed
	// fed_block
	// entertained
	// entertained_block
	// rested
	// rested_block
	struct TamagotchiData has copy, drop , store {
		name: String,
		date_of_birth: u64,
		fed: u64,
		fed_block: u64,
		entertained: u64,
		entertained_block: u64,
		rested: u64,
		rested_block: u64
	}

	public fun new(name: String, date_of_birth: u64, fed: u64, fed_block: u64, entertained: u64, entertained_block: u64, rested: u64, rested_block: u64): TamagotchiData {
		TamagotchiData {
			name,
			date_of_birth,
			fed,
			fed_block,
			entertained,
			entertained_block,
			rested,
			rested_block
		}
	}

	public fun register(_obelisk_world: &mut World, admin_cap: &AdminCap, ctx: &mut TxContext) {
		world::add_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID, table::new<address, TamagotchiData>(ctx), admin_cap);
	}

	public(friend) fun set(_obelisk_world: &mut World, _obelisk_entity_key: address,  name: String, date_of_birth: u64, fed: u64, fed_block: u64, entertained: u64, entertained_block: u64, rested: u64, rested_block: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		let _obelisk_data = new( name, date_of_birth, fed, fed_block, entertained, entertained_block, rested, rested_block);
		if(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key)) {
			*table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key) = _obelisk_data;
		} else {
			table::add(_obelisk_schema, _obelisk_entity_key, _obelisk_data);
		};
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), _obelisk_data)
	}

	public(friend) fun set_name(_obelisk_world: &mut World, _obelisk_entity_key: address, name: String) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.name = name;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_date_of_birth(_obelisk_world: &mut World, _obelisk_entity_key: address, date_of_birth: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.date_of_birth = date_of_birth;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_fed(_obelisk_world: &mut World, _obelisk_entity_key: address, fed: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.fed = fed;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_fed_block(_obelisk_world: &mut World, _obelisk_entity_key: address, fed_block: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.fed_block = fed_block;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_entertained(_obelisk_world: &mut World, _obelisk_entity_key: address, entertained: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.entertained = entertained;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_entertained_block(_obelisk_world: &mut World, _obelisk_entity_key: address, entertained_block: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.entertained_block = entertained_block;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_rested(_obelisk_world: &mut World, _obelisk_entity_key: address, rested: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.rested = rested;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public(friend) fun set_rested_block(_obelisk_world: &mut World, _obelisk_entity_key: address, rested_block: u64) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow_mut<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.rested_block = rested_block;
		events::emit_set(SCHEMA_ID, SCHEMA_TYPE, some(_obelisk_entity_key), *_obelisk_data)
	}

	public fun get(_obelisk_world: &World, _obelisk_entity_key: address): (String,u64,u64,u64,u64,u64,u64,u64) {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		(
			_obelisk_data.name,
			_obelisk_data.date_of_birth,
			_obelisk_data.fed,
			_obelisk_data.fed_block,
			_obelisk_data.entertained,
			_obelisk_data.entertained_block,
			_obelisk_data.rested,
			_obelisk_data.rested_block
		)
	}

	public fun get_name(_obelisk_world: &World, _obelisk_entity_key: address): String {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.name
	}

	public fun get_date_of_birth(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.date_of_birth
	}

	public fun get_fed(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.fed
	}

	public fun get_fed_block(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.fed_block
	}

	public fun get_entertained(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.entertained
	}

	public fun get_entertained_block(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.entertained_block
	}

	public fun get_rested(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.rested
	}

	public fun get_rested_block(_obelisk_world: &World, _obelisk_entity_key: address): u64 {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		let _obelisk_data = table::borrow<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key);
		_obelisk_data.rested_block
	}

	public(friend) fun remove(_obelisk_world: &mut World, _obelisk_entity_key: address) {
		let _obelisk_schema = world::get_mut_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		assert!(table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key), EEntityDoesNotExist);
		table::remove(_obelisk_schema, _obelisk_entity_key);
		events::emit_remove(SCHEMA_ID, _obelisk_entity_key)
	}

	public fun contains(_obelisk_world: &World, _obelisk_entity_key: address): bool {
		let _obelisk_schema = world::get_schema<Table<address,TamagotchiData>>(_obelisk_world, SCHEMA_ID);
		table::contains<address, TamagotchiData>(_obelisk_schema, _obelisk_entity_key)
	}
}
