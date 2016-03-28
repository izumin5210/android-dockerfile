class AndroidDockerImage
  attr_reader :repo, :build_tools, :target_api

  PLACEHOLDER_BUILD_TOOLS = "%{build_tools}"
  PLACEHOLDER_TARGET_API = "%{target_api}"

  def initialize(repo:, build_tools:, target_api:, tag_format:)
    @repo = repo
    @build_tools = build_tools
    @target_api = target_api
    @tag_format = tag_format
  end

  def tag
    @tag_format
      .gsub(PLACEHOLDER_BUILD_TOOLS, build_tools)
      .gsub(PLACEHOLDER_TARGET_API, target_api)
  end

  def fullname
    "#{repo}:#{tag}"
  end

  class << self
    KEY_BUILD_TOOLS = "build-tools"
    KEY_TARGET_API = "target-api"

    KEY_REPO = "repo"
    KEY_TAG_FORMAT = "tag"

    def load(opts = { build_tools: [], target_api: [] })
      repo = opts[KEY_REPO]
      tag_format = opts[KEY_TAG_FORMAT]
      patterns(opts).map do |(build_tools, target_api)|
        AndroidDockerImage.new(
          repo: repo, build_tools: build_tools,
          target_api: target_api, tag_format: tag_format
        )
      end
    end

    private

    def patterns(opts)
      opts[KEY_BUILD_TOOLS].product(
        opts[KEY_TARGET_API]
      )
    end
  end
end
