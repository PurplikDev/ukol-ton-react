import { MouseEvent } from "react";
import { Result } from "../assets/Interfaces";

interface ListGroupProps {
    result: Result
    xmlDoc: string
}

// https://www.ton.eu/exports/reseller_feed_en.xml
// https://ton-config-api.epk-tech.com/v1/lists/products

function ListGroup( { result, xmlDoc } : ListGroupProps ) {
    // const reversed = items.slice().reverse();

    const xmlDocument = new DOMParser().parseFromString(xmlDoc, "text/xml")
    const items = Array.from(xmlDocument.querySelectorAll("item"))


    const listItems = items.map((item) => {

        {
            const id = item.querySelector("id")?.textContent;
            const title = item.querySelector("title")?.textContent;
            const description = item.querySelector("description")?.textContent;
            const availability = item.querySelector("availability")?.textContent;
            const condition = item.querySelector("condition")?.textContent;
            const price = item.querySelector("price")?.textContent;
            const brand = item.querySelector("brand")?.textContent;
            const image_link = item.querySelector("image_link")?.textContent;
            const gtin = item.querySelector("gtin")?.textContent;
            const item_group_id = item.querySelector("item_group_id")?.textContent;
        }

        <li  className={'list-element'}
            key="456"
            onClick={(event: MouseEvent) => { 
                // i'm sure there is more react-y way to do this.... i just don't know how
                if(event.currentTarget.classList.contains("selected")) {
                    event.currentTarget.classList.remove("selected");
                } else {
                    event.currentTarget.classList.add("selected");
                }
            }}>
            <div className="element-small">
                <div className="list-element-id">"456"</div>
                <div className="list-element-title">"456"</div>
                <div className="list-element-misc">"456"</div>
            </div>
            <div className="element-big">
                <h1>Haiiiiiiiiiiiiiiiiii</h1>
            </div>
        </li>
    })

    /*
    const listItems = result.products.map((item) =>
        <li  className={'list-element'}
            key={item.id}
            onClick={(event: MouseEvent) => { 
                // i'm sure there is more react-y way to do this.... i just don't know how
                if(event.currentTarget.classList.contains("selected")) {
                    event.currentTarget.classList.remove("selected");
                } else {
                    event.currentTarget.classList.add("selected");
                }
            }}>
            <div className="element-small">
                <div className="list-element-id">{item.id}</div>
                <div className="list-element-title">{item.name}</div>
                <div className="list-element-misc">{item.model_file_name}</div>
            </div>
            <div className="element-big">
                <h1>Haiiiiiiiiiiiiiiiiii</h1>
            </div>
        </li>
    )

    // insert some filtering stuff here and then use that for comaring

    return (
        <>
            <ul className="list-group">{listItems}</ul>
        </>
    )*/

    for(const item in  listItems) {
        console.log(item)
    }

    return <h1> ... </h1>
}

export default ListGroup;