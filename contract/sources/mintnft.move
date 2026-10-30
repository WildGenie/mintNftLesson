/// Module: mintnft
module mintnft::mintnft;

use std::string::String;
use sui::display::{Self, Display};
use sui::event;
use sui::object::id;
use sui::package::Publisher;

// === Imports ===

// === Imports ===

// === Structs ===

/// Owned Object - NFT cane be accessed and modified by the owner
public struct Nft has key, store {
    // TODO: Add the fields for the NFT
    // 1. The id of the NFT
    // 2. The name of the NFT
    // 3. The description of the NFT
    // 4. The url of the NFT
    id: object::UID,
    name: String,
    description: String,
    url: String,
}

// Shared Object - Addresses that minted NFTs will be stored and everyone can access and modify it
public struct MintAddresses has key, store {
    // TODO: Add the fields for the MintAddresses
    // 1. The id of the MintAddresses object
    // 2. The addresses of the addresses that minted NFTs
    id: UID,
    addresses: vector<address>,
}

// Immutable Object - No one can modify this object
public struct NftMetadata has key, store {
    // TODO: Add the fields for the NftMetadata
    // 1. The id of the NftMetadata object
    // 2. The time stamp of the NftMetadata object
    id: UID,
    timestamp: u64,
}

// ===OTW===
// TODO: Add the OTW for the package
public struct MINTNFT has drop {}

// === Events ===
public struct MintNftEvent has copy, drop {
    // TODO: Add the fields for the MintNftEvent
    // 1. The id of the NFT
    // 2. The name of the NFT
    id: ID,
    name: String,
}

// ===Initializers===
fun init(otw: MINTNFT, ctx: &mut TxContext) {
    // TODO: Create a MintAddresses object
    let mintAddresses = MintAddresses {
        id: object::new(ctx),
        addresses: vector::empty(),
    };

    // TODO: Claim package publisher rights
    let publisher: Publisher = sui::package::claim(otw, ctx);

    // TODO: Set up NFT display object with metadata fields
    let mut display: Display<Nft> = display::new<Nft>(&publisher, ctx);

    display.add(b"name".to_string(), b"{name}".to_string());
    display.add(b"description".to_string(), b"{description}".to_string());
    display.add(b"image_url".to_string(), b"{url}".to_string());

    display.update_version();

    // TODO: Transfer display and publisher to sender, share MintAddresses
    transfer::public_transfer(display, ctx.sender());
    transfer::public_transfer(publisher, ctx.sender());

    // TODO: Share MintAddresses object
    transfer::share_object(mintAddresses);
}

// === Public Functions ===

public entry fun mint(
    mintAddresses: &mut MintAddresses,
    name: String,
    url: String,
    ctx: &mut TxContext,
) {
    // TODO: Create a new NFT object with name, description and url
    let nft = Nft {
        id: object::new(ctx),
        name: name,
        description: b"Koza DAO NFT".to_string(),
        url: url,
    };

    // TODO: Emit mint event with NFT id and name
    event::emit(MintNftEvent {
        id: id(&nft),
        name: name,
    });

    // TODO: Transfer NFT to minter
    transfer::public_transfer(nft, ctx.sender());

    // TODO: Add minter address to tracking list
    vector::push_back(&mut mintAddresses.addresses, ctx.sender());

    // TODO: Create immutable metadata object with timestamp
    let nftMetadata = NftMetadata {
        id: object::new(ctx),
        timestamp: sui::tx_context::epoch_timestamp_ms(ctx),
    };

    // TODO: Transfer metadata object to minter
    transfer::public_transfer(nftMetadata, ctx.sender());
}

//Update Nft Name ------> This will not throw an error as it is a mutable object but only the owner can update it
public entry fun update_nft(nft: &mut Nft, name: String) {
    // TODO: Update the NFT name with the new name
    nft.name = name;
}

// Update the nft metadata ------> This will not updated as it is a freezed object
public entry fun update_nft_metadata(nftMetadata: &mut NftMetadata, ctx: &mut TxContext) {
    // TODO: Update the metadata timestamp (Note: This will fail since object is frozen)
    nftMetadata.timestamp = sui::tx_context::epoch_timestamp_ms(ctx);
}
