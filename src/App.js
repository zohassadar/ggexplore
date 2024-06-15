import SyntaxHighlighter from 'react-syntax-highlighter';
import { useState } from 'react';
import { dracula } from 'react-syntax-highlighter/dist/esm/styles/hljs/';
import opcodes from './opcodes.js';
import addressModes from './modes.js';
const { encodeNES, decodeNES } = require('./gg.js');

function App() {
    const [disasm, setDisasm] = useState('');
    const [loaded, setLoaded] = useState(false);
    const [lookupTable, setLookupTable] = useState([]);
    const [windowObj, setWindowObj] = useState('');
    const [lineNo, setLineNo] = useState(0);
    const [startNo, setStartNo] = useState(1);
    const [originalByte, setOriginalByte] = useState(null);
    const [modifiedByte, setModifiedByte] = useState(null);
    const [address, setAddress] = useState(null);
    const [ogOpcode, setOgOpcode] = useState(null);
    const [ogAddressing, setOgAddressing] = useState(null);
    const [modOpCode, setModOpcode] = useState(null);
    const [modAddressing, setModAddressing] = useState(null);

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
                        const isOpCode = false;
                        if (data[lineNo].match(/^\s+[a-z]{3}/)) {
                            isOpCode = true;
                        }
                        const bytes = search[1]
                            .split(' ')
                            .map((b) => parseInt(b, 16));
                        lookup.push(
                            ...[...Array(bytes.length).keys()].map((bidx) => [
                                lineNo,
                                bidx,
                                bytes[bidx],
                                bidx === 0 ? isOpCode : false,
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
        setLineNo(lookupTable[decoded.address][0]);
        const ogByte = lookupTable[decoded.address][2];
        setOriginalByte(ogByte);
        setModifiedByte(decoded.value);
        setAddress(decoded.address);
        setOgAddressing(null);
        setOgOpcode(null);
        setModOpcode(null);
        setModAddressing(null);
        if (lookupTable[decoded.address][3]) {
            setModOpcode(opcodes[decoded.value]);
            setModAddressing(addressModes[decoded.value]);
            setOgOpcode(opcodes[ogByte]);
            setOgAddressing(addressModes[ogByte]);
        }
    }

    return (
        <div className="App">
            <header className="App-header">
                <p>
                    <label htmlFor="gg">GG Code:</label>
                    <input
                        id="gg"
                        onChange={(e) => handleGGCode(e)}
                        onKeyDown={(e) =>
                            e.key === 'Enter' && setWindowObj(getWindow(lineNo))
                        }
                    ></input>
                </p>
                <>
                    <p>
                        Address:{' '}
                        {address !== null ? '$' + (address + 0x8000).toString(16) : ''}
                    </p>
                    <p>
                        Original:{' '}
                        {originalByte ? '$' + originalByte.toString(16) : ''}{' '}
                        {ogOpcode ? (
                            <>
                                <a
                                    href={
                                        'http://www.6502.org/tutorials/6502opcodes.html#' +
                                        ogOpcode
                                    }
                                >
                                    {ogOpcode}
                                </a>{' '}
                                {ogAddressing}
                            </>
                        ) : (
                            ''
                        )}
                    </p>
                    <p>
                        Modified:{' '}
                        {modifiedByte !== null? '$' + modifiedByte.toString(16) : ''}{' '}
                        {ogOpcode ? (
                            modAddressing ? (
                                <>
                                    <a
                                        href={
                                            'http://www.6502.org/tutorials/6502opcodes.html#' +
                                            modOpCode
                                        }
                                    >
                                        {modOpCode}
                                    </a>{' '}
                                    {modAddressing}
                                </>
                            ) : (
                                <>
                                    <a
                                        href={
                                            'https://www.masswerk.at/6502/6502_instruction_set.html#' +
                                            modOpCode
                                        }
                                    >
                                        {modOpCode}
                                    </a>{' '}
                                    {' illegal!'}
                                </>
                            )
                        ) : (
                            ''
                        )}
                    </p>
                </>
                <p>
                    <button onClick={() => setWindowObj(getWindow(lineNo))}>
                        show code
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
