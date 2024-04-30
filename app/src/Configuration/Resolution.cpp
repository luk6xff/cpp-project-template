#include "Resolution.h"

#include <utility>

std::pair<uint32_t, uint32_t> Resolution::getIntFromResolution(Setting res) {
  switch (res) {
  case Setting::h600w800:
    return {600, 800};
  case Setting::h768w1024:
    return {768, 1024};
  case Setting::h864w1152:
    return {864, 1152};
  case Setting::h960w1280:
    return {960, 1280};
  default:
    return {0, 0};
  }
}

std::string Resolution::resolutionToStr(Setting resolution) {
  switch (resolution) {
  case Setting::h600w800:
    return "600x800";
  case Setting::h768w1024:
    return "768x1024";
  case Setting::h864w1152:
    return "864x1152";
  case Setting::h960w1280:
    return "960x1280";
  default:
    return "";
  }
}

std::optional<Resolution::Setting>
Resolution::stringToResolution(const std::string &str) {
  if (str == "600x800")
    return Setting::h600w800;
  if (str == "768x1024")
    return Setting::h768w1024;
  if (str == "864x1152")
    return Setting::h864w1152;
  if (str == "960x1280")
    return Setting::h960w1280;
  return std::nullopt;
}
