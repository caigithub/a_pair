"=======================================
"a pair
"=======================================

vnoremap ap <esc>:call SelectPair('false')<cr>
onoremap ap :call SelectPair('false')<cr>
vnoremap ip <esc>:call SelectPair('true')<cr>
onoremap ip :call SelectPair('true')<cr>

function SelectPair( inside )
    let l:jump_line = 0
    let l:jump_col = 0

    let [ l:jump_line, l:jump_col ] = FindPos( '(', ')', l:jump_line, l:jump_col )
    let [ l:jump_line, l:jump_col ] = FindPos( '{', '}', l:jump_line, l:jump_col )
    let [ l:jump_line, l:jump_col ] = FindPos( '\[', '\]', l:jump_line, l:jump_col )

    if IsEmptyPos( l:jump_line, l:jump_col )
        echo 'no pair found'
        return
    endif
    
    call cursor( l:jump_line, l:jump_col )   
    if a:inside == 'true'
        normal! v%l
    else
        normal! %v%
    endif

endfunction

function FindPos( begin, end, jump_line, jump_col )
    let [ l:buff, l:l_0 , l:c_0, l:what ] = getpos('.')
    let [ l:l_1 , l:c_1 ] = searchpairpos( a:begin , '', a:end , 'cn')
    
    if IsEmptyPos( l:l_1 , l:c_1 ) == 0
        if IsEmptyPos( a:jump_line, a:jump_col )
            return [ l:l_1 , l:c_1 ]
        else
            return ComparePos( l:l_1, l:c_1, a:jump_line, a:jump_col, l:l_0, l:l_1 )
        endif
    else
        return [a:jump_line, a:jump_col]
    endif
endfunction

function IsEmptyPos( line, pos )
    return a:line == 0 && a:pos == 0
endfunction

function ComparePos( line1, column1, line2, column2, base_line, base_column )
    if abs( a:line1 - a:base_line ) > abs( a:line2 - a:base_line )
        return [ a:line2, a:column2 ]
    endif

    if abs( a:line1 - a:base_line ) < abs( a:line2 - a:base_line )
        return [ a:line1, a:column1 ]
    endif

    if abs( a:column1 - a:base_column ) > abs( a:column2 - a:base_column )
        return [ a:line2, a:column2 ]
    endif

    if abs( a:column1 - a:base_column ) < abs( a:column2 - a:base_column )
        return [ a:line1, a:column1 ]
    endif

    return [ a:line1, a:column1 ]
endfunction
