import Sound
import lean_certs.cert_39_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_142_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 39) (d := 142) (c := cert_39_142) (by decide)
