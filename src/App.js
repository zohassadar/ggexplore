import SyntaxHighlighter from 'react-syntax-highlighter';
import { useState } from 'react';
import { dracula } from 'react-syntax-highlighter/dist/esm/styles/hljs/';

const { encodeNES, decodeNES } = require('./gg.js');

function App() {
    const [disasm, setDisasm] = useState('');
    const [loaded, setLoaded] = useState(false);
    const [lookupTable, setLookupTable] = useState([]);
    const [windowObj, setWindowObj] = useState('');
    const [ggCode, setGgCode] = useState('...');
    const [lineNo, setLineNo] = useState(0);
    const [startNo, setStartNo] = useState(1);
    function getWindow(lineNo) {
        const newWindow = [];
        const disasmLines = disasm.split(/\n/);
        const start = Math.max(lineNo - 20, 0);
        const end = Math.min(lineNo + 20, disasmLines.length);
        console.log(`Start line: ${start} End line: ${end}`);
        newWindow.push(...disasmLines.slice(start, lineNo));
        newWindow.push(...disasmLines.slice(lineNo, end));
        console.log(newWindow.length);
        setStartNo(start + 1);
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
        const code = event.target.value;
        const decoded = decodeNES(code);
        setGgCode(
            `Address: 0x${(decoded.address + 0x8000).toString(
                16,
            )} Value: 0x${decoded.value.toString(16)}`,
        );
        setLineNo(lookupTable[decoded.address][0]);
    }

    return (
        <div className="App">
            <header className="App-header">
                <p>
                    <label htmlFor="gg">GG Code:</label>
                    <input id="gg" onChange={(e) => handleGGCode(e)}></input>
                </p>
                <pre> {ggCode}</pre>
                <p>
                    <button onClick={() => setWindowObj(getWindow(lineNo))}>
                        click
                    </button>
                </p>
                {windowObj && (
                    <SyntaxHighlighter
                        children={windowObj}
                        language="x86asm"
                        showLineNumbers={true}
                        startingLineNumber={startNo}
                        style={dracula}
                        wrapLines={true}
                        lineProps={(lineNumber) => {
                            const style = {
                                display: 'block',
                                width: 'fit-content',
                            };
                            console.log(`lineNumber= ${lineNumber}`);
                            console.log('HELLO');
                            if (lineNumber === lineNo + 1) {
                                style.backgroundColor = '#284a56'; //#282a36
                            }
                            return { style };
                        }}
                    />
                )}
            </header>
        </div>
    );
}

export default App;
