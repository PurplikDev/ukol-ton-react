import { MouseEvent } from "react";
import { Result } from "../assets/Interfaces";

interface ListGroupProps {
    result: Result
}

// https://www.ton.eu/exports/reseller_feed_en.xml
// https://ton-config-api.epk-tech.com/v1/lists/products

function ListGroup( {result } : ListGroupProps ) {
    // const reversed = items.slice().reverse();

    if(result == null) {
        return ( <h2>erm.... oopsie... </h2>)
    }

    const listItems = result.products.map((item, index) =>
        <li  className={'list-element'}
            key={item.id}
            onClick={(event: MouseEvent) => { 
                console.log(index)
                // i'm sure there is more react-y way to do this.... i just don't know how
                if(event.currentTarget.classList.contains("selected")) {
                    event.currentTarget.classList.remove("selected");
                } else {
                    event.currentTarget.classList.add("selected");
                }
            }}>
            
            <div className="list-element-id">{item.id}</div>
            <div className="list-element-title">{item.name}</div>
            <div className="list-element-misc">{item.product_type}</div>
        </li>
    )

    // insert some filtering stuff here and then use that for comaring

    return (
        <>
            { result.products.length === 0 && <h2>No items found!</h2> }
            <ul className="list-group">{listItems}</ul>
        </>
    )
}

export default ListGroup;