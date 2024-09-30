import ListGroup from './components/ListGroup';
import TableController from './components/TableController';
import { useEffect, useState } from "react";

import { Result } from "./assets/Interfaces";

function App() {
    const [result, setResult] = useState<Result>();
    const [xmlData, setXmlData] = useState(null);

    try {
        useEffect(() => {
            const fetchResult = async () => {
                const response = await fetch('https://ton-config-api.epk-tech.com/v1/lists/products');
                const result = await response.json() as Result;
                setResult(result);
            }
            fetchResult();
        });
    } catch(e: any) {
        if (e.anem === "AbortError") {
            return;
        }
    }

    

    // XML ATTEMPT!!!!!!!!!!!!

    useEffect(() => {
        fetch('https://www.ton.eu/exports/reseller_feed_en.xml', { headers: { Accept: "application/xml" } } )
            .then((response) => response.text())
            .then((xmlText) => {
                { /* @ts-ignore */ } 
                setXmlData(xmlText)
            })
            .catch(err => console.log(err));
    }, [])

    return <>
            <div>
{ /* @ts-ignore */ } 
                {/* xmlData ? ( <pre>{ JSON.stringify(xmlData.rss.channel.item, null, 4) }</pre> ) : ( <p>Loading XML data...</p> ) */ }
            </div>
            <TableController></TableController>
            { <ListGroup result={result!} xmlDoc={xmlData!}></ListGroup> }
        </>
    }
export default App;