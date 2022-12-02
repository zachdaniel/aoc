defmodule Aoc.Y2021.Day16 do
  use Aoc.Day

  @encodings %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }

  answers do
    part_1 991
    part_2 1_264_485_568_252
  end

  input do
    handle_input fn input ->
      input
      |> String.graphemes()
      |> Enum.flat_map(fn grapheme ->
        String.graphemes(@encodings[grapheme])
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> decode_packet()
      |> elem(0)
      |> add_up_all_version_numbers()
    end

    part_2 fn input ->
      input
      |> decode_packet()
      |> elem(0)
      |> evaluate_packet()
    end
  end

  # Value packet
  defp evaluate_packet(%{id: 4, value: value}), do: value

  # Packets with type ID 0 are sum packets - their value is the sum of the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
  defp evaluate_packet(%{id: 0, sub_packets: sub_packets}) do
    sub_packets
    |> Enum.map(&evaluate_packet/1)
    |> Enum.sum()
  end

  # Packets with type ID 1 are product packets - their value is the result of multiplying together the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
  defp evaluate_packet(%{id: 1, sub_packets: sub_packets}) do
    sub_packets
    |> Enum.map(&evaluate_packet/1)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  # Packets with type ID 2 are minimum packets - their value is the minimum of the values of their sub-packets.
  defp evaluate_packet(%{id: 2, sub_packets: sub_packets}) do
    sub_packets
    |> Enum.map(&evaluate_packet/1)
    |> Enum.min()
  end

  # Packets with type ID 3 are maximum packets - their value is the maximum of the values of their sub-packets.
  defp evaluate_packet(%{id: 3, sub_packets: sub_packets}) do
    sub_packets
    |> Enum.map(&evaluate_packet/1)
    |> Enum.max()
  end

  # Packets with type ID 5 are greater than packets - their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
  defp evaluate_packet(%{id: 5, sub_packets: [left, right]}) do
    if evaluate_packet(left) > evaluate_packet(right) do
      1
    else
      0
    end
  end

  # Packets with type ID 6 are less than packets - their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
  defp evaluate_packet(%{id: 6, sub_packets: [left, right]}) do
    if evaluate_packet(left) < evaluate_packet(right) do
      1
    else
      0
    end
  end

  # Packets with type ID 7 are equal to packets - their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
  defp evaluate_packet(%{id: 7, sub_packets: [left, right]}) do
    if evaluate_packet(left) == evaluate_packet(right) do
      1
    else
      0
    end
  end

  @doc """
  ## Examples

      iex> Aoc2021.Day16.decode_packet("110100101111111000101000")
      {%{version: 6, id: 4, value: 2021}, ["0", "0", "0"]}
      iex> Aoc2021.Day16.decode_packet("00111000000000000110111101000101001010010001001000000000")
      {%{id: 6, sub_packets: [%{id: 4, value: 10, version: 6}, %{id: 4, value: 20, version: 2}], version: 1}, ["0", "0", "0", "0", "0", "0", "0"]}
      iex> Aoc2021.Day16.decode_packet("11101110000000001101010000001100100000100011000001100000")
      {%{id: 3, sub_packets: [%{id: 4, value: 1, version: 2}, %{id: 4, value: 2, version: 4}, %{id: 4, value: 3, version: 1}], version: 7}, ["0", "0", "0", "0", "0"]}
      iex> Aoc2021.Day16.decode_packet("100010100000000001001010100000000001101010000000000000101111010001111000")
      {%{id: 2, sub_packets: [%{id: 2, sub_packets: [%{id: 2, sub_packets: [%{id: 4, value: 15, version: 6}], version: 5}], version: 1}], version: 4}, ["0", "0", "0"]}
  """
  def decode_packet(packet) when is_binary(packet) do
    decode_packet(String.split(packet, "", trim: true))
  end

  def decode_packet([bit_1, bit_2, bit_3, bit_4, bit_5, bit_6 | binary]) do
    %{
      version: binary_list_to_integer([bit_1, bit_2, bit_3]),
      id: binary_list_to_integer([bit_4, bit_5, bit_6])
    }
    |> decode_typed_packet(binary)
  end

  # literal value case
  defp decode_typed_packet(%{id: 4} = packet, binary) do
    {value, remaining_binary} = decode_value(binary)

    {Map.put(packet, :value, value), remaining_binary}
  end

  defp decode_typed_packet(packet, ["0" | binary]) do
    {length_binary, remaining_binary} = Enum.split(binary, 15)
    operator_bit_count = binary_list_to_integer(length_binary)
    {operator_binary, remaining_binary} = Enum.split(remaining_binary, operator_bit_count)

    {Map.put(packet, :sub_packets, parse_sub_packets(operator_binary)), remaining_binary}
  end

  defp decode_typed_packet(packet, ["1" | binary]) do
    {number_of_sub_packets_binary, remaining_binary} = Enum.split(binary, 11)
    number_of_sub_packets = binary_list_to_integer(number_of_sub_packets_binary)

    {sub_packets, remaining_binary} =
      1..number_of_sub_packets
      |> Enum.reduce({[], remaining_binary}, fn _, {sub_packets, remaining_binary} ->
        {sub_packet, remaining_binary} = decode_packet(remaining_binary)
        {[sub_packet | sub_packets], remaining_binary}
      end)

    {Map.put(packet, :sub_packets, Enum.reverse(sub_packets)), remaining_binary}
  end

  defp parse_sub_packets(binary, sub_packets \\ [])
  defp parse_sub_packets([], sub_packets), do: Enum.reverse(sub_packets)

  defp parse_sub_packets(binary, sub_packets) do
    {sub_packet, remaining} = decode_packet(binary)
    parse_sub_packets(remaining, [sub_packet | sub_packets])
  end

  defp decode_value(binary, value_binary \\ [])

  defp decode_value(["1", bit_1, bit_2, bit_3, bit_4 | remaining], value_binary) do
    decode_value(remaining, value_binary ++ [bit_1, bit_2, bit_3, bit_4])
  end

  defp decode_value(["0", bit_1, bit_2, bit_3, bit_4 | remaining], value_binary) do
    {binary_list_to_integer(value_binary ++ [bit_1, bit_2, bit_3, bit_4]), remaining}
  end

  defp add_up_all_version_numbers(%{sub_packets: sub_packets, version: version}) do
    sub_packets
    |> Enum.map(&add_up_all_version_numbers/1)
    |> Enum.sum()
    |> Kernel.+(version)
  end

  defp add_up_all_version_numbers(%{version: version}), do: version

  defp binary_list_to_integer(list) do
    list
    |> Enum.join()
    |> String.to_integer(2)
  end
end
