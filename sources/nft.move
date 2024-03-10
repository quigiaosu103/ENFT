module nft_contract::nft {
    use sui::object;
    use std::string;
    use sui::tx_context;
    use sui::transfer;
    use nft_contract::url::{Url, new_unsafe_from_bytes, inner_url};
    struct WNFT has key, store {
        id: object::UID,
        name: string::String,
        link: Url,
        image_url: Url,
        description: string::String,
        creator: string::String
    }

    public fun mint(_name: vector<u8>, _link: vector<u8>, _image_url: vector<u8>, _description: vector<u8>, _creator: vector<u8>, ctx: &mut tx_context::TxContext): WNFT {
        WNFT {
            id: object::new(ctx),
            name: string::utf8(_name),
            link: new_unsafe_from_bytes(_link),
            image_url: new_unsafe_from_bytes(_image_url),
            description: string::utf8(_description),
            creator: string::utf8(_creator)
        }
    }

    public fun update_name(nft: &mut WNFT, _name: vector<u8>) {
        nft.name = string::utf8(_name);
    }

    public fun update_link(nft: &mut WNFT, _link: vector<u8>) {
        nft.link =  new_unsafe_from_bytes(_link);
    }

    public fun update_image_url(nft: &mut WNFT, _image_url: vector<u8>) {
        nft.image_url = new_unsafe_from_bytes(_image_url);
    }

    public fun get_name(nft: &WNFT): &string::String {
        &nft.name
    }

    public fun get_link(nft: &mut WNFT): &string::String {
        inner_url(&nft.link)
    }

    public fun get_image_url(nft: &WNFT): &string::String {
        inner_url(&nft.image_url)
    }

    public fun get_description(nft: &WNFT): &string::String {
        &nft.description
    }

  


    #[test_only]
    public fun mint_for_test(
        _name: vector<u8>, 
        _link: vector<u8>, 
        _image_url: vector<u8>, 
        _description: vector<u8>, 
        _creator: vector<u8>, 
        ctx: &mut tx_context::TxContext
    ): WNFT {
        mint(
            _name, 
            _link, 
            _image_url, 
            _description, 
            _creator, 
            ctx
        )
    }
}

#[test_only]
module nft_contract::nft_for_test {
    use nft_contract::nft::{Self, WNFT};
    use sui::test_scenario as ts;
    use sui::transfer;
    use std::string;

    #[test]
    public fun mint_test() {
        let add1 = @0xA;
        let add2 = @0xB;
        let scenario = ts::begin(add1);
        {
            let nft = nft::mint_for_test(
                b"name",
                b"link",
                b"image_link",
                b"des",
                b"creator",
                ts::ctx(&mut scenario),
            );
            transfer::public_transfer(nft, add1);
        };
        ts::next_tx(&mut scenario, add1);
        {
            let nft = ts::take_from_sender(&mut scenario);
            nft::update_name(&mut nft, b"new name");
            assert!(*string::bytes(nft::get_name(&nft)) == b"new name", 0);
            ts::return_to_sender(&mut scenario, nft);
        };
        // ts::next_tx(&mut scenario, add1);
        // {
        //     let nft = ts::take_from_sender(&scenario);
        //     nft::update_link(&mut nft, b"new link");
        //     assert!(*string::bytes(nft::get_link(&nft)) == b"new link", 0);
        //     ts::return_to_sender(&mut scenario, nft);
        // };
        ts::end(scenario);
    }
}