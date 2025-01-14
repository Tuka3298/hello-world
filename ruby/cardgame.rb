class Card
    def initialize(k, c, p)
        @kind=k; @cost=c; @power=p
    end
    def getkind
        return @kind
    end
    def getcost
        return @cost
    end
    def getpower
        return @power
    end
    def getname
        return "#{@kind}_#{@cost}_#{@power}"
    end
end

def tutorial
    printf ("
    これはspを消費して相手に攻撃を行い，相手のlifeを0以下にすることを目的とするカードゲームである．\n
    カードは，チャージャー，アタッカー，ディフェンダー，ヒーラーの4種類に分けられ，それぞれspの回復，相手への攻撃，相手の攻撃の防御，自分のlifeの回復の役割を持つ．\n
    カードはx_n_mのように表示され，xは種族(それぞれc,a,d,hで表される)を表し，nはそのカードのcost，すなわちspの消費量を表し，mはそのカードのpowerを表す．\n
    powerはそれぞれspの回復量，攻撃力，防御力，lifeの回復量を表す．\n
    ディフェンダーは相手がアタッカーの時のみ有効であり，自分の防御力から相手の攻撃力を引いた分だけ相手にダメージを与える．相手の攻撃力が自分の防御力より高い場合は，その差分だけダメージを受ける．\n
    デッキは24枚からなり，手札は4枚である．山札も手札も0枚となった時点で敗北となる．プレーヤーは手札から1枚カードを選び，そのカードを場に出す．\n
    カードを選ぶときは，そのカードがある場所の番号を入力する．なお，spが足りずカードを場に出せない場合は，手札のうち1枚を破壊する．\n")
end

def swap(a,i,j)
    x=a[i]; a[i]=a[j]; a[j]=x
end
def shuffle(a)
    (a.length-1).step(1,-1) do |i|
        swap(a,i,rand(i+1))
    end
end

def make_deck
    $deck_a=[
    c_0_8_1=Card.new("c", 0, 8),
    c_0_8_2=Card.new("c", 0, 8),
    c_0_8_3=Card.new("c", 0, 8),
    c_0_6_1=Card.new("c", 0, 6),
    c_0_6_2=Card.new("c", 0, 6),
    c_0_6_3=Card.new("c", 0, 6),
    c_4_14_1=Card.new("c", 4, 14),
    c_4_14_2=Card.new("c", 4, 14),
    c_4_14_3=Card.new("c", 4, 14),
    a_2_7_1=Card.new("a", 2, 7),
    a_2_7_2=Card.new("a", 2, 7),
    a_2_7_3=Card.new("a", 2, 7),
    a_4_10_1=Card.new("a", 4, 10),
    a_4_10_2=Card.new("a", 4, 10),
    a_4_10_3=Card.new("a", 4, 10),
    d_4_12_1=Card.new("d", 4, 12),
    d_4_12_2=Card.new("d", 4, 12),
    d_4_12_3=Card.new("d", 4, 12),
    d_6_18_1=Card.new("d", 6, 18),
    d_6_18_2=Card.new("d", 6, 18),
    d_6_18_3=Card.new("d", 6, 18),
    h_8_5_1=Card.new("h", 8, 5),
    h_8_5_2=Card.new("h", 8, 5),
    h_8_5_3=Card.new("h", 8, 5)
    ]
    $deck_b=Marshal.load(Marshal.dump($deck_a))
    shuffle($deck_a); shuffle($deck_b)
end


def cardgame
    printf("Would you want to read a tutorial?(y/n) "); yn=gets
    if yn=="y\n"
        tutorial
        sleep(1)
    end
    printf("Do you want to play with bot?(y/n) "); yn=gets
    if yn=="y\n"
        bot=1
    else
        bot=0
    end
    make_deck
    nocard=Card.new(0, 0, 0)
    as1=$deck_a.pop; as2=$deck_a.pop; as3=$deck_a.pop; as4=$deck_a.pop
    a1 =as1.getname; a2 =as2.getname; a3 =as3.getname; a4 =as4.getname
    bs1=$deck_b.pop; bs2=$deck_b.pop; bs3=$deck_b.pop; bs4=$deck_b.pop
    b1 =bs1.getname; b2 =bs2.getname; b3 =bs3.getname; b4 =bs4.getname
    ar=$deck_a.length
    br=$deck_b.length
    al=24; as=4; afs=nocard; af="_"
    bl=24; bs=4; bfs=nocard; bf="_"
    if rand(2)==0
        t=0
    else
        t=1
    end
    turn=1
    while true
        if turn%2==t
            at="first"
            bt="second"
        else
            at="second"
            bt="first"
        end
        ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
        hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
        pa=["life: #{al}", "sp: #{as}", "#{at}"]
        pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
        fa=["#{af}"]
        fb=["#{bf}"]
        printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
        if a1=="_" && b1=="_" 
            return "Drow!"
        elsif a1=="_"
            return "A lose!"
        elsif b1=="_"
            return "B lose!"
        end
        if as>=as1.getcost || as>=as2.getcost || as>=as3.getcost || as>=as4.getcost
            while true do
                printf("Which card do A use? "); a=gets.to_i
                if a==1
                    if as>=as1.getcost
                        afs, as1, as2, as3 = as1, as2, as3, as4; af, a1, a2, a3 = a1, a2, a3, a4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif a==2
                    if as>=as2.getcost
                        afs, as2, as3 = as2, as3, as4; af, a2, a3 = a2, a3, a4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif a==3
                    if as>=as3.getcost
                        afs, as3 = as3, as4; af, a3 = a3, a4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif a==4
                    if as>=as4.getcost
                        afs = as4; af = a4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                else
                    printf("Please enter a valid value.\n")
                end
            end
        else
            while true do
                printf("Which card do A break? "); a=gets.to_i
                if a==1
                    as1, as2, as3 = as2, as3, as4; a1, a2, a3 = a2, a3, a4
                    break
                elsif a==2
                    as2, as3 = as3, as4; a2, a3 = a3, a4
                    break
                elsif a==3
                    as3 = as4; a3 = a4
                    break
                elsif a==4
                    break
                else
                    printf("Please enter a valid value.\n")
                end
            end
        end
        if bs>=bs1.getcost || bs>=bs2.getcost || bs>=bs3.getcost || bs>=bs4.getcost
            while true do
                if bot==0 then printf("Which card do B use? "); b=gets.to_i else b=rand(4)+1 end
                if b==1
                    if bs>=bs1.getcost
                        bfs, bs1, bs2, bs3 = bs1, bs2, bs3, bs4; bf, b1, b2, b3 = b1, b2, b3, b4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif b==2
                    if bs>=bs2.getcost
                        bfs, bs2, bs3 = bs2, bs3, bs4; bf, b2, b3 = b2, b3, b4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif b==3
                    if bs>=bs3.getcost
                        bfs, bs3 = bs3, bs4; bf, b3 = b3, b4
                        break
                    else
                         printf("You don't have enough sp. Please select other card.\n")
                    end
                elsif b==4
                    if bs>=bs4.getcost
                        bfs = bs4; bf = b4
                        break
                    else
                        printf("You don't have enough sp. Please select other card.\n")
                    end
                else
                    printf("Please enter a valid value.\n")
                end
            end
        else
            while true do
                if bot==0 then printf("Which card do B break? "); b=gets.to_i else b=rand(4)+1 end
                if b==1
                    bs1, bs2, bs3 = bs2, bs3, bs4; b1, b2, b3 = b2, b3, b4
                    break
                elsif b==2
                    bs2, bs3 = bs3, bs4; b2, b3 = b3, b4
                    break
                elsif b==3
                    bs3 = bs4; b3 = b4
                    break
                elsif b==4
                    break
                else
                    printf("Please enter a valid value.\n")
                end
            end
        end
        ar=$deck_a.length
        br=$deck_b.length
        if ar>0
            as4=$deck_a.pop; a4=as4.getname
        else
            as4=nocard; a4="_"
        end
        if br>0
            bs4=$deck_b.pop; b4=bs4.getname
        else
            bs4=nocard; b4="_"
        end
        ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
        hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
        pa=["life: #{al}", "sp: #{as}", "#{at}"]
        pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
        fa=["#{af}"]
        fb=["#{bf}"]
        printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
        if at=="first"
            if    afs.getkind=="c"
                as+=afs.getpower-afs.getcost
            elsif afs.getkind=="a"
                as-=afs.getcost
                if bfs.getkind=="d" && afs.getpower>bfs.getpower
                    bl-=afs.getpower-bfs.getpower
                elsif bfs.getkind=="d" && afs.getpower<=bfs.getpower
                    al-=bfs.getpower-afs.getpower
                else
                    bl-=afs.getpower
                end
            elsif afs.getkind=="h"
                as-=afs.getcost
                al+=afs.getpower
            elsif afs.getkind==="d"
                as-=afs.getcost
            end
            ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
            hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
            pa=["life: #{al}", "sp: #{as}", "#{at}"]
            pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
            fa=["#{af}"]
            fb=["#{bf}"]
            printf("---------------------------------------------------\n")
            printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
            sleep(1)
            if al<=0 then return "A lose!" end
            if bl<=0 then return "B lose!" end
            if    bfs.getkind=="c"
                bs+=bfs.getpower-bfs.getcost
            elsif bfs.getkind=="a"
                bs-=bfs.getcost
                if afs.getkind=="d" && bfs.getpower>afs.getpower
                    al-=bfs.getpower-afs.getpower
                elsif afs.getkind=="d" && bfs.getpower<=afs.getpower
                    bl-=afs.getpower-bfs.getpower
                else
                    al-=bfs.getpower
                end
            elsif bfs.getkind=="h"
                bs-=bfs.getcost
                bl+=bfs.getpower
            elsif bfs.getkind==="d"
                bs-=bfs.getcost
            end
            ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
            hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
            pa=["life: #{al}", "sp: #{as}", "#{at}"]
            pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
            fa=["#{af}"]
            fb=["#{bf}"]
            printf("---------------------------------------------------\n")
            printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
            sleep(1)
            if al<=0 then return "A lose!" end
            if bl<=0 then return "B lose!" end
        else
            if    bfs.getkind=="c"
                bs+=bfs.getpower-bfs.getcost
            elsif bfs.getkind=="a"
                bs-=bfs.getcost
                if afs.getkind=="d" && bfs.getpower>afs.getpower
                    al-=bfs.getpower-afs.getpower
                elsif afs.getkind=="d" && bfs.getpower<=afs.getpower
                    bl-=afs.getpower-bfs.getpower
                else
                    al-=bfs.getpower
                end
            elsif bfs.getkind=="h"
                bs-=bfs.getcost
                bl+=bfs.getpower
            elsif bfs.getkind==="d"
                bs-=bfs.getcost
            end
            ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
            hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
            pa=["life: #{al}", "sp: #{as}", "#{at}"]
            pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
            fa=["#{af}"]
            fb=["#{bf}"]
            printf("---------------------------------------------------\n")
            printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
            sleep(1)
            if al<=0 then return "A lose!" end
            if bl<=0 then return "B lose!" end
            if    afs.getkind=="c"
                as+=afs.getpower-afs.getcost
            elsif afs.getkind=="a"
                as-=afs.getcost
                if bfs.getkind=="d" && afs.getpower>bfs.getpower
                    bl-=afs.getpower-bfs.getpower
                elsif bfs.getkind=="d" && afs.getpower<=bfs.getpower
                    al-=bfs.getpower-afs.getpower
                else
                    bl-=afs.getpower
                end
            elsif afs.getkind=="h"
                as-=afs.getcost
                al+=afs.getpower
            elsif afs.getkind==="d"
                as-=afs.getcost
            end
            ha=["rest: #{ar}", "1: #{a1}", "2: #{a2}", "3: #{a3}", "4: #{a4}"]
            hb=["rest: #{br}", "1: #{b1}", "2: #{b2}", "3: #{b3}", "4: #{b4}"]
            pa=["life: #{al}", "sp: #{as}", "#{at}"]
            pb=["life: #{bl}", "sp: #{bs}", "#{bt}"]
            fa=["#{af}"]
            fb=["#{bf}"]
            printf("---------------------------------------------------\n")
            printf("%s\n%s\n%s\n%s\n%s\n%s\n", ha, pa, fa, fb, pb, hb)
            sleep(1)
            if al<=0 then return "A lose!" end
            if bl<=0 then return "B lose!" end
        end
        printf("---------------------------------------------------\n")
        ar=$deck_a.length
        br=$deck_b.length
        afs=nocard; af="_"
        bfs=nocard; bf="_"
        turn+=1
    end
end
