//
//  Post.swift
//  
//
//  Created by Lisovyi, Ivan on 04.12.20.
//

import Foundation

public struct Post: Decodable {
  let id: Int
  let uploaderId: Int
  let parentId: Int?
  let approverId: Int?
  let pixivId: Int?

  let createdAt: Date
  let updatedAt: Date

  let lastCommentedAt: Date?
  let lastCommentBumpedAt: Date?
  let lastNotedAt: Date?

  let imageWidth: Int
  let imageHeight: Int

  let score: Int
  let upScore: Int
  let downScore: Int

  let favCount: Int
  let isFavorited: Bool

  let rating: String

  let source: String
  let md5: String

  let fileSize: Int
  let fileExt: String

  let tagString: String
  let tagStringGeneral: String
  let tagStringCharacter: String
  let tagStringCopyright: String
  let tagStringArtist: String
  let tagStringMeta: String

  let isRatingLocked: Bool
  let isNoteLocked: Bool
  let isStatusLocked: Bool
  let isPending: Bool
  let isFlagged: Bool
  let isDeleted: Bool
  let isBanned: Bool

  let fileUrl: URL
  let largeFileUrl: URL
  let previewFileUrl: URL

  let hasChildren: Bool
  let hasActiveChildren: Bool

  let hasLarge: Bool?

//  {"id":4233523}
//  {"created_at":"2020-12-04T18:03:35.373+01:00"}
//  {"uploader_id":741961}
//  {"score":6}
//  {"source":"https:\/\/i.pximg.net\/img-original\/img\/2020\/12\/05\/01\/54\/30\/86096365_p0.jpg"}
//  {"md5":"daf80e6890f0c21b7218c78bb403778f"}
//  {"last_comment_bumped_at":null}
//  {"rating":"s"}
//  {"image_width":1500}
//  {"image_height":2122}

//  {"tag_string":"1girl animal_ears bare_shoulders blonde_hair blue_eyes breasts bunny_ears bunny_tail casino chungmechanic collarbone covered_navel cowboy_shot detached_collar eyebrows_visible_through_hair eyelashes fake_animal_ears fire_emblem fire_emblem:_three_houses fishnet_legwear fishnets hair_over_shoulder headband highres holding indoors large_breasts leg_garter leotard long_hair looking_at_viewer mercedes_von_martritz pantyhose playboy_bunny sideboob solo standing tail tied_hair tray wrist_cuffs"}
//  {"is_note_locked":false}
//  {"fav_count":12}
//  {"file_ext":"jpg"}
//  {"last_noted_at":null}
//  {"is_rating_locked":false}
//  {"parent_id":null}
//  {"has_children":false}
//  {"approver_id":null}
//  {"tag_count_general":36}
//  {"tag_count_artist":1}
//  {"tag_count_character":1}
//  {"tag_count_copyright":2}
//  {"file_size":1395715}
//  {"is_status_locked":false}
//  {"pool_string":""}
//  {"up_score":6}
//  {"down_score":0}
//  {"is_pending":false}
//  {"is_flagged":false}
//  {"is_deleted":false}
//  {"tag_count":41}
//  {"updated_at":"2020-12-04T18:03:59.041+01:00"}
//  {"is_banned":false}
//  {"pixiv_id":86096365}
//  {"last_commented_at":null}
//  {"has_active_children":false}
//  {"bit_flags":2}
//  {"tag_count_meta":1}
//  {"has_large":true}
//  {"has_visible_children":false}
//  {"is_favorited":true}
//  {"tag_string_general":"1girl animal_ears bare_shoulders blonde_hair blue_eyes breasts bunny_ears bunny_tail casino collarbone covered_navel cowboy_shot detached_collar eyebrows_visible_through_hair eyelashes fake_animal_ears fishnet_legwear fishnets hair_over_shoulder headband holding indoors large_breasts leg_garter leotard long_hair looking_at_viewer pantyhose playboy_bunny sideboob solo standing tail tied_hair tray wrist_cuffs"}
//  {"tag_string_character":"mercedes_von_martritz"}
//  {"tag_string_copyright":"fire_emblem fire_emblem:_three_houses"}
//  {"tag_string_artist":"chungmechanic"}
//  {"tag_string_meta":"highres"}
//  {"file_url":"https:\/\/danbooru.donmai.us\/data\/daf80e6890f0c21b7218c78bb403778f.jpg"}
//  {"large_file_url":"https:\/\/danbooru.donmai.us\/data\/sample\/sample-daf80e6890f0c21b7218c78bb403778f.jpg"}
//  {"preview_file_url":"https:\/\/cdn.donmai.us\/preview\/da\/f8\/daf80e6890f0c21b7218c78bb403778f.jpg"}
}
