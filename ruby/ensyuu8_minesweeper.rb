def make_board(i,j,n)
    board=Array.new(i) {Array.new(j,0)}
    c=0
    while c<n do
        ri=rand(i); rj=rand(j)
        if board[ri][rj]!=1
            board[ri][rj]=1
            c+=1
        end
    end
    return board
end

def sweep(board)
    m=board.length
    n=board[0].length
    output=[]
    0.step(m-1) do |i|
        row=[]
        0.step(n-1) do |j|
            row.push(count(board, i,j))
        end
        output.push(row)
    end
    return output
end

def count(board, i, j)
    return "b" if board[i][j]==1
    di=[-1,-1,-1, 0, 0, 1, 1, 1]
    dj=[-1, 0, 1,-1, 1,-1, 0, 1]
    cnt=0
    0.step(7) do |k|
        cnt+=board[i+di[k]][j+dj[k]] if inside(board, i+di[k], j+dj[k])
    end
    return "#{cnt}"
end

def inside(board, i, j)
    return i>-1 && i<board.length && j>-1 && j<board[0].length
end


def minesweeper (i=5,j=10,n=5)
    board=make_board(i,j,n)
    swp=sweep(board)
    stage=Marshal.load(Marshal.dump(swp))
    mass=0
    stage.each_index do |k|
        stage[0].each_index do |l|
            if stage[k][l]!="0"
                stage[k][l]="_"
                mass+=1
            end
        end
    end
    c=0
    while c<mass-n do
        stage.each_index do |m|
        printf("#{stage[m]}\n")
        end
        printf("where open?(0<=x<=#{stage[0].length-1}) "); x=gets.to_i
        printf("where open?(0<=y<=#{stage.length-1}) "); y=gets.to_i
        if 0<=x && x<=stage[0].length-1 && 0<=y && y<=stage.length-1
            if stage[y][x]=="_"
                if swp[y][x]=="b"
                    swp.each_index do |m|
                    printf("#{swp[m]}\n")
                    end
                    puts "failure!"
                    return
                else
                    stage[y][x]=swp[y][x]
                    c+=1
                end
            else
                puts "please open new place. "
            end
        else
            puts "please enter valid values. "
        end
    end
    swp.each_index do |m|
    printf("#{swp[m]}\n")
    end
    puts "success! "
    return
end
