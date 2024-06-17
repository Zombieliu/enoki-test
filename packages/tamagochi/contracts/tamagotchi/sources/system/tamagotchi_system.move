module tamagotchi::tamagotchi_system {
    use std::ascii::{String, into_bytes};
    use std::vector;
    use tamagotchi::tamagotchi_manager_schema;
    use sui::tx_context::{sender, TxContext};
    use tamagotchi::tamagotchi_schema;
    use tamagotchi::entity_key::{from_address_with_seed};
    use sui::clock::{timestamp_ms, Clock};
    use tamagotchi::world::World;
    use tamagotchi::tamagotchi_schema::{set_fed,set_fed_block, get_fed, get_fed_block, get_date_of_birth,
         get_rested_block, get_entertained_block, get_rested, set_rested_block, set_rested, get_entertained,
        set_entertained_block
    };

    const HUNGER_PER_BLOCK: u64 = 1;
    const BOREDOM_PER_BLOCK: u64 = 2;
    const ENERGY_PER_BLOCK: u64 = 2;

    const FILL_PER_FEED: u64 = 2_000;
    const FILL_PER_ENTERTAINMENT: u64 = 2_000;
    const FILL_PER_SLEEP: u64 = 2_000;

    const MAX_VALUE: u64 = 10_000;

    public entry fun claim(world:&mut World,name:String,clock: &Clock,ctx:&mut TxContext){
        let time_stamp = timestamp_ms(clock);
        let entity_key = from_address_with_seed(sender(ctx),into_bytes(name));
        // if not cotains -> add ,if cotains -> no update
        if (!tamagotchi_schema::contains(world,entity_key)){
            tamagotchi_schema::set(
                world,
                entity_key,
                name,
                time_stamp,
                MAX_VALUE,
                time_stamp,
                MAX_VALUE,
                time_stamp,
                MAX_VALUE,
                time_stamp
            );
        };
        // if not cotains -> add ,if cotains -> update
        if (!tamagotchi_manager_schema::contains(world,sender(ctx))){
            tamagotchi_manager_schema::set(world,sender(ctx),vector::singleton(entity_key));
        }else {
            let entity_key_list = tamagotchi_manager_schema::get(world,sender(ctx));
            // if not cotains -> add ,if contains not update
            if (!vector::contains(&entity_key_list, &entity_key)) {
                vector::push_back(&mut entity_key_list, entity_key);
                tamagotchi_manager_schema::set(world, sender(ctx), entity_key_list);
            };
        };

    }

    public entry fun feed(world:&mut World,name:String,clock: &Clock,ctx:&mut TxContext){
        let entity_key = from_address_with_seed(sender(ctx),into_bytes(name));
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let new_fed = calculate_new_hunger(world,entity_key,clock);
        set_fed_block(world,entity_key,timestamp_ms(clock));
        if (new_fed > MAX_VALUE){
            set_fed(world,entity_key,MAX_VALUE)
        }else {
            set_fed(world,entity_key,new_fed)
        }
    }

    public entry fun play(world:&mut World,name:String,clock: &Clock,ctx:&mut TxContext){
        let entity_key = from_address_with_seed(sender(ctx),into_bytes(name));
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let new_entertained = calculate_new_boredom(world,entity_key,clock);
        set_entertained_block(world,entity_key,timestamp_ms(clock));
        if (new_entertained > MAX_VALUE){
            set_fed(world,entity_key,MAX_VALUE)
        }else {
            set_fed(world,entity_key,new_entertained)
        }
    }

    public entry fun sleep(world:&mut World,name:String,clock: &Clock,ctx:&mut TxContext) {
        let entity_key = from_address_with_seed(sender(ctx),into_bytes(name));
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let new_rested = calculate_new_energy(world,entity_key,clock);
        set_rested_block(world, entity_key,timestamp_ms(clock));
        if (new_rested > MAX_VALUE){
            set_rested(world, entity_key,MAX_VALUE)
        }else {
            set_rested(world, entity_key,new_rested)
        }
    }

    public fun get_age(world:&World,entity_key:address,clock: &Clock):u64{
        timestamp_ms(clock) - get_date_of_birth(world, entity_key)
    }

    public fun calculate_new_hunger(world:&mut World,entity_key:address,clock: &Clock) : u64 {
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let fed = get_fed(world,entity_key);
        let new_fed = fed + FILL_PER_FEED - calculate_hunger(world,entity_key,clock);
        if (new_fed > MAX_VALUE){
            MAX_VALUE
        }else {
          new_fed
        }
    }

    public fun calculate_new_boredom(world:&mut World,entity_key:address,clock: &Clock) : u64 {
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let entertained = get_entertained(world, entity_key);
        let new_entertained = entertained + FILL_PER_ENTERTAINMENT - calculate_boredom(world,entity_key,clock);
        if (new_entertained > MAX_VALUE){
          MAX_VALUE
        }else {
          new_entertained
        }
    }

    public fun calculate_new_energy(world:&mut World,entity_key:address,clock: &Clock) : u64 {
        assert!(!tmg_is_dead(world,entity_key,clock),0);
        let rested = get_rested(world, entity_key);
        let new_rested = rested + FILL_PER_SLEEP - calculate_energy(world,entity_key,clock);
        if (new_rested > MAX_VALUE){
          MAX_VALUE
        }else {
          new_rested
        }
    }

    fun calculate_hunger(world:&World,entity_key:address,clock: &Clock) : u64 {
        let time_stamp = timestamp_ms(clock);
        HUNGER_PER_BLOCK * ((time_stamp- get_fed_block(world, entity_key)) / 1_000)
    }


    fun calculate_boredom(world:&World,entity_key:address,clock: &Clock) : u64 {
        let time_stamp = timestamp_ms(clock);
        BOREDOM_PER_BLOCK * ((time_stamp- get_entertained_block(world, entity_key)) / 1_000)
    }

    fun calculate_energy(world:&World,entity_key:address,clock: &Clock) : u64 {
        let time_stamp = timestamp_ms(clock);
        ENERGY_PER_BLOCK * ((time_stamp- get_rested_block(world, entity_key)) / 1_000)
    }

    public fun tmg_is_dead(world:&mut World,entity_key:address,clock: &Clock) : bool {
        let fed = calculate_hunger(world,entity_key,clock);
        let entertained = calculate_boredom(world,entity_key,clock);
        let rested = calculate_energy(world,entity_key,clock);
        fed == 0 && entertained == 0 && rested == 0
    }

}
