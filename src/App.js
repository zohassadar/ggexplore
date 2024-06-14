import SyntaxHighlighter from 'react-syntax-highlighter';
import { useState } from 'react';
import { dracula } from 'react-syntax-highlighter/dist/esm/styles/hljs/';

function App() {
    const [disasm, setDisasm] = useState('');
    const [loaded, setLoaded] = useState(false);
    const [lookupTable, setLookupTable] = useState([]);
    const [windowObj, setWindowObj] = useState('');
    const [ggCode, setGgCode] = useState('ZZZZZZ');
    function getWindow(lineNo) {
        const newWindow = [];
        const disasmLines = disasm.split(/\n/);
        const start = Math.max(lineNo - 20, 0);
        const end = Math.min(lineNo + 20, disasmLines.length);
        console.log(`Start line: ${start} End line: ${end}`);
        newWindow.push(...disasmLines.slice(start, lineNo));
        newWindow.push(...disasmLines.slice(lineNo, end));
        console.log(newWindow.length);
        return newWindow.join('\n');
    }
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

    function handleGGCode(event) {
        setGgCode(event.target.value);
    }

    return (
        <div className="App">
            <header className="App-header">
                {lookupTable.length}
                <p>
                    <label htmlFor="gg">GG:</label>
                    <input id="gg" onChange={(e) => handleGGCode(e)}></input>
                </p>
                <p>
                    GG Code: <pre> {ggCode}</pre>
                </p>
                <p>
                    <button onClick={() => setWindowObj(getWindow(300))}>
                        click
                    </button>
                </p>
                <SyntaxHighlighter
                    children={windowObj}
                    language="x86asm"
                    style={dracula}
                />
            </header>
        </div>
    );
}

export default App;
