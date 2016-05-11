# encoding: utf-8

class Bf_Interpreter
  
  def initialize()
    @m_arr = Array.new(100, 0) # @m_arr: メモリ領域(サイズは適当、0で初期化)
    @m_ptr = 0 # @m_ptr: メモリのポインタ（初期位置は0番目）
  end

  def set_command(line)
    @c_ptr = 0 # @c_ptr: コマンドのポインタ（初期位置は0番目）
    @c_arr = line.chars # @c_arr: １バイトずつのコマンドの配列
  end

  def exec()
    while (@c_ptr != @c_arr.size) do
      command = @c_arr[@c_ptr]

      case command
      when ">" 
        @m_ptr += 1 if @m_ptr < @m_arr.size
      when "<"
        @m_ptr -= 1 if @m_ptr > 0
      when "+"
        @m_arr[@m_ptr] += 1 if @m_arr[@m_ptr] <= 255 # 1バイトなので最大値は255
      when "-"
        @m_arr[@m_ptr] -= 1 if @m_arr[@m_ptr] > 0
      when "."
        print @m_arr[@m_ptr].chr # バイトコードをASCII文字に変換して出力
      when ","
        @m_arr[@m_ptr] = gets.bytes[0] #先頭の1バイトだけバイトコードを取得して残りは無視
      when "["
        # メモリのポインタが指す値が0なら]までジャンプ
        if @m_arr[@m_ptr] == 0
          dep = 0
          (@c_ptr+1).upto(@c_arr.size) do |i|
            if dep == 0 && @c_arr[i] == "]"
              @c_ptr = i
            elsif @c_arr[i] == "["
              dep += 1
            elsif @c_arr[i] == "]"
              dep -= 1
            end
          end
        end
      when "]"
        # メモリのポインタが指す値が0以外なら対応する[まで戻って繰返す
        if @m_arr[@m_ptr] != 0
          dep = 0
          (@c_ptr-1).downto(0) do |i|
            if dep == 0 && @c_arr[i] == "["
              @c_ptr = i
            elsif @c_arr[i] == "["
              dep -= 1
            elsif @c_arr[i] == "]"
              dep += 1
            end
          end
        end
      else #8つの記号以外は無視する 
      end
      @c_ptr += 1
    end
  end

  # メモリの初期化メソッド
  def clear_mem()
    @m_arr = Array.new(100, 0)
    @m_ptr = 0 
  end
end

bi = Bf_Interpreter.new()

while(true) do
  print "command:"

  # 'q'が入力されたら終了
  break if (input = gets.chomp) == "q"

  bi.set_command(input)
  bi.exec()

  print "\n"

end
