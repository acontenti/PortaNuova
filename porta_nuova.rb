class PortaNuova
	LINES = {
		1 => [
			'Cascine Vica',
			'Leumann',
			'Collegno Centro',
			'Certosa',
			'Fermi',
			'Paradiso',
			'Marche',
			'Massaua',
			'Pozzo Strada',
			'Monte Grappa',
			'Rivoli',
			'Racconigi',
			'Bernini',
			'Principi d\'Acaja',
			'XVIII Dicembre',
			'Porta Susa',
			'Vinzaglio',
			'Re Umberto',
			'Porta Nuova',
			'Marconi',
			'Nizza',
			'Dante',
			'Carducci-Molinette',
			'Spezia',
			'Lingotto',
			'Italia \'61',
			'Bengasi'
		],
		2 => [
			'Pasta di Rivalta',
			'Orbassano Centro',
			'Beinasco Centro',
			'Fornaci',
			'Cimitero Parco',
			'Mirafiori',
			'Cattaneo',
			'Omero',
			'Pitagora',
			'Parco Rignon',
			'Santa Rita',
			'Gessi',
			'Largo Orbassano',
			'Caboto',
			'Politecnico',
			'Stati Uniti',
			'Porta Nuova',
			'Solferino',
			'Castello',
			'Regina Margherita',
			'Verona',
			'Novara',
			'Regio Parco',
			'Zanella',
			'Tabacchi',
			'Cherubini',
			'Paisiello',
			'Giulio Cesare',
			'Vercelli',
			'Rebaudengo'
		]
	}
	LINE_PATTERN = /(?:prendi la linea) ([12]) (?:fino a) ([0-9A-Za-z.'\- ]+)/i
	SHORTCUT_PATTERN = /(?:prendi la scorciatoia) (\w+)(?: con ([0-9]+))?/i
	SHORTCUT_DEFINITION_PATTERN = /(?:per prendere la scorciatoia) (\w+)(?: con un (\w+))?/i

	def initialize(source)
		setup
		source.gsub(/\t+/, '')
		lines = source.split(/[\r\n]+/)
		lines.each { |line| parse line.strip }
	end

	def setup
		@last_station = 'Porta Nuova'
		@last_line = 1
		@shortcuts = {}
		@defining = false
		@backpack = [0, '']
		@station_data = Hash[LINES.values.flatten.map { |key| [key, nil] }]
		@station_data['Porta Nuova'] = 'Porta Nuova'
	end

	def parse(statement)
		if @defining
			parse_shortcut_definition(statement)
		else
			if statement.empty? || statement.start_with?('//')
			elsif statement.start_with? 'prendi la linea'
				parse_line(statement, nil)
			elsif statement.start_with? 'prendi la scorciatoia'
				parse_shortcut(statement, nil)
			elsif statement.start_with? 'per prendere la scorciatoia'
				if statement =~ SHORTCUT_DEFINITION_PATTERN
					@defining = true
					@current_shortcut = $1
					@shortcuts[@current_shortcut] = {
						parameter: ($2 != nil ? Parameter.new($2) : nil),
						statements: []
					}
				end
			else
				throw "Sorry, cannot undarstand '#{statement}'"
			end
		end
	end

	def parse_shortcut_definition(statement)
		if statement.empty? || statement.start_with?('//')
		elsif statement.start_with?('prendi la linea') || statement.start_with?('prendi la scorciatoia')
			if statement =~ LINE_PATTERN || statement =~ SHORTCUT_PATTERN
				@shortcuts[@current_shortcut][:statements] << statement
			end
		elsif statement == 'sei arrivato'
			@defining = false
		else
			throw "Sorry, cannot undarstand '#{statement}'"
		end
	end

	def parse_line(statement, parameter)
		if statement =~ LINE_PATTERN
			line, station = $1.to_i, $2
			station = italia61?(line, station, parameter)
			if LINES[line].include? station
				if line != @last_line
					puts "\nChanging from line #{@last_line} to line #{line}" if $DEBUG
					if LINES[line].include? @last_station
						execute line, station
					else
						throw "In #{@last_station} station you cannot change to line #{line}"
					end
				else
					execute line, station
				end
			else
				throw "There is no #{station} station in line #{line}"
			end
		else
			throw "Sorry, cannot undarstand '#{statement}'"
		end
	end

	def parse_shortcut(statement, parameter)
		if statement =~ SHORTCUT_PATTERN
			name = $1
			if @shortcuts.include? name
				@shortcuts[name][:statements].each { |x|
					parameter = if parameter != nil
									parameter
								else
									@shortcuts[name][:parameter]
								end
					if $2 != nil
						parameter.value = to_num $2
					end
					if x.start_with? 'prendi la linea'
						parse_line(x, parameter)
					elsif x.start_with? 'prendi la scorciatoia'
						parse_shortcut(x, parameter)
					else
						throw "Sorry, cannot undarstand '#{statement}'"
					end
				}
			else
				throw "There is no shortcut called #{name}"
			end
		else
			throw "Sorry, cannot undarstand '#{statement}'"
		end
	end

	def italia61?(line, station, parameter)
		if line == 1 && station.start_with?('Italia \'')
			@italia61_value = station[(station.index('\'') + 1)..-1]
			if parameter != nil && @italia61_value == parameter.name
				@italia61_value = to_num parameter.value
			end
			# noinspection RubyResolve
			puts "Italia '61 value is #{@italia61_value}" if $DEBUG
			'Italia \'61'
		else
			station
		end
	end

	def execute(line, station)
		puts "\nTaking line #{line} to #{station}" if $DEBUG
		puts "\tBackpack contained #{@backpack.join(' and ')}" if $DEBUG
		puts "\tStation contained #{@station_data[station]}" if $DEBUG
		case station
			#line 1
			when 'Cascine Vica' # station reference parking station
				@station_data[station] = get_last_station
			when 'Leumann' # writes backpack in Cascine Vica referenced station
				@station_data[@station_data['Cascine Vica']] = @backpack[0]
			when 'Collegno Centro'
			when 'Certosa'
			when 'Fermi' # print data from station referenced in Bengasi
				print @station_data[@station_data['Bengasi']]
			when 'Paradiso'
			when 'Marche' # set backpack value to last station data
				@backpack[0] = @station_data[get_last_station]
			when 'Massaua' # writes backpack in Bengasi referenced station
				@station_data[@station_data['Bengasi']] = @backpack[0]
			when 'Pozzo Strada' # decrement backpack value
				@backpack[0] = to_num(@backpack[0]) - 1
			when 'Monte Grappa'
			when 'Rivoli' # sum the backpack values and store result in station data
				@station_data[station] = to_num(@backpack[0]) + to_num(@backpack[1])
			when 'Racconigi' # subtract the backpack values and store result in station data
				@station_data[station] = to_num(@backpack[0]) - to_num(@backpack[1])
			when 'Bernini' # converts backpack Integer value to Character and appends it to second value, then reverses backpack values
				@backpack[0] = @backpack[1].to_s + @backpack[0].chr.to_s
				@backpack.reverse!
			when 'Principi d\'Acaja'
			when 'XVIII Dicembre' # set backpack value to 18
				@backpack[0] = 18
			when 'Porta Susa' # puts new value in backpack with last station data
				@backpack[@backpack.size] = @station_data[get_last_station]
			when 'Vinzaglio' # reverse value in backpack
				@backpack[0].reverse!
			when 'Re Umberto'
			when 'Marconi' # prints last visited station data
				print @station_data[get_last_station]
			when 'Nizza' # take the max backpack value and store result in station data
				@station_data[station] = @backpack.map { |x| Integer(x) rescue nil }.compact.max
			when 'Dante'
				print @backpack[0]
			when 'Carducci-Molinette' # reset backpack value to zero
				@backpack[0] = 0
			when 'Spezia' # take the min backpack value and store result in station data
				@station_data[station] = @backpack.map { |x| Integer(x) rescue nil }.compact.min
			when 'Lingotto' # increment backpack value
				@backpack[0] = to_num(@backpack[0]) + 1
			when 'Italia \'61' # put italia '61 special value into backpack
				@backpack[0] = @italia61_value
				@station_data[station] = @italia61_value
			when 'Bengasi' # station reference parking station
				@station_data[station] = get_last_station

			#line 2
			when 'Rebaudengo' # removes last value from the backpack and writes in station data if backpack has more than 2 values
				@station_data[station] = @backpack.pop if @backpack.size > 2
			when 'Vercelli' # multiply the backpack values and store result in station data
				@station_data[station] = to_num(@backpack[0]) * to_num(@backpack[1])
			when 'Giulio Cesare'
			when 'Paisiello'
			when 'Cherubini'
			when 'Tabacchi'
			when 'Zanella'
			when 'Regio Parco'
			when 'Novara' # divide the backpack values and store result in station data
				@station_data[station] = to_num(@backpack[0]) / to_num(@backpack[1])
			when 'Verona' # divide the backpack values and store remainder in station data
				@station_data[station] = to_num(@backpack[0]) % to_num(@backpack[1])
			when 'Regina Margherita' # copy backpack first value to second backpack value
				@backpack[1] = @backpack[0]
			when 'Castello'
			when 'Solferino' # swap backpack values
				@backpack.reverse!
			when 'Stati Uniti' # set last station data to backpack value
				@station_data[get_last_station] = @backpack[0]
			when 'Politecnico' # converts backpack Integer value to Character
				@backpack[0] = @backpack[0].chr
			when 'Caboto' # prints new line
				puts
			when 'Largo Orbassano'
			when 'Gessi'
			when 'Santa Rita'
			when 'Parco Rignon'
			when 'Pitagora' # conversion to Integer
				@backpack[0] = to_num(@backpack[0])
			when 'Omero' # conversion to String
				@backpack[0] = @backpack[0].to_s
			when 'Cattaneo' # converts backpack Character value to Integer
				@backpack[0] = @backpack[0].ord
			when 'Mirafiori' # append first backpack value to second one
				@backpack[0] = @backpack[1].to_s + @backpack[0].to_s
			when 'Cimitero Parco' # reset backpack value as null value
				@backpack[0] = nil
			when 'Fornaci' # append last station data to backpack value
				@backpack[0] = @backpack[0].to_s + @station_data[@last_station].to_s
			when 'Beinasco Centro'
			when 'Orbassano Centro'
			when 'Pasta di Rivalta'

				#interchange
			when 'Porta Nuova'
				@station_data[station] = @last_station
			else
		end
		@last_line = line
		@last_station = station
		puts "\t\tBackpack contains #{@backpack.join(' and ')}" if $DEBUG
		puts "\t\tStation contains #{@station_data[station]}" if $DEBUG
	end

	def get_last_station
		(interchange? @last_station) ? @station_data[@last_station] : @last_station
	end

	def to_num(value)
		Integer(value) rescue 0
	end

	def interchange?(station)
		station == 'Porta Nuova'
	end
end

class Parameter
	attr_accessor :name, :value

	def initialize(name)
		@name = name
	end
end

source = File.read(ARGV[0])
PortaNuova.new source