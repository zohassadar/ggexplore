import { useState } from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
    const [disasm, setDisasm] = useState('');
    const [loaded, setLoaded] = useState(false);
    const [lookupTable, setLookupTable] = useState([]);

    function getLookupTable() {
        fetch('disasm.s').then((response) =>
            response.text().then((text) => {
                // [[lineno, index], ...]
                let lookup = [];
                setDisasm(text);
                let data = text.split(/\n/);
                for (let lineNo = 0; lineNo < data.length; lineNo += 1) {
                    // find address & bytes
                    let search = data[lineNo].match(
                        /; [89A-F][A-F0-9]{3} (.*)/,
                    );
                    if (search !== null) {
                        var bytes = search[1]
                            .split(' ')
                            .map((b) => parseInt(b, 16));
                        lookup.push(
                            ...[...Array(bytes.length).keys()].map((bidx) => [
                                lineNo,
                                bidx,
                            ]),
                        );
                    }
                }
                setLookupTable(lookup);
            }),
        );
    }
    if (!loaded) {
        getLookupTable();
        setLoaded(true);
    }

    return (
        <div className="App">
            <header className="App-header">
                <img src={logo} className="App-logo" alt="logo" />
                {lookupTable.length}
                <pre>{disasm}</pre>
            </header>
        </div>
    );
}

export default App;
