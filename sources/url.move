module nft_contract::url {
    use std::string;
    
    
    struct Url has store, drop {
        url: string::String
    }

    public  fun new_unsafe_from_bytes(_url: vector<u8>): Url {
        let str = string::utf8(_url);
        Url{
            url: str
        }
    }

    public fun inner_url(url: &Url): &string::String  {
        &url.url
    }
}