module main

import net.http
import os
import cli

fn video_info(url string, format string) ?http.Response {
	header := http.new_header_from_map({
		http.CommonHeader.accept:          'tex/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
		http.CommonHeader.accept_charset:  'UTF-8,*;q=0.5'
		http.CommonHeader.accept_encoding: 'gzip,deflate,sdch'
		http.CommonHeader.accept_language: 'en-US,en;q=0.8'
		http.CommonHeader.user_agent:      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36 Edg/79.0.309.43'
	})

	v_info := http.fetch(http.FetchConfig{
		url: url
		header: header
		method: http.Method.get
	}) or { panic(err) }
	return v_info
}

fn main() {
	mut app := cli.Command{
		name: 'gifydl'
		description: 'This is a tool to download gif 🔥'
		version: 'v0.0.1'
		flags: [
			cli.Flag{
				flag: cli.FlagType.string
				name: 'url'
				abbrev: 'u'
				description: '-url http://example.com  or -u http://example.com'
			},
			cli.Flag{
				flag: cli.FlagType.string
				name: 'format'
				abbrev: 'f'
				description: '-format gif or just -f gif'
			},
			cli.Flag{
				flag: cli.FlagType.string
				name: 'output'
				abbrev: 'o'
				description: '-output ./file.gif or just -o ./file.gif'
			},
		]
	}
	app.setup()
	app.parse(os.args)
	url_flag := app.flags[0].get_string()?
	format_flag := app.flags[1].get_string()?
	output_flag := app.flags[2].get_string()?
	if url_flag != '' {
		println('📹 Fetching vedio  detailes.........\n')
		res := video_info(url_flag, format_flag) or { return }
		size := res.header.get(http.CommonHeader.content_length) or { return }
		println('Size of gif ${size.int() / 1024}KB\n')
		println('📝 Writing fil to path ' + output_flag + '\n')
		os.write_file(output_flag, res.body) or { return }
		println('🥳 Written file succesfully \n')
	}
	exit(0)
}
