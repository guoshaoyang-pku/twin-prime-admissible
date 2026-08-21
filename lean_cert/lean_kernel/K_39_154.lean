import Sound
import lean_certs.cert_39_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_154_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 39) (d := 154) (c := cert_39_154) (by decide)
