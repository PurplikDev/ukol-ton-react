import ListGroup from './components/ListGroup';
import TableController from './components/TableController';
import { useEffect, useState } from "react";

import { Result } from "./assets/Interfaces";

import xmlJs from 'xml-js';

function App() {
    const [result, setResult] = useState<Result>();
    const [xmlData, setXmlData] = useState(null);

    try {
        useEffect(() => {
            const fetchResult = async () => {
                const response = await fetch('link');
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
        fetch("link", { headers: { Accept: "application/xml" } } )
            .then((response) => response.text())
            .then((xmlText) => {
                const jsonData = xmlJs.xml2json(xmlText, { compact: true, spaces: 4 });
                setXmlData(JSON.parse(jsonData));
            })
            .catch(err => console.log(err));
    }, [])

    return <>
            <div>
{ /* @ts-ignore */ } 
                {xmlData ? ( <pre>{ JSON.stringify(xmlData.rss.channel.item, null, 4) }</pre> ) : ( <p>Loading XML data...</p> )}
            </div>
            <TableController></TableController>
            <ListGroup result={result!}></ListGroup>
        </>
    }
export default App;