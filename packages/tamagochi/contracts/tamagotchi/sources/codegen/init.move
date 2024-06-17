module tamagotchi::init {
    use std::ascii::string;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use tamagotchi::world;
	use tamagotchi::tamagotchi_schema;
	use tamagotchi::tamagotchi_manager_schema;

    fun init(ctx: &mut TxContext) {
        let (_obelisk_world, admin_cap) = world::create(string(b"Tamagotchi"), string(b"Tamagotchi"),ctx);

        // Add Schema
		tamagotchi_schema::register(&mut _obelisk_world, &admin_cap, ctx);
		tamagotchi_manager_schema::register(&mut _obelisk_world, &admin_cap, ctx);

        transfer::public_share_object(_obelisk_world);
        transfer::public_transfer(admin_cap, tx_context::sender(ctx));
    }

    #[test_only]
    public fun init_world_for_testing(ctx: &mut TxContext){
        init(ctx)
    }
}
